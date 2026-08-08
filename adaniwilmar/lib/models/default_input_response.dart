class DefaultInputResponse {
  int? salesOrganizationId;
  int? distrinbutionChannelId;
  int? divisionId;
  int? stateId;
  int? plantId;

  DefaultInputResponse(
      {this.salesOrganizationId,
        this.distrinbutionChannelId,
        this.divisionId,
        this.stateId,
        this.plantId});

  DefaultInputResponse.fromJson(Map<String, dynamic> json) {
    salesOrganizationId = json['salesOrganizationId'];
    distrinbutionChannelId = json['distrinbutionChannelId'];
    divisionId = json['divisionId'];
    stateId = json['stateId'];
    plantId = json['plantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesOrganizationId'] = this.salesOrganizationId;
    data['distrinbutionChannelId'] = this.distrinbutionChannelId;
    data['divisionId'] = this.divisionId;
    data['stateId'] = this.stateId;
    data['plantId'] = this.plantId;
    return data;
  }
}
