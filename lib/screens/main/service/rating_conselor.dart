import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/widget/loader_dialog.dart';

class RatingConselor extends StatefulWidget {
  const RatingConselor({Key? key}) : super(key: key);

  @override
  _RatingConselorState createState() => _RatingConselorState();
}

class _RatingConselorState extends State<RatingConselor> {
  MainController _mainController = Get.find();
  double ratingConselor = 0;
  TextEditingController _review = TextEditingController();
  var args = Get.arguments;
  Conselor? conselor;
  @override
  void initState() {
    // TODO: implement initState
    print(args);
    conselor = args['conselor'];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            child: Container(
              padding: const EdgeInsets.only(left: 25, top: 0, right: 25),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Order Selesai!",
                                  style: TextStyle(
                                      fontFamily: 'neosansbold', fontSize: 24),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Berikan penilaian anda",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'muli', fontSize: 18),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, left: 10, bottom: 10),
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: Offset(2,
                                              6), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: InkWell(
                                    child: Center(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.network(
                                            conselor!.conselorDetail != null
                                                ? conselor!.conselorDetail!
                                                    .foto_konselor
                                                : "http://web-backend.winlife.id:80/uploads/konselor/20210905203938-2021-09-05konselor203931.jpg",
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    onTap: () {},
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 90,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(conselor!.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'neosansbold',
                                              fontSize: 18,
                                            )),
                                        // Container(
                                        //   margin: const EdgeInsets.only(top: 4),
                                        //   child: Text(
                                        //     "Rate: 4,5",
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        // ),
                                      ])),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  ratingConselor = rating;
                                },
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    maxLines: 3,
                                    controller: _review,
                                    decoration: InputDecoration(
                                      label: Text("Review"),
                                      labelStyle: TextStyle(color: mainColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                      ),
                                    ),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 0.8,
                                          blurRadius: 5,
                                          offset: Offset(2,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      color: mainColor,
                                      border: Border.all(
                                        color: mainColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: const EdgeInsets.all(13),
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          loaderDialog(
                                              context,
                                              SpinKitFadingCircle(
                                                color: mainColor,
                                              ),
                                              "Loading");
                                          await _mainController.addRating(
                                              conselor!.id,
                                              "1",
                                              ratingConselor.toString(),
                                              _review.text);
                                          Get.until((route) =>
                                              Get.currentRoute == Routes.MAIN);
                                        },
                                        child: Text(
                                          "Submit",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'neosansbold',
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      )),
                                    ],
                                  )),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
