import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/controller/quickblox_controller.dart';
import 'package:winlife/data/model/category_model.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/data/model/duration_model.dart';
import 'package:winlife/data/provider/FCM.dart';
import 'package:winlife/helper/CurrencyFormat.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/widget/dialog.dart';
import 'package:winlife/screens/widget/loader_dialog.dart';
import 'package:uuid/uuid.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({Key? key}) : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  TextEditingController coProblem = new TextEditingController();
  TextEditingController coHope = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  AuthController _authController = Get.find();
  QBController _qbController = Get.find();
  String msg = '';
  bool showbody = true;
  bool showfilter = false;
  var response;
  var selected = 0.obs;
  var args = Get.arguments;
  var harga = 0.obs;
  String fcmToken = '';
  List<DurationItem> data = [];
  @override
  void initState() {
    CategoryItem cat = args['category'];
    var dur = [];
    data = _mainController.listDuration.where((value) {
      bool result = cat.id == value.kategori &&
          value.tipeName.toLowerCase() == args['type'].toString().toLowerCase();
      if (result) {
        dur.add(value.time);
      }
      return result;
    }).toList();
    if (data.isNotEmpty) {
      _mainController.durationOrder.value = DurationItem(
          data[selected.value].id,
          data[selected.value].name,
          data[selected.value].time,
          data[selected.value].harga,
          data[selected.value].kategori,
          data[selected.value].tipe,
          data[selected.value].tipeName);
      print("id service duration = " + data[selected.value].id);
    } else {
      _mainController.durationOrder.value =
          DurationItem("", "", "", "", "", "", "");
    }
    super.initState();
  }

  bool loaded = false;

  final MainController _mainController = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose
    _mainController.durationOrder.value = null;
    _mainController.voucherOrder.value = null;
    super.dispose();
  }

  // ===========================VIEW===================================================================================================
  @override
  Widget build(BuildContext context) {
    print(
      "Select Time - ${(args['data'] as Conselor).name}",
    );
    print(
      "Select Time - ${(args['data'] as Conselor).id}",
    );
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Select Time - ${(args['data'] as Conselor).name}",
            style: TextStyle(fontFamily: 'neosansbold'),
          ),
          actions: <Widget>[
            // Padding(
            //     padding: EdgeInsets.only(right: 20.0),
            //     child: GestureDetector(
            //       onTap: () {},
            //       child: Icon(FontAwesomeIcons.filter, size: 18),
            //     )),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Column(
              children: <Widget>[
                //================================================

                Container(
                    child: Text(
                  "Silahkan pilih waktu konsultasi yang Anda butuhkan ",
                  style: TextStyle(fontFamily: 'mulibold', fontSize: 18),
                )),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text("Please Input Your Problem :")),
                Container(
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 15),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 1),
                    child: TextFormField(
                      controller: coProblem,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Explain your problem to conselor',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text("Please Input Your Hope :")),
                Container(
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 15),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 1),
                    child: TextFormField(
                      controller: coHope,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Explain your hope to conselor',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text("Select Time Consultation :")),
                Obx(() {
                  if (_mainController.listDuration.isEmpty) {
                    _mainController.getAllDuration();
                    return Center(
                      child: SpinKitFadingCircle(
                        color: mainColor,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, i) => selectType(data[i], i));
                  }
                }),

                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.LISTVOUCHER)!.then((value) {
                      if (_mainController.voucherOrder.value != null) {
                        int ord = int.parse(
                            _mainController.durationOrder.value!.harga);
                        int voc = int.parse(
                            _mainController.voucherOrder.value!.nilai_rupiah);
                        int diff = ord - voc;
                        if (diff < 0) {
                          _mainController.durationOrder.value!.harga = "100";
                        } else {
                          _mainController.durationOrder.value!.harga =
                              diff.toString();
                        }
                      }
                      _mainController.durationOrder.refresh();
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 1),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(32)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.card_membership, color: mainColor),
                              SizedBox(
                                width: 12,
                              ),
                              FittedBox(
                                child: Obx(() {
                                  if (_mainController.voucherOrder.value !=
                                      null) {
                                    return Text(
                                      _mainController
                                          .voucherOrder.value!.promoCode,
                                      style: TextStyle(
                                          fontFamily: 'neosans', fontSize: 16),
                                    );
                                  } else {
                                    return Text(
                                      "Input Kode Promo",
                                      style: TextStyle(
                                          fontFamily: 'neosans', fontSize: 16),
                                    );
                                  }
                                }),
                              ),
                            ],
                          ),
                          Obx(() {
                            return Visibility(
                                visible:
                                    _mainController.voucherOrder.value != null,
                                child: InkWell(
                                  onTap: () {
                                    _mainController.voucherOrder.value = null;
                                    _mainController.durationOrder.value =
                                        DurationItem(
                                            data[selected.value].id,
                                            data[selected.value].name,
                                            data[selected.value].time,
                                            data[selected.value].harga,
                                            data[selected.value].kategori,
                                            data[selected.value].tipe,
                                            data[selected.value].tipeName);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: Icon(Icons.remove,
                                          color: Colors.white)),
                                ));
                          }),
                        ],
                      )),
                ),
                SizedBox(
                  width: 12,
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(
                            "Type Konsultasi ",
                            style: TextStyle(
                                fontFamily: 'neosansbold', fontSize: 13),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            args['type'],
                            textAlign: TextAlign.right,
                            style: TextStyle(fontFamily: 'muli', fontSize: 13),
                          ),
                        ),
                      ],
                    )), //================================================

                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(
                            "Waktu Konsultasi ",
                            style: TextStyle(
                                fontFamily: 'neosansbold', fontSize: 13),
                          ),
                        ),
                        FittedBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              FontAwesomeIcons.clock,
                              color: Colors.green,
                              size: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: Obx(
                                () => Text(
                                  _mainController.durationOrder.value!.time +
                                      "Mins",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: 'muli', fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        )),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        "Harga",
                        style:
                            TextStyle(fontFamily: 'neosansbold', fontSize: 18),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "IDR ",
                            textAlign: TextAlign.right,
                            style:
                                TextStyle(fontFamily: 'mulibold', fontSize: 15),
                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: Obx(
                                () {
                                  return Text(
                                    CurrencyFormat.convertToIdr(
                                        int.parse(_mainController
                                            .durationOrder.value!.harga),
                                        0),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontFamily: 'muli', fontSize: 15),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
                //================================================
                //
                Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0.8,
                            blurRadius: 5,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                        color: mainColor,
                        border: Border.all(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(13),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () async {
                            if (data.isNotEmpty) {
                              if (coHope.text != "" && coProblem.text != "") {
                                if (args['data'].isActive &&
                                    !args['data'].inOrder) {
                                  await sendRequest();
                                } else {
                                  Get.defaultDialog(
                                      title: "Oops!",
                                      middleText: "Conselor tidak aktif");
                                }
                              } else {
                                Get.defaultDialog(
                                    title: "Oops!",
                                    middleText: "Complete your form!");
                              }
                            }
                          },
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'neosansbold',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        )),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }

  Future<void> sendRequest() async {
    fcmToken = await FCM.getToken((args['data'] as Conselor).email);
    var data = {
      'message': 'create_order',
      'sesi': const Uuid().v1().replaceAll("-", ""),
      'type': args['type'],
      'problem': coProblem.text,
      'hope': coHope.text,
      'time': _mainController.durationOrder.value!.toJson(),
      'user': _authController.user.toJson(),
      'qb': _qbController.qbUser!.id,
      'fcm': _authController.tokenFCM,
      'conselorFCM': fcmToken
    };
    loaderDialog(
        context,
        SpinKitFadingCircle(
          color: mainColor,
        ),
        "Please Wait");
    var resFCM = await FCM.send(fcmToken, data,
        notif: {'title': "Order Incoming", "body": "${data['problem']}"});
    if (resFCM['success'] == 1) {
      Get.offNamedUntil(Routes.WAITINGSCREEN, ModalRoute.withName(Routes.MAIN),
          arguments: {'conselor': args['data'], 'data': data});
    }
  }

  Widget selectType(DurationItem data, int i) {
    return InkWell(
        onTap: () {
          selected.value = i;
          _mainController.durationOrder.value = DurationItem(data.id, data.name,
              data.time, data.harga, data.kategori, data.tipe, data.tipeName);
          if (_mainController.voucherOrder.value != null) {
            int ord = int.parse(_mainController.durationOrder.value!.harga);
            int voc =
                int.parse(_mainController.voucherOrder.value!.nilai_rupiah);
            int diff = ord - voc;
            if (diff < 0) {
              _mainController.durationOrder.value!.harga = "100";
            } else {
              _mainController.durationOrder.value!.harga = diff.toString();
            }
          }
          _mainController.durationOrder.refresh();
        },
        child: Obx(
          () => Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0.8,
                      blurRadius: 5,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                  color: selected.value == i ? Colors.green : Colors.white,
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data.time + "mins",
                      style: TextStyle(fontFamily: 'neosansbold', fontSize: 18),
                    ),
                  ),
                  Container(
                      child: Icon(
                    FontAwesomeIcons.chevronRight,
                    color: Colors.grey[400],
                    size: 15,
                  ))
                ],
              )),
        ));
  }
}
