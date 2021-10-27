import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winlife/constant/color.dart';
import 'package:get/get.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/reward_model.dart';

class FramePromo extends StatefulWidget {
  const FramePromo({Key? key}) : super(key: key);

  @override
  _FramePromoState createState() => _FramePromoState();
}

class _FramePromoState extends State<FramePromo> {
  Future<void> _refresh() async {}
  MainController _mainController = Get.find();
  redeem(harga, modal) {
    var myIntharga = int.parse(harga);
    if (myIntharga > modal) {
      Get.defaultDialog(title: "Oops!", middleText: "Saldo Point tidak cukup.");
    } else {
      Get.defaultDialog(title: "Ok!", middleText: "Saldo Point cukup.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("hadiah");
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "Promo",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontFamily: 'neosansbold', color: Colors.black87),
            ),
          ),
        ),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Obx(() {
                if (_mainController.listReward.isEmpty) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: mainColor,
                    ),
                  );
                } else if (_mainController.listReward.first == null) {
                  return Center(
                    child: Text("Empty"),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    //height: 200,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: _mainController.listReward.length,
                        itemBuilder: (c, i) => InkWell(
                            onTap: () {},
                            child:
                                exploreview(_mainController.listReward[i]!))),
                  );
                }
              })),
        )));
  }

  Widget exploreview(Reward reward) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.8,
              blurRadius: 8,
              offset: Offset(2, 6), // changes position of shadow
            ),
          ],
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 135,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              child: Image.network(
                reward.foto!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          reward.nama_hadiah!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'neosansbold',
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          reward.jumlah_point! + " Point, valid until ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'muli',
                              color: Colors.black87,
                              fontSize: 12),
                        ),
                        Text(
                          reward.expired!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'muli',
                              color: Colors.black87,
                              fontSize: 12),
                        ),
                      ])),
                  Expanded(
                      child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0.8,
                                  blurRadius: 5,
                                  offset: Offset(
                                      2, 5), // changes position of shadow
                                ),
                              ],
                              color: mainColor,
                              border: Border.all(
                                color: mainColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    print("Clicked");
                                    redeem(reward.jumlah_point!, 45);
                                  },
                                  child: Text(
                                    "I Want".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'neosansbold',
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )))
                ],
              ))
        ],
      ),
    );
  }
}
