class SaveSaudaRestReqmodel {
  List<int>? roleIds;
  bool? isActive;
  String? encryptedId;
  int? id;
  bool? dealerIsActive;
  bool? stateIsActive;
  bool? zonalIsActive;
  String? startDateForDistributor;
  String? startDateForST;
  String? startDateForZT;
  bool? postStatus;
  String? postMessage;
  int? loginUserId;
  int? roleId;
  int? roleIdForST;
  int? roleIdForZT;

  List<int>? oilTypeIdsForDistributor;
  List<int>? oilTypeIdsForStateTrader;
  List<int>? oilTypeIdsForZonalTrader;

  List<int>? userIdsForDistributor;
  List<int>? userIdsForStateTrader;
  List<int>? userIdsForZonalTrader;

  List<int>? oilTypeIds;
  String? startDate;

  SaveSaudaRestReqmodel({
    this.roleIds,
    this.isActive,
    this.encryptedId,
    this.id,
    this.dealerIsActive,
    this.stateIsActive,
    this.zonalIsActive,
    this.startDateForDistributor,
    this.startDateForST,
    this.startDateForZT,
    this.postStatus,
    this.postMessage,
    this.loginUserId,
    this.roleId,
    this.roleIdForST,
    this.roleIdForZT,
    this.oilTypeIdsForDistributor,
    this.oilTypeIdsForStateTrader,
    this.oilTypeIdsForZonalTrader,
    this.userIdsForDistributor,
    this.userIdsForStateTrader,
    this.userIdsForZonalTrader,
    this.oilTypeIds,
    this.startDate,
  });

  factory SaveSaudaRestReqmodel.fromJson(Map<String, dynamic> json) {
    return SaveSaudaRestReqmodel(
      roleIds:
      json['roleIds'] != null ? List<int>.from(json['roleIds']) : null,
      isActive: json['isActive'],
      encryptedId: json['encryptedId'],
      id: json['id'],
      dealerIsActive: json['dealerIsActive'],
      stateIsActive: json['stateIsActive'],
      zonalIsActive: json['zonalIsActive'],
      startDateForDistributor: json['startDateForDistributor'],
      startDateForST: json['startDateForST'],
      startDateForZT: json['startDateForZT'],
      postStatus: json['postStatus'],
      postMessage: json['postMessage'],
      loginUserId: json['loginUserId'],
      roleId: json['roleId'],
      roleIdForST: json['roleIdForST'],
      roleIdForZT: json['roleIdForZT'],

      oilTypeIdsForDistributor: json['oilTypeIdsForDistributor'] != null
          ? List<int>.from(json['oilTypeIdsForDistributor'])
          : null,

      oilTypeIdsForStateTrader: json['oilTypeIdsForStateTrader'] != null
          ? List<int>.from(json['oilTypeIdsForStateTrader'])
          : null,

      oilTypeIdsForZonalTrader: json['oilTypeIdsForZonalTrader'] != null
          ? List<int>.from(json['oilTypeIdsForZonalTrader'])
          : null,

      userIdsForDistributor: json['userIdsForDistributor'] != null
          ? List<int>.from(json['userIdsForDistributor'])
          : null,

      userIdsForStateTrader: json['userIdsForStateTrader'] != null
          ? List<int>.from(json['userIdsForStateTrader'])
          : null,

      userIdsForZonalTrader: json['userIdsForZonalTrader'] != null
          ? List<int>.from(json['userIdsForZonalTrader'])
          : null,

      oilTypeIds: json['oilTypeIds'] != null
          ? List<int>.from(json['oilTypeIds'])
          : null,

      startDate: json['startDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "roleIds": roleIds,
      "isActive": isActive,
      "encryptedId": encryptedId,
      "id": id,
      "dealerIsActive": dealerIsActive,
      "stateIsActive": stateIsActive,
      "zonalIsActive": zonalIsActive,
      "startDateForDistributor": startDateForDistributor,
      "startDateForST": startDateForST,
      "startDateForZT": startDateForZT,
      "postStatus": postStatus,
      "postMessage": postMessage,
      "loginUserId": loginUserId,
      "roleId": roleId,
      "roleIdForST": roleIdForST,
      "roleIdForZT": roleIdForZT,
      "oilTypeIdsForDistributor": oilTypeIdsForDistributor,
      "oilTypeIdsForStateTrader": oilTypeIdsForStateTrader,
      "oilTypeIdsForZonalTrader": oilTypeIdsForZonalTrader,
      "userIdsForDistributor": userIdsForDistributor,
      "userIdsForStateTrader": userIdsForStateTrader,
      "userIdsForZonalTrader": userIdsForZonalTrader,
      "oilTypeIds": oilTypeIds,
      "startDate": startDate,
    };
  }
}
