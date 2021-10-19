import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winlife/data/provider/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HttpService {
  //AUTH =======================================================================
  static Future<dynamic> register(
      String name, String email, String password, String mobileNumber) async {
    try {
      String url = Api.REGISTER;

      final res = await http.post(Uri.parse(url), body: {
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "name": name
      }, headers: {
        "x-api-key": Api.API_KEY,
      });
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> login(String email, String password) async {
    String url = Api.LOGIN;

    final res = await http.post(Uri.parse(url), body: {
      "username": email,
      "password": password,
    }, headers: {
      "x-api-key": Api.API_KEY,
    });
    print(res.statusCode);
    final result = await compute(convert.jsonDecode, res.body);
    return result;
  }

  static Future<UserCredential?> signIngWithGoogle() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();

    GoogleSignInAccount? googleuser =
        await GoogleSignIn(scopes: <String>['email']).signIn();
    if (googleuser == null) {
      return null;
    }
    GoogleSignInAuthentication googleAuth = await googleuser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    var user = await FirebaseAuth.instance.signInWithCredential(credential);
    googleSignIn.disconnect();
    return user;
  }

  static Future<UserCredential?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ["email", "public_profile", "user_friends"]);
    // Create a credential from the access token
    print(loginResult.message);
    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }
    return null;
  }

  //HOME =======================================================================

  static Future<dynamic> getAllKategori(String token) async {
    try {
      String url = Api.KATEGORI;

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getAllDuration(String token) async {
    try {
      String url = Api.DURATION + "?limit=10000";

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getAllConselor(String token) async {
    try {
      String url = Api.KONSELOR;

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getPageConselor(
      String token, String limit, String start) async {
    try {
      String url = Api.KONSELOR + '?limit=$limit&start=$start';

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getPoint(String token, String uid) async {
    try {
      String url = Api.POINT + "?uuid=$uid";

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getConselor(String token, String id) async {
    try {
      String url = Api.KONSELORDETAIL + "/?id=$id";

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode,
          res.body.replaceAll("<br", "").replaceAll('\\/>', ""));
      return result['data']['konselor_detail'];
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getConselor2(String token, String id) async {
    try {
      String url = Api.KONSELORDETAIL + "/?id=$id";

      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result['data']['register_konselor'];
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getBannerAll(String token) async {
    try {
      String url = Api.BANNER;
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> getHistory(String token, String uid) async {
    try {
      String url = Api.ORDERDETAILALL + '?uuid=$uid';
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      print(result['data']['order_detail'].length);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> getHistoryDetail(String token, String sesi) async {
    try {
      String url = Api.ORDERDETAILSUMMARY + '?sesi=$sesi';
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> getListKodeVoucher(String token) async {
    try {
      String url = Api.LISTKODEVOUCHER;
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> addOrder(
      String token,
      String sesi,
      String uuid,
      String konselorid,
      String problem,
      String hope,
      String serviceID,
      String jadwalHari,
      String jadwalTgl) async {
    try {
      String url = Api.ORDERDETAIL;
      final res = await http.post(Uri.parse(url), headers: {
        "x-api-key": Api.API_KEY,
        "x-token": token
      }, body: {
        "sesi_id": sesi,
        "user_uuid": uuid,
        "problem": problem,
        "hope": hope,
        "service_id": serviceID,
        "jadwal_hari": jadwalHari,
        "konselor_id": konselorid,
        "jadwal_tanggal": jadwalTgl
      });
      final result = await compute(convert.jsonDecode, res.body);
      print("add order");
      print(result);
      return result;
    } catch (e) {
      Get.defaultDialog(title: "Error", middleText: e.toString());
      return null;
    }
  }

  static Future<dynamic> addRating(
      String token,
      String userid,
      String konselorid,
      String serviceid,
      String rating,
      String rating_reason) async {
    try {
      String url = Api.RATING;
      final res = await http.post(Uri.parse(url), headers: {
        "x-api-key": Api.API_KEY,
        "x-token": token
      }, body: {
        "userid": userid,
        "konselorid": konselorid,
        "serviceid": serviceid,
        "rating": rating,
        "rating_reason": rating_reason
      });
      final result = await compute(convert.jsonDecode, res.body);
      print(result);
      return result;
    } catch (e) {
      Get.defaultDialog(title: "Error", middleText: e.toString());
      return null;
    }
  }

  static Future<dynamic> getReward(String token) async {
    try {
      String url = Api.REWARDS;
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> getPointDetail(String token, String sesi) async {
    try {
      String url = Api.POINTDETAIL + "$sesi";
      final res = await http.get(Uri.parse(url),
          headers: {"x-api-key": Api.API_KEY, "x-token": token});
      final result = await compute(convert.jsonDecode, res.body);
      return result['data']['point_records'];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
