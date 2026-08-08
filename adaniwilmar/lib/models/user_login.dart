class UserLogin {
  String mobileNumber = "";
  String password = "";

  // bool isRequestFromWeb;
  int verticalId = 1;
  bool isRequestFromWeb = false;
  String email = "";

  UserLogin(
      {this.mobileNumber = "",
      this.password = "",
      // this.isRequestFromWeb
      this.verticalId = 1,
      this.isRequestFromWeb = false,
      this.email = ""});

  UserLogin.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    password = json['password'];
    //isRequestFromWeb = json['IsRequestFromWeb'];
    verticalId = json['verticalId'];
    isRequestFromWeb = json['isRequestFromWeb'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['password'] = password;
    //data['IsRequestFromWeb'] = this.isRequestFromWeb;
    data['verticalId'] = verticalId;
    data['isRequestFromWeb'] = isRequestFromWeb;
    data['email'] = email;

    return data;
  }
}
