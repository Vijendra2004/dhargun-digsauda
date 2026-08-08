import 'package:flutter/cupertino.dart';

import '../gmcore/network/GMLogger.dart';

class LoginResponse {
  String loginToken = "";
  int userId = 0;
  String roleId = "";
  int roleTypeId = 0;
  String name = "";
  String profileName = "";
  String email = "";
  bool isUnreadNotificationAvailable = false;
  String lastName = "";
  String mobileNumber = "";
  int genderId = 0;
  String dateOfBirth = "";
  int nationalityId = 0;
  String encryptedId = "";
  String encryptedEmployeeId = "";
  String postStatusMessage = "";
  bool postStatus = false;
  int countryId = 0;
  String countryName = "";
  String dialCode = "";
  int bridgeUserTypeId = 0;
  String bridgeUserType = "";
  int bridgeUserCategoryId = 0;
  String bridgeUserCategoryType = "";
  int customerId = 0;
  String code = "0";
  String teG_AuthAPIUrl = "";
  String teG_clientId = "";
  String teG_clientSecret = "";

  LoginResponse(
      {this.loginToken = "",
      this.userId = 0,
      this.roleId = "",
      this.roleTypeId = 0,
      this.name = "",
      this.profileName = "",
      this.email = "",
      this.isUnreadNotificationAvailable = false,
      this.lastName = "",
      this.mobileNumber = "",
      this.genderId = 0,
      this.dateOfBirth = "",
      this.nationalityId = 0,
      this.encryptedId = "",
      this.encryptedEmployeeId = "",
      this.postStatusMessage = "",
      this.postStatus = false,
      this.countryId = 0,
      this.countryName = "",
      this.dialCode = "",
      this.bridgeUserType = "",
      this.bridgeUserTypeId = 0,
      this.bridgeUserCategoryId = 0,
      this.bridgeUserCategoryType = "",
      this.customerId = 0,
      this.teG_AuthAPIUrl = "",
      this.teG_clientId = "",
      this.teG_clientSecret = "",
      this.code = "0"});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    GMLogger.v("0");
    loginToken = json['loginToken'];
    GMLogger.v("1");
    userId = json['userId'];
    GMLogger.v("11");
    roleId = json['roleId'];
    GMLogger.v("111");
    roleTypeId = json['roleTypeId'];
    GMLogger.v("1111");
    name = json['name'];
    GMLogger.v("11111");
    profileName = json['profileName'] ?? "";
    teG_AuthAPIUrl = json['teG_AuthAPIUrl'] ?? "";
    teG_clientId = json['teG_clientId'] ?? "";
    teG_clientSecret = json['teG_clientSecret'] ?? "";
    GMLogger.v("111111");
    code = json["code"] ?? "0";
    // email = json['email'];
    // isUnreadNotificationAvailable = json['isUnreadNotificationAvailable'];
    // lastName = json['lastName'];
    // mobileNumber = json['mobileNumber'];
    // genderId = json['genderId'];
    // dateOfBirth = json['dateOfBirth'];
    // nationalityId = json['nationalityId'];
    // encryptedId = json['encryptedId'];
    // encryptedEmployeeId = json['encryptedEmployeeId'];
    // postStatusMessage = json['postStatusMessage'];
    // postStatus = json['postStatus'];
    // countryId = json['countryId'];
    // countryName = json['countryName'];
    // dialCode = json['dialCode'];
    // bridgeUserTypeId = json['bridgeUserTypeId'];
    // bridgeUserType = json['bridgeUserType'];
    // bridgeUserCategoryId = json['bridgeUserCategoryId'];
    // bridgeUserCategoryType = json['bridgeUserCategoryType'];
    // customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginToken'] = loginToken;
    data['userId'] = userId;
    data['roleId'] = roleId;
    data['roleTypeId'] = roleTypeId;
    data['name'] = name;
    data['profileName'] = profileName;
    data['email'] = email;
    data['isUnreadNotificationAvailable'] = isUnreadNotificationAvailable;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['genderId'] = genderId;
    data['dateOfBirth'] = dateOfBirth;
    data['nationalityId'] = nationalityId;
    data['encryptedId'] = encryptedId;
    data['encryptedEmployeeId'] = encryptedEmployeeId;
    data['postStatusMessage'] = postStatusMessage;
    data['postStatus'] = postStatus;
    data['countryName'] = countryName;
    data['countryId'] = countryId;
    data['dialCode'] = dialCode;
    data['bridgeUserTypeId'] = bridgeUserTypeId;
    data['bridgeUserType'] = bridgeUserType;
    data['bridgeUserCategoryType'] = bridgeUserCategoryType;
    data['bridgeUserCategoryId'] = bridgeUserCategoryId;
    data['customerId'] = customerId;
    data['code'] = code;
    data['teG_AuthAPIUrl'] = teG_AuthAPIUrl;
    data['teG_clientId'] = teG_clientId;
    data['teG_clientSecret'] = teG_clientSecret;
    return data;
  }
}
