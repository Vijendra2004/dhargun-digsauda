class toSkuResponseModel {
  final List<ToSkuItemResp> response;
  final String? message;

  toSkuResponseModel({
    required this.response,
    this.message,
  });

  factory toSkuResponseModel.fromJson(Map<String, dynamic> json) {
    return toSkuResponseModel(
      response: (json['response'] as List)
          .map((e) => ToSkuItemResp.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
class ToSkuItemResp {
  int? skuId;
  String? skuName;
  String? code;
  double? caseToMetricTonValue;
  double? unit;

  ToSkuItemResp({
    this.skuId,
    this.skuName,
    this.code,
    this.caseToMetricTonValue,
    this.unit,
  });

  factory ToSkuItemResp.fromJson(Map<String, dynamic> json) {
    return ToSkuItemResp(
      skuId: json['skuId'],
      skuName: json['skuName'],
      code: json['code'],
      caseToMetricTonValue: (json['caseToMetricTonValue'] as num).toDouble(),
      unit: (json['unit'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skuId': skuId,
      'skuName': skuName,
      'code': code,
      'caseToMetricTonValue': caseToMetricTonValue,
      'unit': unit,
    };
  }
}
