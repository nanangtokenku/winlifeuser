import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/data/model/user_model.dart';
import 'package:winlife/data/provider/FCM.dart';
import 'package:winlife/data/provider/quickblox/credential.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:winlife/routes/app_routes.dart';

class QBController extends GetxController {
  QBSession? _session;
  QBUser? _qbUser;
  final AuthController _authController = Get.find();
  QBDialog? dialog;
  String? dialogId;
  String? _messageId;
  Map<dynamic, dynamic> payload = {}.obs;
  StreamSubscription? _newMessageSubscription;
  StreamSubscription? _systemMessageSubscription;
  StreamSubscription? _deliveredMessageSubscription;
  StreamSubscription? _readMessageSubscription;
  StreamSubscription? _userTypingSubscription;
  StreamSubscription? _userStopTypingSubscription;
  StreamSubscription? _connectedSubscription;
  StreamSubscription? _connectionClosedSubscription;
  StreamSubscription? _reconnectionFailedSubscription;
  StreamSubscription? _reconnectionSuccessSubscription;
  RxList<types.Message> messages = RxList<types.Message>();
  String? sesi;
  UserData? opponent;
  var opponentAuthor;
  static QBController? _instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
    } on PlatformException catch (e) {
      print(e);
      // Some error occurred, look at the exception message for more details
    }
    try {
      await enableAutoReconnect();
      await loginQB();
      await connect();
      subscribeNewMessage();
      subscribeSystemMessage();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> onClose() async {
    // TODO: implement onClose
    // ;
    unsubscribeNewMessage();
    unsubscribeSystemMessage();
    disconnect();

    await logoutQB();
    super.onClose();
  }

  Future<void> connect() async {
    try {
      await QB.chat.connect(qbUser!.id!, _authController.user.email);
      print("Chat Connect");
    } on PlatformException catch (e) {}
  }

  Future<void> disconnect() async {
    try {
      await QB.chat.disconnect();
      print("Chat Disconnect");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> cekSessionUser() async {
    try {
      QBSession? session = await QB.auth.getSession();
      if (session != null) {
        setSession = session;
      }
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<void> enableAutoReconnect() async {
    try {
      await QB.settings.enableAutoReconnect(true);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }

  Future<void> enableCarbons() async {
    try {
      await QB.settings.enableCarbons();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<void> initStreamManagement() async {
    bool autoReconnect = true;
    int messageTimeout = 3;
    try {
      await QB.settings
          .initStreamManagement(messageTimeout, autoReconnect: autoReconnect);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }

  Future<void> loginQB() async {
    var cekUser = await cekUserQB(_authController.user.email);
    if (cekUser.isEmpty) {
      await registerQB(_authController.user.email, _authController.user.email);
    }
    try {
      QBLoginResult result = await QB.auth
          .login(_authController.user.email, _authController.user.email);
      _qbUser = result.qbUser;
      _session = result.qbSession;
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      loginQB();
      print(e);
    }
  }

  Future<void> logoutQB() async {
    try {
      await QB.auth.logout();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }

  Future<void> registerQB(String email, String password) async {
    try {
      await QB.users.createUser(email, password, fullName: email);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }

  Future<List<QBUser?>> cekUserQB(String login) async {
    QBFilter qbFilter = new QBFilter();
    qbFilter.field = QBUsersFilterFields.FULL_NAME;
    qbFilter.operator = QBUsersFilterOperators.IN;
    qbFilter.type = QBUsersFilterTypes.STRING;
    List<QBUser?> userList = [];
    try {
      userList = await QB.users.getUsers();
    } on PlatformException catch (e) {
      print(e);
    }
    return userList.where((element) => element!.fullName == login).toList();
  }

  static QBController getInstance() {
    if (_instance == null) {
      _instance = QBController();
    }
    return _instance!;
  }

  set setSession(QBSession? session) {
    this._session = session;
  }

  QBSession? get qbSession => _session;

  set setUser(QBUser? qbUser) {
    this._qbUser = qbUser;
  }

  QBUser? get qbUser => _qbUser;

  //Chat ===================================================================

  Timer? timer;
  var start = 300.obs;

  void startTimer(time, conselor, fcm) {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 300) {
          Get.defaultDialog(
              title: "Info!",
              middleText: "Sesi konsultasi akan segera berakhir 5 menit lagi");
        }
        if (start.value == 60) {
          Get.defaultDialog(
              title: "Info!",
              middleText: "Sesi konsultasi akan segera berakhir 1 menit lagi");
        }
        if (start.value == 0) {
          timer.cancel();

          FCM.send(fcm, {'message': 'order_status', 'status': "finish"});
          Get.offNamed(Routes.RATINGCONSELOR,
              arguments: {'conselor': conselor, 'time': time});
        } else {
          start.value--;
        }
      },
    );
  }

  void cancelTimer() {
    if (timer != null) {
      timer!.cancel();
      start.value = 300;
    }
  }

  Future<bool?> isConnected() async {
    bool? connected = false;
    try {
      connected = await QB.chat.isConnected();
    } on PlatformException catch (e) {
      print(e);
    }
    return connected;
  }

  Future<void> sendMessage(String message) async {
    List<QBAttachment>? attachments = [];
    Map<String, String>? properties = Map();
    bool markable = false;
    String dateSent = "DateTime.now().toString()";
    bool saveToHistory = true;

    try {
      await QB.chat.sendMessage(dialogId.toString(),
          body: message, markable: markable, saveToHistory: saveToHistory);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }

  Future<void> sendFileMessage(String x) async {
    try {
      var file = await QB.content.upload(x, public: true);

      if (file != null) {
        String id = file.uid!;
        String? contentType = file.contentType;

        QBAttachment attachment = QBAttachment();
        attachment.id = id.toString();
        attachment.contentType = contentType;

        //Required parameter
        attachment.type = "PHOTO";

        List<QBAttachment> attachmentsList = [];
        attachmentsList.add(attachment);

        try {
          await QB.chat.sendMessage(dialogId.toString(),
              body: "photo",
              markable: false,
              saveToHistory: true,
              attachments: attachmentsList);
        } on PlatformException catch (e) {
          // Some error occurred, look at the exception message for more details
          print(e);
        }
      }
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<void> createDialog(int opponentID) async {
    List<int> occupantsIds = [opponentID];
    String dialogName = "FLUTTER_CHAT_" + DateTime.now().millisecond.toString();

    int dialogType = QBChatDialogTypes.CHAT;

    try {
      dialog = await QB.chat
          .createDialog(occupantsIds, dialogName, dialogType: dialogType);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void deleteDialog() async {
    try {
      await QB.chat.deleteDialog(dialog!.id!);
      dialog = null;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {
      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) async {
        Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(data);
        payload = Map<dynamic, dynamic>.from(map["payload"]);
        _messageId = payload["id"] as String;
        if (payload.containsKey('attachments')) {
          String? url = await QB.content
              .getPublicURL(payload['attachments'].single['id']);
          if (url != null) {
            File? fileImage = await downloadFile(
                url,
                DateTime.now().toIso8601String() +
                    '.' +
                    payload['attachments']
                        .single['contentType']
                        .toString()
                        .split('/')[1],
                '/data/user/0/com.winlifeapp.user/cache');
            if (fileImage != null) {
              final bytes = await fileImage.readAsBytes();
              final image = await decodeImageFromList(bytes);

              final message = types.ImageMessage(
                author: opponentAuthor,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                height: image.height.toDouble(),
                id: const Uuid().v4(),
                name: fileImage.path.split('/').last,
                size: bytes.length,
                uri: fileImage.path,
                width: image.width.toDouble(),
              );
              if (payload['senderId'] != qbUser!.id) {
                messages.insert(0, message);
              }
            }
          }
        } else {
          print("Received message: \n ${payload["body"]}");
          final textMessage = types.TextMessage(
            author: opponentAuthor,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: payload["body"],
          );
          if (payload['senderId'] != qbUser!.id) {
            messages.insert(0, textMessage);
          }
        }
      }, onErrorMethod: (error) {
        print(error);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<File?> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File? file;
    String filePath = '';

    try {
      ;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return file;
  }

  void subscribeSystemMessage() async {
    if (_systemMessageSubscription != null) {
      return;
    }
    try {
      _systemMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_SYSTEM_MESSAGE, (data) {
        Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(data);

        Map<dynamic, dynamic> payload =
            Map<dynamic, dynamic>.from(map["payload"]);

        _messageId = payload["id"];
        print("Received system message");
      }, onErrorMethod: (error) {
        print(error);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void unsubscribeNewMessage() {
    if (_newMessageSubscription != null) {
      _newMessageSubscription!.cancel();
      _newMessageSubscription = null;
    }
  }

  void unsubscribeSystemMessage() {
    if (_systemMessageSubscription != null) {
      _systemMessageSubscription!.cancel();
      _systemMessageSubscription = null;
    }
  }
}
