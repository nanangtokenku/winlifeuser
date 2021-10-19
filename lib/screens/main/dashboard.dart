import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/data/provider/FCM.dart';
import 'package:winlife/screens/main/Frame/history.dart';
import 'package:winlife/screens/main/Frame/profil.dart';
import 'package:winlife/screens/main/Frame/promo.dart';
import 'package:winlife/screens/main/Frame/quick.dart';
import 'package:get/get.dart';
import 'package:winlife/screens/widget/dialog.dart';

import 'Frame/home/home.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Widget> _tabList = [
    FrameHome(),
    FrameHistory(),
    FrameQuick(),
    FramePromo(),
    FrameProfile()
  ];
  var _currentIndex = 0;
  late StreamSubscription<RemoteMessage> subForeground;

  final AuthController _authController = Get.find();

  @override
  void initState() {
    fcmInit();
    super.initState();
  }

  fcmInit() async {
    String? token = await FCM.messaging.getToken();
    await FCM.saveTokenToDatabase(token!, _authController.user.email);
    _authController.tokenFCM = token;
    FCM.messaging.onTokenRefresh.listen((event) {
      FCM.saveTokenToDatabase(event, _authController.user.email);
      _authController.tokenFCM = token;
    });
    subForeground = FCM.onMessage.listen((RemoteMessage message) {});
  }

  @override
  void dispose() {
    super.dispose();
    subForeground.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _tabList[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: mainColor,
          type: BottomNavigationBarType.fixed,
          onTap: (currentIndex) {
            // checkAccount();
            debugPrint("Tab Number : " + currentIndex.toString());
            setState(() {
              _currentIndex = currentIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
                title: Text(
                  'Home'.tr,
                  style: TextStyle(
                      fontFamily: _currentIndex == 0 ? 'mulibold' : 'muli',
                      fontSize: 12),
                ),
                icon: _currentIndex == 0
                    ? Image.asset(
                        'assets/nav/nav_home_sel.png',
                        width: 28,
                        gaplessPlayback: true,
                      )
                    : Image.asset(
                        'assets/nav/nav_home.png',
                        width: 28,
                        gaplessPlayback: true,
                      )),
            BottomNavigationBarItem(
                title: Text(
                  "History".tr,
                  style: TextStyle(
                      fontFamily: _currentIndex == 1 ? 'mulibold' : 'muli',
                      fontSize: 12),
                ),
                icon: _currentIndex == 1
                    ? Image.asset(
                        'assets/nav/nav_history_sel.png',
                        width: 28,
                        gaplessPlayback: true,
                      )
                    : Image.asset(
                        'assets/nav/nav_history.png',
                        width: 28,
                        gaplessPlayback: true,
                      )),
            BottomNavigationBarItem(
                title: Text(
                  "consultation".tr,
                  style: TextStyle(
                      fontFamily: _currentIndex == 2 ? 'mulibold' : 'muli',
                      fontSize: 12),
                ),
                icon: _currentIndex == 2
                    ? Image.asset(
                        'assets/nav/nav_topup_sel.png',
                        width: 28,
                        gaplessPlayback: true,
                      )
                    : Image.asset(
                        'assets/nav/nav_topup.png',
                        width: 28,
                        gaplessPlayback: true,
                      )),
            BottomNavigationBarItem(
                title: Text(
                  "Reward".tr,
                  style: TextStyle(
                      fontFamily: _currentIndex == 3 ? 'mulibold' : 'muli',
                      fontSize: 12),
                ),
                icon: _currentIndex == 3
                    ? Image.asset(
                        'assets/nav/nav_promo_sel.png',
                        width: 28,
                        gaplessPlayback: true,
                      )
                    : Image.asset(
                        'assets/nav/nav_promo.png',
                        width: 28,
                        gaplessPlayback: true,
                      )),
            BottomNavigationBarItem(
                title: Text(
                  "Profile".tr,
                  style: TextStyle(
                      fontFamily: _currentIndex == 4 ? 'mulibold' : 'muli',
                      fontSize: 12),
                ),
                icon: _currentIndex == 4
                    ? Image.asset(
                        'assets/nav/nav_profile_sel.png',
                        width: 28,
                        gaplessPlayback: true,
                      )
                    : Image.asset(
                        'assets/nav/nav_profile.png',
                        width: 28,
                        gaplessPlayback: true,
                      ))
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
