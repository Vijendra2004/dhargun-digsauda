class SaudaModApprovalModel {
   SaudaApprovalResponse? response;
   String? message;

  SaudaModApprovalModel({
    this.response,
    this.message,
  });

  factory SaudaModApprovalModel.fromJson(Map<String, dynamic> json) {
    return SaudaModApprovalModel(
      response: json['response'] != null
          ? SaudaApprovalResponse.fromJson(json['response'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response?.toJson(),
      'message': message,
    };
  }
}

class SaudaApprovalResponse {
   int? listCount;
   List<SaudaModApprovalItem>? items;

  SaudaApprovalResponse({
    this.listCount,
    this.items,
  });

  factory SaudaApprovalResponse.fromJson(Map<String, dynamic> json) {
    return SaudaApprovalResponse(
      listCount: json['listCount'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SaudaModApprovalItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listCount': listCount,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class SaudaModApprovalItem {
   int? id;
   int? dealerId;
   String? dealerName;
   String? createdByName;
   DateTime? modificationDate;
   DateTime? biddingDate;
   String? saudaNumber;
   int? statusId;
   String? status;

  SaudaModApprovalItem({
    this.id,
    this.dealerId,
    this.dealerName,
    this.createdByName,
    this.modificationDate,
    this.biddingDate,
    this.saudaNumber,
    this.statusId,
    this.status,
  });

  factory SaudaModApprovalItem.fromJson(Map<String, dynamic> json) {
    return SaudaModApprovalItem(
      id: json['id'],
      dealerId: json['dealerId'],
      dealerName: json['dealerName'],
      createdByName: json['createdByName'],
      modificationDate: json['modificationDate'] != null
          ? DateTime.parse(json['modificationDate'])
          : null,
      biddingDate : json['biddingDate'] != null
          ? DateTime.parse(json['biddingDate'])
          : null,
      saudaNumber: json['saudaNumber'],
      statusId: json['statusId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealerId': dealerId,
      'dealerName': dealerName,
      'createdByName': createdByName,
      'modificationDate': modificationDate?.toIso8601String(),
      'biddingDate': biddingDate?.toIso8601String(),
      'saudaNumber': saudaNumber,
      'statusId': statusId,
      'status': status,
    };
  }
}


