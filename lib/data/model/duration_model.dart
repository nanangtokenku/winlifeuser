class DurationItem {
  String id;
  String kategori;
  String name;
  String time;
  String harga;
  String tipe;
  String tipeName;

  DurationItem(this.id, this.name, this.time, this.harga, this.kategori,
      this.tipe, this.tipeName);

  factory DurationItem.fromJson(Map<String, dynamic> json) {
    return DurationItem(
        json['id'],
        json['duration_name'],
        json['duration_time'],
        json['harga'],
        json['kategori'],
        json['tipe_layanan'],
        json['nama']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'time': time,
        'harga': harga,
        'kategori': kategori,
        'tipe_layanan': tipe,
        'nama': tipeName
      };
}
