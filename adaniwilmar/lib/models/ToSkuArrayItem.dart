class ToSkuArrayItem {
  final double toSkuCase;
  final double toSkuMt;
  final String toSkuName;
  final String toSkuId;
  final double toCasetoMTValue;

  ToSkuArrayItem({
    required this.toSkuCase,
    required this.toSkuMt,
    required this.toSkuName,
    required this.toSkuId,
    required this.toCasetoMTValue,
  });

  factory ToSkuArrayItem.fromJson(Map<String, dynamic> json) {
    return ToSkuArrayItem(
      toSkuCase: (json['toSkuCase'] as num).toDouble(),
      toSkuMt: (json['toSkuMt'] as num).toDouble(),
      toSkuName: json['toSkuName'],
      toSkuId: json['toSkuId'],
      toCasetoMTValue: (json['toCasetoMTValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toSkuCase': toSkuCase,
      'toSkuMt': toSkuMt,
      'toSkuName': toSkuName,
      'toSkuId': toSkuId,
      'toCasetoMTValue': toCasetoMTValue,
    };
  }
}
