// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/model/day_info.dart';
import 'package:laundry/model/product_info.dart';
import 'package:laundry/model/tslot_info.dart';

class ProductDetailsController extends GetxController implements GetxService {
  ProductInfo? productInfo;
  TslotInfo? tslotInfo;
  List<DayInfo> dayinfo = [];
  bool isLoading = false;
  final dioApi = Api();
  String logo = "";
  String slogan = "";
  String strName = "";
  String strAddress = "";
  String sID = "";
  int qLimit = 0;
  int? isFev;
  var lat;
  var long;
  int? index;

  getProductDetailsApi({String? pId}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "pid": pId,
      };
      print(map);
      String uri = Config.path + Config.produtsInformetion;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        productInfo = ProductInfo.fromJson(result);
        print(productInfo!.productData.productInfo[0].title);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getProductDetails({
    String? sId,
    logo1,
    slogan1,
    strName1,
    straddress,
    qLimit1,
    int? isFev1,
    var lat1,
    var long1,
    int? index1,
  }) {
    logo = logo1 ?? "";
    slogan = slogan1 ?? "";
    strName = strName1 ?? "";
    strAddress = straddress ?? "";
    sID = sId ?? "";
    qLimit = int.parse(qLimit1 ?? "0");
    isFev = isFev1;
    lat = double.parse(lat1);
    long = double.parse(long1);
    index = index1;
    update();
  }

  getDeliverysDayList({String? storeID}) async {
    try {
      isLoading = false;
      Map map = {
        "store_id": storeID,
      };
      String uri = Config.path + Config.dayDeliveryListApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        dayinfo = [];
        for (var element in result["Deliverylist"]) {
          dayinfo.add(DayInfo.fromJson(element));
        }
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getTimeSlotListApi({String? storeID}) async {
    try {
      isLoading = false;
      Map map = {
        "store_id": storeID,
      };
      String uri = Config.path + Config.timeSlotListApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        tslotInfo = TslotInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
