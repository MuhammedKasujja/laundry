// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/model/home_info.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/yourcart_screen.dart';
import 'package:lottie/lottie.dart';
import '../Api/data_store.dart';
import '../controller/catdetails_controller.dart';
import '../controller/home_controller.dart';
import '../controller/stordata_controller.dart';
import '../model/fontfamily_model.dart';
import '../utils/Colors.dart';
import '../utils/cart_item.dart';

class AllCart extends StatefulWidget {
  const AllCart({super.key});

  @override
  State<AllCart> createState() => _AllCartState();
}

class _AllCartState extends State<AllCart> {
  HomePageController homePageController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  CatDetailsController catDetailsController = Get.find();

  late Box<CartItem> cart;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    setupHive();
    homePageController.getHomeDataApi().then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  // Future<void> setupHive() async {
  //   await Hive.initFlutter();
  //   cart = Hive.box<CartItem>('cart');
  //   AsyncSnapshot.waiting();
  // }
  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    const AsyncSnapshot.waiting();
    storeList = cartCalculation();
    print("Cart data before deletion: ${cart.values.map((item) => item.id).toList()}");
  }

  // emptyAllDetailsInStore({List<CartItem>? pList1}) {
  //   for (var i = 0; i < pList1!.length; i++) {
  //     cart.delete(pList1[i].id);
  //   }
  //   setState(() {});
  // }

  void emptyAllDetailsInStore({required String storeId}) {
    var itemsToDelete = cart.values.where((item) => item.storeID == storeId).toList();


    Set<String?> idsToDelete = itemsToDelete.map((item) => item.id).toSet();

    print("IDs to delete: ${idsToDelete.toList()}");


    idsToDelete.forEach((id) {
      if (id != null) {
        cart.delete(id);
        print("Deleted item with ID: $id");
      }
    });


    cart.compact();

    setState(() {
      storeList = cartCalculation();
      print("Store list after refresh: ${storeList.map((item) => item.storeID).toList()}");
    });
  }

  // List<CartItem> cartCalculation(String storeId) {
  //   List<CartItem> tempList = [];
  //
  //   for (var element in cart.values) {
  //     if (element.storeID == storeId) {
  //       CartItem item = CartItem();
  //       item.id = element.id;
  //       item.price = element.price;
  //       item.quantity = element.quantity;
  //       item.productPrice = element.price;
  //       item.strTitle = element.strTitle;
  //       item.per = element.per;
  //       item.isRequride = element.isRequride;
  //       item.storeID = element.storeID;
  //       item.sPrice = element.sPrice;
  //       item.img = element.img;
  //       item.productTitle = element.productTitle;
  //       item.selectDelivery = element.selectDelivery;
  //       item.startDate = element.startDate;
  //       item.startTime = element.startTime;
  //       item.daysList = element.daysList;
  //       item.cartCheck = element.cartCheck;
  //       item.productID = element.productID;
  //       tempList.add(item);
  //     }
  //   }
  //   return tempList;
  // }
  List<CartItem> cartCalculation() {
    List<CartItem> tempList = [];
    Set<String?> uniqueStoreIDs = {};

    for (var element in cart.values) {
      if (element.storeID != null && !uniqueStoreIDs.contains(element.storeID)) {
        tempList.add(CartItem()
          ..id = element.id
          ..price = element.price
          ..quantity = element.quantity
          ..productPrice = element.productPrice
          ..strTitle = element.strTitle
          ..per = element.per
          ..isRequride = element.isRequride
          ..storeID = element.storeID
          ..sPrice = element.sPrice
          ..productImg = element.productImg
          ..storeLogo = element.storeLogo
          ..storeSlogan = element.storeSlogan
          ..productTitle = element.productTitle1);
        uniqueStoreIDs.add(element.storeID);
      }
    }

    print("Cart calculation result: ${tempList.map((item) => item.storeID).toList()}");
    return tempList;
  }

  ItemlegthCalculation({required String storeId}) {
    List langth = [];
    for (var element in cart.values) {
      if (element.storeID == storeId) {
        langth.add(element.quantity!);
      }
    }

    return langth;
  }

  getCartLangth({required String strId}) {
    var count = [];
    double totalAmount = 0.0;

    for (var element in cart.values) {
      if (element.storeID == strId) {
        count.add(element.id);
        for (int a = 0; a < element.quantity!; a++) {
          totalAmount += element.price!;
        }
      }
    }

    return totalAmount;
  }

  List<CartItem> productCartList = [];
  List<CartItem> storeList = [];

  List<CartItem> cartCalculationstorewise({required String storeId}) {
    List<CartItem> tempList = [];
    for (var element in cart.values) {
      if (element.storeID == storeId) {
        tempList.add(CartItem()
          ..id = element.id
          ..price = element.price
          ..quantity = element.quantity
          ..productPrice = element.productPrice
          ..strTitle = element.strTitle
          ..per = element.per
          ..isRequride = element.isRequride
          ..storeID = element.storeID
          ..sPrice = element.sPrice
          ..productImg = element.productImg
          ..storeLogo = element.storeLogo
          ..storeSlogan = element.storeSlogan
          ..productTitle = element.productTitle1);
      }
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (homePageController) {
      return Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "All Carts".tr,
            style: TextStyle(
              color: BlackColor,
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
            ),
          ),
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  cart.values.isEmpty
                      ? Container(
                          // height: Get.size.height,
                          width: Get.size.width,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   height: Get.size.height * 0.2,
                              //   width: Get.size.width * 0.4,
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //       image: AssetImage('assets/cartEmpty.png'),
                              //     ),
                              //   ),
                              // ),

                              Lottie.asset(
                                "assets/lotties/7204393.json",
                              ),

                              Text(
                                "Is's Lonely in here...".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 17,
                                  color: BlackColor,
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Text(
                                "Why don't you check some products on our \n Fast Laundry"
                                    .tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyMedium,
                                  fontSize: 15,
                                  height: 1.2,
                                  color: BlackColor,
                                ),
                              ),

                              SizedBox(
                                height: 40,
                              ),

                              InkWell(
                                onTap: () {
                                  catDetailsController.changeIndex(0);
                                },
                                child: Container(
                                  height: 50,
                                  width: Get.size.width,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    gradient: gradient.btnGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Explore more".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: WhiteColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: storeList.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      productCartList = cartCalculationstorewise(storeId: "${storeList[index].storeID}");
                      return storeList.isNotEmpty
                          ? Container(
                        // height: 300,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius:
                            BorderRadius.circular(12)),
                        child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: greyColor),
                                              image:
                                              DecorationImage(
                                                  image:
                                                  NetworkImage("${Config.imageUrl}${storeList[index].storeLogo}",
                                                  )),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                "${storeList[index].productTitle}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily
                                                      .gilroyExtraBold,
                                                  fontSize: 17,
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${storeList[index].storeSlogan}",
                                                      // "StoreSlogan",
                                                      maxLines: 1,
                                                      style:
                                                      TextStyle(
                                                        color:
                                                        BlackColor,
                                                        fontFamily:
                                                        FontFamily
                                                            .gilroyMedium,
                                                        fontSize:
                                                        15,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Row(
                                                  //   children: [
                                                  //     Image.asset(
                                                  //       "assets/star.png",
                                                  //       height: 18,
                                                  //       width: 18,
                                                  //     ),
                                                  //     const SizedBox(
                                                  //       width: 5,
                                                  //     ),
                                                  //     Text(
                                                  //       "2.39 KM",
                                                  //       maxLines: 1,
                                                  //       style:
                                                  //       TextStyle(
                                                  //         fontFamily:
                                                  //         FontFamily
                                                  //             .gilroyMedium,
                                                  //         color:
                                                  //         BlackColor,
                                                  //         fontSize:
                                                  //         13,
                                                  //         overflow:
                                                  //         TextOverflow
                                                  //             .ellipsis,
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // const SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GetBuilder<CatDetailsController>(
                                      builder:
                                          (catDetailsController) {
                                        return InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          "Remove Cart?"),
                                                      content: Text(
                                                          "Are You Sure You Want To Delete All Item From ${storeList[index].strTitle.toString()}"),
                                                      actions: <Widget>[
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              10,
                                                              vertical:
                                                              10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  "Cancel"
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      fontFamily: FontFamily
                                                                          .gilroyMedium,
                                                                      color:
                                                                      blueColor),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    Get.back();
                                                                    print("++++++++++ ${storeList[index].id}");
                                                                    emptyAllDetailsInStore(storeId: "${storeList[index].storeID}");
                                                                    catDetailsController.getCartLangth();
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Yes, Remove"
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      fontFamily: FontFamily
                                                                          .gilroyMedium,
                                                                      color:
                                                                      blueColor),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            },
                                            child: const Icon(
                                                Icons.close));
                                      })
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Items In Cart (${productCartList.length})",
                                style: TextStyle(
                                  color: BlackColor,
                                  fontFamily:
                                  FontFamily.gilroyExtraBold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                width: Get.width,
                                height: 80,
                                child: ListView.separated(
                                  clipBehavior: Clip.none,
                                  separatorBuilder:
                                      (context, index) {
                                    return const SizedBox(
                                      width: 15,
                                    );
                                  },
                                  itemCount: productCartList.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index1) {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 75,
                                          width: 60,
                                          padding:
                                          const EdgeInsets.all(
                                              8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: greyColor),
                                            borderRadius:
                                            BorderRadius
                                                .circular(10),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Image.network("${Config.imageUrl}${productCartList[index1].productImg}"),
                                                Flexible(
                                                  child: Text(
                                                    productCartList[
                                                    index1]
                                                        .strTitle!,
                                                    style: const TextStyle(
                                                        fontSize:
                                                        10,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        fontFamily:
                                                        FontFamily
                                                            .gilroyRegular),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: -5,
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                            blueColor,
                                            child: Text(
                                              "${ItemlegthCalculation(storeId: "${productCartList[index1].storeID}")[index1]}",
                                              style: TextStyle(
                                                  fontFamily: FontFamily
                                                      .gilroyMedium,
                                                  fontSize: 8,
                                                  color:
                                                  WhiteColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total : $currency${getCartLangth(strId: "${storeList[index].storeID}").toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: BlackColor,
                                        fontFamily:
                                        FontFamily.gilroyBlack),
                                  ),
                                  ElevatedButton(
                                      style:
                                      ElevatedButton.styleFrom(
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                10),
                                          ),
                                          backgroundColor:
                                          blueColor),
                                      onPressed: () async {
                                        catDetailsController.strId =
                                            storeList[index]
                                                .storeID ??
                                                "";
                                        await storeDataContoller
                                            .getStoreData(
                                            storeId:
                                            storeList[index]
                                                .storeID);
                                        save("changeIndex", true);
                                        homePageController.isback =
                                        "1";
                                        Get.to(YourCartScreen(
                                            CartStatus: "1"));
                                      },
                                      child: Text(
                                        "View Cart",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: WhiteColor,
                                            fontFamily: FontFamily
                                                .gilroyMedium),
                                      ))
                                ],
                              ),
                            ]),
                      )
                          : const SizedBox();
                    },
                  ),

                ]),
              ),
      );
    });
  }
}
