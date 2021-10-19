import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/quickblox_controller.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/data/model/user_model.dart';
import 'package:winlife/data/provider/FCM.dart';
import 'package:winlife/routes/app_routes.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthController _authController = Get.find();
  var _user;

  var args = Get.arguments;
  Map<String, dynamic> time = {};
  Map<String, dynamic> opponent = {};
  List<types.Message> _messages = [];
  final QBController _chatController = Get.find();
  late StreamSubscription messageSub;
  Conselor? conselor;

  @override
  void initState() {
    super.initState();

    _chatController.messages.clear();
    time = convert.jsonDecode(args[0]['time']);
    _chatController.start.value = int.parse(time['time']) * 60;
    _chatController.dialogId = args[0]['dialogId'];
    opponent = convert.jsonDecode(args[0]['user']);
    _loadMessages();
    _user = types.User(
        id: _authController.user.id, firstName: _authController.user.fullName);
    _chatController.opponent = UserData.fromJson(opponent, " ");
    _chatController.opponentAuthor = types.User(
        id: _chatController.opponent!.uid,
        firstName: _chatController.opponent!.fullName);
    messageSub = _chatController.messages.listen((value) {
      setState(() {
        _messages = value;
      });
    });
    conselor = args[1];

    _chatController.startTimer(time, conselor, args[0]['conselorFCM']);
  }

  @override
  void dispose() {
    _chatController.cancelTimer();
    messageSub.cancel();
    super.dispose();
  }

  void _addMessage(types.Message message) {
    _chatController.messages.insert(0, message);
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File fi = File(result.files.single.path!);
      final bytes = await fi.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.files.single.name,
        size: bytes.length,
        uri: result.files.single.path!,
        width: image.width.toDouble(),
      );

      Get.snackbar("Please Wait", "Uploading Image",
          isDismissible: false,
          showProgressIndicator: true,
          snackPosition: SnackPosition.BOTTOM);
      await _chatController.sendFileMessage(result.files.single.path!);
      _addMessage(message);
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _chatController.messages
        .indexWhere((element) => element.id == message.id);
    final updatedMessage =
        _chatController.messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _chatController.messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _chatController.sendMessage(message.text);
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    // final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(response) as List)
    //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();

    // setState(() {
    //   _messages = messages;
    // });
  }

  Future<bool> backHandler() async {
    bool value = false;
    print(args[0]['conselorFCM']);
    await Get.defaultDialog(
        title: "Oops!",
        middleText: "Apakah anda ingin mengakhiri sesi konsultasi ini?",
        textConfirm: "Ya",
        textCancel: "Tidak",
        onConfirm: () async {
          await FCM.send(args[0]['conselorFCM'],
              {'message': 'order_status', 'status': "finish"});
          value = true;
          Get.offNamed(Routes.RATINGCONSELOR,
              arguments: {'conselor': conselor, 'time': time});
        },
        buttonColor: mainColor,
        cancelTextColor: mainColor,
        confirmTextColor: Colors.white,
        onCancel: () => value = false);
    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backHandler,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile/privacy.png'),
                  radius: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    _chatController.opponent!.fullName,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'neosansbold',
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Chat(
                      theme: const DefaultChatTheme(
                          primaryColor: mainColor,
                          inputTextColor: Colors.black,
                          secondaryColor: Colors.grey,
                          sendButtonIcon: Icon(
                            FontAwesomeIcons.paperPlane,
                            color: Colors.black,
                          ),
                          inputBackgroundColor: greyColor),
                      messages: _messages,
                      onAttachmentPressed: _handleAtachmentPressed,
                      onMessageTap: _handleMessageTap,
                      onPreviewDataFetched: _handlePreviewDataFetched,
                      onSendPressed: _handleSendPressed,
                      user: _user,
                    ),
                  ),
                  Positioned(
                      top: 5,
                      left: 25,
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 90,
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "neosansbold",
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              time['time'] + ' Mins',
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontFamily: "neosansbold",
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Count Time',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "neosansbold",
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                            Obx(
                                              () {
                                                return Text(
                                                  format(Duration(
                                                      seconds: _chatController
                                                          .start.value)),
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontFamily: "neosansbold",
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ))))
                ],
              ),
            )),
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
}
