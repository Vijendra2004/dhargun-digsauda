class BaseRequest {
  int loginUserId = 0;

  BaseRequest({required this.loginUserId});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    loginUserId = json['loginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginUserId'] = loginUserId;
    return data;
  }
}
