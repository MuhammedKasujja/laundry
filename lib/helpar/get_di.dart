import 'package:get/get.dart';
import 'package:laundry/controller/addlocation_controller.dart';
import 'package:laundry/controller/cart_controller.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/controller/fav_controller.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/controller/login_controller.dart';
import 'package:laundry/controller/myorder_controller.dart';
import 'package:laundry/controller/notification_controller.dart';
import 'package:laundry/controller/subscription_controller.dart';
import 'package:laundry/controller/productdetails_controller.dart';
import 'package:laundry/controller/search_controller.dart';
import 'package:laundry/controller/signup_controller.dart';
import 'package:laundry/controller/stordata_controller.dart';
import 'package:laundry/controller/subscribe_controller.dart';
import 'package:laundry/controller/wallet_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/selectlocation_controller.dart';

init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => CatDetailsController());
  Get.lazyPut(() => AddLocationController());
  Get.lazyPut(() => PreScriptionControllre());
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => SignUpController());
  Get.lazyPut(() => HomePageController());
  Get.lazyPut(() => StoreDataContoller());
  Get.lazyPut(() => CartController());
  Get.lazyPut(() => ProductDetailsController());
  Get.lazyPut(() => FavController());
  Get.lazyPut(() => MyOrderController());
  Get.lazyPut(() => WalletController());
  Get.lazyPut(() => SearchController1());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => SubScibeController());
  Get.lazyPut(() => SelectLocatonController());
}
