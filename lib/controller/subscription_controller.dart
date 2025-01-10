// ignore_for_file: avoid_print, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/model/sdetails_info.dart';
import 'package:laundry/model/sorder_info.dart';
import 'package:laundry/utils/Custom_widget.dart';

import '../Api/dio_api.dart';

class PreScriptionControllre extends GetxController implements GetxService {
  HomePageController homePageController = Get.find();

  List<String> path = [];
  bool isLoading = false;

  SOrderInfo? sOrderInfo;
  SDetailsInfo? sDetailsInfo;

  TextEditingController ratingText = TextEditingController();

  double tRate = 1.0;
  final dioApi = Api();
  bool isOrderLoading = false;
  int currentIndex = 0;
  int? index;

  var selectDate = [];

  totalRateUpdate(double rating) {
    tRate = rating;
    update();
  }

  setOrderLoading() {
    isOrderLoading = true;
    update();
  }

  changeDateIndex({int? index, String? date}) {
    print("<<<<<<<<>>>>>>>" + date.toString());
    if (selectDate.contains(date)) {
      selectDate.remove(date);
      update();
    } else {
      selectDate.add(date);
      update();
    }
  }

  makeDicision({String? oID, status, reson}) async {
    try {
      Map map = {
        "oid": oID,
        "status": status,
        "comment_reject": reson,
      };
      String uri = Config.path + Config.makeDecision;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);

        showToastMessage(result["ResponseMsg"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  orderReviewApi({String? orderID}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderID,
        "total_rate": tRate.toString(),
        "rate_text": ratingText.text != "" ? ratingText.text : "",
      };
      String uri = Config.path + Config.priOrderReview;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        tRate = 1.0;
        ratingText.text = "";
        Get.back();
        subScriptionOrderInfo(orderID: orderID);
        showToastMessage(result["ResponseMsg"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  subScriptionOrderHistory({String? statusWise}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "status": statusWise,
      };
      String uri = Config.path + Config.subScriptionHistory;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        sOrderInfo = SOrderInfo.fromJson(result);
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  changeIndexProductWise({int? index}) {
    currentIndex = index ?? 0;
    update();
  }

  subScriptionOrderInfo({String? orderID}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderID,
      };
      String uri = Config.path + Config.subScriptionInfo;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        sDetailsInfo = SDetailsInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  skipOrExtendDay({String? itemId, orderId, total, status}) async {
    var list = [];
    for (var i = 0; i < selectDate.length; i++) {
      list.add(jsonEncode(selectDate[i]));
    }
    print("|||||||||----------->>" + list.toString());
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderId.toString(),
        "item_id": itemId.toString(),
        "total": total,
        "status": status,
        "sday": list.toString(),
      };
// {
//     "uid": "2",
//     "order_id": "1",
//     "item_id": "1",
//     "total": 22.5,
//     "status": "skip",
//     "sday": "[\"2023-06-01\",\"2023-06-09\"]"
// }
      print("**********(Skip:Map:Extend)*********" + map.toString());
      String uri = Config.path + Config.skipAndExtend;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      print("**********(Skip:Response:Extend)*********" + response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        selectDate = [];
        list = [];
        subScriptionOrderInfo(orderID: orderId);
        showToastMessage(result["ResponseMsg"]);
        homePageController.getHomeDataApi();
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
