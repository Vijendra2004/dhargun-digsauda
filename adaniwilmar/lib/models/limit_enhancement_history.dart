class LimitEnhancementHistory {
  int? dealerId;
  String? dealerName;
  List<Saudahistory>? saudahistory;

  LimitEnhancementHistory({this.dealerId, this.dealerName, this.saudahistory});

  LimitEnhancementHistory.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    if (json['saudahistory'] != null) {
      saudahistory = <Saudahistory>[];
      json['saudahistory'].forEach((v) {
        saudahistory!.add(new Saudahistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dealerId'] = this.dealerId;
    data['dealerName'] = this.dealerName;
    if (this.saudahistory != null) {
      data['saudahistory'] = this.saudahistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Saudahistory {
  int? id;
  String? requestDate;
  String? limitRequestNo;
  String? status;
  int? statusId;
  String? remarks;
  double? requestQuantityLimit;

  Saudahistory(
      {this.id,
        this.requestDate,
        this.limitRequestNo,
        this.status,
        this.statusId,
        this.remarks,
        this.requestQuantityLimit});

  Saudahistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestDate = json['requestDate'];
    limitRequestNo = json['limitRequestNo'];
    status = json['status'];
    statusId = json['statusId'];
    remarks = json['remarks'];
    requestQuantityLimit = json['requestQuantityLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestDate'] = this.requestDate;
    data['limitRequestNo'] = this.limitRequestNo;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['remarks'] = this.remarks;
    data['requestQuantityLimit'] = this.requestQuantityLimit;
    return data;
  }
}
