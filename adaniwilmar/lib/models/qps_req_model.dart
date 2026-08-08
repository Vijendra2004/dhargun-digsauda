class QPSReqModel {
  List<SkuDetails>? skuDetails;
  int? dealerId = 0;

  QPSReqModel({this.skuDetails,this.dealerId});

  QPSReqModel.fromJson(Map<String, dynamic> json) {
    dealerId = json['DealerId'];
    if (json['skuDetails'] != null) {
      skuDetails = <SkuDetails>[];
      json['skuDetails'].forEach((v) {
        skuDetails!.add(new SkuDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DealerId'] = this.dealerId;
    if (this.skuDetails != null) {
      data['skuDetails'] = this.skuDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkuDetails {
  int? skuId;
  double? quantity;

  SkuDetails({this.skuId, this.quantity});

  SkuDetails.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuId'] = this.skuId;
    data['quantity'] = this.quantity;
    return data;
  }

/*  Map<String, dynamic> toMap() {
    return {
      'skuId': skuId,
      'quantity': quantity,
    };
  }

  List<Map<String, dynamic>> convertToArrayOfMaps(List<SkuDetails> objects) {
    List<Map<String, dynamic>> maps = [];
    for (var object in objects) {
      maps.add({...object.toMap()});
    }
    return maps;
  }*/
}
