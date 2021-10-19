import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/category_model.dart';

class EditFavorite extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<EditFavorite> {
  RxList<CategoryItem> listCategoryFav = RxList<CategoryItem>();
  String msg = '';
  bool showbody = true;
  bool showfilter = false;
  bool loaded = false;
  var response;

  MainController _mainController = Get.find();

  @override
  void initState() {
    _mainController.listCategoryFav.forEach((element) {
      listCategoryFav.add(element);
    });
    super.initState();
  }

  // ===========================VIEW===================================================================================================
  @override
  Widget build(BuildContext context) {
//====================
    Widget iconmenu(assets, type, texticon) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  width: 60,
                  height: 60,
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
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  child: Center(
                    child: Image.network(
                      assets,
                      width: 35,
                    ),
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: FittedBox(
                  child: Text(texticon,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'mulibold')),
                ))
          ]);
    }
//================================================================================================================================================

    Widget Iconbuilder() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: Text(
                        "Your Favourites ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'neosansbold',
                          fontSize: 20,
                        ),
                      )),
                  Obx(
                    () {
                      if (listCategoryFav.length == 0) {
                        return Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(child: Text("Kosong"))),
                        );
                      } else {
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, mainAxisSpacing: 20),
                            itemCount: listCategoryFav.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  listCategoryFav.remove(listCategoryFav[i]);
                                },
                                child: Stack(
                                  children: [
                                    iconmenu(listCategoryFav[i].image, "type",
                                        listCategoryFav[i].name),
                                    Positioned(
                                      right: 15,
                                      top: 10,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                          child: Icon(Icons.remove,
                                              color: Colors.white, size: 15)),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 5),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    child: Text(
                      "Other Service",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'neosansbold',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      var data = _mainController.listCategory
                          .where((val) => !(listCategoryFav.contains(val)))
                          .toList();
                      if (data.length == 0) {
                        return Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(child: Text("Kosong"))),
                        );
                      } else {
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, mainAxisSpacing: 20),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  listCategoryFav.add(data[i]);
                                },
                                child: Stack(
                                  children: [
                                    iconmenu(
                                        data[i].image, "type", data[i].name),
                                    Positioned(
                                      right: 15,
                                      top: 10,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor),
                                          child: Icon(Icons.add,
                                              color: Colors.white, size: 15)),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      if (listCategoryFav.length > 6) {
                        List fav = [];
                        _mainController.listCategoryFav.clear();
                        listCategoryFav.forEach((element) {
                          _mainController.listCategoryFav.add(element);
                          fav.add(element.id);
                        });
                        GetStorage storage = GetStorage();
                        await storage.write("categoryfav", fav);
                        Get.back();
                      } else {
                        Get.defaultDialog(
                            title: "Opps!",
                            middleText: "Minimal terdapat 7 kategori favorit");
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0.8,
                                blurRadius: 5,
                                offset:
                                    Offset(2, 5), // changes position of shadow
                              ),
                            ],
                            color: mainColor,
                            border: Border.all(
                              color: mainColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(13),
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          "Simpan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'neosansbold',
                              fontSize: 16,
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Select Favourites",
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
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 0.5,
              color: Colors.white,
            ),
            Container(
              height: 0.5,
              color: Colors.white,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Iconbuilder(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
// ===========================VIEW===================================================================================================
}
