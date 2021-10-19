import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winlife/data/provider/api.dart';

class Conselor {
  String id;
  String name;
  String mobileNumber;
  String email;
  bool isActive;
  bool inOrder;
  Future<ConselorDetail?>? conselorDetailFuture;
  ConselorDetail? conselorDetail;
  Timestamp? lastActive;
  Stream<DocumentSnapshot<Object?>>? streamConselor;
  Conselor(this.email, this.id, this.mobileNumber, this.name,
      {this.isActive = false, this.inOrder = false});

  factory Conselor.fromJson(Map<String, dynamic> json) {
    return Conselor(
      json['email'],
      json['id'],
      json['mobile_number'],
      json['name'],
    );
  }
}

class ConselorDetail {
  String id;
  String riwayat_pendidikan;
  String lama_pengalaman;
  String riwayat_pengalaman;
  String foto_konselor;
  String surat_rekomendasi;
  String sertifikasi;
  String asosiasi_konselor;
  ConselorDetail(
      this.id,
      this.asosiasi_konselor,
      this.foto_konselor,
      this.lama_pengalaman,
      this.riwayat_pendidikan,
      this.riwayat_pengalaman,
      this.sertifikasi,
      this.surat_rekomendasi);

  factory ConselorDetail.fromJson(Map<String, dynamic> json) {
    return ConselorDetail(
      json['conselor_id'],
      json['asosiasi_konselor'],
      Api.IMAGE_KONSELOR_URL + json['foto_konselor'],
      json['lama_pengalaman'],
      json['riwayat_pendidikan'],
      json['riwayat_pengalaman'],
      json['sertifikasi'],
      json['asosiasi_konselor'],
    );
  }
}
