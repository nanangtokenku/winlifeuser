class Voucher {
  String id;
  String promoCode;
  String deskripsi;
  String lifetime_qty;
  String mount_precente;
  String nilai_rupiah;
  String max_discount;
  String minimal_transaction;
  String valid_from;
  String valid_until;
  String date_created;
  String foto;

  Voucher(
      this.id,
      this.promoCode,
      this.deskripsi,
      this.lifetime_qty,
      this.mount_precente,
      this.nilai_rupiah,
      this.max_discount,
      this.minimal_transaction,
      this.valid_from,
      this.valid_until,
      this.date_created,
      this.foto);

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
        json['id'],
        json['promo_code'],
        json['deskripsi'],
        json['lifetime_qty'],
        json['mount_precente'],
        json['nilai_rupiah'],
        json['max_discount'],
        json['minimal_transaction'],
        json['valid_from'],
        json['valid_until'],
        json['date_created'],
        json['gambar']);
  }
}
