// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/model/home_info.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/onbording_screen.dart';

class HomePageController extends GetxController implements GetxService {
  HomeInfo? homeInfo;
  bool isLoading = false;
  final dioApi = Api();
  List<String> bannerList = [];

  String isback = "1";

  HomePageController() {
    getHomeDataApi();
  }
  Future getHomeDataApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat.toString(),
        "longs": long.toString(),
      };
      print("+++++++++++++++++ ${map}");
      print(map.toString());
      String uri = Config.path + Config.homeDataApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        print(result.toString());
        bannerList = [];
        for (var element in result["HomeData"]["Banlist"]) {
          bannerList.add(Config.imageUrl + element["img"]);
        }
        currency = result["HomeData"]["currency"];
        wallat1 = result["HomeData"]["wallet"];
        homeInfo = HomeInfo.fromJson(result);
      }

      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
