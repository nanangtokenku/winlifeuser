import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:winlife/constant/color.dart';
import 'package:get/get.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/category_model.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/routes/app_routes.dart';

class DetailConselor extends StatefulWidget {
  Conselor conselor;
  CategoryItem cat;
  DetailConselor(this.conselor, this.cat);

  @override
  _DetailConselorState createState() => _DetailConselorState();
}

class _DetailConselorState extends State<DetailConselor> {
  void consulNow(type, data) {
    if (data.isActive) {
      if (!data.inOrder) {
        Get.toNamed(Routes.DETAILORDER,
            arguments: {'type': type, 'data': data, 'category': widget.cat});
      } else {
        Get.defaultDialog(title: "Oops!", middleText: "Conselor in Order");
      }
    } else {
      Get.defaultDialog(title: "Oops!", middleText: "Conselor not active");
    }
  }

  MainController _mainController = Get.find();

  Future<void> _refresh() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Detail Counselor".tr,
            style: TextStyle(fontFamily: 'neosansbold', color: Colors.black87),
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
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0.8,
                              blurRadius: 8,
                              offset:
                                  Offset(2, 6), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: const EdgeInsets.only(
                          left: 10, top: 15, right: 10, bottom: 20),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                //=============================================================
                                FutureBuilder(
                                    future: _mainController
                                        .getConselor(widget.conselor.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.data != null) {
                                          ConselorDetail data =
                                              snapshot.data as ConselorDetail;
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1,
                                                child: Image.network(
                                                  data.foto_konselor,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        width: double.infinity,
                                                        height: 90,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                widget.conselor
                                                                            .streamConselor !=
                                                                        null
                                                                    ? StreamBuilder<
                                                                            DocumentSnapshot>(
                                                                        stream: widget
                                                                            .conselor
                                                                            .streamConselor,
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            Map snap =
                                                                                snapshot.data!.data() as Map;
                                                                            if (snap['isActive'] !=
                                                                                null) {
                                                                              widget.conselor.isActive = snap['isActive'];
                                                                            }
                                                                            if (snap['inOrder'] !=
                                                                                null) {
                                                                              widget.conselor.inOrder = snap['inOrder'];
                                                                            }
                                                                            widget.conselor.lastActive =
                                                                                snap['lastActive'];
                                                                          }
                                                                          return Container(
                                                                            margin:
                                                                                const EdgeInsets.only(right: 5),
                                                                            width:
                                                                                12,
                                                                            height:
                                                                                12,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: widget.conselor.isActive
                                                                                  ? widget.conselor.inOrder
                                                                                      ? Colors.red
                                                                                      : Colors.green
                                                                                  : Colors.grey,
                                                                            ),
                                                                          );
                                                                        })
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            right:
                                                                                5),
                                                                        width:
                                                                            12,
                                                                        height:
                                                                            12,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color: widget.conselor.isActive
                                                                              ? Colors.green
                                                                              : Colors.grey,
                                                                        ),
                                                                      ),
                                                                Text(
                                                                    widget
                                                                        .conselor
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'neosansbold',
                                                                        fontSize:
                                                                            18)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Text(
                                                    "Riwayat Pendidikan".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'neosansbold',
                                                        fontSize: 15)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 5),
                                                child: Text(
                                                    data.riwayat_pendidikan,
                                                    style: TextStyle(
                                                        fontFamily: 'muli',
                                                        fontSize: 15)),
                                              ),
                                              //=============================================================
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Text(
                                                    "Lama Pengalaman".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'neosansbold',
                                                        fontSize: 15)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 5),
                                                child: Text(
                                                    data.lama_pengalaman +
                                                        " Tahun",
                                                    style: TextStyle(
                                                        fontFamily: 'muli',
                                                        fontSize: 15)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Text(
                                                    "Riwayat Pengalaman".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'neosansbold',
                                                        fontSize: 15)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 5),
                                                child: Text(
                                                  data.riwayat_pengalaman,
                                                ),
                                              ),
                                              //============================================================

                                              //=============================================================
                                            ],
                                          );
                                        } else {
                                          return Center(child: Text("Kosong"));
                                        }
                                      } else {
                                        return Center(
                                          child: SpinKitFadingCircle(
                                            color: mainColor,
                                          ),
                                        );
                                      }
                                    })
                                //=============================================================
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 18,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Start With".tr,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'neosansbold',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ])),
                                Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            consulNow("Chat", widget.conselor);
                                          },
                                          child: Container(
                                            height: 35,
                                            child: Icon(Icons.chat_bubble,
                                                color: Colors.grey[500],
                                                size: 20),
                                          ),
                                        )),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            consulNow("call", widget.conselor);
                                          },
                                          child: Container(
                                            height: 35,
                                            child: Icon(FontAwesomeIcons.phone,
                                                color: Colors.grey[500],
                                                size: 20),
                                          ),
                                        )),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            consulNow(
                                                "Video Call", widget.conselor);
                                          },
                                          child: Container(
                                            height: 35,
                                            child: Icon(FontAwesomeIcons.video,
                                                color: Colors.grey[500],
                                                size: 20),
                                          ),
                                        )),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            consulNow(
                                                "Meeting", widget.conselor);
                                          },
                                          child: Container(
                                            height: 35,
                                            child: Icon(
                                                FontAwesomeIcons.handshake,
                                                color: Colors.grey[500],
                                                size: 20),
                                          ),
                                        )),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        )));
  }
}
