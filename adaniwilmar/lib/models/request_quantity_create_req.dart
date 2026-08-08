class RequestQuantityCreateReq {
  int? userId;
  int? skuId;
  int? oiltypeId;
  double? quantity;
  int? statusId;
  int? specialtyFatQuantityLimitId;
  int? loginUserId;

  RequestQuantityCreateReq(
      { this.userId,
        this.skuId,
        this.oiltypeId,
        this.quantity,
        this.statusId,
        this.specialtyFatQuantityLimitId,
        this.loginUserId,});

  RequestQuantityCreateReq.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    skuId = json['skuId'];
    oiltypeId = json['oiltypeId'];
    quantity = json['quantity'];
    statusId = json['statusId'];
    specialtyFatQuantityLimitId = json['specialtyFatQuantityLimitId'];
    loginUserId = json['loginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['skuId'] = skuId;
    data['oiltypeId'] = oiltypeId;
    data['quantity'] = quantity;
    data['statusId'] = statusId;
    data['specialtyFatQuantityLimitId'] = specialtyFatQuantityLimitId;
    data['loginUserId'] = loginUserId;
    return data;
  }
}