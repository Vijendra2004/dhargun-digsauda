class DealerStockResponse {
  final List<StockReportItem> response;
  final String? message;

  DealerStockResponse({
    required this.response,
    this.message,
  });

  factory DealerStockResponse.fromJson(Map<String, dynamic> json) {
    return DealerStockResponse(
      response: (json['response'] as List<dynamic>?)
          ?.map((e) => StockReportItem.fromJson(e))
          .toList() ??
          [],
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class StockReportItem {
  final int skuId;
  final String skuName;
  final String skuCode;
  final double quantityInCase;
  final double quantityInMT;
  final DateTime reportedDate;

  StockReportItem({
    required this.skuId,
    required this.skuName,
    required this.skuCode,
    required this.quantityInCase,
    required this.quantityInMT,
    required this.reportedDate,
  });

  factory StockReportItem.fromJson(Map<String, dynamic> json) {
    return StockReportItem(
      skuId: json['skuId'] ?? 0,
      skuName: json['skuName'] ?? '',
      skuCode: json['skuCode'] ?? '',
      quantityInCase: (json['quantityInCase'] as num?)?.toDouble() ?? 0.0,
      quantityInMT: (json['quantityInMT'] as num?)?.toDouble() ?? 0.0,
      reportedDate: json['reportedDate'] != null
          ? DateTime.parse(json['reportedDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skuId': skuId,
      'skuName': skuName,
      'skuCode': skuCode,
      'quantityInCase': quantityInCase,
      'quantityInMT': quantityInMT,
      'reportedDate': reportedDate.toIso8601String(),
    };
  }
}