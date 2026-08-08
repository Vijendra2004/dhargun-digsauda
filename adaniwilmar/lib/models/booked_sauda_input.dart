class BookedSaudaInput {
  BookedSaudaInput({
    required this.dealerId,
    required this.salesOrganizationIds,
    required this.distributionChannelIds,
    required this.divisionIds,
    required this.loginUserId,
    required this.fromDate,
    required this.toDate,
  });
  late final int dealerId;
  late final List<int> salesOrganizationIds;
  late final List<int> distributionChannelIds;
  late final List<int> divisionIds;
  late final int loginUserId;
  late final String fromDate;
  late final String toDate;

  BookedSaudaInput.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    salesOrganizationIds =
        List.castFrom<dynamic, int>(json['salesOrganizationIds']);
    distributionChannelIds =
        List.castFrom<dynamic, int>(json['distributionChannelIds']);
    divisionIds = List.castFrom<dynamic, int>(json['divisionIds']);
    loginUserId = json['loginUserId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dealerId'] = dealerId;
    _data['salesOrganizationIds'] = salesOrganizationIds;
    _data['distributionChannelIds'] = distributionChannelIds;
    _data['divisionIds'] = divisionIds;
    _data['loginUserId'] = loginUserId;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    return _data;
  }
}
