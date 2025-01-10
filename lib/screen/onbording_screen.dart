// ignore_for_file: camel_case_types, use_key_in_widget_constructors, annotate_overrides, prefer_const_literals_to_create_immutables, file_names, unused_element, prefer_const_constructors, prefer_typing_uninitialized_variables, sort_child_properties_last, prefer_interpolation_to_compose_strings, unused_local_variable, curly_braces_in_flow_control_structures, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/loginAndsignup/login_screen.dart';
import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/String.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

var lat;
var long;
var address;

class onbording extends StatefulWidget {
  const onbording({Key? key}) : super(key: key);

  @override
  State<onbording> createState() => _onbordingState();
}

class _onbordingState extends State<onbording> {
  @override
  void initState() {
    super.initState();
    getCurrentLatAndLong();
  }

  //! get Current Location
  getCurrentLatAndLong() async {
    print('PRATIK_1');
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    print('PRATIK_2');
    if (permission == LocationPermission.denied) {
      print('PRATIK_3');
      if (Platform.isAndroid) {
        print('PRATIK_4');
        SystemNavigator.pop();
        print('PRATIK_5');
      } else if (Platform.isIOS) {
        print('PRATIK_6');
        exit(0);
      }
    }

    var currentLocation = await locateUser();
    List<Placemark> addresses = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    await placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${placemarks.first.name!.isNotEmpty ? placemarks.first.name! + ', ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? placemarks.first.thoroughfare! + ', ' : ''}${placemarks.first.subLocality!.isNotEmpty ? placemarks.first.subLocality! + ', ' : ''}${placemarks.first.locality!.isNotEmpty ? placemarks.first.locality! + ', ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? placemarks.first.subAdministrativeArea! + ', ' : ''}${placemarks.first.postalCode!.isNotEmpty ? placemarks.first.postalCode! + ', ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
    });
    setState(() {
      lat = currentLocation.latitude;
      long = currentLocation.longitude;

      setScreen();
    });
  }



  setScreen() async {
    Timer(
      const Duration(seconds: 0),
      () => getData.read('Firstuser') != true
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BoardingPage(),
              ),
            )
          : getData.read('Remember') != true
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                )
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottombarProScreen(),
                  ),
                ),
    );
  }

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = ((prefs.getInt('counter') ?? 0) + 1);
      prefs.setInt('counter', _counter);
    });
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset("assets/appLogo.svg", height: 120, width: 100),
      ),
    );
  }
}

class BoardingPage extends StatefulWidget {
  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingPage> {
  //! creating all the widget before making our home screeen

  void initState() {
    super.initState();
    _currentPage = 0;

    _slides = [
      Slide("assets/lotties/1st.json", provider.discover, provider.healthy),
      Slide("assets/lotties/2nd.json", provider.order, provider.orderthe),
      Slide("assets/lotties/3rd.json", provider.lets, provider.cooking),
    ];

    _pageController = PageController(initialPage: _currentPage);

    super.initState();
  }

  int _currentPage = 0;

  List<Slide> _slides = [];

  PageController _pageController = PageController();

  //! the list which contain the build slides
  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: Get.height * 0.45,
            width: Get.width,

            alignment: Alignment.center,
            margin: EdgeInsets.only(top: Get.size.height * 0.1),
            padding: EdgeInsets.all(10),
            child: Lottie.asset(slide.image, fit: BoxFit.cover),
            // child: Image.asset(slide.image, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  //! handling the on page changed
  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  //! building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1)
        row.children.add(const SizedBox(
          width: 10,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 30 : 8,
      height: index == _currentPage ? 8 : 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              index == _currentPage ? WhiteColor : WhiteColor.withOpacity(0.5)),
    );
  }

  sliderText() {
    return Column(
      children: [
        SizedBox(height: Get.height * 0.05),
        SizedBox(
          width: Get.width * 0.70,
          child: Text(
            _currentPage == 0
                ? "Laundry made easy - anytime, anywhere!".tr
                : _currentPage == 1
                    ? "Say goodbye to laundry day stress with our app".tr
                    : _currentPage == 2
                        ? "Effortlessly clean clothes with just a few taps".tr
                        : "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 21,
                fontFamily: "Gilroy Bold",
                color: Colors.white), //heding Text
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        SizedBox(
          width: Get.width * 0.70,
          child: Text(
            _currentPage == 0
                ? "With this app, users can easily schedule laundry pickups and deliveries from the comfort of their own homes"
                    .tr
                : _currentPage == 1
                    ? "Doing laundry can be a time-consuming and stressful task, but with this app, users can easily schedule pickups and deliveries"
                        .tr
                    : _currentPage == 2
                        ? "Select their preferred cleaning options, and track the status of their laundry"
                            .tr
                        : "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontFamily: "Gilroy Medium",
                height: 1.6), //subtext
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: _handlingOnPageChanged,
            physics: const BouncingScrollPhysics(),
            children: _buildSlides(),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.loginScreen);
              save("isBack", true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.loginScreen);
                    save("isBack", true);
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "Skip".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 14,
                        color: BlackColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: Get.size.height * 0.4,
              width: Get.size.width,
              decoration: BoxDecoration(
                color: Color(0xff113FFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _buildPageIndicator(),
                  sliderText(),
                  Spacer(),
                  _currentPage == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.loginScreen);
                              save("isBack", true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // gradient: gradient.btnGradient,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  provider.getstart,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff113FFF),
                                      fontFamily: "Gilroy Bold"),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                  duration: const Duration(microseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  // gradient: gradient.btnGradient,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  provider.next,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff113FFF),
                                      fontFamily: "Gilroy Bold"),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: Get.height * 0.012,
                    //indicator set screen
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}

Future<Position> locateUser() async {
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
