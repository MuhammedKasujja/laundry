// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/stordata_controller.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/categorydetails_screen.dart';
import 'package:laundry/utils/Colors.dart';

import '../../controller/catdetails_controller.dart';
import '../home_screen.dart';
import '../yourcart_screen.dart';

class CategoryViewAll extends StatefulWidget {
  const CategoryViewAll({super.key});

  @override
  State<CategoryViewAll> createState() => _CategoryViewAllState();
}

class _CategoryViewAllState extends State<CategoryViewAll> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  CatDetailsController catDetailsController = Get.find();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CatDetailsController>(builder: (catDetailsController) {
      return Scaffold(
        bottomNavigationBar: catDetailsController.count.isEmpty
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
                                  "${catDetailsController.totalItem} Item",
                                  style: TextStyle(
                                      color: WhiteColor,
                                      fontSize: 14,
                                      fontFamily: "Gilroy Bold"),
                                ),
                                Text(
                                    " |  $currency${catDetailsController.totalAmount.toStringAsFixed(2)}",
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
        backgroundColor: WhiteColor,
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
            "Category",
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 15,
              color: BlackColor,
            ),
          ),
        ),
        body: GetBuilder<StoreDataContoller>(builder: (storeDataContoller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                  width: Get.size.width,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:
                        storeDataContoller.storeDataInfo?.catwiseproduct.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            pageController.jumpToPage(currentIndex);
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 10, right: 15),
                              child: Row(
                                children: [
                                  storeDataContoller.storeDataInfo
                                              ?.catwiseproduct[index].img !=
                                          ""
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/ezgif.com-crop.gif",
                                              placeholderCacheHeight: 30,
                                              placeholderCacheWidth: 30,
                                              placeholderFit: BoxFit.cover,
                                              image:
                                                  "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storeDataContoller
                                                .storeDataInfo
                                                ?.catwiseproduct[index]
                                                .catTitle ??
                                            "",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          color: greytext,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: WhiteColor,
                                  border: Border.all(
                                      color: currentIndex == index
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount:
                        storeDataContoller.storeDataInfo?.catwiseproduct.length,
                    onPageChanged: (value) {
                      storeDataContoller.changeIndexInCategoryViewAll(
                          index: value);
                      setState(() {
                        // setState(() {
                        //   currentIndex = value;
                        //   pageController.jumpToPage(currentIndex);
                        // });
                        currentIndex = value;
                        scrollController.animateTo(
                          currentIndex * 80,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      });
                    },
                    itemBuilder: (context, index1) {
                      return ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            storeDataContoller.storeDataInfo
                                    ?.catwiseproduct[currentIndex].catTitle ??
                                "",
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            itemCount: storeDataContoller
                                .storeDataInfo
                                ?.catwiseproduct[currentIndex]
                                .productdata
                                .length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return ProductWidget(
                                index1: currentIndex,
                                index: index,
                                productTitle: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productTitle,
                                productImg: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productImg,
                                normalPrice: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productInfo[0]
                                    .normalPrice,
                                attributeId: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productInfo[0]
                                    .attributeId,
                                productDiscount: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productInfo[0]
                                    .productDiscount,
                                productId: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productId,
                                title: storeDataContoller
                                    .storeDataInfo
                                    ?.catwiseproduct[currentIndex]
                                    .productdata[index]
                                    .productInfo[0]
                                    .title,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Expanded(
                //   child: Container(
                //     color: WhiteColor,
                //     child: ListView.builder(
                //       controller: scrollController,
                //       itemCount:
                //           storeDataContoller.storeDataInfo?.catwiseproduct.length,
                //       shrinkWrap: true,
                //       padding: EdgeInsets.zero,
                //       itemBuilder: (context, index1) {
                //         return storeDataContoller.storeDataInfo!
                //                 .catwiseproduct[index1].productdata.isNotEmpty
                //             ? Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   SizedBox(
                //                     height: 10,
                //                   ),
                //                   Text(
                //                     storeDataContoller.storeDataInfo
                //                             ?.catwiseproduct[index1].catTitle ??
                //                         "",
                //                     style: TextStyle(
                //                       color: BlackColor,
                //                       fontFamily: FontFamily.gilroyBold,
                //                       fontSize: 18,
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     height: 10,
                //                   ),
                //                   ListView.builder(
                //                     itemCount: storeDataContoller
                //                         .storeDataInfo
                //                         ?.catwiseproduct[index1]
                //                         .productdata
                //                         .length,
                //                     shrinkWrap: true,
                //                     padding: EdgeInsets.zero,
                //                     physics: NeverScrollableScrollPhysics(),
                //                     itemBuilder: (context, index) {
                //                       return ProductWidget(
                //                         index1: index1,
                //                         index: index,
                //                         productTitle: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productTitle,
                //                         productImg: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productImg,
                //                         normalPrice: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productInfo[0]
                //                             .normalPrice,
                //                         attributeId: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productInfo[0]
                //                             .attributeId,
                //                         productDiscount: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productInfo[0]
                //                             .productDiscount,
                //                         productId: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productId,
                //                         title: storeDataContoller
                //                             .storeDataInfo
                //                             ?.catwiseproduct[index1]
                //                             .productdata[index]
                //                             .productInfo[0]
                //                             .title,
                //                       );
                //                     },
                //                   )
                //                 ],
                //               )
                //             : SizedBox();
                //       },
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
