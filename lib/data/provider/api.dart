class Api {
  static const String _baseUrl = 'http://web-backend.winlife.id/';
  static const String API_KEY = 'EBD19D22637AFD0BC40DE7B0A8F44E09';

  static const String IMAGE_KATEGORI_URL = _baseUrl + "uploads/v13nr_kategori/";

  static const String IMAGE_BANNER_URL = _baseUrl + "uploads/banner/";
  static const String IMAGE_KONSELOR_URL =
      _baseUrl + "uploads/konselor_detail/";
  static const String IMAGE_REWARD = _baseUrl + "uploads/penukaran_point/";

  static const String _API = _baseUrl + 'api/';

//auth
  static const String LOGIN = _API + 'user/login';
  static const String REGISTER = _API + 'register/add';
//main data
  static const String DURATION = _API + 'duration_service/all';
  static const String KATEGORI = _API + 'v13nr_kategori/all';
  static const String KONSELOR = _API + 'register_konselor/all';
  static const String KONSELORDETAIL = _API + 'register_konselor/detail';
  static const String BANNER = _API + 'banner/all';
  static const String LISTKODEVOUCHER = _API + 'kode_promo/all';
  static const String POINT = _API + 'point_records/all';
  static const String POINTDETAIL = _API + 'point_records/detail?sesi=';
  static const String REWARDS = _API + 'penukaran_point/all';

//order
  static const String ORDERDETAIL = _API + 'order_detail/add';
  static const String ORDERDETAILALL = _API + 'order_detail/all';
  static const String ORDERDETAILSUMMARY = _API + 'order_detail/detail';
  static const String RATING = _API + 'post_rating/add';

//xendit
  static const String XENDITKEY = _API + 'xendit_key/all';
  static const String CHARGELINKAJA = 'https://api.xendit.co/ewallets/charges';
  static const String CEKEWALLETCHARGE =
      'https://api.xendit.co/ewallets/charges';
}
