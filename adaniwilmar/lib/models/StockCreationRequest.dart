class StockCreationRequest {
  final int loginUserId;
  final List<StockCreationSkuItem> skuList;

  StockCreationRequest({
    required this.loginUserId,
    required this.skuList,
  });

  factory StockCreationRequest.fromJson(Map<String, dynamic> json) {
    return StockCreationRequest(
      loginUserId: json['LoginUserId'] ?? 0,
      skuList: (json['SkuList'] as List<dynamic>?)
          ?.map((e) => StockCreationSkuItem.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LoginUserId': loginUserId,
      'SkuList': skuList.map((e) => e.toJson()).toList(),
    };
  }
}

class StockCreationSkuItem {
  int skuId;
  double noOfCases;

  StockCreationSkuItem({
    required this.skuId,
    required this.noOfCases,
  });

  factory StockCreationSkuItem.fromJson(Map<String, dynamic> json) {
    return StockCreationSkuItem(
      skuId: json['SkuId'] ?? 0,
      noOfCases: (json['NoOfCases'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SkuId': skuId,
      'NoOfCases': noOfCases,
    };
  }
}