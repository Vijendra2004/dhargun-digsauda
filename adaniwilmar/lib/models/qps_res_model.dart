class QPSResModel {
  List<QPSResponseData>? response;
  Null? message;

  QPSResModel({this.response, this.message});

  QPSResModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <QPSResponseData>[];
      json['response'].forEach((v) {
        response!.add(new QPSResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class QPSResponseData {
  int? skuId;
  String? slabName;
  int? fromRange;
  int? toRange;
  double? discount;
  int? skuType;
  int? qpsDiscountId;

  QPSResponseData(
      {this.skuId, this.slabName, this.fromRange, this.toRange, this.discount, this.skuType, this.qpsDiscountId});

  QPSResponseData.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    slabName = json['slabName'];
    fromRange = json['fromRange'];
    toRange = json['toRange'];
    discount = json['discount'];
    skuType = json['skuType'];
    qpsDiscountId = json['qpsDiscountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuId'] = this.skuId;
    data['slabName'] = this.slabName;
    data['fromRange'] = this.fromRange;
    data['toRange'] = this.toRange;
    data['discount'] = this.discount;
    data['skuType'] = this.skuType;
    data['qpsDiscountId'] = this.qpsDiscountId;
    return data;
  }
}
