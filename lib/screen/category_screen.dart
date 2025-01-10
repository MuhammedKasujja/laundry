// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/catdetails_controller.dart';
import 'package:laundry/controller/home_controller.dart';
import 'package:laundry/controller/stordata_controller.dart';

import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/categorydetails_screen.dart';
import 'package:laundry/utils/Colors.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  HomePageController homePageController = Get.find();
  String title = Get.arguments["catName"];
  String img = Get.arguments["catImag"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: WhiteColor,
              expandedHeight: 180,
              leading: BackButton(
                color: BlackColor,
                onPressed: () {
                  Get.back();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: BlackColor,
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 18,
                  ),
                ),
                background: Container(
                  height: 180,
                  width: Get.size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Image.network(
                      Config.imageUrl + img,
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: GetBuilder<CatDetailsController>(builder: (context) {
          return catDetailsController.isLoading
              ? catDetailsController.catWiseInfo!.catWiseStoreData.isNotEmpty
                  ? ListView.builder(
                      itemCount: catDetailsController
                          .catWiseInfo?.catWiseStoreData.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            catDetailsController.strId = catDetailsController
                                    .catWiseInfo
                                    ?.catWiseStoreData[index]
                                    .storeId ??
                                "";
                            await storeDataContoller.getStoreData(
                              storeId: catDetailsController.catWiseInfo
                                      ?.catWiseStoreData[index].storeId ??
                                  "",
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
                                        borderRadius: BorderRadius.circular(15),
                                        child: FadeInImage.assetNetwork(
                                          fadeInCurve: Curves.easeInCirc,
                                          placeholder:
                                              "assets/ezgif.com-crop.gif",
                                          placeholderCacheHeight: 170,
                                          placeholderCacheWidth: 120,
                                          placeholderFit: BoxFit.fill,
                                          // placeholderScale: 1.0,
                                          image:
                                              "${Config.imageUrl}${catDetailsController.catWiseInfo?.catWiseStoreData[index].storeCover ?? ""}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    catDetailsController
                                                .catWiseInfo
                                                ?.catWiseStoreData[index]
                                                .couponTitle !=
                                            ""
                                        ? Positioned(
                                            bottom: 10,
                                            right: 10,
                                            left: 10,
                                            child: Container(
                                              height: 50,
                                              width: 120,
                                              margin: EdgeInsets.all(5),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 7),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      catDetailsController
                                                              .catWiseInfo
                                                              ?.catWiseStoreData[
                                                                  index]
                                                              .couponTitle ??
                                                          "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      catDetailsController
                                                              .catWiseInfo
                                                              ?.catWiseStoreData[
                                                                  index]
                                                              .couponSubtitle ??
                                                          "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 13,
                                                        overflow: TextOverflow
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
                                                color: WhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        catDetailsController
                                                .catWiseInfo
                                                ?.catWiseStoreData[index]
                                                .storeTitle ??
                                            "",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          catDetailsController
                                                  .catWiseInfo
                                                  ?.catWiseStoreData[index]
                                                  .storeSdesc ??
                                              "",
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: FontFamily.gilroyMedium,
                                            overflow: TextOverflow.ellipsis,
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
                                            color: gradient.defoultColor,
                                          ),
                                          Text(
                                            "${catDetailsController.catWiseInfo?.catWiseStoreData[index].totalFav} ${"Love this".tr}",
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Image.asset(
                                            "assets/ic_star_review.png",
                                            height: 15,
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            catDetailsController
                                                    .catWiseInfo
                                                    ?.catWiseStoreData[index]
                                                    .storeRate ??
                                                "",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              color: BlackColor,
                                              fontSize: 14,
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
                                            padding: EdgeInsets.all(8),
                                            alignment: Alignment.center,
                                            child: Text(
                                              catDetailsController
                                                      .catWiseInfo
                                                      ?.catWiseStoreData[index]
                                                      .storeTags[0] ??
                                                  "",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                color: gradient.defoultColor,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: gradient.defoultColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 50,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${catDetailsController.catWiseInfo?.catWiseStoreData[index].storeTags.length}+",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                overflow: TextOverflow.ellipsis,
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: gradient.defoultColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No store available \nin your area.'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                          color: BlackColor,
                        ),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    color: gradient.defoultColor,
                  ),
                );
        }),
      ),
    );
  }
}
