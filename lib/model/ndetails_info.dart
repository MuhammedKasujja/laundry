// To parse this JSON data, do
//
//     final nDetailsInfo = nDetailsInfoFromJson(jsonString);

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

NDetailsInfo nDetailsInfoFromJson(String str) =>
    NDetailsInfo.fromJson(json.decode(str));

String nDetailsInfoToJson(NDetailsInfo data) => json.encode(data.toJson());

class NDetailsInfo {
  OrderProductList orderProductList;
  String responseCode;
  String result;
  String responseMsg;

  NDetailsInfo({
    required this.orderProductList,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory NDetailsInfo.fromJson(Map<String, dynamic> json) => NDetailsInfo(
        orderProductList: OrderProductList.fromJson(json["OrderProductList"]),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "OrderProductList": orderProductList.toJson(),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class OrderProductList {
  String orderId;
  String riderTitle;
  String riderImage;
  String riderMobile;
  DateTime orderDate;
  String pMethodName;
  String customerAddress;
  String customerName;
  String storeTitle;
  String storeImg;
  String storeRate;
  String wallAmt;
  dynamic orderType;
  String storeAddress;
  String customerMobile;
  String storeCharge;
  dynamic commentReject;
  String deliveryCharge;
  DateTime pickupDate;
  String pickupTimeslot;
  String dropTimeslot;
  String couponAmount;
  String orderTotal;
  String orderSubTotal;
  String isRate;
  String orderTransactionId;
  String additionalNote;
  String orderStatus;
  List<OrderProductDatum> orderProductData;

  OrderProductList({
    required this.orderId,
    required this.riderTitle,
    required this.riderImage,
    required this.riderMobile,
    required this.orderDate,
    required this.pMethodName,
    required this.customerAddress,
    required this.customerName,
    required this.storeTitle,
    required this.storeImg,
    required this.storeRate,
    required this.wallAmt,
    required this.orderType,
    required this.storeAddress,
    required this.customerMobile,
    required this.storeCharge,
    required this.commentReject,
    required this.deliveryCharge,
    required this.pickupDate,
    required this.pickupTimeslot,
    required this.dropTimeslot,
    required this.couponAmount,
    required this.orderTotal,
    required this.orderSubTotal,
    required this.isRate,
    required this.orderTransactionId,
    required this.additionalNote,
    required this.orderStatus,
    required this.orderProductData,
  });

  factory OrderProductList.fromJson(Map<String, dynamic> json) =>
      OrderProductList(
        orderId: json["order_id"],
        riderTitle: json["rider_title"],
        riderImage: json["rider_image"],
        riderMobile: json["rider_mobile"],
        orderDate: DateTime.parse(json["order_date"]),
        pMethodName: json["p_method_name"],
        customerAddress: json["customer_address"],
        customerName: json["customer_name"],
        storeTitle: json["store_title"],
        storeImg: json["store_img"],
        storeRate: json["store_rate"],
        wallAmt: json["wall_amt"],
        orderType: json["Order_Type"],
        storeAddress: json["store_address"],
        customerMobile: json["customer_mobile"],
        storeCharge: json["store_charge"],
        commentReject: json["comment_reject"],
        deliveryCharge: json["Delivery_charge"],
        pickupDate: DateTime.parse(json["Pickup_Date"]),
        pickupTimeslot: json["Pickup_Timeslot"],
        dropTimeslot: json["Drop_Timeslot"],
        couponAmount: json["Coupon_Amount"],
        orderTotal: json["Order_Total"],
        orderSubTotal: json["Order_SubTotal"],
        isRate: json["is_rate"],
        orderTransactionId: json["Order_Transaction_id"],
        additionalNote: json["Additional_Note"],
        orderStatus: json["Order_Status"],
        orderProductData: List<OrderProductDatum>.from(
            json["Order_Product_Data"]
                .map((x) => OrderProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "rider_title": riderTitle,
        "rider_image": riderImage,
        "rider_mobile": riderMobile,
        "order_date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "p_method_name": pMethodName,
        "customer_address": customerAddress,
        "customer_name": customerName,
        "store_title": storeTitle,
        "store_img": storeImg,
        "store_rate": storeRate,
        "wall_amt": wallAmt,
        "Order_Type": orderType,
        "store_address": storeAddress,
        "customer_mobile": customerMobile,
        "store_charge": storeCharge,
        "comment_reject": commentReject,
        "Delivery_charge": deliveryCharge,
        "Pickup_Date":
            "${pickupDate.year.toString().padLeft(4, '0')}-${pickupDate.month.toString().padLeft(2, '0')}-${pickupDate.day.toString().padLeft(2, '0')}",
        "Pickup_Timeslot": pickupTimeslot,
        "Drop_Timeslot": dropTimeslot,
        "Coupon_Amount": couponAmount,
        "Order_Total": orderTotal,
        "Order_SubTotal": orderSubTotal,
        "is_rate": isRate,
        "Order_Transaction_id": orderTransactionId,
        "Additional_Note": additionalNote,
        "Order_Status": orderStatus,
        "Order_Product_Data":
            List<dynamic>.from(orderProductData.map((x) => x.toJson())),
      };
}

class OrderProductDatum {
  String productQuantity;
  String productName;
  String productDiscount;
  String productImage;
  String productPrice;
  String productVariation;
  var productTotal;

  OrderProductDatum({
    required this.productQuantity,
    required this.productName,
    required this.productDiscount,
    required this.productImage,
    required this.productPrice,
    required this.productVariation,
    required this.productTotal,
  });

  factory OrderProductDatum.fromJson(Map<String, dynamic> json) =>
      OrderProductDatum(
        productQuantity: json["Product_quantity"],
        productName: json["Product_name"],
        productDiscount: json["Product_discount"],
        productImage: json["Product_image"],
        productPrice: json["Product_price"],
        productVariation: json["Product_variation"],
        productTotal: json["Product_total"],
      );

  Map<String, dynamic> toJson() => {
        "Product_quantity": productQuantity,
        "Product_name": productName,
        "Product_discount": productDiscount,
        "Product_image": productImage,
        "Product_price": productPrice,
        "Product_variation": productVariation,
        "Product_total": productTotal,
      };
}
