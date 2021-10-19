import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:winlife/controller/quickblox_controller.dart';

class RTCController extends GetxController {
  StreamSubscription? _callSubscription;
  StreamSubscription? _callEndSubscription;
  StreamSubscription? _rejectSubscription;
  StreamSubscription? _acceptSubscription;
  StreamSubscription? _hangUpSubscription;
  StreamSubscription? _videoTrackSubscription;
  StreamSubscription? _notAnswerSubscription;
  StreamSubscription? _peerConnectionSubscription;

  RTCVideoViewController? localVideoViewController;
  RTCVideoViewController? remoteVideoViewController;

  String parsedState = "";

  QBController _qbController = Get.find();

  var vidiocall = false;
  String? sessionId;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    try {
      await QB.webrtc.init();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
    subscribeCall();
    subscribePeerConnection();
    subscribeVideoTrack();
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    unsubscribeCall();
    unsubscribeVideoTrack();
    unsubscribePeerConnection();
    releaseVideoViews();
    super.onClose();
  }

  Future<void> subscribeCall() async {
    if (_callSubscription != null) {
      return;
    }

    try {
      _callSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        Map<dynamic, dynamic> sessionMap =
            Map<dynamic, dynamic>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];

        if (callType == QBRTCSessionTypes.AUDIO) {
          vidiocall = false;
        } else {
          vidiocall = true;
        }

        this.sessionId = sessionId;
        String messageCallType = vidiocall ? "Video" : "Audio";
        acceptWebRTC(sessionId);
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> callWebRTC(int sessionType, int opponent) async {
    try {
      QBRTCSession? session = await QB.webrtc.call([opponent], sessionType);
      sessionId = session!.id;
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> acceptWebRTC(String sessionId) async {
    try {
      QBRTCSession? session = await QB.webrtc.accept(sessionId);
      String? receivedSessionId = session!.id;
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> rejectWebRTC(String sessionId) async {
    try {
      QBRTCSession? session = await QB.webrtc.reject(sessionId);
      String? id = session!.id;
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> hangUpWebRTC() async {
    try {
      QBRTCSession? session = await QB.webrtc.hangUp(sessionId!);

      await releaseWebRTC();

      try {
        Get.back();
        Get.back();
      } on PlatformException catch (e) {
        // Some error occurred, look at the exception message for more details
      }
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> setRTCConfigs() async {
    try {
      await QB.rtcConfig.setAnswerTimeInterval(10);
      await QB.rtcConfig.setDialingTimeInterval(15);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> getRTCConfigs() async {
    try {
      int? answerInterval = await QB.rtcConfig.getAnswerTimeInterval();
      int? dialingInterval = await QB.rtcConfig.getDialingTimeInterval();
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> releaseWebRTC() async {
    try {
      await QB.webrtc.release();
      sessionId = null;
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> releaseVideoViews() async {
    try {
      if (localVideoViewController != null) {
        await localVideoViewController!.release();
        await remoteVideoViewController!.release();
      }
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> getSessionWebRTC() async {
    try {
      QBRTCSession? session = await QB.webrtc.getSession(sessionId!);
      sessionId = session!.id;
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> enableVideo(bool enable) async {
    try {
      await QB.webrtc.enableVideo(sessionId!, enable: enable);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> enableAudio(bool enable) async {
    try {
      await QB.webrtc.enableAudio(sessionId!, enable: enable);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> switchCamera() async {
    try {
      await QB.webrtc.switchCamera(sessionId!);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> mirrorCamera() async {
    try {
      await QB.webrtc.mirrorCamera(_qbController.qbUser!.id!, true);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> switchAudioOutput(int output) async {
    try {
      await QB.webrtc.switchAudioOutput(output);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<String> parseState(int state) async {
    String parsedState = "";

    switch (state) {
      case QBRTCPeerConnectionStates.NEW:
        parsedState = "NEW";
        break;
      case QBRTCPeerConnectionStates.FAILED:
        parsedState = "FAILED";
        break;
      case QBRTCPeerConnectionStates.DISCONNECTED:
        parsedState = "DISCONNECTED";
        break;
      case QBRTCPeerConnectionStates.CLOSED:
        parsedState = "CLOSED";
        break;
      case QBRTCPeerConnectionStates.CONNECTED:
        parsedState = "CONNECTED";
        break;
    }
    return parsedState;
  }

  Future<void> startRenderingLocal() async {
    try {
      await localVideoViewController!
          .play(sessionId!, _qbController.qbUser!.id!);
      switchAudioOutput(QBRTCAudioOutputTypes.LOUDSPEAKER);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> startRenderingRemote(int opponentId) async {
    try {
      await remoteVideoViewController!.play(sessionId!, opponentId);
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeCallEnd() async {
    if (_callEndSubscription != null) {
      return;
    }
    try {
      _callEndSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        Map<dynamic, dynamic> sessionMap =
            Map<dynamic, dynamic>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      return;
    }

    try {
      _videoTrackSubscription = await QB.webrtc
          .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == _qbController.qbUser!.id!) {
          startRenderingLocal();
        } else {
          startRenderingRemote(opponentId);
        }
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeNotAnswer() async {
    if (_notAnswerSubscription != null) {
      return;
    }

    try {
      _notAnswerSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeReject() async {
    if (_rejectSubscription != null) {
      return;
    }

    try {
      _rejectSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeAccept() async {
    if (_acceptSubscription != null) {
      return;
    }

    try {
      _acceptSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribeHangUp() async {
    if (_hangUpSubscription != null) {
      return;
    }

    try {
      _hangUpSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  Future<void> subscribePeerConnection() async {
    if (_peerConnectionSubscription != null) {
      return;
    }

    try {
      _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
          QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) async {
        int state = data["payload"]["state"];
        parsedState = await parseState(state);
      }, onErrorMethod: (error) {
        Get.defaultDialog(title: "Eror", middleText: error.toString());
      });
    } on PlatformException catch (e) {
      Get.defaultDialog(title: "Eror", middleText: e.toString());
    }
  }

  void unsubscribeCall() {
    if (_callSubscription != null) {
      _callSubscription!.cancel();
      _callSubscription = null;
    }
  }

  void unsubscribeCallEnd() {
    if (_callEndSubscription != null) {
      _callEndSubscription!.cancel();
      _callEndSubscription = null;
    }
  }

  void unsubscribeReject() {
    if (_rejectSubscription != null) {
      _rejectSubscription!.cancel();
      _rejectSubscription = null;
    }
  }

  void unsubscribeAccept() {
    if (_acceptSubscription != null) {
      _acceptSubscription!.cancel();
      _acceptSubscription = null;
    }
  }

  void unsubscribeHangUp() {
    if (_hangUpSubscription != null) {
      _hangUpSubscription!.cancel();
      _hangUpSubscription = null;
    }
  }

  void unsubscribeVideoTrack() {
    if (_videoTrackSubscription != null) {
      _videoTrackSubscription!.cancel();
      _videoTrackSubscription = null;
    }
  }

  void unsubscribeNotAnswer() {
    if (_notAnswerSubscription != null) {
      _notAnswerSubscription!.cancel();
      _notAnswerSubscription = null;
    }
  }

  void unsubscribePeerConnection() {
    if (_peerConnectionSubscription != null) {
      _peerConnectionSubscription!.cancel();
      _peerConnectionSubscription = null;
    }
  }
}
