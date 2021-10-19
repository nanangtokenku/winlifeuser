import 'dart:async';
import 'dart:convert' as convert;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/controller/rtc_controller.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/data/model/duration_model.dart';
import 'package:winlife/data/provider/FCM.dart';
import 'package:winlife/data/provider/http_service.dart';
import 'package:winlife/routes/app_routes.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  MainController _mainController = Get.find();
  String msg = '';
  bool showbody = true;
  bool showfilter = false;
  Conselor? _conselor;
  var data;
  StreamSubscription? subTime;
  var response;
  bool loaded = false;
  late StreamSubscription<RemoteMessage> onMessegeSub;
  late StreamSubscription<RemoteMessage> onMessegeOpenedAppSub;
  late StreamSubscription paidSub;
  GetStorage storage = GetStorage();

  @override
  void initState() {
    _conselor = Get.arguments['conselor'];
    data = Get.arguments['data'];
    _mainController.start.value = 9000;
    _mainController.startTimer();
    storage.write('sesi', data['sesi']);
    subTime = _mainController.start.listen((value) {
      if (value == 0) {
        Get.back();
      }
    });
    paidSub = _mainController.paid.listen((value) async {
      if (value) {
        _mainController.cancelTimer();
        await _mainController.addOrder(data['sesi'], _conselor!.id,
            data['problem'], data['hope'], data['time']['id']);
        await FCM.send(
            data['conselorFCM'], {'message': 'order_status', 'status': "paid"});
      }
    });
    onMessegeSub = FCM.onMessage.listen((RemoteMessage message) {
      print(message.data);
      switch (message.data['type'].toString().toLowerCase()) {
        case 'chat':
          Get.toNamed(Routes.CHATSCREEN, arguments: [message.data, _conselor]);
          break;
        case 'call':
          Get.toNamed(Routes.CALLSCREEN, arguments: message.data);
          break;
        case 'video call':
          Get.toNamed(Routes.VIDCALLSCREEN, arguments: message.data);
          break;
        case 'meet':
          break;
        default:
      }
    });
    onMessegeOpenedAppSub = FCM.onMessage.listen((RemoteMessage message) {
      print(message.data);
      switch (message.data['type'].toString().toLowerCase()) {
        case 'chat':
          Get.toNamed(Routes.CHATSCREEN, arguments: message.data);
          break;
        case 'call':
          Get.toNamed(Routes.CALLSCREEN, arguments: message.data);
          break;
        case 'video call':
          Get.toNamed(Routes.VIDCALLSCREEN, arguments: message.data);
          break;
        case 'meet':
          break;
        default:
      }
    });
    if (data['type'].toString().toLowerCase() != 'chat') {
      Get.put(RTCController());
    }
    super.initState();
  }

  @override
  void dispose() {
    onMessegeOpenedAppSub.cancel();
    onMessegeSub.cancel();
    _mainController.cancelTimer();
    subTime!.cancel();
    paidSub.cancel();
    _mainController.paid.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_mainController.paid.value) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            child: Container(
              padding: const EdgeInsets.only(left: 25, top: 0, right: 25),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  child: Obx(
                                () => Text(
                                  _mainController.paid.value
                                      ? "Congratulations"
                                      : "Order Created!",
                                  style: TextStyle(
                                      fontFamily: 'neosansbold', fontSize: 24),
                                ),
                              )),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Obx(
                                    () => Text(
                                      _mainController.paid.value
                                          ? "Your payment is succes, Please wait for a moment"
                                          : "Your request has been send, please complete payment to start conseling ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'muli', fontSize: 18),
                                    ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Obx(
                                    () => Visibility(
                                      visible: !_mainController.paid.value,
                                      child: Text(
                                        "Time left : " +
                                            _mainController.start.value
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'muli', fontSize: 18),
                                      ),
                                    ),
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, left: 10, bottom: 10),
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: Offset(2,
                                              6), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: InkWell(
                                    child: Center(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.network(
                                            _conselor!.conselorDetail != null
                                                ? _conselor!.conselorDetail!
                                                    .foto_konselor
                                                : "http://web-backend.winlife.id:80/uploads/konselor/20210905203938-2021-09-05konselor203931.jpg",
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    onTap: () {},
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 90,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(_conselor!.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'neosansbold',
                                              fontSize: 18,
                                            )),
                                        // Container(
                                        //   margin: const EdgeInsets.only(top: 4),
                                        //   child: Text(
                                        //     "Rate: 4,5",
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        // ),
                                      ])),

                              // Container(
                              //     child: Row(
                              //   children: [
                              //     Expanded(
                              //       child: Text(
                              //         "Payment Status ",
                              //         style: TextStyle(
                              //             fontFamily: 'neosansbold',
                              //             fontSize: 15),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Text(
                              //         response['payment_status']
                              //             .toString(),
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             fontFamily: 'muli',
                              //             fontSize: 15),
                              //       ),
                              //     ),
                              //   ],
                              // )),

                              //================================================
                              Container(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Type Konsultasi ",
                                      style: TextStyle(
                                          fontFamily: 'neosansbold',
                                          fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      data['type'],
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontFamily: 'muli', fontSize: 15),
                                    ),
                                  ),
                                ],
                              )),

                              //================================================

                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Waktu Konsultasi ",
                                          style: TextStyle(
                                              fontFamily: 'neosansbold',
                                              fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          data['time']['time'] + ' Mins',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontFamily: 'muli', fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  )),
                              //================================================
                              //
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 1,
                                width: double.infinity,
                                color: Colors.grey[500],
                              ),
                              Container(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Harga",
                                      style: TextStyle(
                                          fontFamily: 'neosansbold',
                                          fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "IDR ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontFamily: 'mulibold',
                                              fontSize: 15),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            data['time']['harga'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontFamily: 'muli',
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              Obx(
                                () => Visibility(
                                    visible: !_mainController.paid.value,
                                    child: Column(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 0.8,
                                                    blurRadius: 5,
                                                    offset: Offset(2,
                                                        5), // changes position of shadow
                                                  ),
                                                ],
                                                color: mainColor,
                                                border: Border.all(
                                                  color: mainColor,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            padding: const EdgeInsets.all(13),
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: InkWell(
                                                  onTap: () async {
                                                    Get.toNamed(Routes.PAYMENT,
                                                        arguments: data);
                                                  },
                                                  child: Text(
                                                    "Pay",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'neosansbold',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                              ],
                                            )),
                                        Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 0.8,
                                                    blurRadius: 5,
                                                    offset: Offset(2,
                                                        5), // changes position of shadow
                                                  ),
                                                ],
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            padding: const EdgeInsets.all(13),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: InkWell(
                                                  onTap: () async {
                                                    await FCM.send(
                                                        data['conselorFCM'], {
                                                      'message': 'order_status',
                                                      'status': "cancel"
                                                    });
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'neosansbold',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                              ],
                                            ))
                                      ],
                                    )),
                              )
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
