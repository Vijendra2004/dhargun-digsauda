class SaudaBookedStatusDealerDetail {
  SaudaBookedStatusDealerDetail({this.dealer, this.dealerId, this.dealerCode});
  String? dealer;
  int? dealerId;
  String? dealerCode;
  List<BookedSaudaResponse>? bookedSaudaList;

  SaudaBookedStatusDealerDetail.fromJson(Map<String, dynamic> json) {
    dealer = json['dealer'];
    dealerId = json['dealerId'];
    dealerCode = json['dealerCode'];
    bookedSaudaList = List.from(json['bookedSaudaList'])
        .map((e) => BookedSaudaResponse.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dealer'] = dealer;
    _data['dealerId'] = dealerId;
    _data['dealerCode'] = dealerCode;
    _data['bookedSaudaList'] = bookedSaudaList!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class BookedSaudaResponse {
  int? saudaId;
  int? dealerId;
  String? dealer;
  String? saudaNumber;
  String? approvalUser;
  bool? isBroker;
  String? saudaBookedDate;
  int? oilTypeId;
  String? oilType;
  int? statusId;
  String? status;
  int? saudaOrderId;
  double? totalQuantity;
  List<BookedSaudaDetailDto>? bookedSaudaDetailDto;

  BookedSaudaResponse(
      {this.saudaId,
      this.dealerId,
      this.dealer,
      this.saudaNumber,
      this.approvalUser,
      this.isBroker,
      this.saudaBookedDate,
      this.oilTypeId,
      this.oilType,
      this.statusId,
      this.status,
      this.saudaOrderId,
        this.totalQuantity,
      this.bookedSaudaDetailDto});

  BookedSaudaResponse.fromJson(Map<String, dynamic> json) {
    saudaId = json['saudaId'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    saudaNumber = json['saudaNumber'];
    approvalUser = json['approvalUser'];
    isBroker = json['isBroker'];
    saudaBookedDate = json['saudaBookedDate'];
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    statusId = json['statusId'];
    status = json['status'];
    saudaOrderId = json['saudaOrderId'];
    totalQuantity = json['totalQuantity'];
    if (json['bookedSaudaDetailDto'] != null) {
      bookedSaudaDetailDto = <BookedSaudaDetailDto>[];
      json['bookedSaudaDetailDto'].forEach((v) {
        bookedSaudaDetailDto!.add(BookedSaudaDetailDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saudaId'] = saudaId;
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['saudaNumber'] = saudaNumber;
    data['approvalUser'] = approvalUser;
    data['isBroker'] = isBroker;
    data['saudaBookedDate'] = saudaBookedDate;
    data['oilTypeId'] = oilTypeId;
    data['oilType'] = oilType;
    data['statusId'] = statusId;
    data['status'] = status;
    data['saudaOrderId'] = saudaOrderId;
    data['totalQuantity'] = totalQuantity;
    if (bookedSaudaDetailDto != null) {
      data['bookedSaudaDetailDto'] =
          bookedSaudaDetailDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookedSaudaDetailDto {
  int? oilTypeId;
  String? oilType;
  int? skuCount;

  BookedSaudaDetailDto({this.oilTypeId, this.oilType, this.skuCount});

  BookedSaudaDetailDto.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    skuCount = json['skuCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilTypeId'] = oilTypeId;
    data['oilType'] = oilType;
    data['skuCount'] = skuCount;
    return data;
  }
}
