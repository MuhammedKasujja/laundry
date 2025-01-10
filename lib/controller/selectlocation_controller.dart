// ignore_for_file: prefer_typing_uninitialized_variables, file_names, empty_catches

import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';

import '../Api/dio_api.dart';
import '../model/mapzone_info.dart';

class SelectLocatonController extends GetxController implements GetxService {
  var lat;
  var long;
  var address;
  late MapZone mapzone;
  getCurrentLatAndLong(double latitude, double longitude) {
    lat = latitude;
    long = longitude;
    update();
  }

  final dioApi = Api();
  Future getMapZone() async {
    try {
      String uri = Config.path + Config.mapZone;
      var response = await dioApi.sendRequest.get(
        uri,
      );
      if (response.statusCode == 200) {
        mapzone = mapZoneFromJson(response.data);
        update();
      }

      update();
    } catch (e) {}
  }
}
