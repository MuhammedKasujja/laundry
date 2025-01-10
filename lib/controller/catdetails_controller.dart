// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/model/catwise_info.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/onbording_screen.dart';
import 'package:laundry/utils/cart_item.dart';

class CatDetailsController extends GetxController implements GetxService {
  CatWiseInfo? catWiseInfo;
  HomePageController homePageController = Get.find();
  double totalAmount = 0.0;
  int totalItem = 0;
  bool isLoading = false;
  bool isLoading1 = false;

  String strId = "";
  Box<CartItem> cart = Hive.box<CartItem>('cart');
  List count = [];
  final dioApi = Api();
  String id = "";
  double price = 0.0;
  List cartlength = [];
  double productPrice = 0.0;
  String strTitle = "";
  String per = "";
  String isRequride = "";
  String qLimit = "";
  String storeID = "";

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  addTotalAmount(value) {
    totalAmount = value;
    update();
  }

  getCartLangth() {
    count = [];
    totalAmount = 0;
    totalItem = 0;
    cartlength = [];

    for (var element in cart.values) {
      cartlength.add(element.storeID);
      cartlength = cartlength.toSet().toList();
      if (element.storeID == strId) {
        count.add(element.id);
        totalItem += element.quantity!;
        for (int a = 0; a < element.quantity!; a++) {
          totalAmount += element.price!;
        }
      }
      update();
    }
    update();
  }

  getDetails({
    String? id1,
    price1,
    quantity1,
    productPrice1,
    strTitle1,
    per1,
    isRequride1,
    qLimit1,
    storeID1,
  }) {
    id = id1 ?? "";
    price = double.parse(price1);
    productPrice = double.parse(productPrice1);
    strTitle = strTitle1;
    per = per1;
    isRequride = isRequride1;
    qLimit = qLimit1;
    storeID = storeID1;
    update();
  }

  getCatWiseData({String? catId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat.toString(),
        "longs": long.toString(),
        "cat_id": catId,
      };
      String uri = Config.path + Config.catWiseData;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        catWiseInfo = CatWiseInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
