class Contract {
  int? id;
  int? userId;
  int? distributionChannelId;
  int? divisionId;
  int? salesOrganizationId;
  String? saudaNumber;
  int? saudaOrderId;
  double? availableQuantity;
  double? soOpenQuantity;

  Contract({this.id, this.userId, this.saudaNumber, this.availableQuantity, this.soOpenQuantity});

  Contract.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    distributionChannelId = json['distributionChannelId'];
    divisionId = json['divisionId'];
    salesOrganizationId = json['salesOrganizationId'];
    saudaNumber = json['saudaNumber'];
    saudaOrderId = json['saudaOrderId'];
    availableQuantity = json['availableQuantity'];
    soOpenQuantity = json['soOpenQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['distributionChannelId'] = distributionChannelId;
    data['divisionId'] = divisionId;
    data['salesOrganizationId'] = salesOrganizationId;
    data['saudaNumber'] = saudaNumber;
    data['saudaOrderId'] = saudaOrderId;
    data['availableQuantity'] = availableQuantity;
    data['soOpenQuantity'] = soOpenQuantity;
    return data;
  }
}
