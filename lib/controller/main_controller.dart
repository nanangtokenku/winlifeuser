import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:get_storage/get_storage.dart';
import 'package:winlife/constant/request_permission.dart';
import 'package:winlife/controller/auth_controller.dart';
import 'package:winlife/data/model/banner_model.dart';
import 'package:winlife/data/model/category_model.dart';
import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/data/model/duration_model.dart';
import 'package:winlife/data/model/history_model.dart';
import 'package:winlife/data/model/reward_model.dart';
import 'package:winlife/data/model/voucher_model.dart';
import 'package:winlife/data/provider/http_service.dart';
import 'package:winlife/data/provider/payment_gateway.dart';

class MainController extends GetxController {
  RxList<CategoryItem> listCategory = RxList<CategoryItem>();
  RxList<CategoryItem> listCategoryFav = RxList<CategoryItem>();
  RxList<Conselor?> listConselor = RxList<Conselor?>();
  RxList<DurationItem> listDuration = RxList<DurationItem>();
  RxList<BannerItem?> listBanner = RxList<BannerItem?>();
  RxList<Reward?> listReward = RxList<Reward?>();
  RxList<History?> listHistory = RxList<History?>();
  RxList<Voucher?> listVoucher = RxList<Voucher?>();
  Rx<DurationItem?> durationOrder = Rx<DurationItem?>(null);
  Rx<Voucher?> voucherOrder = Rx<Voucher?>(null);
  final AuthController _authController = Get.find();

  var paid = false.obs;
  var point = "0".obs;
  var historyLoad = false.obs;

  CollectionReference _conselorFirestore =
      FirebaseFirestore.instance.collection('conselors');

  Future<void> getAllCategory() async {
    GetStorage storage = GetStorage();
    listCategory.clear();
    listCategoryFav.clear();
    var fav = storage.read('categoryfav');
    var result = await HttpService.getAllKategori(_authController.user.token);
    result['data']['v13nr_kategori'].forEach((element) {
      listCategory.add(CategoryItem.fromJson(element));
    });

    if (fav == null) {
      fav = [];
      for (var i = 0; i < 7; i++) {
        listCategoryFav.add(listCategory[i]);
        fav.add(listCategory[i].id);
      }
      await storage.write('categoryfav', fav);
    } else {
      for (var i = 0; i < fav.length; i++) {
        listCategoryFav.add(listCategory.where((p0) => p0.id == fav![i]).first);
      }
    }
  }

  Future<void> getAllConselor() async {
    var result = await HttpService.getAllConselor(_authController.user.token);
    listConselor.clear();
    if (result['total'] > 0) {
      result['data']['register_konselor'].forEach((element) async {
        Conselor item = Conselor.fromJson(element);
        var firestore = await _conselorFirestore.doc(item.email).get();
        if (firestore.exists) {
          item.streamConselor = _conselorFirestore.doc(item.email).snapshots();
          Map data = firestore.data() as Map;
          if (data.containsKey("isActive")) {
            item.isActive = data['isActive'];
          }
        }
        var conselorDetail = getConselor(item.id);

        item.conselorDetail = await conselorDetail;
        listConselor.add(item);
      });
    }
    sortListConselor();
  }

  Future<List<Conselor>> getConselorPagging(int limit, int start) async {
    var result = await HttpService.getPageConselor(
        _authController.user.token, limit.toString(), start.toString());
    List<Conselor> list = [];
    if (result['total'] > 0) {
      List listRes = result['data']['register_konselor'];
      for (var element in listRes) {
        Conselor item = Conselor.fromJson(element);
        var firestore = await _conselorFirestore.doc(item.email).get();
        if (firestore.exists) {
          item.streamConselor = _conselorFirestore.doc(item.email).snapshots();
          Map data = firestore.data() as Map;
          if (data.containsKey("isActive")) {
            item.isActive = data['isActive'];
          }
        }
        var conselorDetail = await getConselor(item.id);

        item.conselorDetail = conselorDetail;
        list.add(item);
      }
    }
    return list;
  }

  Future<ConselorDetail?> getConselor(String id) async {
    List? result =
        await HttpService.getConselor(_authController.user.token, id);
    if (result != null) {
      if (result.isNotEmpty) {
        return ConselorDetail.fromJson(result.first);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Conselor?> getConselor2(String id) async {
    var result = await HttpService.getConselor2(_authController.user.token, id);
    if (result.isNotEmpty) {
      return Conselor.fromJson(result);
    } else {
      return null;
    }
  }

  Future<void> getAllDuration() async {
    var data = await HttpService.getAllDuration(_authController.user.token);
    listDuration.clear();
    print(data);
    data['data']['duration_service'].forEach((element) {
      listDuration.add(DurationItem.fromJson(element));
    });
  }

  Future<void> getPoint() async {
    var data = await HttpService.getPoint(
        _authController.user.token, _authController.user.uid);
    var p = data['data']['point_records']['jumlah_total_point'];
    print("P= " + p.toString());
    if (p != null) {
      final storage = GetStorage();
      point.value = p.toString();
      await storage.write('poinku', point.value);
    }
  }

  Future<void> getAllBanner() async {
    var data = await HttpService.getBannerAll(_authController.user.token);
    listBanner.clear();
    print(data);
    if (data['total'] > 0) {
      data['data']['banner'].forEach((element) {
        listBanner.add(BannerItem.fromJson(element));
      });
    } else {
      listBanner.add(null);
    }
  }

  Future<void> getAllReward() async {
    var data = await HttpService.getReward(_authController.user.token);
    listReward.clear();
    print(data);
    if (data['total'] > 0) {
      data['data']['penukaran_point'].forEach((element) {
        listReward.add(Reward.fromJson(element));
      });
    } else {
      listReward.add(null);
    }
  }

  Future<void> getListVoucher() async {
    var data = await HttpService.getListKodeVoucher(_authController.user.token);
    listVoucher.clear();
    if (data['total'] > 0) {
      data['data']['kode_promo'].forEach((element) {
        var item = Voucher.fromJson(element);
        var now = DateTime.now();
        DateFormat format = DateFormat("yyyy-MM-dd");
        DateTime validUntil = format.parse(item.valid_until);
        var diff = validUntil.difference(now).inDays;
        if (diff >= 0) {
          listVoucher.add(item);
        }
      });
    } else {
      listVoucher.add(null);
    }
  }

  Future<void> getAllHistory() async {
    if (listHistory.isEmpty) {
      historyLoad.value = true;
    }
    var data = await HttpService.getHistory(
        _authController.user.token, _authController.user.uid);
    List listElement = data['data']['order_detail'];
    print("v13nr = " + listElement.toString());
    List<History> result = [];
    for (var element in listElement) {
      var history = History.fromJson(element);
      history.duration = listDuration
          .where((val) => val.id == history.service_id)
          .toList()
          .first;
      var summaryFuture = HttpService.getHistoryDetail(
          _authController.user.token, history.sesi_id);
      // var point = await HttpService.getPointDetail(
      //     _authController.user.token, history.sesi_id);
      if (history.conselorId != "") {
        var cd = getConselor(history.conselorId);
        List lc =
            listConselor.where((p0) => p0!.id == history.conselorId).toList();
        if (lc.isNotEmpty) {
          history.conselor = lc.first;
        }
        history.conselorDetailFuture = cd;
      }

      history.summaryFuture = summaryFuture;
      result.add(history);
    }

    listHistory.clear();
    listHistory.value = result.reversed.toList();
    historyLoad.value = false;
  }

  Future<void> getXenditKey() async {
    PaymentGateway.getXenditKey(_authController.user.token);
  }

  sortListConselor() {
    listConselor.value.sort((a, b) {
      if (b!.isActive) {
        return 1;
      }
      return -1;
    });
  }

  Timer? timer;
  var start = 300.obs;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start.value--;
        }
      },
    );
  }

  Future<void> addOrder(String sesi, String konselorid, String problem,
      String hope, String serviceID,
      {String jadwalHari = '', String jadwalTgl = ''}) async {
    var now = DateTime.now();
    if (jadwalHari == '') {
      jadwalHari = DateFormat('EEEE').format(now);
      jadwalTgl = DateFormat('yyyy-MM-dd').format(now);
    }
    print(jadwalTgl);
    await HttpService.addOrder(
        _authController.user.token,
        sesi,
        _authController.user.uid,
        konselorid,
        problem,
        hope,
        serviceID,
        jadwalHari,
        jadwalTgl);
  }

  Future<void> addRating(String konselorid, String serviceid, String rating,
      String rating_reason) async {
    var res = await HttpService.addRating(
        _authController.user.token,
        _authController.user.id,
        konselorid,
        serviceid,
        rating[0],
        rating_reason);
    print(res['status']);
  }

  void cancelTimer() {
    if (timer != null) {
      timer!.cancel();
      start.value = 300;
    }
  }

  Future<void> getAllData() async {
    await Future.wait([
      getAllCategory(),
      getAllDuration(),
      getAllBanner(),
      getXenditKey(),
      getPoint(),
      getAllConselor(),
      getAllReward(),
      getListVoucher()
    ]);
  }

  @override
  void onInit() async {
    await getAllData();
    super.onInit();
  }
}
