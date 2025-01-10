// To parse this JSON data, do
//
//     final nOrderInfo = nOrderInfoFromJson(jsonString);

import 'dart:convert';

NOrderInfo nOrderInfoFromJson(String str) =>
    NOrderInfo.fromJson(json.decode(str));

String nOrderInfoToJson(NOrderInfo data) => json.encode(data.toJson());

class NOrderInfo {
  List<OrderHistory> orderHistory;
  String responseCode;
  String result;
  String responseMsg;

  NOrderInfo({
    required this.orderHistory,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory NOrderInfo.fromJson(Map<String, dynamic> json) => NOrderInfo(
        orderHistory: List<OrderHistory>.from(
            json["OrderHistory"].map((x) => OrderHistory.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "OrderHistory": List<dynamic>.from(orderHistory.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class OrderHistory {
  String id;

  String status;
  DateTime odate;
  String oTotal;
  String storeTitle;
  String storeImg;
  String storeRate;
  String storeAddress;
  String deliveryName;

  OrderHistory({
    required this.id,
    required this.status,
    required this.odate,
    required this.oTotal,
    required this.storeTitle,
    required this.storeImg,
    required this.storeRate,
    required this.storeAddress,
    required this.deliveryName,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        id: json["id"].toString(),
        status: json["status"].toString(),
        odate: DateTime.parse(json["odate"]),
        oTotal: json["o_total"].toString(),
        storeTitle: json["store_title"].toString(),
        storeImg: json["store_img"].toString(),
        storeRate: json["store_rate"].toString(),
        storeAddress: json["store_address"].toString(),
        deliveryName: json["Delivery_name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "odate":
            "${odate.year.toString().padLeft(4, '0')}-${odate.month.toString().padLeft(2, '0')}-${odate.day.toString().padLeft(2, '0')}",
        "o_total": oTotal,
        "store_title": storeTitle,
        "store_img": storeImg,
        "store_rate": storeRate,
        "store_address": storeAddress,
        "Delivery_name": deliveryName,
      };
}
