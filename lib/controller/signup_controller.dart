// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/model/pagelist_info.dart';
import 'package:laundry/utils/Custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/dio_api.dart';

class SignUpController extends GetxController implements GetxService {
  PageListInfo? pageListInfo;

  bool isLoading = false;

  final dioApi = Api();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referralCode = TextEditingController();

  bool showPassword = true;
  bool chack = false;
  int currentIndex = 0;
  String userMessage = "";
  String resultCheck = "";
  String signUpMsg = "";

  SignUpController() {
    print("-+-+-+-+- profile call -+-+-++-+-");
    pageListApi();
  }

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  checkTermsAndCondition(bool? newbool) {
    chack = newbool ?? false;
    update();
  }

  cleanFild() {
    name.text = "";
    email.text = "";
    number.text = "";
    password.text = "";
    referralCode.text = "";
    chack = false;
    update();
  }

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  checkMobileNumber(String cuntryCode) async {
    try {
      Map map = {
        "mobile": number.text,
        "ccode": cuntryCode,
      };
      String uri = Config.path + Config.mobileChack;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        print("MMMMMMMMMMMMMMMMMM" + userMessage);
        if (resultCheck == "true") {
          update();
          return response.data;
        }
        showToastMessage(userMessage);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  checkMobileInResetPassword({String? number, String? cuntryCode}) async {
    try {
      Map map = {
        "mobile": number,
        "ccode": cuntryCode,
      };
      String uri = Config.path + Config.mobileChack;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        if (resultCheck == "false") {
          update();
          return response.data;
        } else {
          showToastMessage('Invalid Mobile Number');
        }
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  setUserApiData(String cuntryCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map map = {
        "name": name.text,
        "email": email.text,
        "mobile": number.text,
        "ccode": cuntryCode,
        "password": password.text
      };
      String uri = Config.path + Config.registerUser;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result["Result"] == "true") {
          save("UserLogin", result["UserLogin"]);
          save('Firstuser', true);
          signUpMsg = result["ResponseMsg"];
          showToastMessage(signUpMsg);
          Get.offAndToNamed(Routes.homeScreen);
          initPlatformState();
          OneSignal.User.addTagWithKey("userid", getData.read("UserLogin")["id"]);
          update();
        } else {
          showToastMessage(result["ResponseMsg"]);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  editProfileApi({
    String? name,
    String? password,
  }) async {
    try {
      Map map = {
        "name": name,
        "password": password,
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      String uri = Config.path + Config.profileEdit;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        showToastMessage(result["ResponseMsg"]);
        save("UserLogin", result["UserLogin"]);
      }
      Get.back();
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  pageListApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
      };
      String uri = Config.path + Config.pageList;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        pageListInfo = PageListInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
