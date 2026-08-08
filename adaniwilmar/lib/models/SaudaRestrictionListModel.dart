class SaudaRestrictionListModel {
  List<SaudaItem>? response;
  String? message;

  SaudaRestrictionListModel({this.response, this.message});

  factory SaudaRestrictionListModel.fromJson(Map<String, dynamic> json) {
    return SaudaRestrictionListModel(
      response: json['response'] != null
          ? List<SaudaItem>.from(
          json['response'].map((x) => SaudaItem.fromJson(x)))
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.map((x) => x.toJson()).toList(),
    "message": message,
  };
}

class SaudaItem {
  int? id;
  String? encryptedId;
  int? roleId;
  String? roleName;
  List<int>? oilTypeIds;
  String? oilTypeNames;
  List<int>? userIds;
  String? userNames;
  bool? isActive;
  String? startDate; // use DateTime? if you want to parse
  int? loginUserId;

  SaudaItem({
    this.id,
    this.encryptedId,
    this.roleId,
    this.roleName,
    this.oilTypeIds,
    this.oilTypeNames,
    this.userIds,
    this.userNames,
    this.isActive,
    this.startDate,
    this.loginUserId,
  });

  factory SaudaItem.fromJson(Map<String, dynamic> json) {
    return SaudaItem(
      id: json['id'],
      encryptedId: json['encryptedId'],
      roleId: json['roleId'],
      roleName: json['roleName'],
      oilTypeIds: json['oilTypeIds'] != null
          ? List<int>.from(json['oilTypeIds'])
          : null,
      oilTypeNames: json['oilTypeNames'],
      userIds: json['userIds'] != null
          ? List<int>.from(json['userIds'])
          : null,
      userNames: json['userNames'],
      isActive: json['isActive'],
      startDate: json['startDate'],
      loginUserId: json['loginUserId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "encryptedId": encryptedId,
    "roleId": roleId,
    "roleName": roleName,
    "oilTypeIds": oilTypeIds,
    "oilTypeNames": oilTypeNames,
    "userIds": userIds,
    "userNames": userNames,
    "isActive": isActive,
    "startDate": startDate,
    "loginUserId": loginUserId,
  };
}
