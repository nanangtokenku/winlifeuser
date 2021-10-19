import 'package:winlife/data/model/conselor_model.dart';
import 'package:winlife/data/model/duration_model.dart';

class History {
  String id;
  String problem;
  String hope;
  String? nama_konselor;
  String jadwal_hari;
  String jadwal_tanggal;
  String sesi_id;
  String conselorId;
  String service_id;
  Future<dynamic>? conselorDetailFuture;
  ConselorDetail? conselorDetail;
  Conselor? conselor;
  DurationItem? duration;
  int? point;
  Future<dynamic>? summaryFuture;
  String? summary;
  History(
      this.id,
      this.problem,
      this.hope,
      this.nama_konselor,
      this.jadwal_hari,
      this.jadwal_tanggal,
      this.sesi_id,
      this.conselorId,
      this.service_id);

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        json['id'],
        json['problem'],
        json['hope'],
        json['nama_konselor'],
        json['jadwal_hari'],
        json['jadwal_tanggal'],
        json['sesi_id'],
        json['konselor_id'],
        json['service_id']);
  }
}
