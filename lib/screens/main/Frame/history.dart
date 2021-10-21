import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/category_model.dart';
import 'package:winlife/data/model/history_model.dart';
import 'package:winlife/screens/main/service/detail_conselor.dart';

class FrameHistory extends StatefulWidget {
  const FrameHistory({Key? key}) : super(key: key);

  @override
  _FrameHistoryState createState() => _FrameHistoryState();
}

class _FrameHistoryState extends State<FrameHistory> {
  Future<void> _refresh() async {
    await _mainController.getAllHistory();
    dataHistory.clear();
    pageKey.value = 0;
    isLastPage.value = false;
  }

  MainController _mainController = Get.find();
  ScrollController _scrollController = ScrollController();

  RxList<History?> dataHistory = RxList<History?>();
  var isLastPage = false.obs;
  var _pageSize = 5;
  var pageKey = 0.obs;
  var isFetch = false.obs;

  Future<void> _fetchPage(int pageKey) async {
    isFetch.value = true;
    await Future.delayed(Duration(milliseconds: 1000));
    var delta = 0;
    if (_mainController.listHistory.length < _pageSize + pageKey) {
      delta = _mainController.listHistory.length - 1;
    } else {
      delta = _pageSize + pageKey;
    }
    final newItems = _mainController.listHistory.getRange(pageKey, delta);
    for (var item in newItems) {
      var res =
          await Future.wait([item!.conselorDetailFuture!, item.summaryFuture!]);
      item.conselorDetail = res[0];
      if (res[1] != null) {
        if (res[1]['data']['summary'].length > 0) {
          item.summary = res[1]['data']['summary'][0]['summary'];
        }
      }
    }
    isLastPage.value = newItems.length < _pageSize;
    if (isLastPage.value) {
      dataHistory.addAll(newItems);
      this.pageKey.value = 0;

      isFetch.value = false;
    } else {
      this.pageKey.value = pageKey + newItems.length;
      dataHistory.addAll(newItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "History".tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'neosansbold', color: Colors.black87),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              if (_mainController.historyLoad.value) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: mainColor,
                  ),
                );
              } else {
                if (_mainController.listHistory.isEmpty) {
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
                                  fontFamily: "neosansbold", fontSize: 20),
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
                } else {
                  if (dataHistory.length == 0) {
                    _fetchPage(pageKey.value);
                  }
                  return NotificationListener(
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                          itemCount: dataHistory.length + 1,
                          controller: _scrollController,
                          itemBuilder: (contex, index) {
                            if (index < dataHistory.length) {
                              return exploreview(context, dataHistory[index]!);
                            } else {
                              return Visibility(
                                visible: isFetch.value,
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
                        if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                          if (!isLastPage.value) {
                            _fetchPage(pageKey.value);
                          }
                        }
                      }
                      return true;
                    },
                  );
                }
              }
            })),
      ),
    );
  }

  Widget exploreview(BuildContext context, History data) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
            title: "Summary",
            middleText: data.summary != null
                ? data.summary!
                : "Menunggu Summary dari Konselor");
      },
      child: Container(
        width: double.infinity,
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
            borderRadius: BorderRadius.all(Radius.circular(7))),
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: FittedBox(
                        child: Text(
                          data.duration!.name,
                          style: TextStyle(
                              fontFamily: 'neosansbold', color: Colors.white),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: FittedBox(
                        child: Text(
                          data.jadwal_hari + ", " + data.tanggal_formated !=
                                  null
                              ? data.tanggal_formated
                              : "",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'muli',
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                            "Hope",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'neosansbold',
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            data.hope,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'muli',
                                color: Colors.black87,
                                fontSize: 12),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            width: 100,
                            color: Colors.green,
                            height: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Problem".tr,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'neosansbold',
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                data.problem,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'muli',
                                    color: Colors.black87,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Summary",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'neosansbold',
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                data.summary != null
                                    ? data.summary!
                                    : "Menunggu Summary dari Konselor",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'muli',
                                    color: Colors.black87,
                                    fontSize: 12),
                              ),
                            ],
                          )
                        ])),
                    InkWell(
                      onTap: () {
                        CategoryItem cat = _mainController.listCategory
                            .where((val) => val.id == data.duration!.kategori)
                            .toList()
                            .first;
                        if (data.conselor != null) {
                          Get.to(() => DetailConselor(data.conselor!, cat));
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            width: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                data.conselorDetail != null
                                    ? data.conselorDetail!.foto_konselor
                                    : "http://web-backend.winlife.id:80/uploads/konselor/20210905203938-2021-09-05konselor203931.jpg",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data.conselor != null
                                ? data.conselor!.name
                                : "Unknown",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: 'muli',
                                color: Colors.black87,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Point : 200",
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: 'muli',
                                color: Colors.black87,
                                fontSize: 8),
                          ),
                          RatingBar.builder(
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.3),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              size: 10,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
