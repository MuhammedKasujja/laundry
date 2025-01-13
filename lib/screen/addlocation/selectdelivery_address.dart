// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/selectlocation_controller.dart';
import 'package:laundry/screen/onbording_screen.dart';
import 'dart:ui' as ui;
import '../../model/fontfamily_model.dart';
import '../../utils/Colors.dart';

class SelectDeliveryAddress extends StatefulWidget {
  const SelectDeliveryAddress({super.key});

  @override
  State<SelectDeliveryAddress> createState() => _SelectDeliveryAddressState();
}

class _SelectDeliveryAddressState extends State<SelectDeliveryAddress> {
  SelectLocatonController addLocationController = Get.find();

  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  var newlatlang;
  bool isnotavalble = true;
  final Set<Polygon> _polygon = HashSet<Polygon>();

  List<LatLng> points = [];

  final List<Marker> _markers = <Marker>[];
  String location = "Search for your delivery address".tr;
  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future setvalueinZone() async {
    for (int i = 0; i < addLocationController.mapzone.zone.length; i++) {
      points.add(LatLng(addLocationController.mapzone.zone[i].lat,
          addLocationController.mapzone.zone[i].lng));
    }

    setState(() {});
  }

  getcurrentlocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    debugPrint('location: ${currentLocation.latitude}');
    await placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude)
        .then((List<Placemark> placemarks) {
      addLocationController.address =
          '${placemarks.first.name!.isNotEmpty ? '${placemarks.first.name!}, ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? '${placemarks.first.thoroughfare!}, ' : ''}${placemarks.first.subLocality!.isNotEmpty ? '${placemarks.first.subLocality!}, ' : ''}${placemarks.first.locality!.isNotEmpty ? '${placemarks.first.locality!}, ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? '${placemarks.first.subAdministrativeArea!}, ' : ''}${placemarks.first.postalCode!.isNotEmpty ? '${placemarks.first.postalCode!}, ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
      setState(() {
        location = addLocationController.address;
      });
      newlatlang = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newlatlang, zoom: 17),
        ),
      );

      isloading = false;
    });

    addLocationController.getCurrentLatAndLong(
      currentLocation.latitude,
      currentLocation.longitude,
    );

    loadData();
  }

  bool isloading = true;
  @override
  void initState() {
    addLocationController.getMapZone().then((value) {
      setvalueinZone().then((value) {
        _polygon.add(Polygon(
          // given polygonId
          polygonId: const PolygonId('1'),
          // initialize the list of points to display polygon
          points: points,
          // given color to polygon
          fillColor: Colors.transparent,
          // given border color to polygon
          strokeColor: Colors.transparent,
          geodesic: true,
          // given width of border
          strokeWidth: 4,

          onTap: () {},
        ));
        getcurrentlocation();
        loadData();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLocatonController>(
        builder: (addLocationController) {
      return Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
            color: BlackColor,
          ),
          title: Text(
            "Select Location".tr,
            maxLines: 1,
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
              fontSize: 17,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(
                color: gradient.defoultColor,
              ))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                        width: Get.size.width,
                        decoration: BoxDecoration(
                          color: WhiteColor,
                        ),
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  addLocationController.lat,
                                  addLocationController.long,
                                ), //initial position
                                zoom: 15.0, //initial zoom level
                              ),
                              polygons: _polygon,
                              markers: Set<Marker>.of(_markers),
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              compassEnabled: true,
                              zoomGesturesEnabled: true,
                              tiltGesturesEnabled: true,
                              zoomControlsEnabled: true,
                              onMapCreated: (controller) {
                                //method called when map is created
                                setState(() {
                                  mapController = controller;
                                });
                              },
                              onTap: (argument) async {
                                bool istap =
                                    _isPointInsidePolygon(argument, points);
                                setState(() {
                                  isnotavalble = istap;
                                });

                                if (istap) {
                                  final Uint8List markIcons = await getImages(
                                      "assets/ic_destination_long.png", 100);
                                  // makers added according to index
                                  _markers.add(
                                    Marker(
                                      // given marker id
                                      markerId: const MarkerId("1"),
                                      // given marker icon
                                      icon: BitmapDescriptor.bytes(markIcons),
                                      // given position
                                      position: LatLng(
                                        argument.latitude,
                                        argument.longitude,
                                      ),

                                      infoWindow: const InfoWindow(),
                                    ),
                                  );
                                  await placemarkFromCoordinates(
                                          argument.latitude, argument.longitude)
                                      .then((List<Placemark> placemarks) {
                                    addLocationController.address =
                                        '${placemarks.first.name!.isNotEmpty ? '${placemarks.first.name!}, ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? '${placemarks.first.thoroughfare!}, ' : ''}${placemarks.first.subLocality!.isNotEmpty ? '${placemarks.first.subLocality!}, ' : ''}${placemarks.first.locality!.isNotEmpty ? '${placemarks.first.locality!}, ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? '${placemarks.first.subAdministrativeArea!}, ' : ''}${placemarks.first.postalCode!.isNotEmpty ? '${placemarks.first.postalCode!}, ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
                                  });
                                  addLocationController.getCurrentLatAndLong(
                                    argument.latitude,
                                    argument.longitude,
                                  );
                                  setState(() {});
                                } else {}
                              },
                            ),
                            Positioned(
                              top: 0,
                              child: InkWell(
                                onTap: () async {
                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: Config.googleKey,
                                      mode: Mode.overlay,
                                      types: [],
                                      resultTextStyle: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: BlackColor,
                                      ),
                                      strictbounds: false,
                                      backArrowIcon:
                                          const Icon(Icons.arrow_back),
                                      components: [
                                        const Component(Component.country, 'In')
                                      ],
                                      //google_map_webservice package
                                      onError: (err) {});

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                      addLocationController.address =
                                          place.description.toString();
                                      // homePageController.getChangeLocation(location);
                                    });
                                    //form google_maps_webservice package
                                    final plist = GoogleMapsPlaces(
                                      apiKey: Config.googleKey,
                                      apiHeaders: await const GoogleApiHeaders()
                                          .getHeaders(),
                                      //from google_api_headers package
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail = await plist
                                        .getDetailsByPlaceId(placeid);
                                    final geometry = detail.result.geometry!;
                                    final lat = geometry.location.lat;
                                    final lang = geometry.location.lng;
                                    addLocationController.getCurrentLatAndLong(
                                      lat,
                                      lang,
                                    );
                                    newlatlang = LatLng(lat, lang);
                                    mapController?.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: newlatlang, zoom: 17),
                                      ),
                                    );
                                    loadData();
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: Get.size.width / 1.05,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: WhiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/Search.png",
                                          height: 20,
                                          width: 20,
                                          color: greyColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                        child: Text(
                                          location.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 16,
                                            color: greyColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                bottom: 0,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      getcurrentlocation();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: Get.width / 2,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: WhiteColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: primeryColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/location-crosshairs.png",
                                            height: 25,
                                            width: 25,
                                            color: primeryColor,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Use Current Location".tr,
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyMedium,
                                                  color: primeryColor,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  ),
                  Container(
                    height: 170,
                    width: Get.size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
                          offset: const Offset(3.0, 0),
                          color: Colors.grey.shade300,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            isnotavalble
                                ? Image.asset(
                                    "assets/location-crosshairs1.png",
                                    height: 20,
                                    width: 20,
                                  )
                                : SvgPicture.asset(
                                    "assets/location-pin-slash.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              isnotavalble ? "Near".tr : "Oops! Sorry,",
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          isnotavalble
                              ? addLocationController.address
                              : "we don't deliver at your location, Please select a different location",
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                            color: BlackColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            if (isnotavalble) {
                              setState(() {
                                address = addLocationController.address;
                              });

                              Get.back();
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Oops! Sorry, we don't deliver at your location, Please select a different location",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                              );
                              Get.back();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: Get.size.width,
                            decoration: BoxDecoration(
                              gradient: gradient.btnGradient,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Confirm Location".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 17,
                                    color: WhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      );
    });
  }

  bool _isPointInsidePolygon(LatLng tapLocation, List<LatLng> polygon) {
    // List<LatLng> polygon = polygonCoordinates.toList();
    int i = 0, j = polygon.length - 1;
    bool isInside = false;

    for (; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > tapLocation.latitude) !=
              (polygon[j].latitude > tapLocation.latitude)) &&
          (tapLocation.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (tapLocation.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        isInside = !isInside;
      }
    }

    return isInside;
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    final Uint8List markIcons =
        await getImages("assets/ic_destination_long.png", 100);
    // makers added according to index
    _markers.add(
      Marker(
        // given marker id
        markerId: const MarkerId("1"),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: LatLng(
          addLocationController.lat,
          addLocationController.long,
        ),
        infoWindow: const InfoWindow(),
      ),
    );
    setState(() {});
  }
}
//Oops! Sorry, we don't deliver at your location, Please select a different location
