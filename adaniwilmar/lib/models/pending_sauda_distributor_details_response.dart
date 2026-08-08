class PendingSaudaList {
  String? biddingDate;
  List<SaudaListOutputs>? saudaListOutputs;

  PendingSaudaList({this.biddingDate, this.saudaListOutputs});

  PendingSaudaList.fromJson(Map<String, dynamic> json) {
    biddingDate = json['biddingDate'];
    if (json['saudaListOutputs'] != null) {
      saudaListOutputs = <SaudaListOutputs>[];
      json['saudaListOutputs'].forEach((v) {
        saudaListOutputs!.add(new SaudaListOutputs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biddingDate'] = this.biddingDate;
    if (this.saudaListOutputs != null) {
      data['saudaListOutputs'] =
          this.saudaListOutputs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaudaListOutputs {
  int? saudaId;
  int? saudaOrderId;
  String? biddingDate;
  String? dealerName;
  int? dealerId;
  double? totalQty;
  double? totalAmt;
  String? deliveryLocation;
  String? plantOrDepot;
  String? incoTerms;
  String? saudaNo;
  String? saudaNumber;

  SaudaListOutputs(
      {this.saudaId,
        this.saudaOrderId,
        this.biddingDate,
        this.dealerName,
        this.totalQty,
        this.totalAmt,
        this.deliveryLocation,
        this.plantOrDepot,
        this.incoTerms,
        this.saudaNo,
        this.saudaNumber,
      this.dealerId});

  SaudaListOutputs.fromJson(Map<String, dynamic> json) {
    saudaId = json['saudaId'];
    saudaOrderId = json['saudaOrderId'];
    biddingDate = json['biddingDate'];
    dealerName = json['dealerName'];
    totalQty = json['totalQty'];
    totalAmt = json['totalAmt'];
    deliveryLocation = json['deliveryLocation'];
    plantOrDepot = json['plantOrDepot'];
    incoTerms = json['incoTerms'];
    saudaNo = json['saudaNo'];
    saudaNumber = json['saudaNumber'];
    dealerId = json['dealerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saudaId'] = this.saudaId;
    data['saudaOrderId'] = this.saudaOrderId;
    data['biddingDate'] = this.biddingDate;
    data['dealerName'] = this.dealerName;
    data['totalQty'] = this.totalQty;
    data['totalAmt'] = this.totalAmt;
    data['deliveryLocation'] = this.deliveryLocation;
    data['plantOrDepot'] = this.plantOrDepot;
    data['incoTerms'] = this.incoTerms;
    data['saudaNo'] = this.saudaNo;
    data['saudaNumber'] = this.saudaNumber;
    data['dealerId'] = this.dealerId;
    return data;
  }
}