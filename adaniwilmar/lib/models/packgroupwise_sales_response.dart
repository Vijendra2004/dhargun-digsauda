class PackGroupwiseSales {
  int? dealerId;
  String? dealer;
  String? townName;
  double? target;
  double? achievement;

  PackGroupwiseSales(
      {this.dealerId,
      this.dealer,
      this.townName,
      this.target,
      this.achievement});

  PackGroupwiseSales.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    townName = json['townName'];
    target = json['target'];
    achievement = json['achievement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['townName'] = townName;
    data['target'] = target;
    data['achievement'] = achievement;
    return data;
  }
}
