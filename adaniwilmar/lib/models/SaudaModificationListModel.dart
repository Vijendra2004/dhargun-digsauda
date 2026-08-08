class SaudaModificationListModel {
   SaudaModListData? response;
   String? message;

  SaudaModificationListModel({
    this.response,
    this.message,
  });

  factory SaudaModificationListModel.fromJson(Map<String, dynamic> json) {
    return SaudaModificationListModel(
      response: json['response'] != null
          ? SaudaModListData.fromJson(json['response'])
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

class SaudaModListData {
  List<DealerGroup>? pendingList = [];
  List<DealerGroup>? approvedList = [];

  SaudaModListData({
    this.pendingList,
    this.approvedList,
  });

  factory SaudaModListData.fromJson(Map<String, dynamic> json) {
    return SaudaModListData(
      pendingList: (json['pendingList'] as List?)
          ?.map((e) => DealerGroup.fromJson(e))
          .toList(),
      approvedList: (json['approvedList'] as List?)
          ?.map((e) => DealerGroup.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingList': pendingList?.map((e) => e.toJson()).toList(),
      'approvedList': approvedList?.map((e) => e.toJson()).toList(),
    };
  }
}

class DealerGroup {
   int? dealerId;
   String? dealerName;
   List<SaudaModListItem>? items;

  DealerGroup({
    this.dealerId,
    this.dealerName,
    this.items,
  });

  factory DealerGroup.fromJson(Map<String, dynamic> json) {
    return DealerGroup(
      dealerId: json['dealerId'],
      dealerName: json['dealerName'],
      items:
          (json['items'] as List?)?.map((e) => SaudaModListItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dealerId': dealerId,
      'dealerName': dealerName,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class SaudaModListItem {
   int? id;
   int? dealerId;
   String? dealerName;
   String? createdByName;
   String? modificationDate;
   String? saudaNumber;
   int? statusId;
   String? status;
   String? approvalRejectedByName;

  SaudaModListItem({
    this.id,
    this.dealerId,
    this.dealerName,
    this.createdByName,
    this.modificationDate,
    this.saudaNumber,
    this.statusId,
    this.status,
    this.approvalRejectedByName,
  });

  factory SaudaModListItem.fromJson(Map<String, dynamic> json) {
    return SaudaModListItem(
      id: json['id'],
      dealerId: json['dealerId'],
      dealerName: json['dealerName'],
      createdByName: json['createdByName'],
      modificationDate: json['modificationDate'],
      saudaNumber: json['saudaNumber'],
      statusId: json['statusId'],
      status: json['status'],
      approvalRejectedByName: json['approvalRejectedByName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealerId': dealerId,
      'dealerName': dealerName,
      'createdByName': createdByName,
      'modificationDate': modificationDate,
      'saudaNumber': saudaNumber,
      'statusId': statusId,
      'status': status,
      'approvalRejectedByName': approvalRejectedByName,
    };
  }
}
