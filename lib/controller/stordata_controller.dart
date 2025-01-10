// ignore_for_file: avoid_print, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/model/storedata_info.dart';
import 'package:laundry/screen/onbording_screen.dart';

import '../Api/dio_api.dart';

class StoreDataContoller extends GetxController implements GetxService {
  bool isLoading = false;
  StoreDataInfo? storeDataInfo;
  final dioApi = Api();
  String storeid = "";

  int currentIndex = 0;
  int viewAllIndex = 0;

  changeIndexInCategory({int? index}) {
    currentIndex = index ?? 0;
    update();
  }

  changeIndexInCategoryViewAll({int? index}) {
    viewAllIndex = index ?? 0;
    update();
  }

  getStoreData({String? storeId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeId,
        "lats": lat.toString(),
        "longs": long.toString(),
      };
      print(map.toString());
      String uri = Config.path + Config.storeData;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      print("<<<<<<<<Response>>>>>>>>>>" + response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        print(result.toString());
        storeid = result["StoreInfo"]["store_id"];
        print("SSSSSSSSSS" + storeId.toString());
        storeDataInfo = StoreDataInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
