import 'package:winlife/data/provider/api.dart';

class BannerItem {
  String? id;
  String? img;
  String? deskripsi;
  String? url;
  String? date;

  BannerItem({this.id, this.img, this.date, this.deskripsi, this.url});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
        id: json['id'],
        img: Api.IMAGE_BANNER_URL + json['filez'],
        deskripsi: json['deskripsi'],
        url: json['url'],
        date: json['date_created']);
  }
}
