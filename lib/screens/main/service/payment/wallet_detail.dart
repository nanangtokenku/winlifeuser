import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/provider/payment_gateway.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/widget/loader_dialog.dart';

class WalletDetail extends StatefulWidget {
  const WalletDetail({Key? key}) : super(key: key);

  @override
  _WalletDetailState createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  TextEditingController co_walletphone = new TextEditingController();
  MainController _mainController = Get.find();
  AuthController _authController = Get.find();
  var args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          child: new Image.asset(args['icon']),
                        ),
                      ],
                    )),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "E-Wallet Payment ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "NeoSansBold", fontSize: 25),
                          )),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Please enter your phone number",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: "MuliLight", fontSize: 12),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    width: double.infinity,
                    child: Text(
                      "PHONE NUMBER",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: "mulilight", fontSize: 12),
                    )),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 0),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            controller: co_walletphone,
                            decoration: const InputDecoration(
                              hintText: '628xxxxxxx',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ))
                      ],
                    )),
                Center(
                  child: Container(
                      width: double.infinity,
                      height: 45,
                      margin: const EdgeInsets.only(top: 30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5),
                          shadowColor: mainColor,
                          elevation: 5.0,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 0.0,
                            minWidth: 200.0,
                            height: 50.0,
                            onPressed: () async {
                              loaderDialog(
                                  context,
                                  SpinKitFadingCircle(
                                    color: mainColor,
                                  ),
                                  "Loading");
                              var result = await PaymentGateway.chargeEwallet(
                                  _authController.user.id +
                                      "-" +
                                      _authController.user.email +
                                      "-" +
                                      DateTime.now().toString(),
                                  args['data']['harga'],
                                  "ID_DANA");
                              print(result);
                              Get.offNamed(Routes.WEBVIEW, arguments: [
                                result['actions']['mobile_web_checkout_url'],
                                "Ewallet Payment"
                              ])!
                                  .then((value) async {
                                Get.back();
                                Get.back();
                                loaderDialog(
                                    context,
                                    SpinKitFadingCircle(
                                      color: mainColor,
                                    ),
                                    "Please wait");
                                var cekStatus =
                                    await PaymentGateway.cekEwalletPayment(
                                        result['id']);
                                if (cekStatus['status'] == 'SUCCEEDED') {
                                  _mainController.paid.value = true;
                                }
                                Get.back();
                              });
                            },
                            color: mainColor,
                            child: Text('CONTINUE',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: 'mulibold')),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
