import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/provider/payment_gateway.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/widget/loader_dialog.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var paymenticon = "";
  TextEditingController co_walletphone = new TextEditingController();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  MainController _mainController = Get.find();
  AuthController _authController = Get.find();
  var typepay = "";
  var viewstate = "";
  var paymenttitle = "";
  var data = Get.arguments;
  var payment_type = "";
  @override
  Widget build(BuildContext context) {
//================================================================================================================================================

    Widget SelectType(data, logo, name, current) {
      return Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.8,
                  blurRadius: 5,
                  offset: Offset(2, 5), // changes position of shadow
                ),
              ],
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[200]!,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 15),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Image.asset(
                    logo,
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      name,
                      style: TextStyle(fontFamily: 'mulibold', fontSize: 14),
                    ),
                  )
                ],
              )),
              Container(
                  child: Icon(
                FontAwesomeIcons.chevronRight,
                color: Colors.grey[400],
                size: 15,
              ))
            ],
          ));
    }

//================================================================================================================================================
//

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Obx(
          () => Text(
            "Payment Type - " + _mainController.start.value.toString(),
            style: TextStyle(fontFamily: 'neosansbold'),
          ),
        )),
        body: Container(
            child: Container(
          padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(12),
                  child: Text(
                    "Silahkan pilih metode pembayaran Anda",
                    style: TextStyle(fontFamily: 'mulibold', fontSize: 18),
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                        Container(
                          child: Text(
                            "Virtual Account",
                            style: TextStyle(
                                fontFamily: "neosansbold", fontSize: 18),
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        SelectType("response['data'][i]",
                            "assets/bayar_bni.png", "VA BNI", 0),
                        SelectType("response['data'][i]",
                            "assets/bayar_bri2.png", "VA BRO", 1),
                        SelectType("response['data'][i]",
                            "assets/bayar_mandiri.png", "VA MANDIRI", 2),
                        SelectType("response['data'][i]",
                            "assets/bayar_permata.png", "VA PERMATA", 3),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Text(
                            "E-Wallet",
                            style: TextStyle(
                                fontFamily: "neosansbold", fontSize: 18),
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.WALLETDETAIL, arguments: {
                              'icon': "assets/icon-ovo.png",
                              'data': data['time']
                            });
                          },
                          child: SelectType("response['data'][i]",
                              "assets/icon-ovo.png", "E-Wallet OVO", 4),
                        ),
                        InkWell(
                          onTap: () async {
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
                                data['time']['harga'],
                                "ID_DANA");
                            print(result);
                            Get.offNamed(Routes.WEBVIEW, arguments: [
                              result['actions']['mobile_web_checkout_url'],
                              "Ewallet Payment"
                            ])!
                                .then((value) async {
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
                          child: SelectType("response['data'][i]",
                              "assets/icon-dana.png", "E-Wallet DANA", 5),
                        ),
                        InkWell(
                          onTap: () async {
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
                                data['time']['harga'],
                                "ID_LINKAJA");
                            Get.offNamed(Routes.WEBVIEW, arguments: [
                              result['actions']['mobile_web_checkout_url'],
                              "Ewallet Payment"
                            ])!
                                .then((value) async {
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
                          child: SelectType("response['data'][i]",
                              "assets/icon-linkaja.png", "E-Wallet LIKNAJA", 6),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ])),
                ),
              ),
            ],
          ),
        )));
  }
}
