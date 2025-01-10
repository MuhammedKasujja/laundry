// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:laundry/screen/addlocation/addressdetails_screen.dart';
import 'package:laundry/screen/addlocation/deliveryaddress1.dart';
import 'package:laundry/screen/addlocation/deliveryaddress2.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/category_screen.dart';
import 'package:laundry/screen/categorydetails_screen.dart';
import 'package:laundry/screen/coupon_screen.dart';
import 'package:laundry/screen/loginAndsignup/login_screen.dart';
import 'package:laundry/screen/loginAndsignup/otp_screen.dart';
import 'package:laundry/screen/loginAndsignup/resetpassword_screen.dart';
import 'package:laundry/screen/loginAndsignup/signup_screen.dart';
import 'package:laundry/screen/loream_screen.dart';
import 'package:laundry/screen/my%20booking/mybooking_screen.dart';
import 'package:laundry/screen/my%20booking/mybookinginfo_screen.dart';
import 'package:laundry/screen/notification_screen.dart';
import 'package:laundry/screen/onbording_screen.dart';
import 'package:laundry/screen/profile_screen.dart';
import 'package:laundry/screen/refer&earn_screen.dart';
import 'package:laundry/screen/subscribe/subscribe_screen.dart';
import 'package:laundry/screen/wallet/addwallet_screen.dart';
import 'package:laundry/screen/wallet/wallethistory_screen.dart';

import '../screen/prescription/prescription order/mysubscription_order.dart';
import '../screen/prescription/prescription order/mysubscriptioninfo_screen.dart';

class Routes {
  static String initial = "/";
  static String homeScreen = "/homeScreen";
  static String categoryScreen = "/categoryScreen";
  static String categoryDetailsScreen = "/categoryDetailsScreen";
  static String bottombarProScreen = "/bottombarProScreen";
  static String couponScreen = "/couponScreen";
  static String deliveryaddress1 = "/deliveryaddress1";
  static String deliveryaddress2 = "/deliveryaddress2";
  static String addressDetailsScreen = "/addressDetailsScreen";
  static String prescriptionDetails = "/prescriptionDetails";
  static String profileScreen = "/profileScreen";
  static String myBookingScreen = "/myBookingScreen";
  //! ----------- Login And Signup -----------!//
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String otpScreen = '/otpScreen';
  static String resetPassword = "/resetPassword";
  //!---------------------------------------!//
  static String loream = "/loream";
  static String orderdetailsScreen = "/OrderdetailsScreen";
  static String myPriscriptionOrder = "/MyPriscriptionOrder";
  static String myPriscriptionInfo = "/MyPriscriptionInfo";

  static String walletHistoryScreen = "/walletHistoryScreen";
  static String addWalletScreen = "/addWalletScreen";

  static String referFriendScreen = "/referFriendScreen";
  static String notificationScreen = "/notificationScreen";

  static String subScribeScreen = "/subScribeScreen";
}

final getPages = [
  GetPage(
    name: Routes.initial,
    page: () => onbording(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => BottombarProScreen(),
  ),
  GetPage(
    name: Routes.categoryScreen,
    page: () => CategoryScreen(),
  ),
  GetPage(
    name: Routes.categoryDetailsScreen,
    page: () => CategoryDetailsScreen(),
  ),
  GetPage(
    name: Routes.bottombarProScreen,
    page: () => BottombarProScreen(),
  ),
  GetPage(
    name: Routes.couponScreen,
    page: () => CouponScreen(),
  ),
  GetPage(
    name: Routes.deliveryaddress1,
    page: () => DeliveryAddress1(),
  ),
  GetPage(
    name: Routes.deliveryaddress2,
    page: () => DelieryAddress2(),
  ),
  GetPage(
    name: Routes.addressDetailsScreen,
    page: () => AddressDetailsScreen(),
  ),
  GetPage(
    name: Routes.profileScreen,
    page: () => ProfileScreen(),
  ),
  GetPage(
    name: Routes.myBookingScreen,
    page: () => MyBookingScreen(),
  ),
  GetPage(
    name: Routes.loginScreen,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: Routes.signUpScreen,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: Routes.otpScreen,
    page: () => OtpScreen(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => ResetPasswordScreen(),
  ),
  GetPage(
    name: Routes.loream,
    page: () => Loream(),
  ),
  GetPage(
    name: Routes.orderdetailsScreen,
    page: () => OrderdetailsScreen(),
  ),
  GetPage(
    name: Routes.myPriscriptionOrder,
    page: () => MyPriscriptionOrder(),
  ),
  GetPage(
    name: Routes.myPriscriptionInfo,
    page: () => MyPriscriptionInfo(),
  ),
  GetPage(
    name: Routes.walletHistoryScreen,
    page: () => WalletHistoryScreen(),
  ),
  GetPage(
    name: Routes.addWalletScreen,
    page: () => AddWalletScreen(),
  ),
  GetPage(
    name: Routes.referFriendScreen,
    page: () => ReferFriendScreen(),
  ),
  GetPage(
    name: Routes.notificationScreen,
    page: () => NotificationScreen(),
  ),
  GetPage(
    name: Routes.subScribeScreen,
    page: () => SubScribeScreen(),
  ),
];
