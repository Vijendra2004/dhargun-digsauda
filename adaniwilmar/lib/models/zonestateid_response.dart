class ActiveStateResponse {
  int? stateId;
  String? stateName;

  ActiveStateResponse({this.stateId, this.stateName});

  ActiveStateResponse.fromJson(Map<String, dynamic> json) {
    stateId = json['StateId'];
    stateName = json['StateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StateId'] = this.stateId;
    data['StateName'] = this.stateName;
    return data;
  }
}