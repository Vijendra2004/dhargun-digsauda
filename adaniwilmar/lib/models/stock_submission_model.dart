class SkuDetail {
  final int skuId;
  final String skuName;
  final String skuCode;
  final double quantityInCase;
  final double quantityInMT;

  SkuDetail({
    required this.skuId,
    required this.skuName,
    required this.skuCode,
    required this.quantityInCase,
    required this.quantityInMT,
  });

  factory SkuDetail.fromJson(Map<String, dynamic> json) {
    return SkuDetail(
      skuId: (json['skuId'] as num?)?.toInt() ?? 0,
      skuName: (json['skuName'] as String?)?.trim() ?? '',
      skuCode: (json['skuCode'] as String?)?.trim() ?? '',
      quantityInCase: _parseDouble(json['quantityInCase']),
      quantityInMT: _parseDouble(json['quantityInMT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skuId': skuId,
      'skuName': skuName,
      'skuCode': skuCode,
      'quantityInCase': quantityInCase,
      'quantityInMT': quantityInMT,
    };
  }
}

class StockEntry {
  final int entryId;
  final String reportedDate;
  final int skuCount;
  final double totalQuantityInCase;
  final double totalQuantityInMT;
  final List<SkuDetail> skuDetails;

  StockEntry({
    required this.entryId,
    required this.reportedDate,
    required this.skuCount,
    required this.totalQuantityInCase,
    required this.totalQuantityInMT,
    required this.skuDetails,
  });

  factory StockEntry.fromJson(Map<String, dynamic> json) {
    final skuDetailsJson = json['skuDetails'] as List<dynamic>? ?? [];
    final skuDetails = skuDetailsJson
        .map((item) => SkuDetail.fromJson(item as Map<String, dynamic>))
        .toList();

    return StockEntry(
      entryId: (json['entryId'] as num?)?.toInt() ?? 0,
      reportedDate: (json['reportedDate'] as String?)?.trim() ?? '',
      skuCount: (json['skuCount'] as num?)?.toInt() ?? 0,
      totalQuantityInCase: _parseDouble(json['totalQuantityInCase']),
      totalQuantityInMT: _parseDouble(json['totalQuantityInMT']),
      skuDetails: skuDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryId': entryId,
      'reportedDate': reportedDate,
      'skuCount': skuCount,
      'totalQuantityInCase': totalQuantityInCase,
      'totalQuantityInMT': totalQuantityInMT,
      'skuDetails': skuDetails.map((x) => x.toJson()).toList(),
    };
  }
}

class StockSubmissionResponse {
  final int listCount;
  final List<StockEntry> stockEntries;
  final String? message;

  StockSubmissionResponse({
    required this.listCount,
    required this.stockEntries,
    this.message,
  });

  factory StockSubmissionResponse.fromJson(Map<String, dynamic> json) {
    final stockEntriesJson = json['stockEntries'] as List<dynamic>? ?? [];
    final stockEntries = stockEntriesJson
        .map((item) => StockEntry.fromJson(item as Map<String, dynamic>))
        .toList();

    return StockSubmissionResponse(
      listCount: (json['listCount'] as num?)?.toInt() ?? 0,
      stockEntries: stockEntries,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listCount': listCount,
      'stockEntries': stockEntries.map((x) => x.toJson()).toList(),
      'message': message,
    };
  }
}

/// Helper function to safely parse double values
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
  try {
    return (value as num).toDouble();
  } catch (e) {
    return 0.0;
  }
}

