class SaudaApprovalSkuList {
  int? skuId; // Added
  String? skuName;
  double? quantity;
  double? quantityInMT;
  double? pricePercase;

  SaudaApprovalSkuList({this.skuId, this.skuName, this.quantity, this.quantityInMT, this.pricePercase});

  SaudaApprovalSkuList.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId']; // Added
    skuName = json['skuName'];
    quantity = json['quantity'] != null ? json['quantity'].toDouble() : null;
    quantityInMT = json['quantityInMT'] != null ? json['quantityInMT'].toDouble() : null;
    pricePercase = json['pricePercase'] != null ? json['pricePercase'].toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId; // Added
    data['skuName'] = skuName;
    data['quantity'] = quantity;
    data['quantityInMT'] = quantityInMT;
    data['pricePercase'] = pricePercase;
    return data;
  }
}