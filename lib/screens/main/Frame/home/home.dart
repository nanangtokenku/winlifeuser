import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/banner_model.dart';
import 'package:winlife/data/model/reward_model.dart';
import 'package:winlife/data/model/voucher_model.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/main/Frame/detail_reward.dart';
import 'package:winlife/screens/main/Frame/home/edit_fav.dart';
import 'package:winlife/screens/main/service/list_conselor.dart';
import 'package:winlife/setting/language.dart';

class FrameHome extends StatefulWidget {
  const FrameHome({Key? key}) : super(key: key);

  @override
  _FrameHomeState createState() => _FrameHomeState();
}

class _FrameHomeState extends State<FrameHome> {
  final MainController _mainController = Get.find();
  final AuthController _authController = Get.find();

  final storage = GetStorage();

  SolidController _controller = SolidController();
  @override
  void initState() {
    super.initState();
  }

  List lang = [
    Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
      child: Text(
        'ID',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
      ),
    ),
    Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
      child: Text(
        'EN',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          padding: const EdgeInsets.all(15),
          child: Row(children: [
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.grey[200],
                  ),
                  height: 40,
                  child: InkWell(
                      onTap: () {},
                      child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.black,
                              ),
                              margin: const EdgeInsets.only(right: 10),
                            ),
                            Expanded(
                              child: Text(
                                "Find News".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Muli'),
                              ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center))),
            ),
            Container(
              child: Image.asset(
                "assets/icon_message.png",
                width: 30,
              ),
              margin: const EdgeInsets.only(left: 20),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: "pilih bahasa".tr,
                          content: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              ListTile(
                                onTap: () {
                                  _authController.selectIndexLang.value = 0;
                                  LanguageService.changeLocale('id');
                                  storage.write('lang', 'id');
                                  Get.back();
                                },
                                leading: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: mainColor, shape: BoxShape.circle),
                                  child: Text(
                                    'ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                                title: Text("Indonesia"),
                                trailing: Obx(
                                  () => Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: _authController
                                                      .selectIndexLang.value ==
                                                  0
                                              ? mainColor
                                              : Colors.grey,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              ListTile(
                                onTap: () {
                                  _authController.selectIndexLang.value = 1;
                                  LanguageService.changeLocale('en');
                                  storage.write('lang', 'en');
                                  Get.back();
                                },
                                leading: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    'EN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                                title: Text("English"),
                                trailing: Obx(
                                  () => Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: _authController
                                                      .selectIndexLang.value ==
                                                  1
                                              ? mainColor
                                              : Colors.grey,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],
                          ));
                    },
                    child: Obx(
                        () => lang[_authController.selectIndexLang.value]))),
          ]),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _mainController.getAllData,
        child: SingleChildScrollView(
          child: Container(
              child: Column(children: [
            //=================================================================================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              margin: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 15, right: 15),
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
                    child: Text(
                      "welcome".tr,
                      style: TextStyle(
                          fontFamily: 'mulibold', color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Row(children: [
                      Container(
                          child: Image.asset("assets/logo-white.png"),
                          margin: const EdgeInsets.only(right: 10)),
                      Expanded(child: Container(height: 1, color: Colors.white))
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 20, top: 5, left: 10, right: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.only(top: 5),
                                margin: const EdgeInsets.only(right: 5, top: 0),
                                child: Row(children: [
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Image.asset(
                                          "assets/icon_banner_reward.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Image.asset(
                                          "assets/icon_banner_reward.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Image.asset(
                                          "assets/icon_banner_voucher.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                child: Row(children: [
                                  Expanded(
                                    child: Center(
                                        child: Text('Account'.tr,
                                            style: TextStyle(
                                                fontFamily: 'muli',
                                                fontSize: 11,
                                                color: Colors.white))),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text('History'.tr,
                                            style: TextStyle(
                                                fontFamily: 'muli',
                                                fontSize: 11,
                                                color: Colors.white))),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text('Hadiahku'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'muli',
                                                fontSize: 11,
                                                color: Colors.white))),
                                  ),
                                ]),
                                margin: const EdgeInsets.only(right: 3, top: 5),
                              ),
                            ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15, left: 10),
                            width: 1,
                            height: 50,
                            color: Colors.white,
                          ),
                          Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "MyPoint".tr,
                                      style: TextStyle(
                                          fontFamily: 'neosansbold',
                                          color: Colors.white),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 3, bottom: 5),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 6, top: 6),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 3),
                                            FittedBox(
                                              child: Row(
                                                children: [
                                                  Obx(() {
                                                    return Text(
                                                      _mainController
                                                          .point.value,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'neosansbold',
                                                          fontSize: 13),
                                                    );
                                                  }),
                                                  Text(
                                                    "Point".tr,
                                                    style: TextStyle(
                                                        fontFamily: 'mulilight',
                                                        fontSize: 11),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              FontAwesomeIcons.caretRight,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 35,
                                        padding: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(),
                                        child: Image.asset(
                                          "assets/icon_banner_point.png",
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ))
                        ]),
                  )
                ],
              ),
            ),
            //==========================================================================
            Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Our Service".tr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'neosansbold',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Consulting Your Life".tr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'muli',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ])),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Obx(
                () {
                  if (_mainController.listCategory.length == 0) {
                    return Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: SpinKitFadingCircle(
                          color: mainColor,
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, mainAxisSpacing: 20),
                        itemCount: 8,
                        itemBuilder: (context, i) {
                          if (i < 7) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.LISTCONSELOR, arguments: {
                                  'category': _mainController.listCategoryFav[i]
                                })!
                                    .then((value) {
                                  _mainController.getPoint();
                                });
                              },
                              child: iconmenu(
                                  context,
                                  _mainController.listCategoryFav[i].image,
                                  "type",
                                  _mainController.listCategoryFav[i].name),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              _controller.isOpened
                                  ? _controller.hide()
                                  : _controller.show();
                            },
                            child: Column(
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
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 0.8,
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
                                                Radius.circular(35))),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icon_menu8.png',
                                            width: 35,
                                          ),
                                        )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text("All".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'mulibold',
                                            fontSize: 12)),
                                  )
                                ]),
                          );
                        });
                  }
                },
              ),
            ),

            //==========================================================================
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Promo",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'neosansbold',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Consulting Your Life".tr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'muli',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "See All".tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'mulibold',
                                  fontSize: 12,
                                  color: mainColor),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
            //==========================================================================

            Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Obx(() {
                  if (_mainController.listVoucher.isEmpty) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: mainColor,
                      ),
                    );
                  } else if (_mainController.listVoucher.first == null) {
                    return Center(
                      child: Text("Empty"),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _mainController.listVoucher.length,
                          itemBuilder: (c, i) => InkWell(
                              onTap: () {
                                Get.toNamed(Routes.DETAILREWARD,
                                    arguments: ArgumentDetailVoucher(
                                        title: _mainController
                                            .listVoucher[i]!.promoCode,
                                        voucher:
                                            _mainController.listVoucher[i]!));
                              },
                              child:
                                  promoview(_mainController.listVoucher[i]!))),
                    );
                  }
                })),

            //=========================R=================================================
            //
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "News".tr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'neosansbold',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "See All".tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'mulibold',
                                  fontSize: 12,
                                  color: mainColor),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
            //===================================================================================
            //
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Obx(() {
                  if (_mainController.listBanner.isEmpty) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: mainColor,
                      ),
                    );
                  } else if (_mainController.listBanner.first == null) {
                    return Center(
                      child: Text("Empty"),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _mainController.listBanner.length,
                          itemBuilder: (c, i) => InkWell(
                              onTap: () {
                                Get.toNamed(Routes.WEBVIEW, arguments: [
                                  _mainController.listBanner[i]!.url,
                                  "News".tr
                                ]);
                              },
                              child: exploreview(
                                  c, _mainController.listBanner[i]!))),
                    );
                  }
                })),
          ])),
        ),
      ),
      bottomSheet: SolidBottomSheet(
        maxHeight: 500,
        controller: _controller,
        draggableBody: true,
        toggleVisibilityOnTap: true,
        body: SingleChildScrollView(
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 0.5,
                  color: Colors.white,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
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
                            color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35))),
                        margin: const EdgeInsets.all(2),
                        width: 50,
                      ),
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
                            color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35))),
                        margin: const EdgeInsets.all(2),
                        width: 50,
                      ),
                    ],
                  ),
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
                        child: buildIconFooter(context)),
                  ),
                )
              ],
            ),
          ),
        ),
        headerBar: Container(),
      ),
    );
  }

  Widget iconmenu(context, assets, type, texticon) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: 50,
                height: 50,
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
                  style: TextStyle(fontFamily: 'mulibold', fontSize: 12)),
            ),
          )
        ]);
  }

  Widget promoview(Voucher voucher) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            voucher.foto,
            fit: BoxFit.fitWidth,
          ),
        ));
  }

  Widget exploreview(context, BannerItem data) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              Image.network(
                data.img!,
                fit: BoxFit.cover,
                height: 130,
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.all(5),
                child: Text(
                  data.deskripsi!,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'mulibold',
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildIconFooter(context) {
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
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Your Favorites".tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'neosansbold',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              _controller.hide();
                              Get.to(() => EditFavorite())!.then((value) {
                                _mainController.getAllCategory();
                              });
                            },
                            child: Text(
                              "Edit >>",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'mulibold',
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Obx(
                  () {
                    if (_mainController.listCategory.length == 0) {
                      return Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: SpinKitFadingCircle(
                            color: mainColor,
                          ),
                        ),
                      );
                    } else {
                      return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, mainAxisSpacing: 20),
                          itemCount: _mainController.listCategoryFav.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.LISTCONSELOR, arguments: {
                                  'category': _mainController.listCategoryFav[i]
                                })!
                                    .then((value) {
                                  _mainController.getPoint();
                                });
                              },
                              child: iconmenu(
                                  context,
                                  _mainController.listCategoryFav[i].image,
                                  "type",
                                  _mainController.listCategoryFav[i].name),
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
                    if (_mainController.listCategory.length == 0) {
                      return Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: SpinKitFadingCircle(
                            color: mainColor,
                          ),
                        ),
                      );
                    } else {
                      var data = _mainController.listCategory
                          .where((val) =>
                              !(_mainController.listCategoryFav.contains(val)))
                          .toList();
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
                                Get.toNamed(Routes.LISTCONSELOR,
                                        arguments: {'category': data[i]})!
                                    .then((value) {
                                  _mainController.getPoint();
                                });
                              },
                              child: iconmenu(
                                  context, data[i].image, "type", data[i].name),
                            );
                          });
                    }
                  },
                ),
                // Container(
                //   child: GridView.builder(
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: categoryItemsnonfav.length,
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 4, mainAxisSpacing: 20),
                //       itemBuilder: (ctx, i) {
                //         var ii = i;
                //         return InkWell(
                //           onTap: () {
                //             Navigator.of(context)
                //                 .push(new MaterialPageRoute(
                //                     builder: (context) => new ListConselor(
                //                         categoryItemsnonfav[ii].id.toString())))
                //                 .then((result) {
                //               if (result != "") {
                //                 debugPrint(result);
                //               }
                //             });
                //           },
                //           child: iconmenu(
                //               context,
                //               categoryItemsnonfav[ii].image.toString(),
                //               "type",
                //               categoryItemsnonfav[ii].name.toString()),
                //         );
                //       }),
                // ),
              ],
            ),
          ),
        ]);
  }

  Widget promoview2(text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'mulibold', color: Colors.white),
      ),
    );
  }
}
