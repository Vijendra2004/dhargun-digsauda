class LiftingResponse {
  int? dealerId;
  String? dealer;
  int? shipToPartyId;
  String? shipToParty;
  int? totalLiftingCount;

  LiftingResponse(
      {this.dealerId,
      this.dealer,
      this.shipToPartyId,
      this.shipToParty,
      this.totalLiftingCount});

  LiftingResponse.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    shipToPartyId = json['shipToPartyId'];
    shipToParty = json['shipToParty'];
    totalLiftingCount = json['totalLiftingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['shipToPartyId'] = shipToPartyId;
    data['shipToParty'] = shipToParty;
    data['totalLiftingCount'] = totalLiftingCount;
    return data;
  }
}
