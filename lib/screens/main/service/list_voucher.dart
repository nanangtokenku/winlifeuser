import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/controller/main_controller.dart';
import 'package:winlife/data/model/voucher_model.dart';

class ListVoucher extends StatefulWidget {
  const ListVoucher({Key? key}) : super(key: key);

  @override
  _ListVoucherState createState() => _ListVoucherState();
}

class _ListVoucherState extends State<ListVoucher> {
  var _searchConselor = "".obs;
  MainController _mainController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    _mainController.getListVoucher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Voucher"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Flexible(
              flex: 2,
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
                        hintText: "Masukan kode voucher",
                        border: InputBorder.none),
                    onChanged: (value) {
                      _searchConselor.value = value;
                    },
                    style: TextStyle(
                        fontSize: 14, color: Colors.black, fontFamily: 'Muli'),
                  )),
            ),
            Flexible(
                flex: 8,
                child: Obx(() {
                  if (_mainController.listVoucher.isNotEmpty) {
                    if (_mainController.listVoucher.first != null) {
                      return ListView.builder(
                          itemCount: _mainController.listVoucher.length,
                          itemBuilder: (contex, i) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14),
                              padding: EdgeInsets.all(12),
                              child: Card(
                                child: ListTile(
                                  title: Text(_mainController
                                      .listVoucher[i]!.promoCode),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Minimal Order"),
                                            Text(_mainController.listVoucher[i]!
                                                .minimal_transaction),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Jumlah Voucher"),
                                            Text(_mainController
                                                .listVoucher[i]!.lifetime_qty),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Nilai Voucher"),
                                            Text("Rp " +
                                                _mainController.listVoucher[i]!
                                                    .nilai_rupiah),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Nilai Maksimal"),
                                            Text("Rp " +
                                                _mainController.listVoucher[i]!
                                                    .max_discount),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Berlaku hingga"),
                                            Text(_mainController
                                                .listVoucher[i]!.valid_until),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor),
                                                onPressed: () {
                                                  int hargaOrder = int.parse(
                                                      _mainController
                                                          .durationOrder
                                                          .value!
                                                          .harga);
                                                  int minOrderVoc = int.parse(
                                                      _mainController
                                                          .listVoucher[i]!
                                                          .minimal_transaction);

                                                  if (hargaOrder >
                                                      minOrderVoc) {
                                                    _mainController.voucherOrder
                                                            .value =
                                                        _mainController
                                                            .listVoucher[i];

                                                    Get.back();
                                                  } else {
                                                    Get.defaultDialog(
                                                        title: "Oops!",
                                                        middleText:
                                                            "Minimal Transaksi tidak memenuhi");
                                                  }
                                                },
                                                child: Text("Pakai")),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Empty"),
                            ElevatedButton(
                                onPressed: () {
                                  _mainController.getListVoucher();
                                },
                                child: Text("Reload"))
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: mainColor,
                      ),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}
