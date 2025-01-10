// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/controller/productdetails_controller.dart';
import 'package:laundry/controller/search_controller.dart';
import 'package:laundry/controller/stordata_controller.dart';

import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/yourcart_screen.dart';
import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/cart_item.dart';
import 'package:readmore/readmore.dart';

import '../Api/data_store.dart';
import 'categorydetails_screen.dart';

class HomeSearchScreen extends StatefulWidget {
  final bool statusWiseSearch;
  final bool backbutton;
  const HomeSearchScreen(
      {super.key, required this.statusWiseSearch, required this.backbutton});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  TextEditingController search = TextEditingController();
  CatDetailsController catDetailsController = Get.find();
  SearchController1 searchController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  ProductDetailsController productDetailsController = Get.find();
  HomePageController homePageController = Get.find();

  bool statusWiseSearch = true;

  late Box<CartItem> cart;
  late final List<CartItem> items;

  @override
  void initState() {
    setState(() {
      statusWiseSearch = widget.statusWiseSearch;
    });
    cart = Hive.box<CartItem>('cart');
    super.initState();
    search.text = "";
    if (statusWiseSearch == true) {
      searchController.getSearchStoreData(keyWord: "");
    } else if (statusWiseSearch == false) {
      searchController.getSearchProductData(
        keyWord: "",
        storeID: storeDataContoller.storeDataInfo?.storeInfo.storeId,
      );
    }
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    catDetailsController.getCartLangth();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CatDetailsController>(builder: (catDetailsController) {
      return Scaffold(
        bottomNavigationBar: statusWiseSearch
            ? null
            : catDetailsController.count.isEmpty
                ? SizedBox()
                : Row(children: [
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
                                      catDetailsController.totalItem
                                              .toString() +
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
                                  style: TextStyle(
                                      fontSize: 12, color: WhiteColor),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  catDetailsController.isLoading1 = true;
                                });
                                Future.delayed(
                                  Duration(seconds: 2),
                                  () {
                                    Get.to(YourCartScreen(CartStatus: "1"));
                                  },
                                );
                              },
                              child: Text(
                                "View Cart".tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: WhiteColor,
                                    fontFamily: 'Gilroy Bold'),
                              ),
                            ),
                          ]),
                    ))
                  ]),
        backgroundColor: bgcolor,
        body: GetBuilder<SearchController1>(builder: (context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        width: Get.size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 8),
                          child: TextField(
                            controller: search,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              // searchController.getSearchData(
                              //     countryId: getData.read("countryId"));
                            },
                            onChanged: (value) {
                              statusWiseSearch
                                  ? value != ""
                                      ? searchController.getSearchStoreData(
                                          keyWord: value)
                                      : searchController.getSearchStoreData(
                                          keyWord: "a")
                                  : value != ""
                                      ? searchController.getSearchProductData(
                                          keyWord: value,
                                          storeID: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                        )
                                      : searchController.getSearchProductData(
                                          keyWord: "",
                                          storeID: storeDataContoller
                                              .storeDataInfo?.storeInfo.storeId,
                                        );
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 12, 10, 6),
                              border: InputBorder.none,
                              hintText: statusWiseSearch
                                  ? "Search for stores".tr
                                  : "Search for products".tr,
                              hintStyle: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                color: greytext,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: InkWell(
                                    onTap: () {
                                      if (widget.backbutton) {
                                        Get.back();
                                      }
                                    },
                                    child: widget.backbutton
                                        ? Icon(
                                            Icons.arrow_back,
                                            color: BlackColor,
                                          )
                                        : Image.asset(
                                            "assets/Search.png",
                                            height: 12,
                                            width: 12,
                                          )),
                              ),
                              // suffix: InkWell(
                              //   onTap: () {
                              //     search.text = "";
                              //   },
                              //   child: Container(
                              //     height: 45,
                              //     width: 30,
                              //     padding: EdgeInsets.only(top: 0),
                              //     alignment: Alignment.center,
                              //     child: Icon(
                              //       Icons.close,
                              //       color: BlackColor,
                              //       size: 18,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                search.text != ""
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: search.text != ""
                      ? statusWiseSearch
                          ? Text(
                              "${searchController.searchInfo.length} ${"Stores".tr}",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                              ),
                            )
                          : Text(
                              "${searchController.searchProductInfo.length} ${"Products".tr}",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                              ),
                            )
                      : SizedBox(),
                ),
                search.text != ""
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(),
                statusWiseSearch
                    ? searchController.isLoading
                        ? searchController.searchInfo.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchController.searchInfo.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        catDetailsController.strId = searchController.searchInfo[index].storeId ?? "";
                                        await storeDataContoller.getStoreData(
                                          storeId: searchController.searchInfo[index].storeId,
                                        );
                                        save("changeIndex", true);
                                        homePageController.isback = "1";
                                        Get.to(CategoryDetailsScreen());
                                      },
                                      child: Container(
                                        height: 170,
                                        width: Get.size.width,
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 170,
                                                  width: 120,
                                                  margin: EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      fadeInCurve:
                                                          Curves.easeInCirc,
                                                      placeholder:
                                                          "assets/ezgif.com-crop.gif",
                                                      placeholderCacheHeight:
                                                          170,
                                                      placeholderCacheWidth:
                                                          120,
                                                      placeholderFit:
                                                          BoxFit.fill,
                                                      // placeholderScale: 1.0,
                                                      image:
                                                          "${Config.imageUrl}${searchController.searchInfo[index].storeCover}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 10,
                                                  right: 10,
                                                  child: Container(
                                                    height: 70,
                                                    width: 120,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 7),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            searchController
                                                                .searchInfo[
                                                                    index]
                                                                .couponTitle,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: WhiteColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            searchController
                                                                .searchInfo[
                                                                    index]
                                                                .couponSubtitle,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: WhiteColor,
                                                              fontFamily: FontFamily
                                                                  .gilroyMedium,
                                                              fontSize: 13,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/Rectangle.png"),
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    searchController
                                                        .searchInfo[index]
                                                        .storeTitle,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 18,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Text(
                                                      searchController
                                                          .searchInfo[index]
                                                          .storeSdesc,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/heart.png",
                                                        height: 18,
                                                        width: 18,
                                                        color: gradient
                                                            .defoultColor,
                                                      ),
                                                      Text(
                                                        "${searchController.searchInfo[index].totalFav} ${"Love this".tr}",
                                                        style: TextStyle(
                                                          color: BlackColor,
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Image.asset(
                                                        "assets/ic_star_review.png",
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        searchController
                                                            .searchInfo[index]
                                                            .storeRate,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          color: BlackColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 100,
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          searchController
                                                              .searchInfo[index]
                                                              .storeTags[0],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: gradient
                                                                .defoultColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: gradient
                                                              .defoultColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "${searchController.searchInfo[index].storeTags.length}+",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: gradient
                                                                .defoultColor,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: gradient
                                                              .defoultColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: WhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Container(
                                    height: 200,
                                    width: Get.size.width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No store available \nin your area.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 15,
                                        color: BlackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                        : Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: gradient.defoultColor,
                              ),
                            ),
                          )
                    : searchController.isLoading
                        ? searchController.searchProductInfo.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      searchController.searchProductInfo.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return SearchProductWidget(
                                      index: index,
                                      productId: searchController
                                          .searchProductInfo[index].productId,
                                      productImg: searchController
                                          .searchProductInfo[index].productImg,
                                      productTitle: searchController
                                          .searchProductInfo[index]
                                          .productTitle,
                                      normalPrice: searchController
                                          .searchProductInfo[index]
                                          .productInfo[0]
                                          .normalPrice,
                                      attributeId: searchController
                                          .searchProductInfo[index]
                                          .productInfo[0]
                                          .attributeId,
                                      title: searchController
                                          .searchProductInfo[index]
                                          .productInfo[0]
                                          .title,
                                      productDiscount: searchController
                                          .searchProductInfo[index]
                                          .productInfo[0]
                                          .productDiscount,
                                    );

                                    // return Builder(builder: (context) {
                                    //   print(searchController
                                    //       .searchProductInfo[index].productTitle);
                                    //   return ProductWidget(
                                    //     index: index,
                                    //     productTitle: searchController
                                    //         .searchProductInfo[index]
                                    //         .productTitle,
                                    //     productImg: searchController
                                    //         .searchProductInfo[index].productImg,
                                    //     normalPrice: searchController
                                    //         .searchProductInfo[index]
                                    //         .productInfo[0]
                                    //         .normalPrice,
                                    //     attributeId: searchController
                                    //         .searchProductInfo[index]
                                    //         .productInfo[0]
                                    //         .attributeId,
                                    //     productDiscount: searchController
                                    //         .searchProductInfo[index]
                                    //         .productInfo[0]
                                    //         .productDiscount,
                                    //     productId: searchController
                                    //         .searchProductInfo[index].productId,
                                    //     title: searchController
                                    //         .searchProductInfo[index]
                                    //         .productInfo[0]
                                    //         .title,
                                    //   );
                                    // });
                                  },
                                ),
                              )

                            // Expanded(
                            //     child: GridView.builder(
                            //       shrinkWrap: true,
                            //       itemCount:
                            //           searchController.searchProductInfo.length,
                            //       padding: EdgeInsets.all(8),
                            //       gridDelegate:
                            //           SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 2,
                            //         mainAxisSpacing: 8,
                            //         crossAxisSpacing: 8,
                            //         mainAxisExtent: 250,
                            //       ),
                            //       itemBuilder: (context, index) {
                            //         double price = (double.parse(searchController
                            //                     .searchProductInfo[index]
                            //                     .productInfo[0]
                            //                     .normalPrice) *
                            //                 double.parse(searchController
                            //                     .searchProductInfo[index]
                            //                     .productInfo[0]
                            //                     .productDiscount)) /
                            //             100;
                            //         return Stack(
                            //           clipBehavior: Clip.none,
                            //           children: [
                            //             Container(
                            //               margin: EdgeInsets.all(1),
                            //               alignment: Alignment.center,
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 5,
                            //                   ),
                            //                   InkWell(
                            //                     onTap: () {
                            //                       productDetailsController
                            //                           .getProductDetailsApi(
                            //                         pId: searchController
                            //                             .searchProductInfo[index]
                            //                             .productId,
                            //                       );
                            //                       detailsSheet(storeDataContoller
                            //                               .storeDataInfo
                            //                               ?.storeInfo
                            //                               .storeShortDesc ??
                            //                           "");
                            //                     },
                            //                     child: Column(
                            //                       crossAxisAlignment:
                            //                           CrossAxisAlignment.start,
                            //                       children: [
                            //                         InkWell(
                            //                           onTap: () {
                            //                             productDetailsController
                            //                                 .getProductDetailsApi(
                            //                               pId: searchController
                            //                                   .searchProductInfo[
                            //                                       index]
                            //                                   .productId,
                            //                             );
                            //                             detailsSheet(
                            //                                 storeDataContoller
                            //                                         .storeDataInfo
                            //                                         ?.storeInfo
                            //                                         .storeShortDesc ??
                            //                                     "");
                            //                           },
                            //                           child: Center(
                            //                             child: Container(
                            //                               height: 125,
                            //                               width: Get.size.width *
                            //                                   0.35,
                            //                               child: ClipRRect(
                            //                                 borderRadius:
                            //                                     BorderRadius
                            //                                         .circular(12),
                            //                                 child: FadeInImage
                            //                                     .assetNetwork(
                            //                                   fadeInCurve: Curves
                            //                                       .easeInCirc,
                            //                                   placeholder:
                            //                                       "assets/ezgif.com-crop.gif",
                            //                                   placeholderCacheHeight:
                            //                                       125,
                            //                                   placeholderCacheWidth:
                            //                                       125,
                            //                                   height: 125,
                            //                                   width: 125,
                            //                                   placeholderFit:
                            //                                       BoxFit.fill,
                            //                                   image:
                            //                                       "${Config.imageUrl}${searchController.searchProductInfo[index].productImg}",
                            //                                   fit: BoxFit.cover,
                            //                                 ),
                            //                               ),
                            //                               decoration:
                            //                                   BoxDecoration(
                            //                                 borderRadius:
                            //                                     BorderRadius
                            //                                         .circular(12),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         SizedBox(
                            //                           height: 5,
                            //                         ),
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsets.symmetric(
                            //                                   horizontal: 8),
                            //                           child: Text(
                            //                             searchController
                            //                                 .searchProductInfo[
                            //                                     index]
                            //                                 .productTitle,
                            //                             maxLines: 2,
                            //                             style: TextStyle(
                            //                               fontFamily: FontFamily
                            //                                   .gilroyBold,
                            //                               fontSize: 12,
                            //                               overflow: TextOverflow
                            //                                   .ellipsis,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         SizedBox(
                            //                           height: 5,
                            //                         ),
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsets.symmetric(
                            //                                   horizontal: 8),
                            //                           child: InkWell(
                            //                             onTap: () {
                            //                               productDetailsController
                            //                                   .getProductDetailsApi(
                            //                                 pId: searchController
                            //                                     .searchProductInfo[
                            //                                         index]
                            //                                     .productId,
                            //                               );
                            //                               detailsSheet(
                            //                                   storeDataContoller
                            //                                           .storeDataInfo
                            //                                           ?.storeInfo
                            //                                           .storeShortDesc ??
                            //                                       "");
                            //                             },
                            //                             child: Row(
                            //                               children: [
                            //                                 Flexible(
                            //                                   child: Text(
                            //                                     searchController
                            //                                         .searchProductInfo[
                            //                                             index]
                            //                                         .productInfo[
                            //                                             0]
                            //                                         .title,
                            //                                     maxLines: 1,
                            //                                     overflow:
                            //                                         TextOverflow
                            //                                             .ellipsis,
                            //                                     style: TextStyle(
                            //                                       fontFamily:
                            //                                           FontFamily
                            //                                               .gilroyMedium,
                            //                                       fontSize: 12,
                            //                                       overflow:
                            //                                           TextOverflow
                            //                                               .ellipsis,
                            //                                       color: gradient
                            //                                           .defoultColor,
                            //                                     ),
                            //                                   ),
                            //                                 ),
                            //                                 SizedBox(
                            //                                   width: 4,
                            //                                 ),
                            //                                 1 <
                            //                                         searchController
                            //                                             .searchProductInfo[
                            //                                                 index]
                            //                                             .productInfo
                            //                                             .length
                            //                                     ? Image.asset(
                            //                                         "assets/angle-down.png",
                            //                                         height: 10,
                            //                                         width: 10,
                            //                                         color: gradient
                            //                                             .defoultColor,
                            //                                       )
                            //                                     : SizedBox()
                            //                               ],
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     height: 70,
                            //                     alignment: Alignment.bottomCenter,
                            //                     child: Column(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment.end,
                            //                       children: [
                            //                         searchController
                            //                                     .searchProductInfo[
                            //                                         index]
                            //                                     .productInfo[0]
                            //                                     .productOutStock ==
                            //                                 "0"
                            //                             ? Row(
                            //                                 mainAxisAlignment:
                            //                                     MainAxisAlignment
                            //                                         .end,
                            //                                 children: [
                            //                                   // searchController
                            //                                   //             .searchProductInfo[
                            //                                   //                 index]
                            //                                   //             .productInfo[
                            //                                   //                 0]
                            //                                   //             .subscriptionRequired !=
                            //                                   //         "0"
                            //                                   //     ? isSubscibe(searchController
                            //                                   //                 .searchProductInfo[index]
                            //                                   //                 .productInfo[0]
                            //                                   //                 .attributeId
                            //                                   //                 .toString()) !=
                            //                                   //             "0"
                            //                                   //         ? InkWell(
                            //                                   //             onTap:
                            //                                   //                 () {
                            //                                   //               print(
                            //                                   //                   "!!!!!!!!!!!!!!!!!!!!");
                            //                                   //               productDetailsController
                            //                                   //                   .getProductDetailsApi(
                            //                                   //                 pId:
                            //                                   //                     searchController.searchProductInfo[index].productId,
                            //                                   //               );
                            //                                   //               Get.toNamed(
                            //                                   //                   Routes.subScribeScreen,
                            //                                   //                   arguments: {
                            //                                   //                     "img": searchController.searchProductInfo[index].productImg,
                            //                                   //                     "name": searchController.searchProductInfo[index].productTitle,
                            //                                   //                     "sprice": searchController.searchProductInfo[index].productInfo[0].subscribePrice,
                            //                                   //                     "aprice": searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                   //                     "per": searchController.searchProductInfo[index].productInfo[0].productDiscount,
                            //                                   //                     "attributeId": searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                   //                     "productTitle": searchController.searchProductInfo[index].productInfo[0].title,
                            //                                   //                     "isEmpty": "0",
                            //                                   //                     "productId": searchController.searchProductInfo[index].productId,
                            //                                   //                   });
                            //                                   //               // }
                            //                                   //             },
                            //                                   //             child:
                            //                                   //                 Container(
                            //                                   //               height:
                            //                                   //                   25,
                            //                                   //               padding:
                            //                                   //                   EdgeInsets.symmetric(horizontal: 8),
                            //                                   //               alignment:
                            //                                   //                   Alignment.center,
                            //                                   //               child:
                            //                                   //                   Text(
                            //                                   //                 "SUBSCRIBED".tr,
                            //                                   //                 style:
                            //                                   //                     TextStyle(
                            //                                   //                   color: gradient.defoultColor,
                            //                                   //                   fontFamily: FontFamily.gilroyBold,
                            //                                   //                   fontSize: 11,
                            //                                   //                 ),
                            //                                   //               ),
                            //                                   //               decoration:
                            //                                   //                   BoxDecoration(
                            //                                   //                 borderRadius:
                            //                                   //                     BorderRadius.circular(5),
                            //                                   //                 border:
                            //                                   //                     Border.all(color: Colors.grey.shade300),
                            //                                   //               ),
                            //                                   //             ),
                            //                                   //           )
                            //                                   //         :
                            //                                   // InkWell(
                            //                                   //   onTap: () {
                            //                                   //     print(
                            //                                   //         "!!!!!!!!!!!!!!!!!!!!");
                            //                                   //     productDetailsController
                            //                                   //         .getProductDetailsApi(
                            //                                   //       pId: searchController
                            //                                   //           .searchProductInfo[
                            //                                   //               index]
                            //                                   //           .productId,
                            //                                   //     );
                            //                                   //     // Get.toNamed(
                            //                                   //     //     Routes.subScribeScreen,
                            //                                   //     //     arguments: {
                            //                                   //     //       "img": searchController.searchProductInfo[index].productImg,
                            //                                   //     //       "name": searchController.searchProductInfo[index].productTitle,
                            //                                   //     //       "sprice": searchController.searchProductInfo[index].productInfo[0].subscribePrice,
                            //                                   //     //       "aprice": searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                   //     //       "per": searchController.searchProductInfo[index].productInfo[0].productDiscount,
                            //                                   //     //       "attributeId": searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                   //     //       "productTitle": searchController.searchProductInfo[index].productInfo[0].title,
                            //                                   //     //       "isEmpty": "0",
                            //                                   //     //       "productId": searchController.searchProductInfo[index].productId,
                            //                                   //     //     });
                            //                                   //     // }
                            //                                   //   },
                            //                                   //   child: Container(
                            //                                   //     height: 25,
                            //                                   //     padding: EdgeInsets
                            //                                   //         .symmetric(
                            //                                   //             horizontal:
                            //                                   //                 8),
                            //                                   //     alignment:
                            //                                   //         Alignment
                            //                                   //             .center,
                            //                                   //     child: Text(
                            //                                   //       "SUBSCRIBE"
                            //                                   //           .tr,
                            //                                   //       style:
                            //                                   //           TextStyle(
                            //                                   //         color: gradient
                            //                                   //             .defoultColor,
                            //                                   //         fontFamily:
                            //                                   //             FontFamily
                            //                                   //                 .gilroyBold,
                            //                                   //         fontSize:
                            //                                   //             11,
                            //                                   //       ),
                            //                                   //     ),
                            //                                   //     decoration:
                            //                                   //         BoxDecoration(
                            //                                   //       borderRadius:
                            //                                   //           BorderRadius
                            //                                   //               .circular(
                            //                                   //                   5),
                            //                                   //       border: Border.all(
                            //                                   //           color: Colors
                            //                                   //               .grey
                            //                                   //               .shade300),
                            //                                   //     ),
                            //                                   //   ),
                            //                                   // ),

                            //                                   SizedBox(
                            //                                     width: 5,
                            //                                   ),
                            //                                 ],
                            //                               )
                            //                             : SizedBox(),

                            //                         //! ------------ Add Product Widget -------------!//
                            //                         Row(
                            //                           children: [
                            //                             SizedBox(
                            //                               width: 8,
                            //                             ),
                            //                             Column(
                            //                               children: [
                            //                                 Text(
                            //                                   "${currency}${double.parse(searchController.searchProductInfo[index].productInfo[0].normalPrice) - price}",
                            //                                   maxLines: 1,
                            //                                   style: TextStyle(
                            //                                     fontFamily:
                            //                                         FontFamily
                            //                                             .gilroyBold,
                            //                                     fontSize: 13,
                            //                                   ),
                            //                                 ),
                            //                                 searchController
                            //                                             .searchProductInfo[
                            //                                                 index]
                            //                                             .productInfo[
                            //                                                 0]
                            //                                             .productDiscount !=
                            //                                         "0"
                            //                                     ? Text(
                            //                                         "${currency}${searchController.searchProductInfo[index].productInfo[0].normalPrice}",
                            //                                         maxLines: 1,
                            //                                         style:
                            //                                             TextStyle(
                            //                                           color:
                            //                                               greyColor,
                            //                                           fontFamily:
                            //                                               FontFamily
                            //                                                   .gilroyMedium,
                            //                                           decoration:
                            //                                               TextDecoration
                            //                                                   .lineThrough,
                            //                                           fontSize:
                            //                                               11,
                            //                                         ),
                            //                                       )
                            //                                     : SizedBox(),
                            //                               ],
                            //                             ),
                            //                             Spacer(),
                            //                             searchController
                            //                                         .searchProductInfo[
                            //                                             index]
                            //                                         .productInfo[
                            //                                             0]
                            //                                         .productOutStock ==
                            //                                     "0"
                            //                                 ? isItem(searchController
                            //                                             .searchProductInfo[
                            //                                                 index]
                            //                                             .productInfo[
                            //                                                 0]
                            //                                             .attributeId
                            //                                             .toString()) !=
                            //                                         "0"
                            //                                     ? isSubscibe(searchController
                            //                                                 .searchProductInfo[
                            //                                                     index]
                            //                                                 .productInfo[
                            //                                                     0]
                            //                                                 .attributeId
                            //                                                 .toString()) !=
                            //                                             "1"
                            //                                         ? Container(
                            //                                             height:
                            //                                                 25,
                            //                                             width: 80,
                            //                                             margin: EdgeInsets
                            //                                                 .all(
                            //                                                     5),
                            //                                             alignment:
                            //                                                 Alignment
                            //                                                     .center,
                            //                                             child:
                            //                                                 Row(
                            //                                               children: [
                            //                                                 SizedBox(
                            //                                                   width:
                            //                                                       5,
                            //                                                 ),
                            //                                                 InkWell(
                            //                                                   onTap:
                            //                                                       () {
                            //                                                     setState(() {
                            //                                                       onRemoveItem(
                            //                                                         index,
                            //                                                         isItem(searchController.searchProductInfo[index].productInfo[0].attributeId.toString()),
                            //                                                         id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                         price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                       );
                            //                                                     });
                            //                                                   },
                            //                                                   child:
                            //                                                       Container(
                            //                                                     height: 30,
                            //                                                     width: 15,
                            //                                                     alignment: Alignment.center,
                            //                                                     child: Icon(
                            //                                                       Icons.remove,
                            //                                                       color: gradient.defoultColor,
                            //                                                       size: 15,
                            //                                                     ),
                            //                                                   ),
                            //                                                 ),
                            //                                                 Expanded(
                            //                                                   child:
                            //                                                       Container(
                            //                                                     alignment: Alignment.center,
                            //                                                     child: Text(
                            //                                                       isItem(searchController.searchProductInfo[index].productInfo[0].attributeId).toString(),
                            //                                                       style: TextStyle(
                            //                                                         color: gradient.defoultColor,
                            //                                                         fontFamily: FontFamily.gilroyBold,
                            //                                                         fontSize: 12,
                            //                                                       ),
                            //                                                     ),
                            //                                                   ),
                            //                                                 ),
                            //                                                 InkWell(
                            //                                                   onTap:
                            //                                                       () {
                            //                                                     for (var element in cart.values) {
                            //                                                       if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                         if (element.cartCheck == "1") {
                            //                                                           Get.bottomSheet(
                            //                                                             Container(
                            //                                                               height: 200,
                            //                                                               width: Get.size.width,
                            //                                                               child: Column(
                            //                                                                 children: [
                            //                                                                   SizedBox(
                            //                                                                     height: 15,
                            //                                                                   ),
                            //                                                                   Padding(
                            //                                                                     padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                            //                                                                     child: Text(
                            //                                                                       "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                            //                                                                       style: TextStyle(
                            //                                                                         fontFamily: FontFamily.gilroyMedium,
                            //                                                                         fontSize: 16,
                            //                                                                         height: 1.2,
                            //                                                                         letterSpacing: 1,
                            //                                                                         color: BlackColor,
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                   SizedBox(
                            //                                                                     height: 10,
                            //                                                                   ),
                            //                                                                   Padding(
                            //                                                                     padding: const EdgeInsets.symmetric(horizontal: 15),
                            //                                                                     child: Divider(
                            //                                                                       color: Colors.grey,
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                   Spacer(),
                            //                                                                   Row(
                            //                                                                     children: [
                            //                                                                       Expanded(
                            //                                                                         child: InkWell(
                            //                                                                           onTap: () {
                            //                                                                             Get.back();
                            //                                                                           },
                            //                                                                           child: Container(
                            //                                                                             height: 40,
                            //                                                                             width: Get.size.width,
                            //                                                                             alignment: Alignment.center,
                            //                                                                             margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                             child: Text(
                            //                                                                               "No".tr,
                            //                                                                               style: TextStyle(
                            //                                                                                 fontFamily: FontFamily.gilroyBold,
                            //                                                                                 color: gradient.defoultColor,
                            //                                                                                 fontSize: 16,
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                             decoration: BoxDecoration(
                            //                                                                               color: gradient.defoultColor.withOpacity(0.1),
                            //                                                                               borderRadius: BorderRadius.circular(25),
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                       Expanded(
                            //                                                                         child: InkWell(
                            //                                                                           onTap: () {
                            //                                                                             for (var element in cart.values) {
                            //                                                                               if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                                                 if (element.cartCheck == "1") {
                            //                                                                                   cart.delete(element.id);
                            //                                                                                   catDetailsController.getCartLangth();
                            //                                                                                   setState(() {});
                            //                                                                                 }
                            //                                                                               }
                            //                                                                             }
                            //                                                                             onAddItem(
                            //                                                                               index,
                            //                                                                               isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                                               id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                                               price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                                               strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                                               per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                                               storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                                               img1: searchController.searchProductInfo[index].productImg,
                            //                                                                               productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                                               productID: searchController.searchProductInfo[index].productId,
                            //                                                                             );

                            //                                                                             Get.back();
                            //                                                                           },
                            //                                                                           child: Container(
                            //                                                                             height: 40,
                            //                                                                             width: Get.size.width,
                            //                                                                             alignment: Alignment.center,
                            //                                                                             margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                             child: Text(
                            //                                                                               "Clear Cart".tr,
                            //                                                                               style: TextStyle(
                            //                                                                                 fontFamily: FontFamily.gilroyBold,
                            //                                                                                 color: WhiteColor,
                            //                                                                                 fontSize: 16,
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                             decoration: BoxDecoration(
                            //                                                                               gradient: gradient.btnGradient,
                            //                                                                               borderRadius: BorderRadius.circular(25),
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                     ],
                            //                                                                   ),
                            //                                                                   SizedBox(
                            //                                                                     height: 20,
                            //                                                                   ),
                            //                                                                 ],
                            //                                                               ),
                            //                                                               decoration: BoxDecoration(
                            //                                                                 color: WhiteColor,
                            //                                                                 borderRadius: BorderRadius.only(
                            //                                                                   topLeft: Radius.circular(30),
                            //                                                                   topRight: Radius.circular(30),
                            //                                                                 ),
                            //                                                               ),
                            //                                                             ),
                            //                                                           );
                            //                                                           break;
                            //                                                         } else {
                            //                                                           setState(() {
                            //                                                             onAddItem(
                            //                                                               index,
                            //                                                               isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                               id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                               price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                               strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                               per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                               storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                               img1: searchController.searchProductInfo[index].productImg,
                            //                                                               productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                               productID: searchController.searchProductInfo[index].productId,
                            //                                                             );
                            //                                                           });
                            //                                                           break;
                            //                                                         }
                            //                                                       }
                            //                                                     }
                            //                                                   },
                            //                                                   child:
                            //                                                       Container(
                            //                                                     height: 30,
                            //                                                     width: 15,
                            //                                                     alignment: Alignment.center,
                            //                                                     child: Icon(
                            //                                                       Icons.add,
                            //                                                       color: gradient.defoultColor,
                            //                                                       size: 15,
                            //                                                     ),
                            //                                                   ),
                            //                                                 ),
                            //                                                 SizedBox(
                            //                                                   width:
                            //                                                       5,
                            //                                                 ),
                            //                                               ],
                            //                                             ),
                            //                                             decoration:
                            //                                                 BoxDecoration(
                            //                                               borderRadius:
                            //                                                   BorderRadius.circular(5),
                            //                                               border: Border.all(
                            //                                                   color:
                            //                                                       Colors.grey.shade300),
                            //                                             ),
                            //                                           )
                            //                                         : InkWell(
                            //                                             onTap:
                            //                                                 () {
                            //                                               setState(
                            //                                                   () {
                            //                                                 print(
                            //                                                     "object");
                            //                                                 if (cart
                            //                                                     .values
                            //                                                     .isNotEmpty) {
                            //                                                   for (var element
                            //                                                       in cart.values) {
                            //                                                     if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                       if (element.cartCheck == "1") {
                            //                                                         Get.bottomSheet(
                            //                                                           Container(
                            //                                                             height: 200,
                            //                                                             width: Get.size.width,
                            //                                                             child: Column(
                            //                                                               children: [
                            //                                                                 SizedBox(
                            //                                                                   height: 15,
                            //                                                                 ),
                            //                                                                 Padding(
                            //                                                                   padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                            //                                                                   child: Text(
                            //                                                                     "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                            //                                                                     style: TextStyle(
                            //                                                                       fontFamily: FontFamily.gilroyMedium,
                            //                                                                       fontSize: 16,
                            //                                                                       height: 1.2,
                            //                                                                       letterSpacing: 1,
                            //                                                                       color: BlackColor,
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                 ),
                            //                                                                 SizedBox(
                            //                                                                   height: 10,
                            //                                                                 ),
                            //                                                                 Padding(
                            //                                                                   padding: const EdgeInsets.symmetric(horizontal: 15),
                            //                                                                   child: Divider(
                            //                                                                     color: Colors.grey,
                            //                                                                   ),
                            //                                                                 ),
                            //                                                                 Spacer(),
                            //                                                                 Row(
                            //                                                                   children: [
                            //                                                                     Expanded(
                            //                                                                       child: InkWell(
                            //                                                                         onTap: () {
                            //                                                                           Get.back();
                            //                                                                         },
                            //                                                                         child: Container(
                            //                                                                           height: 40,
                            //                                                                           width: Get.size.width,
                            //                                                                           alignment: Alignment.center,
                            //                                                                           margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                           child: Text(
                            //                                                                             "No".tr,
                            //                                                                             style: TextStyle(
                            //                                                                               fontFamily: FontFamily.gilroyBold,
                            //                                                                               color: gradient.defoultColor,
                            //                                                                               fontSize: 16,
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                           decoration: BoxDecoration(
                            //                                                                             color: gradient.defoultColor.withOpacity(0.1),
                            //                                                                             borderRadius: BorderRadius.circular(25),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                     Expanded(
                            //                                                                       child: InkWell(
                            //                                                                         onTap: () {
                            //                                                                           for (var element in cart.values) {
                            //                                                                             if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                                               if (element.cartCheck == "1") {
                            //                                                                                 cart.delete(element.id);
                            //                                                                                 catDetailsController.getCartLangth();
                            //                                                                                 setState(() {});
                            //                                                                               }
                            //                                                                             }
                            //                                                                           }
                            //                                                                           onAddItem(
                            //                                                                             index,
                            //                                                                             isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                                             id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                                             price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                                             strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                                             per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                                             storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                                             img1: searchController.searchProductInfo[index].productImg,
                            //                                                                             productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                                             productID: searchController.searchProductInfo[index].productId,
                            //                                                                           );

                            //                                                                           Get.back();
                            //                                                                         },
                            //                                                                         child: Container(
                            //                                                                           height: 40,
                            //                                                                           width: Get.size.width,
                            //                                                                           alignment: Alignment.center,
                            //                                                                           margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                           child: Text(
                            //                                                                             "Clear Cart".tr,
                            //                                                                             style: TextStyle(
                            //                                                                               fontFamily: FontFamily.gilroyBold,
                            //                                                                               color: WhiteColor,
                            //                                                                               fontSize: 16,
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                           decoration: BoxDecoration(
                            //                                                                             gradient: gradient.btnGradient,
                            //                                                                             borderRadius: BorderRadius.circular(25),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                   ],
                            //                                                                 ),
                            //                                                                 SizedBox(
                            //                                                                   height: 20,
                            //                                                                 ),
                            //                                                               ],
                            //                                                             ),
                            //                                                             decoration: BoxDecoration(
                            //                                                               color: WhiteColor,
                            //                                                               borderRadius: BorderRadius.only(
                            //                                                                 topLeft: Radius.circular(30),
                            //                                                                 topRight: Radius.circular(30),
                            //                                                               ),
                            //                                                             ),
                            //                                                           ),
                            //                                                         );
                            //                                                         break;
                            //                                                       } else {
                            //                                                         onAddItem(
                            //                                                           index,
                            //                                                           isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                           id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                           price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                           strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                           per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                           storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                           img1: searchController.searchProductInfo[index].productImg,
                            //                                                           productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                           productID: searchController.searchProductInfo[index].productId,
                            //                                                         );

                            //                                                         break;
                            //                                                       }
                            //                                                     }
                            //                                                   }
                            //                                                 } else {
                            //                                                   onAddItem(
                            //                                                     index,
                            //                                                     isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                     id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                     price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                     strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                     per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                     storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                     img1: searchController.searchProductInfo[index].productImg,
                            //                                                     productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                     productID: searchController.searchProductInfo[index].productId,
                            //                                                   );
                            //                                                 }
                            //                                               });
                            //                                             },
                            //                                             child:
                            //                                                 Container(
                            //                                               height:
                            //                                                   25,
                            //                                               width:
                            //                                                   80,
                            //                                               margin:
                            //                                                   EdgeInsets.all(5),
                            //                                               alignment:
                            //                                                   Alignment.center,
                            //                                               child:
                            //                                                   Text(
                            //                                                 "ADD"
                            //                                                     .tr,
                            //                                                 style:
                            //                                                     TextStyle(
                            //                                                   color:
                            //                                                       gradient.defoultColor,
                            //                                                   fontFamily:
                            //                                                       FontFamily.gilroyBold,
                            //                                                   fontSize:
                            //                                                       12,
                            //                                                 ),
                            //                                               ),
                            //                                               decoration:
                            //                                                   BoxDecoration(
                            //                                                 borderRadius:
                            //                                                     BorderRadius.circular(5),
                            //                                                 border:
                            //                                                     Border.all(color: Colors.grey.shade300),
                            //                                               ),
                            //                                             ),
                            //                                           )
                            //                                     : InkWell(
                            //                                         onTap: () {
                            //                                           setState(
                            //                                               () {
                            //                                             print(cart
                            //                                                 .values
                            //                                                 .isNotEmpty);
                            //                                             if (cart
                            //                                                 .values
                            //                                                 .isNotEmpty) {
                            //                                               for (var element
                            //                                                   in cart.values) {
                            //                                                 if (element.storeID !=
                            //                                                     storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                   if (element.cartCheck ==
                            //                                                       "1") {
                            //                                                     Get.bottomSheet(
                            //                                                       Container(
                            //                                                         height: 200,
                            //                                                         width: Get.size.width,
                            //                                                         child: Column(
                            //                                                           children: [
                            //                                                             SizedBox(
                            //                                                               height: 15,
                            //                                                             ),
                            //                                                             Padding(
                            //                                                               padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                            //                                                               child: Text(
                            //                                                                 "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                            //                                                                 style: TextStyle(
                            //                                                                   fontFamily: FontFamily.gilroyMedium,
                            //                                                                   fontSize: 16,
                            //                                                                   height: 1.2,
                            //                                                                   letterSpacing: 1,
                            //                                                                   color: BlackColor,
                            //                                                                 ),
                            //                                                               ),
                            //                                                             ),
                            //                                                             SizedBox(
                            //                                                               height: 10,
                            //                                                             ),
                            //                                                             Padding(
                            //                                                               padding: const EdgeInsets.symmetric(horizontal: 15),
                            //                                                               child: Divider(
                            //                                                                 color: Colors.grey,
                            //                                                               ),
                            //                                                             ),
                            //                                                             Spacer(),
                            //                                                             Row(
                            //                                                               children: [
                            //                                                                 Expanded(
                            //                                                                   child: InkWell(
                            //                                                                     onTap: () {
                            //                                                                       Get.back();
                            //                                                                     },
                            //                                                                     child: Container(
                            //                                                                       height: 40,
                            //                                                                       width: Get.size.width,
                            //                                                                       alignment: Alignment.center,
                            //                                                                       margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                       child: Text(
                            //                                                                         "No".tr,
                            //                                                                         style: TextStyle(
                            //                                                                           fontFamily: FontFamily.gilroyBold,
                            //                                                                           color: gradient.defoultColor,
                            //                                                                           fontSize: 16,
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                       decoration: BoxDecoration(
                            //                                                                         color: gradient.defoultColor.withOpacity(0.1),
                            //                                                                         borderRadius: BorderRadius.circular(25),
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                 ),
                            //                                                                 Expanded(
                            //                                                                   child: InkWell(
                            //                                                                     onTap: () {
                            //                                                                       for (var element in cart.values) {
                            //                                                                         if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                            //                                                                           if (element.cartCheck == "1") {
                            //                                                                             cart.delete(element.id);
                            //                                                                             catDetailsController.getCartLangth();
                            //                                                                             setState(() {});
                            //                                                                           }
                            //                                                                         }
                            //                                                                       }
                            //                                                                       onAddItem(
                            //                                                                         index,
                            //                                                                         isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                                         id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                                         price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                                         strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                                         per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                                         storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                                         img1: searchController.searchProductInfo[index].productImg,
                            //                                                                         productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                                         productID: searchController.searchProductInfo[index].productId,
                            //                                                                       );

                            //                                                                       Get.back();
                            //                                                                     },
                            //                                                                     child: Container(
                            //                                                                       height: 40,
                            //                                                                       width: Get.size.width,
                            //                                                                       alignment: Alignment.center,
                            //                                                                       margin: EdgeInsets.symmetric(horizontal: 10),
                            //                                                                       child: Text(
                            //                                                                         "Clear Cart".tr,
                            //                                                                         style: TextStyle(
                            //                                                                           fontFamily: FontFamily.gilroyBold,
                            //                                                                           color: WhiteColor,
                            //                                                                           fontSize: 16,
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                       decoration: BoxDecoration(
                            //                                                                         gradient: gradient.btnGradient,
                            //                                                                         borderRadius: BorderRadius.circular(25),
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                 ),
                            //                                                               ],
                            //                                                             ),
                            //                                                             SizedBox(
                            //                                                               height: 20,
                            //                                                             ),
                            //                                                           ],
                            //                                                         ),
                            //                                                         decoration: BoxDecoration(
                            //                                                           color: WhiteColor,
                            //                                                           borderRadius: BorderRadius.only(
                            //                                                             topLeft: Radius.circular(30),
                            //                                                             topRight: Radius.circular(30),
                            //                                                           ),
                            //                                                         ),
                            //                                                       ),
                            //                                                     );
                            //                                                     break;
                            //                                                   } else {
                            //                                                     onAddItem(
                            //                                                       index,
                            //                                                       isItem(searchController.searchProductInfo[index].productInfo[0].attributeId),
                            //                                                       id1: searchController.searchProductInfo[index].productInfo[0].attributeId,
                            //                                                       price1: searchController.searchProductInfo[index].productInfo[0].normalPrice,
                            //                                                       strTitle1: searchController.searchProductInfo[index].productTitle,
                            //                                                       per1: searchController.searchProductInfo[index].productInfo[0].productDiscount.toString(),
                            //                                                       storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                            //                                                       img1: searchController.searchProductInfo[index].productImg,
                            //                                                       productTitle1: searchController.searchProductInfo[index].productInfo[0].title,
                            //                                                       productID: searchController.searchProductInfo[index].productId,
                            //                                                     );

                            //                                                     break;
                            //                                                   }
                            //                                                 } else {}
                            //                                               }
                            //                                             } else {
                            //                                               onAddItem(
                            //                                                 index,
                            //                                                 isItem(searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productInfo[0]
                            //                                                     .attributeId),
                            //                                                 id1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productInfo[0]
                            //                                                     .attributeId,
                            //                                                 price1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productInfo[0]
                            //                                                     .normalPrice,
                            //                                                 strTitle1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productTitle,
                            //                                                 per1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productInfo[0]
                            //                                                     .productDiscount
                            //                                                     .toString(),
                            //                                                 storeId1: storeDataContoller
                            //                                                     .storeDataInfo
                            //                                                     ?.storeInfo
                            //                                                     .storeId,
                            //                                                 img1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productImg,
                            //                                                 productTitle1: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productInfo[0]
                            //                                                     .title,
                            //                                                 productID: searchController
                            //                                                     .searchProductInfo[index]
                            //                                                     .productId,
                            //                                               );
                            //                                             }
                            //                                           });
                            //                                         },
                            //                                         child:
                            //                                             Container(
                            //                                           height: 25,
                            //                                           width: 80,
                            //                                           margin: EdgeInsets
                            //                                               .all(5),
                            //                                           alignment:
                            //                                               Alignment
                            //                                                   .center,
                            //                                           child: Text(
                            //                                             "ADD".tr,
                            //                                             style:
                            //                                                 TextStyle(
                            //                                               color: gradient
                            //                                                   .defoultColor,
                            //                                               fontFamily:
                            //                                                   FontFamily.gilroyBold,
                            //                                               fontSize:
                            //                                                   12,
                            //                                             ),
                            //                                           ),
                            //                                           decoration:
                            //                                               BoxDecoration(
                            //                                             borderRadius:
                            //                                                 BorderRadius.circular(
                            //                                                     5),
                            //                                             border: Border.all(
                            //                                                 color: Colors
                            //                                                     .grey
                            //                                                     .shade300),
                            //                                           ),
                            //                                         ),
                            //                                       )
                            //                                 : Container(
                            //                                     height: 22,
                            //                                     width: 90,
                            //                                     margin: EdgeInsets
                            //                                         .all(5),
                            //                                     alignment:
                            //                                         Alignment
                            //                                             .center,
                            //                                     child: Text(
                            //                                       "Out of stock",
                            //                                       style:
                            //                                           TextStyle(
                            //                                         fontFamily:
                            //                                             FontFamily
                            //                                                 .gilroyMedium,
                            //                                         fontSize: 12,
                            //                                         color:
                            //                                             RedColor,
                            //                                       ),
                            //                                     ),
                            //                                     decoration:
                            //                                         BoxDecoration(
                            //                                       border: Border.all(
                            //                                           color:
                            //                                               RedColor),
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   5),
                            //                                     ),
                            //                                   ),
                            //                           ],
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               decoration: BoxDecoration(
                            //                 color: WhiteColor,
                            //                 borderRadius:
                            //                     BorderRadius.circular(8),
                            //                 boxShadow: [
                            //                   BoxShadow(
                            //                     color: Colors.grey.shade300,
                            //                     offset: const Offset(
                            //                       0.3,
                            //                       0.3,
                            //                     ),
                            //                     blurRadius: 0.3,
                            //                     spreadRadius: 0.3,
                            //                   ), //BoxShadow
                            //                   BoxShadow(
                            //                     color: Colors.white,
                            //                     offset: const Offset(0.0, 0.0),
                            //                     blurRadius: 0.0,
                            //                     spreadRadius: 0.0,
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             searchController
                            //                         .searchProductInfo[index]
                            //                         .productInfo[0]
                            //                         .productDiscount !=
                            //                     "0"
                            //                 ? Positioned(
                            //                     top: -5,
                            //                     left: 4,
                            //                     child: Container(
                            //                       height: 40,
                            //                       width: 40,
                            //                       alignment: Alignment.center,
                            //                       child: Text(
                            //                         "${searchController.searchProductInfo[index].productInfo[0].productDiscount}%\nOFF",
                            //                         style: TextStyle(
                            //                           fontFamily:
                            //                               FontFamily.gilroyMedium,
                            //                           color: WhiteColor,
                            //                           fontSize: 11,
                            //                           height: 1.1,
                            //                         ),
                            //                       ),
                            //                       decoration: BoxDecoration(
                            //                         image: DecorationImage(
                            //                           image: AssetImage(
                            //                             "assets/lable1.png",
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   )
                            //                 : SizedBox(),
                            //           ],
                            //         );
                            //       },
                            //     ),
                            //   )

                            : Expanded(
                                child: Center(
                                  child: Container(
                                    height: 200,
                                    width: Get.size.width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "The Product is currently \nunavailable in Store",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 15,
                                        color: BlackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                        : Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: gradient.defoultColor,
                              ),
                            ),
                          ),
              ],
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
    String? isRequride1,
    storeId1,
    String? sPrice1,
    img1,
    productTitle1,
    productID,
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
    newItem.sPrice = double.parse(sPrice1 ?? "0"); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productID; //Product Id

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
        required String storeLogo, required String storeSlogan,required String productImage,required String productTitlee1
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
    newItem.productID = productId; // Product Id
    newItem.storeLogo = storeLogo;
    newItem.productImg = productImage;
    newItem.productTitle1 = productTitlee1;
    newItem.storeSlogan = storeSlogan;
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
      // if (element.subscriptionRequired != "0") {
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
                      ? Container(
                          height: Get.size.height * 0.8,
                          width: Get.size.width,
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
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
                                                        "${Config.imageUrl}${productDetailsController.productInfo?.productData.img ?? ""}",
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
                                      bottom: 0,
                                      child: SizedBox(
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
                                                for (var i = 0;
                                                    i <
                                                        productDetailsController
                                                            .productInfo!
                                                            .productData
                                                            .productInfo
                                                            .length;
                                                    i++) {
                                                  // if (productDetailsController.productInfo!.productData.productInfo[i].subscriptionRequired =="1") {
                                                  //   productDetailsController.getProductDetailsApi(
                                                  //     pId:
                                                  //         productDetailsController
                                                  //                 .productInfo
                                                  //                 ?.productData
                                                  //                 .id ??
                                                  //             "",
                                                  //   );
                                                  //   Get.toNamed(
                                                  //       Routes.subScribeScreen,
                                                  //       arguments: {
                                                  //         "img":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .img[0],
                                                  //         "name":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .title,
                                                  //         "sprice":
                                                  //             "",
                                                  //         "aprice":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .productInfo[
                                                  //                     i]
                                                  //                 .normalPrice,
                                                  //         "per": productDetailsController
                                                  //             .productInfo!
                                                  //             .productData
                                                  //             .productInfo[i]
                                                  //             .productDiscount,
                                                  //         "attributeId":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .productInfo[
                                                  //                     i]
                                                  //                 .attributeId,
                                                  //         "productTitle":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .productInfo[
                                                  //                     i]
                                                  //                 .title,
                                                  //         "isEmpty": "0",
                                                  //         "productId":
                                                  //             productDetailsController
                                                  //                 .productInfo!
                                                  //                 .productData
                                                  //                 .id,
                                                  //       });
                                                  //   break;
                                                  // }
                                                }
                                              },
                                              child: Container(
                                                height: 25,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "SUBSCRIBE",
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
                                    "Select unit",
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
                                                                      // onAddItem1(
                                                                      //   index,
                                                                      //   isItem(productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .attributeId),
                                                                      //   id1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .attributeId,
                                                                      //   price1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .normalPrice,
                                                                      //   strTitle1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .title,
                                                                      //   isRequride1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .subscriptionRequired,
                                                                      //   per1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .productDiscount,
                                                                      //   storeId1: storeDataContoller
                                                                      //       .storeDataInfo
                                                                      //       ?.storeInfo
                                                                      //       .storeId,
                                                                      //   sPrice1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .subscribePrice,
                                                                      //   img1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .img[0],
                                                                      //   productTitle1: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .productInfo[index]
                                                                      //       .title,
                                                                      //   productId: productDetailsController
                                                                      //       .productInfo
                                                                      //       ?.productData
                                                                      //       .id,
                                                                      // );
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
                                                                                    "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?",
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
                                                                                            "No",
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
                                                                                          // onAddItem1(
                                                                                          //   index,
                                                                                          //   isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                          //   id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                          //   price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                          //   strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                          //   isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                          //   per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                          //   storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                          //   sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                          //   img1: productDetailsController.productInfo?.productData.img[0],
                                                                                          //   productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                          //   productId: productDetailsController.productInfo?.productData.id,
                                                                                          // );

                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "Clear Cart",
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
                                                                        // onAddItem1(
                                                                        //   index,
                                                                        //   isItem(productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .attributeId),
                                                                        //   id1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .attributeId,
                                                                        //   price1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .normalPrice,
                                                                        //   strTitle1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .title,
                                                                        //   isRequride1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .subscriptionRequired,
                                                                        //   per1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .productDiscount,
                                                                        //   storeId1: storeDataContoller
                                                                        //       .storeDataInfo
                                                                        //       ?.storeInfo
                                                                        //       .storeId,
                                                                        //   sPrice1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .subscribePrice,
                                                                        //   img1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .img[0],
                                                                        //   productTitle1: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .productInfo[index]
                                                                        //       .title,
                                                                        //   productId: productDetailsController
                                                                        //       .productInfo
                                                                        //       ?.productData
                                                                        //       .id,
                                                                        // );

                                                                        break;
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  // onAddItem1(
                                                                  //   index,
                                                                  //   isItem(productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .attributeId),
                                                                  //   id1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .attributeId,
                                                                  //   price1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .normalPrice,
                                                                  //   strTitle1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .title,
                                                                  //   isRequride1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .subscriptionRequired,
                                                                  //   per1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .productDiscount,
                                                                  //   storeId1: storeDataContoller
                                                                  //       .storeDataInfo
                                                                  //       ?.storeInfo
                                                                  //       .storeId,
                                                                  //   sPrice1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .subscribePrice,
                                                                  //   img1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .img[0],
                                                                  //   productTitle1: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .productInfo[
                                                                  //           index]
                                                                  //       .title,
                                                                  //   productId: productDetailsController
                                                                  //       .productInfo
                                                                  //       ?.productData
                                                                  //       .id,
                                                                  // );
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
                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?",
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
                                                                                        "No",
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
                                                                                      // onAddItem1(
                                                                                      //   index,
                                                                                      //   isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                      //   id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                      //   price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                      //   strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                      //   isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                      //   per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                      //   storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                      //   sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                      //   img1: productDetailsController.productInfo?.productData.img[0],
                                                                                      //   productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                      //   productId: productDetailsController.productInfo?.productData.id,
                                                                                      // );

                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "Clear Cart",
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
                                                                      isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                      id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                      price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                      strTitle1: productDetailsController.productInfo?.productData.title,
                                                                      per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                      storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                      img1: productDetailsController.productInfo?.productData.img[0],
                                                                      productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                      productId: productDetailsController.productInfo?.productData.id,
                                                                      storeLogo: storeDataContoller.storeDataInfo!.storeInfo.storeLogo,
                                                                      storeSlogan: storeDataContoller.storeDataInfo!.storeInfo.storeSlogan,
                                                                      productImage: productDetailsController.productInfo!.productData.img[0],
                                                                      productTitlee1: storeDataContoller.storeDataInfo!.storeInfo.storeTitle,
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
                                                                storeLogo: storeDataContoller.storeDataInfo!.storeInfo.storeLogo,
                                                                storeSlogan: storeDataContoller.storeDataInfo!.storeInfo.storeSlogan,
                                                                productImage: productDetailsController.productInfo!.productData.img[0],
                                                                productTitlee1: storeDataContoller.storeDataInfo!.storeInfo.storeTitle,
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
                                    "Description",
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
                color: WhiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            );
          });
        });
  }
}

class SearchProductWidget extends StatefulWidget {
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
  SearchProductWidget({
    super.key,
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
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  SearchController1 searchController = Get.find();

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
    // setState(() {
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
    // });
    // print(productTitle);
    super.initState();
    prductAttribute = [];
    for (int i = 0;
        i <
            searchController
                .searchProductInfo[widget.index ?? 0].productInfo.length;
        i++) {
      prductAttribute.add(searchController
          .searchProductInfo[widget.index ?? 0].productInfo[i].title);
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
              placeholderCacheHeight: 65,
              placeholderCacheWidth: 65,
              height: 65,
              width: 65,
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
                      "${currency}${(double.parse(normalPrice.toString()) - (double.parse(normalPrice.toString()) * double.parse(productDiscount)) / 100).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        color: BlackColor,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${currency}${normalPrice}",
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
                                        child: SizedBox(
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
                                                          searchController
                                                              .searchProductInfo[
                                                                  widget.index ??
                                                                      0]
                                                              .productInfo
                                                              .length;
                                                      i++) {
                                                    if (prductAttribute[
                                                            index] ==
                                                        searchController
                                                            .searchProductInfo[
                                                                widget.index ??
                                                                    0]
                                                            .productInfo[i]
                                                            .title) {
                                                      setState(() {
                                                        normalPrice = searchController
                                                            .searchProductInfo[
                                                                widget.index ??
                                                                    0]
                                                            .productInfo[i]
                                                            .normalPrice;

                                                        attributeId = searchController
                                                            .searchProductInfo[
                                                                widget.index ??
                                                                    0]
                                                            .productInfo[i]
                                                            .attributeId;
                                                        productDiscount =
                                                            searchController
                                                                .searchProductInfo[
                                                                    widget.index ??
                                                                        0]
                                                                .productInfo[i]
                                                                .productDiscount;
                                                        title = searchController
                                                            .searchProductInfo[
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
                                                  });
                                                  Get.back();
                                                },
                                                child: SizedBox(
                                                  height: 25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          prductAttribute[
                                                              index],
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: BlackColor,
                                                            fontSize: 13,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
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
                            //     onTap: () {},
                            //     value: selectItem,
                            //     icon: Icon(Icons.arrow_drop_down),
                            //     iconSize: 25,
                            //     isExpanded: true,
                            //     underline: SizedBox.shrink(),
                            //     items:
                            //         prductAttribute.toSet().map((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(
                            //           value,
                            //           style: TextStyle(
                            //             fontFamily: FontFamily.gilroyMedium,
                            //             color: BlackColor,
                            //             fontSize: 10,
                            //           ),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     onChanged: (value) {
                            //       for (var i = 0;
                            //           i <
                            //               searchController
                            //                   .searchProductInfo[
                            //                       widget.index ?? 0]
                            //                   .productInfo
                            //                   .length;
                            //           i++) {
                            //         if (value ==
                            //             searchController
                            //                 .searchProductInfo[
                            //                     widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .title) {
                            //           setState(() {
                            //             widget.normalPrice = searchController
                            //                 .searchProductInfo[
                            //                     widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .normalPrice;

                            //             widget.attributeId = searchController
                            //                 .searchProductInfo[
                            //                     widget.index ?? 0]
                            //                 .productInfo[i]
                            //                 .attributeId;
                            //             widget.productDiscount =
                            //                 searchController
                            //                     .searchProductInfo[
                            //                         widget.index ?? 0]
                            //                     .productInfo[i]
                            //                     .productDiscount;
                            //             widget.title = searchController
                            //                 .searchProductInfo[
                            //                     widget.index ?? 0]
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
                                  Text(
                                    prductAttribute[0],
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      color: BlackColor,
                                      fontSize: 10,
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
                                      ),
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
                                        per1: productDiscount,
                                        storeId1: storeDataContoller
                                            .storeDataInfo?.storeInfo.storeId,
                                        img1: widget.productImg,
                                        productTitle1: title,
                                        productId: widget.productId,
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
                                  widget.index ?? 0,
                                  isItem(attributeId),
                                  id1: attributeId,
                                  price1: normalPrice,
                                  strTitle1: widget.productTitle,
                                  per1: productDiscount,
                                  storeId1: storeDataContoller
                                      .storeDataInfo?.storeInfo.storeId,
                                  img1: widget.productImg,
                                  productTitle1: title,
                                  productId: widget.productId,
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
        color: WhiteColor,
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }

  Future<void> onAddItem(int index, String qtys,
      {String? id1,
      price1,
      strTitle1,
      per1,
      storeId1,
      img1,
      productTitle1,
      productId,
      productInfoTitle}) async {
    String? id = id1;
    String? price = price1.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();

    String finalPrice =
        "${(double.parse(price1.toString()) * double.parse(per1)) / 100}";

    print("@@@@@@@@@<FinalPrice>@@@@@@@@@" + finalPrice);
    print("@@@@@@@@@<productTitle1>@@@@@@@@@" + productTitle1);

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

    print("<<<<<<<<ID>>>>>>>>" + id1.toString());
    print("<<<<<<<<Price1>>>>>>>>" + price1.toString());
    print("<<<<<<<<Qty>>>>>>>>" + qty.toString());
    print("<<<<<<<<StrTitle1>>>>>>>>" + strTitle1.toString());
    print("<<<<<<<<Per1>>>>>>>>" + per1.toString());
    print("<<<<<<<<StoreId1>>>>>>>>" + storeId1.toString());

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
