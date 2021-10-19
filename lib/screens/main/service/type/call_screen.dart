import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/quickblox_controller.dart';
import 'package:winlife/controller/rtc_controller.dart';
import 'package:winlife/routes/app_routes.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AuthController _authController = Get.find();
  final RTCController _rtcController = Get.find();
  var args = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<RTCController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(),
              SizedBox(
                width: 20,
              ),
              Text(
                "Robby Maulana",
                style: TextStyle(
                    fontFamily: 'neosans', fontSize: 20, color: Colors.black),
              )
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "On Going Call",
                  style: TextStyle(
                      fontFamily: 'neosans', fontSize: 32, color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        FontAwesomeIcons.volumeUp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        await _rtcController.hangUpWebRTC();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        FontAwesomeIcons.microphone,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 90,
                  child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '12 August 2021',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: mainColor,
                                    fontFamily: "neosansbold",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                            VerticalDivider(
                              width: 20,
                            ),
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
                                          'Text',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "neosansbold",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          '60 Min',
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
                                          'Count Date',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "neosansbold",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          '00:59',
                                          style: TextStyle(
                                              color: mainColor,
                                              fontFamily: "neosansbold",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13),
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
    );
  }
}
