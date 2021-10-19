import 'package:winlife/data/provider/api.dart';

class Reward {
  String? id;
  String? jumlah_point;
  String? deskripsi_hadiah;
  String? nama_hadiah;
  String? foto;
  String? expired;

  Reward(
      {this.id,
      this.jumlah_point,
      this.deskripsi_hadiah,
      this.nama_hadiah,
      this.foto,
      this.expired});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
        id: json['id'],
        foto: Api.IMAGE_REWARD + json['foto'].toString().split(',')[0],
        jumlah_point: json['jumlah_point'],
        deskripsi_hadiah: json['deskripsi_hadiah'],
        nama_hadiah: json['nama_hadiah'],
        expired: json['expired']);
  }
}
