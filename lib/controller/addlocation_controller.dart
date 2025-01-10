// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/utils/Custom_widget.dart';

class AddLocationController extends GetxController implements GetxService {
  TextEditingController completeAddress = TextEditingController();
  TextEditingController landMark = TextEditingController();
  TextEditingController reach = TextEditingController();
  TextEditingController homeAddress = TextEditingController();
  final dioApi = Api();
  CatDetailsController catDetailsController = Get.find();

  var lat;
  var long;
  var address;
  getCurrentLatAndLong(double latitude, double longitude) {
    lat = latitude;
    long = longitude;
    Get.toNamed(Routes.deliveryaddress2);
    update();
  }

  addAddressApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "address": completeAddress.text,
        "lats": lat.toString(),
        "longs": long.toString(),
        "a_type": homeAddress.text,
        "landmark": landMark.text,
        "r_instruction": reach.text != "" ? reach.text : "",
      };
      String uri = Config.path + Config.addAddress;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result["Result"] == "true") {
          showToastMessage(result["ResponseMsg"]);
          catDetailsController.changeIndex(3);
          Get.close(3);
          // Get.offAndToNamed(Routes.bottombarProScreen);
          completeAddress.text = "";
          landMark.text = "";
          reach.text = "";
          homeAddress.text = "";
        } else {
          showToastMessage(result["ResponseMsg"]);
        }
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
