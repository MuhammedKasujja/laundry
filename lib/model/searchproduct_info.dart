// To parse this JSON data, do
//
//     final searchProductInfo = searchProductInfoFromJson(jsonString);

import 'dart:convert';

SearchProductInfo searchProductInfoFromJson(String str) =>
    SearchProductInfo.fromJson(json.decode(str));

String searchProductInfoToJson(SearchProductInfo data) =>
    json.encode(data.toJson());

class SearchProductInfo {
  List<SearchDatum> searchData;
  String responseCode;
  String result;
  String responseMsg;

  SearchProductInfo({
    required this.searchData,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory SearchProductInfo.fromJson(Map<String, dynamic> json) =>
      SearchProductInfo(
        searchData: List<SearchDatum>.from(
            json["SearchData"].map((x) => SearchDatum.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "SearchData": List<dynamic>.from(searchData.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class SearchDatum {
  String productId;
  String catid;
  String productTitle;
  String productImg;
  List<ProductInfo> productInfo;

  SearchDatum({
    required this.productId,
    required this.catid,
    required this.productTitle,
    required this.productImg,
    required this.productInfo,
  });

  factory SearchDatum.fromJson(Map<String, dynamic> json) => SearchDatum(
        productId: json["product_id"],
        catid: json["catid"],
        productTitle: json["product_title"],
        productImg: json["product_img"],
        productInfo: List<ProductInfo>.from(
            json["product_info"].map((x) => ProductInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "catid": catid,
        "product_title": productTitle,
        "product_img": productImg,
        "product_info": List<dynamic>.from(productInfo.map((x) => x.toJson())),
      };
}

class ProductInfo {
  String attributeId;
  String normalPrice;
  String title;
  String productDiscount;
  String productOutStock;

  ProductInfo({
    required this.attributeId,
    required this.normalPrice,
    required this.title,
    required this.productDiscount,
    required this.productOutStock,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        attributeId: json["attribute_id"],
        normalPrice: json["normal_price"],
        title: json["title"],
        productDiscount: json["product_discount"],
        productOutStock: json["Product_Out_Stock"],
      );

  Map<String, dynamic> toJson() => {
        "attribute_id": attributeId,
        "normal_price": normalPrice,
        "title": title,
        "product_discount": productDiscount,
        "Product_Out_Stock": productOutStock,
      };
}
