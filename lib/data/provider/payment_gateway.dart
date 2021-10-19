import 'package:flutter/foundation.dart';
import 'package:winlife/data/provider/api.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PaymentGateway {
  static String xenditKey = "";
  static String testKey =
      "eG5kX2RldmVsb3BtZW50X3ZOaEU1bzhtOW9Ka0V6T1R4ZjFudDVaS3E3bnJKUnB4aFpJNUN6ODU1S3psbXp4RU55ejNGVHR4eW01TTh0Og==";
  static Future<dynamic> getXenditKey(String token) async {
    String url = Api.XENDITKEY;
    final res = await http.get(Uri.parse(url), headers: {
      "x-api-key": Api.API_KEY,
      "x-token": token,
    });
    final decode = await compute(convert.jsonDecode, res.body);
    String result = decode['data']['xendit_key'][0]['api_key_secret'];
    int iter = 0;
    var length = result.length / 3;
    for (var i = 0; i < length; i++) {
      for (var j = 1; j <= 3; j++) {
        if (i % 2 != 0) {
          int index = j + (i * 3) - 1 - iter;
          result = result.substring(0, index) + result.substring(index + 1);
          iter += 1;
        }
      }
    }
    String xendit = convert.base64.encode(convert.utf8.encode(result));
    xenditKey = xendit.replaceAll("w==", "zo=");
  }

  static Future<dynamic> chargeEwallet(
      String id, String harga, String channelCode) async {
    String url = Api.CHARGELINKAJA;
    final res = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Basic $testKey',
          'Content-Type': 'application/json'
        },
        body: convert.jsonEncode({
          "reference_id": "$id",
          "currency": "IDR",
          "amount": int.parse(harga),
          "checkout_method": "ONE_TIME_PAYMENT",
          "channel_code": channelCode,
          "channel_properties": {
            "success_redirect_url": "https://winlife.id/xendit-payment-succes"
          },
          "metadata": {"branch_area": "PLUIT", "branch_city": "JAKARTA"}
        }));
    final decode = await compute(convert.jsonDecode, res.body);
    return decode;
  }

  static Future<dynamic> chargeEwalletOvo(
      String id, String harga, String channelCode, String number) async {
    String url = Api.CHARGELINKAJA;
    final res = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Basic $testKey',
          'Content-Type': 'application/json'
        },
        body: convert.jsonEncode({
          "reference_id": "$id",
          "currency": "IDR",
          "amount": int.parse(harga),
          "checkout_method": "ONE_TIME_PAYMENT",
          "channel_code": channelCode,
          "channel_properties": {"mobile_number": number},
          "metadata": {"branch_area": "PLUIT", "branch_city": "JAKARTA"}
        }));
    final decode = await compute(convert.jsonDecode, res.body);
    return decode;
  }

  static Future<dynamic> cekEwalletPayment(String id) async {
    String url = Api.CEKEWALLETCHARGE + '/$id';
    final res = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Basic $testKey',
      'Content-Type': 'application/json'
    });
    final decode = await compute(convert.jsonDecode, res.body);
    return decode;
  }
}
