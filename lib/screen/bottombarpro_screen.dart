// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, prefer_is_empty, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use

import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/all_cart.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/home_search.dart';
import 'package:laundry/screen/profile_screen.dart';
import 'package:laundry/utils/Colors.dart';

class BottombarProScreen extends StatefulWidget {
  const BottombarProScreen({super.key});

  @override
  State<BottombarProScreen> createState() => _BottombarProScreenState();
}

int currentIndex = 0;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class _BottombarProScreenState extends State<BottombarProScreen>
    with TickerProviderStateMixin {
  CatDetailsController catDetailsController = Get.find();
  HomePageController homePageController = Get.find();

  late TabController tabController;
  List<Widget> myChilders = [
    HomeScreen(),
    HomeSearchScreen(statusWiseSearch: true, backbutton: false),
    // PreScriptionScreen(),
    AllCart(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    // catDetailsController.cartlength = [];
    print("++++++++++++ ${catDetailsController.cartlength.length}");
    if (getData.read("changeIndex") != null) {
      if (getData.read("changeIndex") != true) {
        currentIndex = 0;
        setState(() {});
        save("changeIndex", false);
      } else {
        if (homePageController.isback == "1") {
          currentIndex = 0;
        }
      }
    } else {
      currentIndex = 0;
    }
    // currentIndex = 0;
    tabController =
        TabController(length: 4, vsync: this, initialIndex: currentIndex);
    super.initState();
    tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CatDetailsController>(builder: (context) {
        return TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              TabController(length: 4, vsync: this, initialIndex: currentIndex),
          children: myChilders,
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: WhiteColor,
        child: GetBuilder<CatDetailsController>(builder: (context) {
          return TabBar(
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            indicator: UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 52),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            labelColor: Colors.blueAccent,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            controller: TabController(
                length: 4, vsync: this, initialIndex: currentIndex),
            padding: const EdgeInsets.symmetric(vertical: 6),
            tabs: [
              Tab(
                child: Column(
                  children: [
                    currentIndex == 0
                        ? SvgPicture.asset(
                            "assets/bottomIcons/Homefill.svg",
                            color: gradient.defoultColor,
                          )
                        : SvgPicture.asset(
                            "assets/bottomIcons/Home.svg",
                            color: BlackColor,
                          ),
                    SizedBox(height: 4),
                    Text(
                      "Shop".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 0
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    if (currentIndex == 1)
                      SvgPicture.asset(
                        "assets/bottomIcons/searchfill.svg",
                        color: gradient.defoultColor,
                      )
                    else
                      SvgPicture.asset(
                        "assets/bottomIcons/search-1.svg",
                        color: BlackColor,
                      ),
                    SizedBox(height: 4),
                    Text(
                      "Search".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 1
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: bg.Badge(
                  position: bg.BadgePosition.topEnd(end: -5, top: -8),
                  badgeAnimation: bg.BadgeAnimation.fade(),
                  badgeContent: Text(
                    catDetailsController.cartlength.length.toString(),
                    style: TextStyle(color: WhiteColor, fontSize: 10),
                  ),
                  badgeStyle: bg.BadgeStyle(
                    badgeColor: gradient.defoultColor,
                    elevation: 0,
                    shape: bg.BadgeShape.circle,
                  ),
                  showBadge: catDetailsController.cartlength.length == 0
                      ? false
                      : true,
                  child: Column(
                    children: [
                      currentIndex == 2
                          ? SvgPicture.asset(
                              "assets/bottomIcons/Shopping Cartfill.svg",
                              color: gradient.defoultColor,
                            )
                          : SvgPicture.asset(
                              "assets/bottomIcons/Shopping-cart.svg",
                              color: BlackColor,
                            ),
                      SizedBox(height: 4),
                      Text(
                        "Cart".tr,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: FontFamily.gilroyBold,
                          color: currentIndex == 2
                              ? gradient.defoultColor
                              : BlackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    currentIndex == 3
                        ? SvgPicture.asset(
                            "assets/bottomIcons/Userfill.svg",
                            color: gradient.defoultColor,
                          )
                        : SvgPicture.asset(
                            "assets/bottomIcons/User.svg",
                            color: BlackColor,
                          ),
                    SizedBox(height: 4),
                    Text(
                      "Profile".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 3
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
