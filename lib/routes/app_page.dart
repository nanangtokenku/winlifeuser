import 'package:get/get.dart';
import 'package:winlife/bindings/main_binding.dart';
import 'package:winlife/bindings/quickblox_binding.dart';
import 'package:winlife/bindings/rtc_binding.dart';
import 'package:winlife/routes/app_routes.dart';
import 'package:winlife/screens/auth/landingpage.dart';
import 'package:winlife/screens/auth/lupapassword.dart';
import 'package:winlife/screens/auth/otppage.dart';
import 'package:winlife/screens/auth/registerSocialPage.dart';
import 'package:winlife/screens/auth/registerpage.dart';
import 'package:winlife/screens/main/Frame/detail_reward.dart';
import 'package:winlife/screens/main/dashboard.dart';
import 'package:winlife/screens/main/service/detail_order.dart';
import 'package:winlife/screens/main/service/list_conselor.dart';
import 'package:winlife/screens/main/service/list_voucher.dart';
import 'package:winlife/screens/main/service/payment/payment_screen.dart';
import 'package:winlife/screens/main/service/payment/wallet_detail.dart';
import 'package:winlife/screens/main/service/rating_conselor.dart';
import 'package:winlife/screens/main/service/type/vidcall_screen.dart';
import 'package:winlife/screens/main/service/waiting_screen.dart';
import 'package:winlife/screens/main/service/type/call_screen.dart';
import 'package:winlife/screens/main/service/type/chat_screen.dart';
import 'package:winlife/screens/splashscreen.dart';
import 'package:winlife/screens/auth/loginpage.dart';
import 'package:winlife/screens/webview.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.INITIAL,
        page: () => SplashScreen(),
        transition: Transition.fadeIn),
    GetPage(name: Routes.LANDING, page: () => LandingPage()),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: Routes.REGISTERSOCIAL,
      page: () => RegisterSocialPage(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => OTPVerification(),
    ),
    GetPage(
      name: Routes.FORGETPASSWORD,
      page: () => LupaPasswordPage(),
    ),
    GetPage(
      name: Routes.CHANGEPASSWORD,
      page: () => LupaPasswordPage(),
    ),
    GetPage(
        name: Routes.MAIN,
        page: () => DashboardPage(),
        bindings: [MainBindings(), QBBindings()]),
    GetPage(name: Routes.WEBVIEW, page: () => WebViewPage()),
    GetPage(name: Routes.LISTCONSELOR, page: () => ListConselor()),
    GetPage(name: Routes.DETAILORDER, page: () => DetailOrder()),
    GetPage(name: Routes.CALLSCREEN, page: () => CallScreen()),
    GetPage(name: Routes.CHATSCREEN, page: () => ChatScreen()),
    GetPage(name: Routes.VIDCALLSCREEN, page: () => VidCallScreen()),
    GetPage(name: Routes.WAITINGSCREEN, page: () => WaitingScreen()),
    GetPage(name: Routes.PAYMENT, page: () => PaymentPage()),
    GetPage(name: Routes.WALLETDETAIL, page: () => WalletDetail()),
    GetPage(name: Routes.LISTVOUCHER, page: () => ListVoucher()),
    GetPage(name: Routes.RATINGCONSELOR, page: () => RatingConselor()),
    GetPage(name: Routes.DETAILREWARD, page: () => DetailReward()),
  ];
}
