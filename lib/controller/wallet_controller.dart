// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/model/wallet_info.dart';
import 'package:laundry/utils/Custom_widget.dart';

class WalletController extends GetxController implements GetxService {
  TextEditingController amount = TextEditingController();
  HomePageController homePageController = Get.find();

  bool isLoading = false;
  WalletInfo? walletInfo;
  final dioApi = Api();
  String results = "";
  String walletMsg = "";

  String rCode = "";
  String signupcredit = "";
  String refercredit = "";

  getWalletReportData() async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      String uri = Config.path + Config.walletReportApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        walletInfo = WalletInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  addAmount({String? price}) {
    amount.text = price ?? "";
    update();
  }

  getWalletUpdateData() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "wallet": amount.text,
      };
      String uri = Config.path + Config.walletUpdateApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        results = result["Result"];
        walletMsg = result["ResponseMsg"];
        if (results == "true") {
          getWalletReportData();
          homePageController.getHomeDataApi();
          Get.back();
          amount.text = "";
          showToastMessage(walletMsg);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getReferData() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      String uri = Config.path + Config.referDataGetApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      print(response.data.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        rCode = result["code"];
        signupcredit = result["signupcredit"];
        refercredit = result["refercredit"];

        // Get.toNamed(Routes.referFriendScreen);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  deletAccount() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      print(map.toString());
      String uri = Config.path + Config.deletAccount;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        showToastMessage(result["ResponseMsg"]);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
