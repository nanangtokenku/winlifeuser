import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/category_model.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/main/service/detail_conselor.dart';

class ListConselor extends StatefulWidget {
  @override
  _ListConselorState createState() => _ListConselorState();
}

class _ListConselorState extends State<ListConselor> {
  var response;
  bool loaded = false;

  var _searchConselor = "".obs;

  sendLogKonselor(tipe, nama, status) async {
    print("v23 konselor status  = " +
        tipe +
        "=>" +
        nama.toString() +
        "=>" +
        status.toString());

    //makeRequest(tipe, nama.toString(), status.toString());

    final response = await http.post(
        Uri.parse('https://web-backend.winlife.id/' + "/ajax/setLog.php"),
        body: <String, String>{
          'tipe': tipe,
          'nama': nama,
          'status': status.toString()
        });
  }

  void makeRequest(tipe, nama, status) async {
    var response = await http.get(Uri.https(
        'https://web-backend.winlife.id/',
        'ajax/setLog.php?tipe=' +
            tipe +
            "&nama=" +
            nama.toString() +
            "&status=" +
            status.toString()));
    //If the http request is successful the statusCode will be 200
    //if (response.statusCode == 200) {
    //String htmlToParse = response.body;
    //print(htmlToParse);
    //}
  }

  Future<void> _refresh() async {
    isLastPage.value = false;
    dataConselor.clear();
    pageKey.value = 0;
    _fetchPage(0);
  }

  RxList<Conselor?> dataConselor = RxList<Conselor?>();
  ScrollController _scrollController = ScrollController();
  var isLastPage = false.obs;
  var _pageSize = 5;
  var pageKey = 0.obs;
  var isFetch = false.obs;

  Future<void> _fetchPage(int pageKey) async {
    isFetch.value = true;
    await Future.delayed(Duration(milliseconds: 1000));
    var delta = 0;
    final newItems =
        await _mainController.getConselorPagging(_pageSize, pageKey);
    isLastPage.value = newItems.length < _pageSize;
    print("last page = " + isLastPage.toString());
    print("page key " + pageKey.toString());
    if (isLastPage.value) {
      this.pageKey.value = 9900099;
      dataConselor.addAll(newItems);
    } else {
      dataConselor.addAll(newItems);
      this.pageKey.value = pageKey + newItems.length;
    }

    isFetch.value = false;
  }

  var args = Get.arguments;

  void consulNow(type, Conselor data, CategoryItem categoryItem) {
    if (data.isActive) {
      if (!data.inOrder) {
        Get.toNamed(Routes.DETAILORDER,
            arguments: {'type': type, 'data': data, 'category': categoryItem});
      } else {
        Get.defaultDialog(title: "Oops!", middleText: "Conselor in Order");
      }
    } else {
      Get.defaultDialog(title: "Oops!", middleText: "Conselor not active");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    CategoryItem categoryItem = args['category'];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "List Counselor - ${categoryItem.name}",
            style: TextStyle(fontFamily: 'neosansbold'),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.grey[200],
                    ),
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          hintText: "Find Conselor",
                          border: InputBorder.none),
                      onChanged: (value) {
                        _searchConselor.value = value;
                      },
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Muli'),
                    )),
              ),
              Flexible(
                  flex: 9,
                  child: Obx(() {
                    if (_mainController.listConselor.isEmpty) {
                      return SpinKitFadingCircle(
                        color: mainColor,
                      );
                    }
                    if (_searchConselor.value != "") {
                      var data = _mainController.listConselor
                          .where((element) => element!.name
                              .toLowerCase()
                              .contains(_searchConselor.value.toLowerCase()))
                          .toList();
                      if (data.isNotEmpty) {
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return exploreview(context, data[i]!);
                            });
                      } else {
                        return Center(
                          child: Text("Empty"),
                        );
                      }
                    } else {
                      if (!_mainController.listConselor.contains(null)) {
                        if (dataConselor.length == 0) {
                          _fetchPage(pageKey.value);
                        }
                        return NotificationListener(
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.builder(
                                itemCount: dataConselor.length + 1,
                                controller: _scrollController,
                                itemBuilder: (contex, index) {
                                  if (index < dataConselor.length) {
                                    //print("v23 data c " +
                                    // dataConselor[index].toString());
                                    return exploreview(
                                        context, dataConselor[index]!);
                                  } else {
                                    return Visibility(
                                      visible: !isLastPage.value,
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: SpinKitFadingCircle(
                                            color: mainColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ),
                          onNotification: (t) {
                            if (t is ScrollEndNotification) {
                              if (_scrollController.position.pixels >
                                  _scrollController.position.maxScrollExtent -
                                      75) {
                                if (!isLastPage.value && !isFetch.value) {
                                  _fetchPage(pageKey.value);
                                }
                              }
                            }
                            return true;
                          },
                        );
                      } else {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 300,
                                    child: Image.asset("assets/icon_empty.png"),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Empty".tr,
                                    style: TextStyle(
                                        fontFamily: "neosansbold",
                                        fontSize: 20),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _refresh();
                                  },
                                  child: Container(
                                      color: mainColor,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "Reload".tr,
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  })),
            ],
          ),
        ));
  }

  Widget exploreview(BuildContext context, Conselor data) {
    return Stack(
      children: [
        Container(
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
          margin: const EdgeInsets.only(left: 40, top: 15, right: 10),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  margin: const EdgeInsets.only(left: 70),
                  width: double.infinity,
                  height: 90,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            data.streamConselor != null
                                ? StreamBuilder<DocumentSnapshot>(
                                    stream: data.streamConselor,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Map snap = snapshot.data!.data() as Map;
                                        if (snap['isActive'] != null) {
                                          data.isActive = snap['isActive'];

                                          sendLogKonselor("isActive", data.name,
                                              data.isActive);
                                        }
                                        if (snap['inOrder'] != null) {
                                          data.inOrder = snap['inOrder'];

                                          sendLogKonselor("inOrder", data.name,
                                              data.inOrder);
                                        }
                                        data.lastActive = snap['lastActive'];
                                      }
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: data.isActive
                                              ? data.inOrder
                                                  ? Colors.red
                                                  : Colors.green
                                              : Colors.grey,
                                        ),
                                      );
                                    })
                                : Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: data.isActive
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                            Text(data.name,
                                style: TextStyle(
                                    fontFamily: 'neosansbold', fontSize: 18)),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Container(
                                  child: RatingBar.builder(
                                    initialRating: 3.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 15,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0.3),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ])),
              Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  consulNow("Chat", data, args['category']);
                                },
                                child: Container(
                                  height: 35,
                                  child: Icon(Icons.chat_bubble,
                                      color: Colors.grey[500], size: 20),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  consulNow("call", data, args['category']);
                                },
                                child: Container(
                                  height: 35,
                                  child: Icon(FontAwesomeIcons.phone,
                                      color: Colors.grey[500], size: 20),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  consulNow(
                                      "Video Call", data, args['category']);
                                },
                                child: Container(
                                  height: 35,
                                  child: Icon(FontAwesomeIcons.video,
                                      color: Colors.grey[500], size: 20),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  consulNow("Meeting", data, args['category']);
                                },
                                child: Container(
                                  height: 35,
                                  child: Icon(FontAwesomeIcons.handshake,
                                      color: Colors.grey[500], size: 20),
                                ),
                              )),
                            ],
                          ))
                    ],
                  ))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30, left: 10, bottom: 10),
          width: 85,
          height: 85,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(2, 6), // changes position of shadow
                ),
              ],
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Center(
            child: OpenContainer(
              closedBuilder: (_, openContainer) {
                return AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    data.conselorDetail != null
                        ? data.conselorDetail!.foto_konselor
                        : "http://web-backend.winlife.id:80/uploads/konselor/20210905203938-2021-09-05konselor203931.jpg",
                    fit: BoxFit.cover,
                  ),
                );
              },
              openColor: Colors.white,
              closedElevation: 10.0,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              closedColor: Colors.white,
              openBuilder: (_, closeContainer) {
                return new DetailConselor(data, args['category']);
              },
            ),
          ),
        ),
      ],
    );
  }
}
