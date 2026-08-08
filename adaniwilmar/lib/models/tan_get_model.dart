class TanNumberResponseModel {
  String? tanNumber;
  int? userId;
  String? code;

  TanNumberResponseModel({this.tanNumber, this.userId, this.code});

  TanNumberResponseModel.fromJson(Map<String, dynamic> json) {
    tanNumber = json['tanNumber'];
    userId = json['userId'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tanNumber'] = this.tanNumber;
    data['userId'] = this.userId;
    data['code'] = this.code;
    return data;
  }
}