// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/model/search_info.dart';
import 'package:laundry/model/searchproduct_info.dart';
import 'package:laundry/screen/onbording_screen.dart';

import '../Api/dio_api.dart';

class SearchController1 extends GetxController implements GetxService {
  List<SearchInfo> searchInfo = [];
  List<SearchDatum> searchProductInfo = [];
  bool isLoading = false;
  final dioApi = Api();

  getSearchStoreData({String? keyWord}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat,
        "longs": long,
        "keyword": keyWord,
      };
      String uri = Config.path + Config.storeSearchApi;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        searchInfo = [];
        for (var element in result["SearchStoreData"]) {
          searchInfo.add(SearchInfo.fromJson(element));
        }
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getSearchProductData({String? keyWord, storeID}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeID,
        "keyword": keyWord,
      };
      String uri = Config.path + Config.productSearch;
      var response = await dioApi.sendRequest.post(
        uri,
        data: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);

        searchProductInfo = [];

        SearchProductInfo info;

        info = searchProductInfoFromJson(response.data);
        for (var element in info.searchData) {
          print(element);
          searchProductInfo.add(element);
        }
        print(info.searchData.length);
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
