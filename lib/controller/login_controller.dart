// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/utils/Custom_widget.dart';

class LoginController extends GetxController implements GetxService {
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController newPassword = TextEditingController();
  TextEditingController newConformPassword = TextEditingController();
  final dioApi = Api();
  bool showPassword = true;
  bool newShowPassword = true;
  bool conformPassword = true;
  bool isChecked = false;

  String userMessage = "";
  String resultCheck = "";

  String forgetPasswprdResult = "";
  String forgetMsg = "";

  changeRememberMe(bool? value) {
    isChecked = value ?? false;
    update();
  }

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  newShowOfPassword() {
    newShowPassword = !newShowPassword;
    update();
  }

  newConformShowOfPassword() {
    conformPassword = !conformPassword;
    update();
  }

  getLoginApiData(String cuntryCode) async {
    try {
      Map map = {
        "mobile": number.text,
        "ccode": cuntryCode,
        "password": password.text,
      };
      print("-----$map");
      String uri = Config.path + Config.loginApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      print("***********" + uri.toString());
      if (response.statusCode == 200) {
        save('Firstuser', true);
        var result = jsonDecode(response.data);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        showToastMessage(userMessage);
        if (resultCheck == "true") {
          Get.offAllNamed(Routes.homeScreen);
          number.text = "";
          password.text = "";
          isChecked = false;
          update();
        }
        save("UserLogin", result["UserLogin"]);
        // OneSignal.shared.sendTag("userid", getData.read("UserLogin")["id"]);
        initPlatformState();
        OneSignal.User.addTagWithKey("userid", getData.read("UserLogin")["id"]);
        update();
      }
      print(Config.path);
    } catch (e) {
      print(Config.path);
      print(e.toString());
    }
  }

  setForgetPasswordApi({
    String? mobile,
    String? ccode,
  }) async {
    try {
      Map map = {
        "mobile": mobile,
        "ccode": ccode,
        "password": newPassword.text,
      };
      String uri = Config.path + Config.forgetPassword;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        forgetPasswprdResult = result["Result"];
        forgetMsg = result["ResponseMsg"];
        if (forgetPasswprdResult == "true") {
          Get.toNamed(Routes.loginScreen);
          showToastMessage(forgetMsg);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
