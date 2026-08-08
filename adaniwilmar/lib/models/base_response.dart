class BaseResponse {
  dynamic response;
  String successMessage = "";

  BaseResponse({this.response, required this.successMessage});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    successMessage = json['successMessage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response.toJson();
      data['successMessage'] = successMessage;
    }
    return data;
  }
}
