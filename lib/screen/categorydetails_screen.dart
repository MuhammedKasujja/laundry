// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unrelated_type_equality_checks, use_key_in_widget_constructors, must_be_immutable, library_private_types_in_public_api, unused_field, prefer_final_fields, avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty, deprecated_member_use

import 'dart:async';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/cart_controller.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/controller/fav_controller.dart';
import 'package:laundry/controller/productdetails_controller.dart';
import 'package:laundry/controller/stordata_controller.dart';

import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/about_screen.dart';
import 'package:laundry/screen/categoryviewall/category_viewall.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/home_search.dart';
import 'package:laundry/screen/yourcart_screen.dart';

import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/cart_item.dart';
import 'package:readmore/readmore.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  ProductDetailsController productDetailsController = Get.find();
  CartController cartController = Get.find();
  FavController favController = Get.find();

  int cnt = 0;
  ScrollController? _scrollController;
  bool lastStatus = true;

  double height = Get.height * 0.56;

  PageController pageController = PageController();

  int currentIndex = 0;

  int selectIndex = -1;
  List bottom = ["About", "Review", "Photos", "FAQ's"];

  late Box<CartItem> cart;
  late final List<CartItem> items;
  double productPrice = 0;

  List<String> img = [
    "assets/star2.png",
    "assets/location-pin2.png",
    "assets/door-open.png",
    "assets/like.png",
  ];

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    cart = Hive.box<CartItem>('cart');
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    setupHive();

    print("............." + scrollController.keepScrollOffset.toString());
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    List<CartItem> tempList = [];
    catDetailsController.getCartLangth();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CatDetailsController>(builder: (catDetailsController) {
      return Scaffold(
        backgroundColor: WhiteColor,
        bottomNavigationBar: catDetailsController.count.length == 0
            ? SizedBox()
            : GestureDetector(
          onTap: (){
            setState(() {
              catDetailsController.isLoading1 = true;
            });
            Get.to(YourCartScreen(CartStatus: "1"));
            // Future.delayed(
            //   Duration(seconds: 2),
            //   () {
            //     Get.to(YourCartScreen(CartStatus: "1"));
            //   },
            // );
          },
              child: Row(children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: primeryColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 60,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    catDetailsController.totalItem.toString() +
                                        " Item",
                                    style: TextStyle(
                                        color: WhiteColor,
                                        fontSize: 14,
                                        fontFamily: "Gilroy Bold"),
                                  ),
                                  Text(
                                      " |  ${currency}" +
                                          catDetailsController.totalAmount
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: WhiteColor,
                                          fontSize: 15,
                                          fontFamily: "Gilroy Bold")),
                                ],
                              ),
                              Text(
                                "Extra charges may apply".tr,
                                style: TextStyle(fontSize: 12, color: WhiteColor),
                              )
                            ],
                          ),
                          Text(
                            "View Cart".tr,
                            style: TextStyle(
                                fontSize: 16,
                                color: WhiteColor,
                                fontFamily: 'Gilroy Bold'),
                          ),
                        ]),
                  ))
                ]),
            ),
        body: GetBuilder<StoreDataContoller>(builder: (context) {
          return storeDataContoller.isLoading
              ? RefreshIndicator(
                  color: gradient.defoultColor,
                  onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 2),
                      () {
                        storeDataContoller.getStoreData(
                            storeId: catDetailsController.strId);
                      },
                    );
                  },

                  child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            pinned: true,
                            leading: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(7),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: WhiteColor,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF000000).withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            actions: [
                              InkWell(
                                onTap: () {
                                  // Get.toNamed(
                                  //   Routes.homeSearchScreen,
                                  //   arguments: {
                                  //     "statusWiseSearch": false,
                                  //   },
                                  // );
                                  Get.to(HomeSearchScreen(statusWiseSearch: false, backbutton: true));
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/Search.png",
                                    height: 20,
                                    width: 20,
                                    color: WhiteColor,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF000000).withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  favController.addFavAndRemoveApi(
                                    storeId: storeDataContoller
                                        .storeDataInfo?.storeInfo.storeId,
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: storeDataContoller.storeDataInfo
                                              ?.storeInfo.isFavourite == 0
                                      ? Image.asset(
                                          "assets/heartOutlinded.png",
                                          height: 20,
                                          width: 20,
                                          color: WhiteColor,
                                        )
                                      : Image.asset(
                                          "assets/heart.png",
                                          height: 25,
                                          width: 25,
                                          color: gradient.defoultColor,
                                        ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF000000).withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                            expandedHeight: Get.height * 0.29,
                            bottom: PreferredSize(
                              child: Container(),
                              preferredSize: Size(0, 20),
                            ),
                            flexibleSpace: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: Get.height * 0.34,
                                    width: double.infinity,
                                    child: Image.network(
                                      "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeCover ?? ""}",
                                      fit: BoxFit.cover,
                                    ),
                                    decoration: BoxDecoration(
                                      color: transparent,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                  bottom: -1,
                                  left: 0,
                                  right: 0,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: WhiteColor,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          storeDataContoller.storeDataInfo
                                                  ?.storeInfo.storeTitle ??
                                              "",
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 20,
                                            color: BlackColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Container(
                                        height: 45,
                                        width: 45,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/ezgif.com-crop.gif",
                                            image:
                                                "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeLogo ?? ""}",
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: WhiteColor,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 55,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(0, -1),
                                                    child: Image.asset(
                                                      img[0],
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(0, 1),
                                                    child: Text(
                                                      storeDataContoller
                                                              .storeDataInfo
                                                              ?.storeInfo
                                                              .storeRate ??
                                                          "",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 55,
                                          width: Get.size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    img[1],
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        Get.size.width * 0.15,
                                                    child: Transform.translate(
                                                      offset: Offset(0, 1),
                                                      child: Text(
                                                        "${storeDataContoller.storeDataInfo?.storeInfo.restDistance.split(" ").first ?? ""}Km",
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 13,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 55,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    img[2],
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Flexible(
                                                    child: Transform.translate(
                                                      offset: Offset(0, 1),
                                                      child: Text(
                                                        "${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeOpentime}")).toString().split(":").first}AM - ${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeClosetime}")).toString().split(":").first}PM"
                                                            .tr,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 13,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 55,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(0, -1),
                                                    child: Image.asset(
                                                      img[3],
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(0, 1),
                                                    child: Text(
                                                      storeDataContoller
                                                              .storeDataInfo
                                                              ?.storeInfo
                                                              .totalFav
                                                              .toString() ??
                                                          "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 13,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),

                                  SizedBox(
                                    height: 55,
                                    width: Get.width,
                                    child: ListView.builder(
                                      itemCount: 4,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectIndex = index;
                                            });
                                            Get.bottomSheet(
                                                enterBottomSheetDuration:
                                                    Duration(milliseconds: 450),
                                                isScrollControlled: true,
                                                selectIndex == 0
                                                    ? AboutScreen()
                                                    : selectIndex == 1
                                                        ? reviewWidget()
                                                        : selectIndex == 2
                                                            ? photoWidget()
                                                            : faqWidget());

                                            //     ProfileScreen(),
                                            //     YourCartScreen(CartStatus: "1"),
                                            //     ProfileScreen(),
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                // height: 50,
                                                width: Get.width * 0.21,
                                                // decoration: BoxDecoration(
                                                //   color: selectIndex == index
                                                //       ? primeryColor
                                                //       : Colors.transparent,
                                                //   borderRadius: BorderRadius.circular(8),
                                                // ),
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    bottom[index],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 13,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              selectIndex == index
                                                  ? Container(
                                                      height: 3,
                                                      width: Get.width * 0.22,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "Category",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(CategoryViewAll())
                                              ?.then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Text(
                                          "View All",
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 15,
                                            color: gradient.defoultColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  SizedBox(
                                    height: 65,
                                    width: Get.size.width,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: storeDataContoller
                                          .storeDataInfo?.catwiseproduct.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentIndex = index;
                                              pageController
                                                  .jumpToPage(currentIndex);
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                margin: EdgeInsets.all(5),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 15),
                                                child: Row(
                                                  children: [
                                                    storeDataContoller
                                                                .storeDataInfo
                                                                ?.catwiseproduct[
                                                                    index]
                                                                .img !=
                                                            ""
                                                        ? Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    "assets/ezgif.com-crop.gif",
                                                                placeholderCacheHeight:
                                                                    30,
                                                                placeholderCacheWidth:
                                                                    30,
                                                                placeholderFit:
                                                                    BoxFit
                                                                        .cover,
                                                                image:
                                                                    "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                                                                height: 30,
                                                                width: 30,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          storeDataContoller
                                                                  .storeDataInfo
                                                                  ?.catwiseproduct[
                                                                      index]
                                                                  .catTitle ??
                                                              "",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: greytext,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: WhiteColor,
                                                    border: Border.all(
                                                        color: currentIndex ==
                                                                index
                                                            ? primeryColor
                                                            : transparent)),
                                              ),
                                              // storeDataContoller.viewAllIndex == index
                                              //     ? Container(
                                              //         height: 4,
                                              //         width: 80,
                                              //         color: gradient.defoultColor,
                                              //       )
                                              //     : SizedBox(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  storeDataContoller.storeDataInfo!
                                          .catwiseproduct.isNotEmpty
                                      ? Text(
                                          storeDataContoller
                                                  .storeDataInfo
                                                  ?.catwiseproduct[currentIndex]
                                                  .catTitle ??
                                              "",
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 18,
                                          ),
                                        )
                                      : SizedBox(),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  storeDataContoller.storeDataInfo!
                                          .catwiseproduct.isNotEmpty
                                      ? Container(
                                          height: storeDataContoller
                                                      .storeDataInfo!
                                                      .catwiseproduct[
                                                          currentIndex]
                                                      .productdata
                                                      .length ==
                                                  0
                                              ? Get.height / 3
                                              : (110.0 *
                                                  storeDataContoller
                                                      .storeDataInfo!
                                                      .catwiseproduct[
                                                          currentIndex]
                                                      .productdata
                                                      .length),
                                          width: Get.width,
                                          child: PageView.builder(
                                            controller: pageController,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: storeDataContoller
                                                .storeDataInfo
                                                ?.catwiseproduct
                                                .length,
                                            onPageChanged: (value) {
                                              print(storeDataContoller
                                                  .storeDataInfo
                                                  ?.catwiseproduct
                                                  .length);
                                              storeDataContoller
                                                  .changeIndexInCategoryViewAll(
                                                      index: value);
                                              setState(() {
                                                currentIndex = value;
                                                scrollController.animateTo(
                                                  currentIndex * 80,
                                                  curve: Curves.easeOut,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                );
                                              });
                                            },
                                            itemBuilder: (context, index1) {
                                              return MediaQuery.removePadding(
                                                context: context,
                                                removeTop: true,
                                                child: ListView.builder(
                                                  itemCount: storeDataContoller
                                                      .storeDataInfo
                                                      ?.catwiseproduct[
                                                          currentIndex]
                                                      .productdata
                                                      .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ProductWidget(
                                                      index1: currentIndex,
                                                      index: index,
                                                      productTitle:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productTitle,
                                                      productImg:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productImg,
                                                      normalPrice:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productInfo[0]
                                                              .normalPrice,
                                                      attributeId:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productInfo[0]
                                                              .attributeId,
                                                      productDiscount:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productInfo[0]
                                                              .productDiscount,
                                                      productId:
                                                          storeDataContoller
                                                              .storeDataInfo
                                                              ?.catwiseproduct[
                                                                  currentIndex]
                                                              .productdata[
                                                                  index]
                                                              .productId,
                                                      title: storeDataContoller
                                                          .storeDataInfo
                                                          ?.catwiseproduct[
                                                              currentIndex]
                                                          .productdata[index]
                                                          .productInfo[0]
                                                          .title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(height: Get.height / 3),

                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          catDetailsController.isLoading1
                              ? CircularProgressIndicator(
                                  color: primeryColor,
                                )
                              : SizedBox(),
                        ],
                      )),

                  // child: CustomScrollView(
                  //   controller: scrollController,
                  //   slivers: [
                  //     SliverAppBar(
                  //       pinned: true,
                  //       leading: InkWell(
                  //         onTap: () {
                  //           Get.back();
                  //         },
                  //         child: Container(
                  //           height: 40,
                  //           width: 40,
                  //           margin: EdgeInsets.all(5),
                  //           padding: EdgeInsets.all(7),
                  //           child: Icon(
                  //             Icons.arrow_back,
                  //             color: WhiteColor,
                  //           ),
                  //           decoration: BoxDecoration(
                  //             color: Color(0xFF000000).withOpacity(0.4),
                  //             shape: BoxShape.circle,
                  //           ),
                  //         ),
                  //       ),
                  //       elevation: 0,
                  //       backgroundColor: Colors.transparent,
                  //       actions: [
                  //         InkWell(
                  //           onTap: () {
                  //             Get.toNamed(
                  //               Routes.homeSearchScreen,
                  //               arguments: {
                  //                 "statusWiseSearch": false,
                  //               },
                  //             );
                  //           },
                  //           child: Container(
                  //             height: 40,
                  //             width: 40,
                  //             margin: EdgeInsets.all(5),
                  //             alignment: Alignment.center,
                  //             child: Image.asset(
                  //               "assets/Search.png",
                  //               height: 20,
                  //               width: 20,
                  //               color: WhiteColor,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               color: Color(0xFF000000).withOpacity(0.4),
                  //               shape: BoxShape.circle,
                  //             ),
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             favController.addFavAndRemoveApi(
                  //               storeId: storeDataContoller
                  //                   .storeDataInfo?.storeInfo.storeId,
                  //             );
                  //           },
                  //           child: Container(
                  //             height: 40,
                  //             width: 40,
                  //             margin: EdgeInsets.all(5),
                  //             alignment: Alignment.center,
                  //             child: storeDataContoller
                  //                         .storeDataInfo?.storeInfo.isFavourite ==
                  //                     0
                  //                 ? Image.asset(
                  //                     "assets/heartOutlinded.png",
                  //                     height: 20,
                  //                     width: 20,
                  //                     color: WhiteColor,
                  //                   )
                  //                 : Image.asset(
                  //                     "assets/heart.png",
                  //                     height: 25,
                  //                     width: 25,
                  //                     color: gradient.defoultColor,
                  //                   ),
                  //             decoration: BoxDecoration(
                  //               color: Color(0xFF000000).withOpacity(0.4),
                  //               shape: BoxShape.circle,
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 8,
                  //         ),
                  //       ],
                  //       expandedHeight: Get.height * 0.29,
                  //       bottom: PreferredSize(
                  //         child: Container(),
                  //         preferredSize: Size(0, 20),
                  //       ),
                  //       flexibleSpace: Stack(
                  //         children: [
                  //           Positioned(
                  //             top: 0,
                  //             left: 0,
                  //             right: 0,
                  //             bottom: 0,
                  //             child: Container(
                  //               height: Get.height * 0.34,
                  //               width: double.infinity,
                  //               child: Image.network(
                  //                 "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeCover ?? ""}",
                  //                 fit: BoxFit.cover,
                  //               ),
                  //               decoration: BoxDecoration(
                  //                 color: transparent,
                  //               ),
                  //             ),
                  //           ),
                  //           Positioned(
                  //             child: Container(
                  //               height: 10,
                  //               decoration: BoxDecoration(
                  //                 color: WhiteColor,
                  //                 borderRadius: BorderRadius.vertical(
                  //                   top: Radius.circular(50),
                  //                 ),
                  //               ),
                  //             ),
                  //             bottom: -1,
                  //             left: 0,
                  //             right: 0,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SliverList(
                  //       delegate: SliverChildListDelegate(
                  //         [
                  //           Container(
                  //             padding: EdgeInsets.symmetric(horizontal: 10),
                  //             color: WhiteColor,
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: Text(
                  //                         storeDataContoller.storeDataInfo
                  //                                 ?.storeInfo.storeTitle ??
                  //                             "",
                  //                         maxLines: 2,
                  //                         style: TextStyle(
                  //                           fontFamily: FontFamily.gilroyBold,
                  //                           fontSize: 20,
                  //                           color: BlackColor,
                  //                           overflow: TextOverflow.ellipsis,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 4,
                  //                     ),
                  //                     Container(
                  //                       height: 45,
                  //                       width: 45,
                  //                       child: ClipRRect(
                  //                         borderRadius: BorderRadius.circular(30),
                  //                         child: FadeInImage.assetNetwork(
                  //                           placeholder:
                  //                               "assets/ezgif.com-crop.gif",
                  //                           image:
                  //                               "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeLogo ?? ""}",
                  //                         ),
                  //                       ),
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         color: WhiteColor,
                  //                         border: Border.all(
                  //                             color: Colors.grey.shade300),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: Container(
                  //                         height: 70,
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.center,
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               children: [
                  //                                 Image.asset(
                  //                                   img[0],
                  //                                   height: 18,
                  //                                   width: 18,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 3,
                  //                                 ),
                  //                                 Text(
                  //                                   storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.storeInfo
                  //                                           .storeRate ??
                  //                                       "",
                  //                                   style: TextStyle(
                  //                                     fontFamily:
                  //                                         FontFamily.gilroyMedium,
                  //                                     fontSize: 14,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "Rating".tr,
                  //                               style: TextStyle(
                  //                                 fontFamily:
                  //                                     FontFamily.gilroyMedium,
                  //                                 fontSize: 13,
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 70,
                  //                       child: VerticalDivider(
                  //                         color: Colors.grey.shade200,
                  //                         endIndent: 15,
                  //                         width: 2,
                  //                         indent: 15,
                  //                         thickness: 1,
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: Container(
                  //                         height: 70,
                  //                         width: Get.size.width,
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.center,
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               children: [
                  //                                 Image.asset(
                  //                                   img[1],
                  //                                   height: 18,
                  //                                   width: 18,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 1,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: Get.size.width * 0.15,
                  //                                   child: Text(
                  //                                     "${storeDataContoller.storeDataInfo?.storeInfo.restDistance.split(" ").first ?? ""}Km",
                  //                                     maxLines: 1,
                  //                                     textAlign: TextAlign.center,
                  //                                     style: TextStyle(
                  //                                       fontFamily: FontFamily
                  //                                           .gilroyMedium,
                  //                                       fontSize: 13,
                  //                                       overflow:
                  //                                           TextOverflow.ellipsis,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "Distance".tr,
                  //                               style: TextStyle(
                  //                                 fontFamily:
                  //                                     FontFamily.gilroyMedium,
                  //                                 fontSize: 13,
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 70,
                  //                       child: VerticalDivider(
                  //                         color: Colors.grey.shade200,
                  //                         endIndent: 15,
                  //                         width: 2,
                  //                         indent: 15,
                  //                         thickness: 1,
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: Container(
                  //                         height: 70,
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.center,
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               children: [
                  //                                 Image.asset(
                  //                                   img[2],
                  //                                   height: 18,
                  //                                   width: 18,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 3,
                  //                                 ),
                  //                                 Text(
                  //                                   "Time".tr,
                  //                                   maxLines: 1,
                  //                                   style: TextStyle(
                  //                                     fontFamily:
                  //                                         FontFamily.gilroyMedium,
                  //                                     fontSize: 13,
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeOpentime}")).toString().split(":").first}AM - ${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeClosetime}")).toString().split(":").first}PM",
                  //                               style: TextStyle(
                  //                                 fontFamily:
                  //                                     FontFamily.gilroyMedium,
                  //                                 fontSize: 13,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 70,
                  //                       child: VerticalDivider(
                  //                         color: Colors.grey.shade200,
                  //                         endIndent: 15,
                  //                         width: 2,
                  //                         indent: 15,
                  //                         thickness: 1,
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: Container(
                  //                         height: 70,
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.center,
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.center,
                  //                               children: [
                  //                                 Image.asset(
                  //                                   img[3],
                  //                                   height: 18,
                  //                                   width: 18,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   width: 3,
                  //                                 ),
                  //                                 Text(
                  //                                   storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.storeInfo
                  //                                           .totalFav
                  //                                           .toString() ??
                  //                                       "",
                  //                                   maxLines: 1,
                  //                                   style: TextStyle(
                  //                                     fontFamily:
                  //                                         FontFamily.gilroyMedium,
                  //                                     fontSize: 13,
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "Likes".tr,
                  //                               style: TextStyle(
                  //                                 fontFamily:
                  //                                     FontFamily.gilroyMedium,
                  //                                 fontSize: 13,
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   height: 5,
                  //                 ),
                  //                 Row(
                  //                   children: [
                  //                     Text(
                  //                       "Category",
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontFamily: FontFamily.gilroyBold,
                  //                         color: BlackColor,
                  //                       ),
                  //                     ),
                  //                     Spacer(),
                  //                     TextButton(
                  //                       onPressed: () {
                  //                         Get.to(CategoryViewAll())
                  //                             ?.then((value) {
                  //                           setState(() {});
                  //                         });
                  //                       },
                  //                       child: Text(
                  //                         "View All",
                  //                         style: TextStyle(
                  //                           fontFamily: FontFamily.gilroyMedium,
                  //                           fontSize: 15,
                  //                           color: gradient.defoultColor,
                  //                         ),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   height: 65,
                  //                   width: Get.size.width,
                  //                   child: ListView.builder(
                  //                     controller: scrollController,
                  //                     itemCount: storeDataContoller
                  //                         .storeDataInfo?.catwiseproduct.length,
                  //                     scrollDirection: Axis.horizontal,
                  //                     itemBuilder: (context, index) {
                  //                       return InkWell(
                  //                         onTap: () {
                  //                           setState(() {
                  //                             currentIndex = index;
                  //                             pageController
                  //                                 .jumpToPage(currentIndex);
                  //                           });
                  //                         },
                  //                         child: Column(
                  //                           children: [
                  //                             Container(
                  //                               height: 50,
                  //                               margin: EdgeInsets.all(5),
                  //                               alignment: Alignment.center,
                  //                               padding: EdgeInsets.only(
                  //                                   left: 10, right: 15),
                  //                               child: Row(
                  //                                 children: [
                  //                                   storeDataContoller
                  //                                               .storeDataInfo
                  //                                               ?.catwiseproduct[
                  //                                                   index]
                  //                                               .img !=
                  //                                           ""
                  //                                       ? Container(
                  //                                           height: 30,
                  //                                           width: 30,
                  //                                           child: ClipRRect(
                  //                                             borderRadius:
                  //                                                 BorderRadius
                  //                                                     .circular(
                  //                                                         30),
                  //                                             child: FadeInImage
                  //                                                 .assetNetwork(
                  //                                               placeholder:
                  //                                                   "assets/ezgif.com-crop.gif",
                  //                                               placeholderCacheHeight:
                  //                                                   30,
                  //                                               placeholderCacheWidth:
                  //                                                   30,
                  //                                               placeholderFit:
                  //                                                   BoxFit.cover,
                  //                                               image:
                  //                                                   "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                  //                                               height: 30,
                  //                                               width: 30,
                  //                                               fit: BoxFit.cover,
                  //                                             ),
                  //                                           ),
                  //                                           decoration:
                  //                                               BoxDecoration(
                  //                                             shape:
                  //                                                 BoxShape.circle,
                  //                                           ),
                  //                                         )
                  //                                       : SizedBox(),
                  //                                   SizedBox(
                  //                                     width: 5,
                  //                                   ),
                  //                                   Column(
                  //                                     mainAxisAlignment:
                  //                                         MainAxisAlignment
                  //                                             .center,
                  //                                     crossAxisAlignment:
                  //                                         CrossAxisAlignment
                  //                                             .start,
                  //                                     children: [
                  //                                       Text(
                  //                                         storeDataContoller
                  //                                                 .storeDataInfo
                  //                                                 ?.catwiseproduct[
                  //                                                     index]
                  //                                                 .catTitle ??
                  //                                             "",
                  //                                         style: TextStyle(
                  //                                           fontFamily: FontFamily
                  //                                               .gilroyBold,
                  //                                           fontSize: 13,
                  //                                         ),
                  //                                       ),
                  //                                       Text(
                  //                                         "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                  //                                         style: TextStyle(
                  //                                           fontFamily: FontFamily
                  //                                               .gilroyMedium,
                  //                                           color: greytext,
                  //                                           fontSize: 10,
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   )
                  //                                 ],
                  //                               ),
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(30),
                  //                                 color: WhiteColor,
                  //                               ),
                  //                             ),
                  //                             storeDataContoller.currentIndex ==
                  //                                     index
                  //                                 ? Container(
                  //                                     height: 4,
                  //                                     width: 80,
                  //                                     color:
                  //                                         gradient.defoultColor,
                  //                                   )
                  //                                 : SizedBox(),
                  //                           ],
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Container(
                  //                   height: Get.size.height,
                  //                   color: WhiteColor,
                  //                   child: PageView.builder(
                  //                     controller: pageController,
                  //                     itemCount: storeDataContoller
                  //                         .storeDataInfo?.catwiseproduct.length,
                  //                     onPageChanged: (value) {
                  //                       storeDataContoller.changeIndexInCategory(
                  //                           index: value);
                  //                       setState(() {
                  //                         currentIndex = value;
                  //                         scrollController.animateTo(
                  //                           currentIndex * 80,
                  //                           curve: Curves.easeOut,
                  //                           duration:
                  //                               const Duration(milliseconds: 300),
                  //                         );
                  //                       });
                  //                     },
                  //                     itemBuilder: (context, index1) {
                  //                       return Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           SizedBox(
                  //                             height: 10,
                  //                           ),
                  //                           Text(
                  //                             storeDataContoller
                  //                                     .storeDataInfo
                  //                                     ?.catwiseproduct[
                  //                                         currentIndex]
                  //                                     .catTitle ??
                  //                                 "",
                  //                             style: TextStyle(
                  //                               color: BlackColor,
                  //                               fontFamily: FontFamily.gilroyBold,
                  //                               fontSize: 18,
                  //                             ),
                  //                           ),
                  //                           SizedBox(
                  //                             height: 10,
                  //                           ),
                  //                           Expanded(
                  //                             flex: 1,
                  //                             child: ListView.builder(
                  //                               itemCount: storeDataContoller
                  //                                   .storeDataInfo
                  //                                   ?.catwiseproduct[currentIndex]
                  //                                   .productdata
                  //                                   .length,
                  //                               shrinkWrap: true,
                  //                               physics:
                  //                                   NeverScrollableScrollPhysics(),
                  //                               padding: EdgeInsets.zero,
                  //                               itemBuilder: (context, index) {
                  //                                 return ProductWidget(
                  //                                   index1: currentIndex,
                  //                                   index: index,
                  //                                   productTitle:
                  //                                       storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.catwiseproduct[
                  //                                               currentIndex]
                  //                                           .productdata[index]
                  //                                           .productTitle,
                  //                                   productImg: storeDataContoller
                  //                                       .storeDataInfo
                  //                                       ?.catwiseproduct[
                  //                                           currentIndex]
                  //                                       .productdata[index]
                  //                                       .productImg,
                  //                                   normalPrice:
                  //                                       storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.catwiseproduct[
                  //                                               currentIndex]
                  //                                           .productdata[index]
                  //                                           .productInfo[0]
                  //                                           .normalPrice,
                  //                                   attributeId:
                  //                                       storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.catwiseproduct[
                  //                                               currentIndex]
                  //                                           .productdata[index]
                  //                                           .productInfo[0]
                  //                                           .attributeId,
                  //                                   productDiscount:
                  //                                       storeDataContoller
                  //                                           .storeDataInfo
                  //                                           ?.catwiseproduct[
                  //                                               currentIndex]
                  //                                           .productdata[index]
                  //                                           .productInfo[0]
                  //                                           .productDiscount,
                  //                                   productId: storeDataContoller
                  //                                       .storeDataInfo
                  //                                       ?.catwiseproduct[
                  //                                           currentIndex]
                  //                                       .productdata[index]
                  //                                       .productId,
                  //                                   title: storeDataContoller
                  //                                       .storeDataInfo
                  //                                       ?.catwiseproduct[
                  //                                           currentIndex]
                  //                                       .productdata[index]
                  //                                       .productInfo[0]
                  //                                       .title,
                  //                                 );
                  //                               },
                  //                             ),
                  //                           )
                  //                         ],
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),

                  //                 // SizedBox(
                  //                 //   height: 65,
                  //                 //   width: Get.size.width,
                  //                 //   child: ListView.builder(
                  //                 //     itemCount: storeDataContoller
                  //                 //         .storeDataInfo?.catwiseproduct.length,
                  //                 //     scrollDirection: Axis.horizontal,
                  //                 //     itemBuilder: (context, index) {
                  //                 //       return storeDataContoller
                  //                 //               .storeDataInfo!
                  //                 //               .catwiseproduct[index]
                  //                 //               .productdata
                  //                 //               .isNotEmpty
                  //                 //           ? InkWell(
                  //                 //               onTap: () {
                  //                 //                 storeDataContoller
                  //                 //                     .changeIndexInCategory(
                  //                 //                         index: index);
                  //                 //                 scrollController.animateTo(
                  //                 //                   index * 450,
                  //                 //                   curve: Curves.easeOut,
                  //                 //                   duration: const Duration(
                  //                 //                       milliseconds: 300),
                  //                 //                 );
                  //                 //               },
                  //                 //               child: Column(
                  //                 //                 children: [
                  //                 //                   Container(
                  //                 //                     height: 50,
                  //                 //                     margin: EdgeInsets.all(5),
                  //                 //                     alignment: Alignment.center,
                  //                 //                     padding: EdgeInsets.only(
                  //                 //                         left: 10, right: 15),
                  //                 //                     child: Row(
                  //                 //                       children: [
                  //                 //                         storeDataContoller
                  //                 //                                     .storeDataInfo
                  //                 //                                     ?.catwiseproduct[
                  //                 //                                         index]
                  //                 //                                     .img !=
                  //                 //                                 ""
                  //                 //                             ? Container(
                  //                 //                                 height: 30,
                  //                 //                                 width: 30,
                  //                 //                                 child:
                  //                 //                                     ClipRRect(
                  //                 //                                   borderRadius:
                  //                 //                                       BorderRadius
                  //                 //                                           .circular(
                  //                 //                                               30),
                  //                 //                                   child: FadeInImage
                  //                 //                                       .assetNetwork(
                  //                 //                                     placeholder:
                  //                 //                                         "assets/ezgif.com-crop.gif",
                  //                 //                                     placeholderCacheHeight:
                  //                 //                                         30,
                  //                 //                                     placeholderCacheWidth:
                  //                 //                                         30,
                  //                 //                                     placeholderFit:
                  //                 //                                         BoxFit
                  //                 //                                             .cover,
                  //                 //                                     image:
                  //                 //                                         "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                  //                 //                                     height: 30,
                  //                 //                                     width: 30,
                  //                 //                                     fit: BoxFit
                  //                 //                                         .cover,
                  //                 //                                   ),
                  //                 //                                 ),
                  //                 //                                 decoration:
                  //                 //                                     BoxDecoration(
                  //                 //                                   shape: BoxShape
                  //                 //                                       .circle,
                  //                 //                                 ),
                  //                 //                               )
                  //                 //                             : SizedBox(),
                  //                 //                         SizedBox(
                  //                 //                           width: 5,
                  //                 //                         ),
                  //                 //                         Column(
                  //                 //                           mainAxisAlignment:
                  //                 //                               MainAxisAlignment
                  //                 //                                   .center,
                  //                 //                           crossAxisAlignment:
                  //                 //                               CrossAxisAlignment
                  //                 //                                   .start,
                  //                 //                           children: [
                  //                 //                             Text(
                  //                 //                               storeDataContoller
                  //                 //                                       .storeDataInfo
                  //                 //                                       ?.catwiseproduct[
                  //                 //                                           index]
                  //                 //                                       .catTitle ??
                  //                 //                                   "",
                  //                 //                               style: TextStyle(
                  //                 //                                 fontFamily:
                  //                 //                                     FontFamily
                  //                 //                                         .gilroyBold,
                  //                 //                                 fontSize: 13,
                  //                 //                               ),
                  //                 //                             ),
                  //                 //                             Text(
                  //                 //                               "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                  //                 //                               style: TextStyle(
                  //                 //                                 fontFamily:
                  //                 //                                     FontFamily
                  //                 //                                         .gilroyMedium,
                  //                 //                                 color: greytext,
                  //                 //                                 fontSize: 10,
                  //                 //                               ),
                  //                 //                             ),
                  //                 //                           ],
                  //                 //                         )
                  //                 //                       ],
                  //                 //                     ),
                  //                 //                     decoration: BoxDecoration(
                  //                 //                       borderRadius:
                  //                 //                           BorderRadius.circular(
                  //                 //                               30),
                  //                 //                       color: WhiteColor,
                  //                 //                       // boxShadow: [
                  //                 //                       //   BoxShadow(
                  //                 //                       //     color:
                  //                 //                       //         Colors.grey.shade300,
                  //                 //                       //     offset: const Offset(
                  //                 //                       //       0.3,
                  //                 //                       //       0.3,
                  //                 //                       //     ),
                  //                 //                       //     blurRadius: 0.3,
                  //                 //                       //     spreadRadius: 0.3,
                  //                 //                       //   ), //BoxShadow
                  //                 //                       //   BoxShadow(
                  //                 //                       //     color: Colors.white,
                  //                 //                       //     offset: const Offset(
                  //                 //                       //         0.0, 0.0),
                  //                 //                       //     blurRadius: 0.0,
                  //                 //                       //     spreadRadius: 0.0,
                  //                 //                       //   ), //BoxShadow
                  //                 //                       // ],
                  //                 //                     ),
                  //                 //                   ),
                  //                 //                   storeDataContoller
                  //                 //                               .currentIndex ==
                  //                 //                           index
                  //                 //                       ? Container(
                  //                 //                           height: 4,
                  //                 //                           width: 80,
                  //                 //                           color: gradient
                  //                 //                               .defoultColor,
                  //                 //                         )
                  //                 //                       : SizedBox(),
                  //                 //                 ],
                  //                 //               ),
                  //                 //             )
                  //                 //           : SizedBox();
                  //                 //     },
                  //                 //   ),
                  //                 // ),
                  //                 // SizedBox(
                  //                 //   height: 10,
                  //                 // ),
                  //                 // Container(
                  //                 //   color: WhiteColor,
                  //                 //   child: ListView.builder(
                  //                 //     itemCount: storeDataContoller
                  //                 //         .storeDataInfo?.catwiseproduct.length,
                  //                 //     shrinkWrap: true,
                  //                 //     physics: NeverScrollableScrollPhysics(),
                  //                 //     padding: EdgeInsets.zero,
                  //                 //     itemBuilder: (context, index1) {
                  //                 //       return storeDataContoller
                  //                 //               .storeDataInfo!
                  //                 //               .catwiseproduct[index1]
                  //                 //               .productdata
                  //                 //               .isNotEmpty
                  //                 //           ? Column(
                  //                 //               crossAxisAlignment:
                  //                 //                   CrossAxisAlignment.start,
                  //                 //               children: [
                  //                 //                 SizedBox(
                  //                 //                   height: 10,
                  //                 //                 ),
                  //                 //                 Text(
                  //                 //                   storeDataContoller
                  //                 //                           .storeDataInfo
                  //                 //                           ?.catwiseproduct[
                  //                 //                               index1]
                  //                 //                           .catTitle ??
                  //                 //                       "",
                  //                 //                   style: TextStyle(
                  //                 //                     color: BlackColor,
                  //                 //                     fontFamily:
                  //                 //                         FontFamily.gilroyBold,
                  //                 //                     fontSize: 18,
                  //                 //                   ),
                  //                 //                 ),
                  //                 //                 SizedBox(
                  //                 //                   height: 10,
                  //                 //                 ),
                  //                 //                 ListView.builder(
                  //                 //                   itemCount: storeDataContoller
                  //                 //                       .storeDataInfo
                  //                 //                       ?.catwiseproduct[index1]
                  //                 //                       .productdata
                  //                 //                       .length,
                  //                 //                   shrinkWrap: true,
                  //                 //                   padding: EdgeInsets.zero,
                  //                 //                   physics:
                  //                 //                       NeverScrollableScrollPhysics(),
                  //                 //                   itemBuilder:
                  //                 //                       (context, index) {
                  //                 //                     return ProductWidget(
                  //                 //                       index1: index1,
                  //                 //                       index: index,
                  //                 //                       productTitle:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productTitle,
                  //                 //                       productImg:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productImg,
                  //                 //                       normalPrice:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productInfo[0]
                  //                 //                               .normalPrice,
                  //                 //                       attributeId:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productInfo[0]
                  //                 //                               .attributeId,
                  //                 //                       productDiscount:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productInfo[0]
                  //                 //                               .productDiscount,
                  //                 //                       productId:
                  //                 //                           storeDataContoller
                  //                 //                               .storeDataInfo
                  //                 //                               ?.catwiseproduct[
                  //                 //                                   index1]
                  //                 //                               .productdata[
                  //                 //                                   index]
                  //                 //                               .productId,
                  //                 //                       title: storeDataContoller
                  //                 //                           .storeDataInfo
                  //                 //                           ?.catwiseproduct[
                  //                 //                               index1]
                  //                 //                           .productdata[index]
                  //                 //                           .productInfo[0]
                  //                 //                           .title,
                  //                 //                     );
                  //                 //                   },
                  //                 //                 )
                  //                 //               ],
                  //                 //             )
                  //                 //           : SizedBox();
                  //                 //     },
                  //                 //   ),
                  //                 // ),

                  //                 SizedBox(
                  //                   height: 10,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: gradient.defoultColor,
                  ),
                );
        }),
      );
    });
  }

  Future<void> onAddItem(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    isRequride1,
    storeId1,
    sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = id1;
    String? price = price1.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();

    String finalPrice =
        "${(double.parse(price1.toString()) * double.parse(per1)) / 100}";

    print("@@@@@@@@@<FinalPrice>@@@@@@@@@" + finalPrice);

    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId;

    print("<<<<<<<<ID>>>>>>>>" + id1.toString());
    print("<<<<<<<<Price1>>>>>>>>" + price1.toString());
    print("<<<<<<<<Qty>>>>>>>>" + qty.toString());
    print("<<<<<<<<StrTitle1>>>>>>>>" + strTitle1.toString());
    print("<<<<<<<<Per1>>>>>>>>" + per1.toString());
    print("<<<<<<<<IsRequride1>>>>>>>>" + isRequride1.toString());
    print("<<<<<<<<StoreId1>>>>>>>>" + storeId1.toString());

    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
    } else {
      // if (int.parse(isItem(id)) < int.parse(qLimit1)) {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
      // } else {
      //   showToastMessage("Exceeded the maximum quantity limit per order!".tr);
      // }
    }
  }

  void onRemoveItem(int index, String qtys, {String? id1, price1}) {
    String? id = id1;
    String? price = price1;
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);
      catDetailsController.getCartLangth();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  String isItem(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  Widget catDRow({String? img, text}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, right: 5),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Image.asset(
            img ?? "",
            height: 13,
            width: 13,
            color: greytext,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: greytext,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onAddItem1(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    String? isRequride1,
    storeId1,
    String? sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = productDetailsController
        .productInfo?.productData.productInfo[index].attributeId;

    String finalPrice = "${(double.parse(price1) * double.parse(per1)) / 100}";

    String? price = price1.toString();

    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();
    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1 ?? "0"); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId; // Product ID

    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();

      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  void onRemoveItem1(
    int index,
    String qtys, {
    String? pr1,
  }) {
    String? id = productDetailsController
        .productInfo?.productData.productInfo[index].attributeId
        .toString();
    String? price = productDetailsController
        .productInfo?.productData.productInfo[index].normalPrice
        .toString();
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);

      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);

      setState(() {});
    }
  }

  String isItem1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  List itemList = [];

  getSubScriptionProductTypeList() {
    print('.......+++++++++.........' +
        productDetailsController.productInfo!.productData.productInfo.length
            .toString());
    itemList = [];
    for (var element
        in productDetailsController.productInfo!.productData.productInfo) {
      // if (element.subscriptionRequired != "0" &&
      //     element.productOutStock == "0") {
      //   itemList.add(element.title);
      // }
    }
  }

  detailsSheet(String desc) {
    int selectIndex = 0;
    return showModalBottomSheet(
        backgroundColor: WhiteColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: Get.height * 0.8,
              // padding: const EdgeInsets.symmetric(vertical: 12),
              child: Scaffold(
                backgroundColor: WhiteColor,
                floatingActionButton: Container(
                  transform: Matrix4.translationValues(
                      0.0, -80, 0.0), // translate up by 30
                  child: FloatingActionButton(
                    backgroundColor: WhiteColor.withOpacity(0.5),
                    onPressed: () {
                      Get.back();
                    },
                    child: Icon(Icons.close),
                  ),
                ),
                bottomNavigationBar:
                    GetBuilder<ProductDetailsController>(builder: (context) {
                  if (productDetailsController.isLoading == true) {
                    getSubScriptionProductTypeList();
                  }
                  return productDetailsController.isLoading
                      ? Container(
                          height: 50,
                          width: Get.size.width,
                          color: WhiteColor,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${catDetailsController.count.length.toString()} Piece",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  catDetailsController.changeIndex(2);
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "View Cart".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 14,
                                      color: WhiteColor,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: gradient.btnGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox();
                }),
                body: GetBuilder<ProductDetailsController>(builder: (context) {
                  return productDetailsController.isLoading
                      ? SizedBox(
                          height: Get.size.height,
                          width: Get.size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      color: WhiteColor,
                                      height: Get.size.height * 0.3,
                                      child: PageView.builder(
                                        itemCount: productDetailsController
                                            .productInfo
                                            ?.productData
                                            .img
                                            .length,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/ezgif.com-crop.gif",
                                                    placeholderFit: BoxFit.fill,
                                                    image:
                                                        "${Config.imageUrl}${productDetailsController.productInfo?.productData.img[index] ?? ""}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        onPageChanged: (value) {
                                          setState(() {
                                            selectIndex = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -8,
                                      child: Container(
                                        height: 25,
                                        width: Get.size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ...List.generate(
                                                productDetailsController
                                                    .productInfo!
                                                    .productData
                                                    .img
                                                    .length, (index) {
                                              return Indicator(
                                                isActive: selectIndex == index
                                                    ? true
                                                    : false,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    productDetailsController
                                            .productInfo?.productData.title ??
                                        "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      itemList.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                // for (var i = 0;
                                                //     i <
                                                //         productDetailsController
                                                //             .productInfo!
                                                //             .productData
                                                //             .productInfo
                                                //             .length;
                                                //     i++) {
                                                //   if (productDetailsController
                                                //               .productInfo!
                                                //               .productData
                                                //               .productInfo[i]
                                                //               .subscriptionRequired ==
                                                //           "1" &&
                                                //       productDetailsController
                                                //               .productInfo!
                                                //               .productData
                                                //               .productInfo[i]
                                                //               .productOutStock ==
                                                //           "0") {
                                                //     productDetailsController
                                                //         .getProductDetailsApi(
                                                //       pId:
                                                //           productDetailsController
                                                //                   .productInfo
                                                //                   ?.productData
                                                //                   .id ??
                                                //               "",
                                                //     );
                                                //     Get.toNamed(
                                                //         Routes.subScribeScreen,
                                                //         arguments: {
                                                //           "img":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .img[0],
                                                //           "name":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .title,
                                                //           "sprice":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .productInfo[
                                                //                       i]
                                                //                   .subscribePrice,
                                                //           "aprice":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .productInfo[
                                                //                       i]
                                                //                   .normalPrice,
                                                //           "per": productDetailsController
                                                //               .productInfo!
                                                //               .productData
                                                //               .productInfo[i]
                                                //               .productDiscount,
                                                //           "attributeId":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .productInfo[
                                                //                       i]
                                                //                   .attributeId,
                                                //           "productTitle":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .productInfo[
                                                //                       i]
                                                //                   .title,
                                                //           "isEmpty": "0",
                                                //           "productId":
                                                //               productDetailsController
                                                //                   .productInfo!
                                                //                   .productData
                                                //                   .id,
                                                //         });
                                                //     break;
                                                //   }
                                                // }
                                              },
                                              child: Container(
                                                height: 25,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "SUBSCRIBE".tr,
                                                  style: TextStyle(
                                                    color:
                                                        gradient.defoultColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Select unit".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: productDetailsController
                                        .productInfo
                                        ?.productData
                                        .productInfo
                                        .length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      String currentPrice =
                                          "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}";
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            fontSize: 15,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "${currency}${double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice.toString() ?? "") - double.parse(currentPrice)}",
                                                            style: TextStyle(
                                                              color: BlackColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          productDetailsController
                                                                      .productInfo
                                                                      ?.productData
                                                                      .productInfo[
                                                                          index]
                                                                      .productDiscount !=
                                                                  "0"
                                                              ? Text(
                                                                  "${currency}${productDetailsController.productInfo?.productData.productInfo[index].normalPrice}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          greytext,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      fontSize:
                                                                          13,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.all(8),
                                          ),
                                          Positioned(
                                            bottom: 18,
                                            left: 20,
                                            right: 20,
                                            child: productDetailsController
                                                        .productInfo
                                                        ?.productData
                                                        .productInfo[index]
                                                        .productOutStock ==
                                                    "0"
                                                ? isItem1(productDetailsController
                                                            .productInfo
                                                            ?.productData
                                                            .productInfo[index]
                                                            .attributeId
                                                            .toString()) !=
                                                        "0"
                                                    ? isSubscibe(productDetailsController
                                                                .productInfo
                                                                ?.productData
                                                                .productInfo[
                                                                    index]
                                                                .attributeId
                                                                .toString()) !=
                                                            "1"
                                                        ? Container(
                                                            height: 28,
                                                            width: 70,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onRemoveItem1(
                                                                        index,
                                                                        isItem1(productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId
                                                                            .toString()),
                                                                        pr1:
                                                                            "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}",
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      isItem1(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId)
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: gradient
                                                                            .defoultColor,
                                                                        fontFamily:
                                                                            FontFamily.gilroyBold,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onAddItem1(
                                                                        index,
                                                                        isItem(productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId),
                                                                        id1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId,
                                                                        price1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .normalPrice,
                                                                        strTitle1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .title,
                                                                        per1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .productDiscount,
                                                                        storeId1: storeDataContoller
                                                                            .storeDataInfo
                                                                            ?.storeInfo
                                                                            .storeId,
                                                                        img1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .img[0],
                                                                        productTitle1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .title,
                                                                        productId: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .id,
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: WhiteColor,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (cart.values
                                                                    .isNotEmpty) {
                                                                  for (var element
                                                                      in cart
                                                                          .values) {
                                                                    if (element
                                                                            .storeID ==
                                                                        storeDataContoller
                                                                            .storeDataInfo
                                                                            ?.storeInfo
                                                                            .storeId) {
                                                                      if (element
                                                                              .cartCheck ==
                                                                          "1") {
                                                                        Get.bottomSheet(
                                                                          Container(
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                Get.size.width,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                  child: Text(
                                                                                    "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                    style: TextStyle(
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      fontSize: 16,
                                                                                      height: 1.2,
                                                                                      letterSpacing: 1,
                                                                                      color: BlackColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                  child: Divider(
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "No".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: gradient.defoultColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: gradient.defoultColor.withOpacity(0.1),
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          for (var element in cart.values) {
                                                                                            if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                              if (element.cartCheck == "1") {
                                                                                                cart.delete(element.id);
                                                                                                catDetailsController.getCartLangth();
                                                                                                setState(() {});
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                          //!
                                                                                          onAddItem1(
                                                                                            index,
                                                                                            isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                            id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                            price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                            strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                            per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                            storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                            img1: productDetailsController.productInfo?.productData.img[0],
                                                                                            productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                            productId: productDetailsController.productInfo?.productData.id,
                                                                                          );

                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "Clear Cart".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: WhiteColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: gradient.btnGradient,
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: WhiteColor,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(30),
                                                                                topRight: Radius.circular(30),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                        break;
                                                                      } else {
                                                                        onAddItem1(
                                                                          index,
                                                                          isItem(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId),
                                                                          id1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId,
                                                                          price1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .normalPrice,
                                                                          strTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .title,
                                                                          per1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .productDiscount,
                                                                          storeId1: storeDataContoller
                                                                              .storeDataInfo
                                                                              ?.storeInfo
                                                                              .storeId,
                                                                          img1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .img[0],
                                                                          productTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .title,
                                                                          productId: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .id,
                                                                        );

                                                                        break;
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "ADD".tr,
                                                                style:
                                                                    TextStyle(
                                                                  color: gradient
                                                                      .defoultColor,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyBold,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    WhiteColor,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                            ),
                                                          )
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (cart.values
                                                                .isNotEmpty) {
                                                              for (var element
                                                                  in cart
                                                                      .values) {
                                                                if (element
                                                                        .storeID ==
                                                                    storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId) {
                                                                  if (element
                                                                          .cartCheck ==
                                                                      "1") {
                                                                    Get.bottomSheet(
                                                                      Container(
                                                                        height:
                                                                            200,
                                                                        width: Get
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                              child: Text(
                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                style: TextStyle(
                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                  fontSize: 16,
                                                                                  height: 1.2,
                                                                                  letterSpacing: 1,
                                                                                  color: BlackColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                              child: Divider(
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "No".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: gradient.defoultColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        color: gradient.defoultColor.withOpacity(0.1),
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      for (var element in cart.values) {
                                                                                        if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                          if (element.cartCheck == "1") {
                                                                                            cart.delete(element.id);
                                                                                            catDetailsController.getCartLangth();
                                                                                            setState(() {});
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                      //!
                                                                                      onAddItem1(
                                                                                        index,
                                                                                        isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                        id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                        price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                        strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                        per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                        img1: productDetailsController.productInfo?.productData.img[0],
                                                                                        productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                        productId: productDetailsController.productInfo?.productData.id,
                                                                                      );

                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "Clear Cart".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: WhiteColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: gradient.btnGradient,
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              WhiteColor,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(30),
                                                                            topRight:
                                                                                Radius.circular(30),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                    break;
                                                                  } else {
                                                                    onAddItem1(
                                                                      index,
                                                                      isItem(productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .attributeId),
                                                                      id1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .attributeId,
                                                                      price1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .normalPrice,
                                                                      strTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .title,
                                                                      per1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .productDiscount,
                                                                      storeId1: storeDataContoller
                                                                          .storeDataInfo
                                                                          ?.storeInfo
                                                                          .storeId,
                                                                      img1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .img[0],
                                                                      productTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .title,
                                                                      productId: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .id,
                                                                    );
                                                                    break;
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                  break;
                                                                }
                                                              }
                                                            } else {
                                                              onAddItem1(
                                                                index,
                                                                isItem(productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId),
                                                                id1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId,
                                                                price1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .normalPrice,
                                                                strTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .title,
                                                                per1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .productDiscount,
                                                                storeId1: storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.storeInfo
                                                                    .storeId,
                                                                img1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .img[0],
                                                                productTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .title,
                                                                productId: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .id,
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 70,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "ADD".tr,
                                                            style: TextStyle(
                                                              color: gradient
                                                                  .defoultColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: WhiteColor,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ),
                                                      )
                                                : Container(
                                                    height: 27,
                                                    width: 80,
                                                    margin: EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Out of stock".tr,
                                                      style: TextStyle(
                                                        color: RedColor,
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: WhiteColor,
                                                      border: Border.all(
                                                          color: RedColor),
                                                    ),
                                                  ),
                                          ),
                                          productDetailsController
                                                      .productInfo
                                                      ?.productData
                                                      .productInfo[index]
                                                      .productDiscount !=
                                                  "0"
                                              ? Positioned(
                                                  top: 5,
                                                  left: 20,
                                                  right: 20,
                                                  child: Container(
                                                    height: 15,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${productDetailsController.productInfo?.productData.productInfo[index].productDiscount}% OFF",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        color: WhiteColor,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          "assets/selectUnitLable.png",
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "Description".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ReadMoreText(
                                    productDetailsController.productInfo
                                            ?.productData.productDescription ??
                                        "",
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    lessStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 12,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: gradient.defoultColor,
                          ),
                        );
                }),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            );
          });
        });
  }

  Widget photoWidget() {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            color: BlackColor,
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? "",
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
              color: BlackColor,
            ),
          ),
        ),
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          color: WhiteColor,
          child: storeDataContoller.storeDataInfo!.photos.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: GridView.builder(
                    itemCount: storeDataContoller.storeDataInfo?.photos.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 120,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                            FullScreenImage(
                              imageUrl:
                                  "${Config.imageUrl}${storeDataContoller.storeDataInfo?.photos[index].img ?? ""}",
                              tag: "generate_a_unique_tag",
                            ),
                          );
                        },
                        child: Container(
                          height: 110,
                          width: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/ezgif.com-crop.gif",
                              placeholderCacheWidth: 110,
                              placeholderCacheHeight: 110,
                              image:
                                  "${Config.imageUrl}${storeDataContoller.storeDataInfo?.photos[index].img ?? ""}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Sorry, there are no photos \n available to display at this time"
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget reviewWidget() {
    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.window),
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            color: BlackColor,
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? "",
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
              color: BlackColor,
            ),
          ),
        ),
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          color: WhiteColor,
          child: storeDataContoller.storeDataInfo!.reviewdata.isNotEmpty
              ? ListView.builder(
                  itemCount:
                      storeDataContoller.storeDataInfo?.reviewdata.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            height: 60,
                            width: 60,
                            alignment: Alignment.center,
                            child: Text(
                              storeDataContoller.storeDataInfo
                                      ?.reviewdata[index].userTitle[0] ??
                                  "",
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 22,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                          ),
                          title: Text(
                            storeDataContoller.storeDataInfo?.reviewdata[index]
                                    .userTitle ??
                                "",
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Text(
                            storeDataContoller
                                    .storeDataInfo?.reviewdata[index].reviewDate
                                    .toString()
                                    .split(" ")
                                    .first ??
                                "",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              color: greycolor,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                          ),
                          trailing: Container(
                            height: 40,
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/reviewStar.png",
                                  height: 15,
                                  width: 15,
                                  color: gradient.defoultColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  storeDataContoller.storeDataInfo
                                          ?.reviewdata[index].userRate ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: FontFamily.gilroyBold,
                                    color: gradient.defoultColor,
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: gradient.defoultColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            storeDataContoller.storeDataInfo?.reviewdata[index]
                                    .userDesc ??
                                "",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              color: greycolor,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    "Sorry, there are no reviews \nto display at this time".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget faqWidget() {
    const contentStyle = TextStyle(
        color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.window),
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            color: BlackColor,
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? "",
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
              color: BlackColor,
            ),
          ),
        ),
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          color: WhiteColor,
          child: storeDataContoller.storeDataInfo!.faQdata.isNotEmpty
              ? Accordion(
                  disableScrolling: true,
                  flipRightIconIfOpen: true,
                  contentVerticalPadding: 0,
                  scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                  contentBorderColor: Colors.transparent,
                  maxOpenSections: 1,
                  headerBackgroundColorOpened: Colors.grey.shade100,
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  children: [
                    for (var j = 0;
                        j < storeDataContoller.storeDataInfo!.faQdata.length;
                        j++)
                      AccordionSection(
                        rightIcon: Image.asset(
                          "assets/Arrow - Down.png",
                          height: 20,
                          width: 20,
                          color: gradient.defoultColor,
                        ),
                        headerPadding: const EdgeInsets.all(15),
                        headerBackgroundColor: Colors.grey.shade100,
                        contentBackgroundColor: Colors.grey.shade100,
                        header: Text(
                            storeDataContoller
                                    .storeDataInfo?.faQdata[j].question ??
                                "",
                            style: TextStyle(
                                color: BlackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        content: Text(
                          storeDataContoller.storeDataInfo?.faQdata[j].answer ??
                              "",
                          style: contentStyle,
                        ),
                        contentHorizontalPadding: 20,
                        contentBorderWidth: 1,
                      ),
                  ],
                )
              : Center(
                  child: Text(
                    "Sorry, there are no photos \navailable to display at this time"
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                      color: BlackColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class ProductWidget extends StatefulWidget {
  int? index1;
  int? index;
  String? productImg;
  String? productTitle;
  String? normalPrice;
  String? sprice;
  String? attributeId;
  String? isRequride;
  String? productDiscount;
  String? title;
  String? productId;
  ProductWidget({
    super.key,
    this.index1,
    this.index,
    this.productImg,
    this.productTitle,
    this.normalPrice,
    this.sprice,
    this.attributeId,
    this.isRequride,
    this.productDiscount,
    this.title,
    this.productId,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();

  // int index1 = 0;
  // int index = 0;
  // String productImg = "";
  // String productTitle = "";
  String normalPrice = "";
  // String sprice = "";
  String attributeId = "";
  // String isRequride = "";
  String productDiscount = "";

  String title = "";
  // String productId = "";

  late Box<CartItem> cart;
  late final List<CartItem> items;

  List<String> prductAttribute = [];
  String? selectItem;

  @override
  void initState() {
    cart = Hive.box<CartItem>('cart');
    setupHive();
    setState(() {
      //   index1 = widget.index1 ?? 0;
      //   index = widget.index ?? 0;
      //   productImg = widget.productImg ?? "";
      //   productTitle = widget.productTitle ?? "";
      normalPrice = widget.normalPrice ?? "";
      attributeId = widget.attributeId ?? "";
      //   isRequride = widget.isRequride ?? "";
      productDiscount = widget.productDiscount ?? "";
      title = widget.title ?? "";
      //   sprice = widget.sprice ?? "";
      //   productId = widget.productId ?? "";
    });
    // print(productTitle);
    super.initState();
    prductAttribute = [];
    for (int i = 0;
        i <
            storeDataContoller.storeDataInfo!.catwiseproduct[widget.index1 ?? 0]
                .productdata[widget.index ?? 0].productInfo.length;
        i++) {
      prductAttribute.add(storeDataContoller
          .storeDataInfo!
          .catwiseproduct[widget.index1 ?? 0]
          .productdata[widget.index ?? 0]
          .productInfo[i]
          .title);
    }
    selectItem = prductAttribute.first;
    setState(() {});
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    List<CartItem> tempList = [];
    catDetailsController.getCartLangth();
  }

  @override
  void dispose() {
    super.dispose();
    attributeId = "0";
    productDiscount = "0";
    title = "0";
    normalPrice = "0";
    print("object");
  }

  String productInfo = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            child: FadeInImage.assetNetwork(
              fadeInCurve: Curves.easeInCirc,
              placeholder: "assets/ezgif.com-crop.gif",
              placeholderCacheHeight: 85,
              placeholderCacheWidth: 85,
              height: 85,
              width: 85,
              placeholderFit: BoxFit.fill,
              image: "${Config.imageUrl}${widget.productImg}",
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(
            width: 9,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "${currency}${"${(double.parse(normalPrice.toString()) - (double.parse(normalPrice.toString()) * double.parse(productDiscount)) / 100).toStringAsFixed(2)}"}",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        color: BlackColor,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    productDiscount == "0"
                        ? SizedBox()
                        : Text(
                            "${currency}${"${normalPrice}"}",
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyMedium,
                              color: greyColor,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.only(right: 3, left: 10),
                        child: prductAttribute.toSet().length > 1
                            ? PopupMenuButton(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        selectItem!,
                                        style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            color: BlackColor,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        enabled: false,
                                        child: Container(
                                          // height: 100,
                                          width: 111,
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                height: 0,
                                              );
                                            },
                                            shrinkWrap: true,
                                            itemCount: prductAttribute.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  for (var i = 0;
                                                      i <
                                                          storeDataContoller
                                                              .storeDataInfo!
                                                              .catwiseproduct[
                                                                  widget
                                                                      .index1!]
                                                              .productdata[
                                                                  widget.index!]
                                                              .productInfo
                                                              .length;
                                                      i++) {
                                                    if (prductAttribute[
                                                            index] ==
                                                        storeDataContoller
                                                            .storeDataInfo!
                                                            .catwiseproduct[
                                                                widget.index1!]
                                                            .productdata[
                                                                widget.index!]
                                                            .productInfo[i]
                                                            .title) {
                                                      setState(() {
                                                        normalPrice =
                                                            storeDataContoller
                                                                .storeDataInfo!
                                                                .catwiseproduct[
                                                                    widget.index1 ??
                                                                        0]
                                                                .productdata[
                                                                    widget.index ??
                                                                        0]
                                                                .productInfo[i]
                                                                .normalPrice;

                                                        attributeId =
                                                            storeDataContoller
                                                                .storeDataInfo!
                                                                .catwiseproduct[
                                                                    widget.index1 ??
                                                                        0]
                                                                .productdata[
                                                                    widget.index ??
                                                                        0]
                                                                .productInfo[i]
                                                                .attributeId;
                                                        productDiscount =
                                                            storeDataContoller.storeDataInfo!.catwiseproduct[widget.index1 ??
                                                                        0].productdata[widget.index ??
                                                                        0]
                                                                .productInfo[i]
                                                                .productDiscount;
                                                        title = storeDataContoller
                                                            .storeDataInfo!
                                                            .catwiseproduct[
                                                                widget.index1 ??
                                                                    0]
                                                            .productdata[
                                                                widget.index ??
                                                                    0]
                                                            .productInfo[i]
                                                            .title;
                                                      });
                                                    }
                                                  }
                                                  setState(() {
                                                    selectItem =
                                                        prductAttribute[index];

                                                    Get.back();
                                                  });
                                                },
                                                child: Container(
                                                  height: 25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        prductAttribute[index],
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          color: BlackColor,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ))
                                  ];
                                },
                              )

                            // DropdownButton(
                            //     onTap: () {
                            //       print(prductAttribute);
                            //     },
                            //     value: selectItem,
                            //     icon: Icon(Icons.arrow_drop_down),
                            //     iconSize: 25,
                            //     isExpanded: true,
                            //     underline: SizedBox(),
                            //     padding: EdgeInsets.zero,
                            //     items:
                            //         prductAttribute.toSet().map((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(
                            //           value,
                            //           style: TextStyle(
                            //             fontFamily: FontFamily.gilroyMedium,
                            //             color: BlackColor,
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     onChanged: (value) {
                            //       for (var i = 0;
                            //           i <
                            //               storeDataContoller
                            //                   .storeDataInfo!
                            //                   .catwiseproduct[
                            //                       widget.index1 ?? 0]
                            //                   .productdata[widget.index ?? 0]
                            //                   .productInfo
                            //                   .length;
                            //           i++) {
                            //         if (value ==
                            //             storeDataContoller
                            //                 .storeDataInfo!
                            //                 .catwiseproduct[widget.index1 ?? 0]
                            //                 .productdata[widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .title) {
                            //           setState(() {
                            //             widget.normalPrice = storeDataContoller
                            //                 .storeDataInfo!
                            //                 .catwiseproduct[widget.index1 ?? 0]
                            //                 .productdata[widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .normalPrice;

                            //             widget.attributeId = storeDataContoller
                            //                 .storeDataInfo!
                            //                 .catwiseproduct[widget.index1 ?? 0]
                            //                 .productdata[widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .attributeId;
                            //             widget.productDiscount =
                            //                 storeDataContoller
                            //                     .storeDataInfo!
                            //                     .catwiseproduct[
                            //                         widget.index1 ?? 0]
                            //                     .productdata[widget.index ?? 0]
                            //                     .productInfo[i]
                            //                     .productDiscount;
                            //             widget.title = storeDataContoller
                            //                 .storeDataInfo!
                            //                 .catwiseproduct[widget.index1 ?? 0]
                            //                 .productdata[widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .title;
                            //           });
                            //         }
                            //       }
                            //       setState(() {
                            //         selectItem = value;
                            //       });
                            //     },
                            //   )

                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      prductAttribute[0],
                                      style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          color: BlackColor,
                                          fontSize: 10,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    isItem(attributeId) != "0"
                        ? Container(
                            height: 35,
                            width: 100,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      onRemoveItem(
                                        widget.index!,
                                        isItem(attributeId.toString()),
                                        id1: attributeId,
                                        price1: normalPrice,
                                      );
                                      catDetailsController.getCartLangth();
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove,
                                      color: WhiteColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      isItem(attributeId).toString(),
                                      style: TextStyle(
                                          color: WhiteColor,
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      onAddItem(
                                        widget.index!,
                                        isItem(attributeId),
                                        id1: attributeId,
                                        price1: normalPrice,
                                        strTitle1: widget.productTitle,
                                        isRequride1: widget.isRequride,
                                        per1: productDiscount,
                                        storeId1: storeDataContoller
                                            .storeDataInfo?.storeInfo.storeId,
                                        sPrice1: widget.sprice,
                                        img1: widget.productImg,
                                        productTitle1: title,
                                        productId: widget.productId,
                                        storeLogo: storeDataContoller.storeDataInfo!.storeInfo.storeLogo,
                                        storeSlogan: storeDataContoller.storeDataInfo!.storeInfo.storeSlogan,
                                        productImage: widget.productImg!,
                                        productTitlee1: storeDataContoller.storeDataInfo!.storeInfo.storeTitle,
                                      );
                                      catDetailsController.getCartLangth();
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      color: WhiteColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: gradient.defoultColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                onAddItem(
                                  widget.index!,
                                  isItem(attributeId),
                                  id1: attributeId,
                                  price1: normalPrice,
                                  strTitle1: widget.productTitle,
                                  isRequride1: widget.isRequride,
                                  per1: productDiscount,
                                  storeId1: storeDataContoller
                                      .storeDataInfo?.storeInfo.storeId,
                                  sPrice1: widget.sprice,
                                  img1: widget.productImg,
                                  productTitle1: title,
                                  productId: widget.productId,
                                  storeLogo: storeDataContoller.storeDataInfo!.storeInfo.storeLogo,
                                  storeSlogan: storeDataContoller.storeDataInfo!.storeInfo.storeSlogan,
                                  productImage: widget.productImg!,
                                  productTitlee1: storeDataContoller.storeDataInfo!.storeInfo.storeTitle,
                                );
                                catDetailsController.getCartLangth();
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: WhiteColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 14,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: gradient.defoultColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }

  Future<void> onAddItem(int index, String qtys,
      {String? id1,
      price1,
      strTitle1,
      per1,
      isRequride1,
      storeId1,
      sPrice1,
      img1,
      productTitle1,
      productId,
      productInfoTitle,required String storeLogo, required String storeSlogan,required String productImage,required String productTitlee1}) async {
    String? id = id1;
    String? price = price1.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();

    String finalPrice =
        "${(double.parse(price1.toString()) * double.parse(per1)) / 100}";

    // print("@@@@@@@@@<FinalPrice>@@@@@@@@@" + finalPrice);
    // print("@@@@@@@@@<productTitle1>@@@@@@@@@" + productTitle1);

    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = "0"; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse("0"); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId;
    newItem.storeLogo = storeLogo;
    newItem.productImg = productImage;
    newItem.productTitle1 = productTitlee1;
    newItem.storeSlogan = storeSlogan;

    // print("<<<<<<<<ID>>>>>>>>" + id1.toString());
    // print("<<<<<<<<Price1>>>>>>>>" + price1.toString());
    // print("<<<<<<<<Qty>>>>>>>>" + qty.toString());
    // print("<<<<<<<<StrTitle1>>>>>>>>" + strTitle1.toString());
    // print("<<<<<<<<Per1>>>>>>>>" + per1.toString());
    // print("<<<<<<<<IsRequride1>>>>>>>>" + isRequride1.toString());
    // print("<<<<<<<<StoreId1>>>>>>>>" + storeId1.toString());

    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  void onRemoveItem(int index, String qtys, {String? id1, price1}) {
    String? id = id1;
    String? price = price1;
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);
      catDetailsController.getCartLangth();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  String isItem(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }
}
