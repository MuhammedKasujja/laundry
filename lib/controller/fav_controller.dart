// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unrelated_type_equality_checks

import 'dart:convert';

import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/Api/dio_api.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/controller/stordata_controller.dart';

class FavController extends GetxController implements GetxService {
  StoreDataContoller storeDataContoller = Get.find();
  HomePageController homePageController = Get.find();
  final dioApi = Api();

  addFavAndRemoveApi({String? storeId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeId,
      };
      String uri = Config.path + Config.favAndRemoveApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        print(result.toString());
        storeDataContoller.getStoreData(storeId: storeId);
        homePageController.getHomeDataApi();
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
