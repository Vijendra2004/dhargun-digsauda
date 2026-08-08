class GamificationFieldsData {
  List<LabelListDto>? labelListDto;
  List<GamificationDashboardDto>? gamificationDashboardDto;

  GamificationFieldsData({this.labelListDto, this.gamificationDashboardDto});

  GamificationFieldsData.fromJson(Map<String, dynamic> json) {
    if (json['labelListDto'] != null) {
      labelListDto = <LabelListDto>[];
      json['labelListDto'].forEach((v) {
        labelListDto!.add(LabelListDto.fromJson(v));
      });
    }
    if (json['gamificationDashboardDto'] != null) {
      gamificationDashboardDto = <GamificationDashboardDto>[];
      json['gamificationDashboardDto'].forEach((v) {
        gamificationDashboardDto!.add(GamificationDashboardDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (labelListDto != null) {
      data['labelListDto'] = labelListDto!.map((v) => v.toJson()).toList();
    }
    if (gamificationDashboardDto != null) {
      data['gamificationDashboardDto'] = gamificationDashboardDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabelListDto {
  String? targetMT;
  String? achievementMT;
  String? balanceTargetMT;
  String? pointsEarned;
  String? currentSlab;
  String? nextSlab;
  String? balancePointForNextSlab;
  String? totalEarningRs;
  String? message;
  List<GamificationDynamicModel>? dynamicValues = [];
  List<GamificationDynamicModel>? dynamicListValues = [];

  LabelListDto(
      {this.targetMT,
      this.achievementMT,
      this.balanceTargetMT,
      this.pointsEarned,
      this.currentSlab,
      this.nextSlab,
      this.balancePointForNextSlab,
      this.totalEarningRs,
      this.message,
      this.dynamicValues,
      this.dynamicListValues});

  LabelListDto.fromJson(Map<String, dynamic> json) {
    targetMT = json['Target (MT)'];
    achievementMT = json[' Achievement (MT)'];
    balanceTargetMT = json[' Balance Target (MT)'];
    pointsEarned = json[' Points Earned'];
    currentSlab = json[' Current Slab'];
    nextSlab = json[' Next Slab'];
    balancePointForNextSlab = json[' Balance Point for next slab'];
    totalEarningRs = json[' Total Earning (Rs.)'];
    message = json[' Message'];
    dynamicValues = [];
    dynamicListValues = [];
    json.forEach((key, value) {
      GamificationDynamicModel gamificationDynamicModel = GamificationDynamicModel();
      String result = key.trim().replaceAll(RegExp(r' \s+'), ' ');
      bool isNumber = isNumeric(value);

      if (isNumber) {
        String val = value;
        if (val.contains('.')) {
          List<String> list = value.split('.');
          if (list.length > 1) {
            String lenCount = list[1];
            if (lenCount.length > 3) {
              double inDouble = double.parse(value); // 2.35
              gamificationDynamicModel.value = inDouble.toStringAsFixed(3);
            } else {
              gamificationDynamicModel.value = value;
            }
          } else {
            gamificationDynamicModel.value = value;
          }
        } else {
          gamificationDynamicModel.value = value;
        }
      } else {
        gamificationDynamicModel.value = value;
      }
      if(result.toLowerCase() == "message"){
        gamificationDynamicModel.label = "Udaan Reward";
      }else{
        gamificationDynamicModel.label = result;
      }
      //dynamicValues?.add(gamificationDynamicModel);
      if (value.toString().length > 15) {
        dynamicListValues?.add(gamificationDynamicModel);
      } else {
        dynamicValues?.add(gamificationDynamicModel);
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Target (MT)'] = targetMT;
    data[' Achievement (MT)'] = achievementMT;
    data[' Balance Target (MT)'] = balanceTargetMT;
    data[' Points Earned'] = pointsEarned;
    data[' Current Slab'] = currentSlab;
    data[' Next Slab'] = nextSlab;
    data[' Balance Point for next slab'] = balancePointForNextSlab;
    data[' Total Earning (Rs.)'] = totalEarningRs;
    data[' Message'] = message;
    return data;
  }
}

class GamificationDashboardDto {
  int? id;
  int? encryptedId;
  int? loginUserId;
  bool? isActive;
  int? postMessage;
  bool? postStatus;
  int? distributorId;
  String? distributorCode;
  double? distributorTargetMT;
  double? distributorAchievementTillN1MT;
  double? remainingTargetToAchieveMT;
  int? earnedPoints;
  String? currentSlab;
  String? nextHigherSlab;
  double? pointsToBeEarnedToReachNextHigherSlab;
  double? totalEarningsInRs;
  String? specialBonusMessage;
  int? wholePointsStructure;
  bool? isDiamond;

  GamificationDashboardDto(
      {this.id,
      this.encryptedId,
      this.loginUserId,
      this.isActive,
      this.postMessage,
      this.postStatus,
      this.distributorId,
      this.distributorCode,
      this.distributorTargetMT,
      this.distributorAchievementTillN1MT,
      this.remainingTargetToAchieveMT,
      this.earnedPoints,
      this.currentSlab,
      this.nextHigherSlab,
      this.pointsToBeEarnedToReachNextHigherSlab,
      this.totalEarningsInRs,
      this.specialBonusMessage,
      this.wholePointsStructure,
      this.isDiamond});

  GamificationDashboardDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedId = json['encryptedId'];
    loginUserId = json['loginUserId'];
    isActive = json['isActive'];
    postMessage = json['postMessage'];
    postStatus = json['postStatus'];
    distributorId = json['distributorId'];
    distributorCode = json['distributorCode'];
    distributorTargetMT = json['distributorTargetMT'];
    distributorAchievementTillN1MT = json['distributorAchievementTillN1MT'];
    remainingTargetToAchieveMT = json['remainingTargetToAchieveMT'];
    earnedPoints = json['earnedPoints'];
    currentSlab = json['currentSlab'];
    nextHigherSlab = json['nextHigherSlab'];
    pointsToBeEarnedToReachNextHigherSlab = json['pointsToBeEarnedToReachNextHigherSlab'];
    totalEarningsInRs = json['totalEarningsInRs'];
    specialBonusMessage = json['specialBonusMessage'];
    wholePointsStructure = json['wholePointsStructure'];
    isDiamond = json['isDiamond'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['encryptedId'] = encryptedId;
    data['loginUserId'] = loginUserId;
    data['isActive'] = isActive;
    data['postMessage'] = postMessage;
    data['postStatus'] = postStatus;
    data['distributorId'] = distributorId;
    data['distributorCode'] = distributorCode;
    data['distributorTargetMT'] = distributorTargetMT;
    data['distributorAchievementTillN1MT'] = distributorAchievementTillN1MT;
    data['remainingTargetToAchieveMT'] = remainingTargetToAchieveMT;
    data['earnedPoints'] = earnedPoints;
    data['currentSlab'] = currentSlab;
    data['nextHigherSlab'] = nextHigherSlab;
    data['pointsToBeEarnedToReachNextHigherSlab'] = pointsToBeEarnedToReachNextHigherSlab;
    data['totalEarningsInRs'] = totalEarningsInRs;
    data['specialBonusMessage'] = specialBonusMessage;
    data['wholePointsStructure'] = wholePointsStructure;
    data['isDiamond'] = isDiamond;
    return data;
  }
}

class GamificationDynamicModel {
  String? label;
  String? value;

  GamificationDynamicModel({this.label, this.value});
}

class ProductCategory {
  ProductCategory(this.productName, this.line1, this.l2, this.l3, this.l3B, this.foodBP, this.bakery);

  final String productName;
  final String line1;
  final String l2;
  final String l3;
  final String l3B;
  final String foodBP;
  final String bakery;
}

class GamificationDashboardDynamicFields {
  final String label;
  final String value;

  GamificationDashboardDynamicFields(this.label, this.value);

  List<GamificationDashboardDynamicFields> getDynamicValue() {
    final List<GamificationDashboardDynamicFields> _dynamicFields = [];

    GamificationDashboardDynamicFields a = GamificationDashboardDynamicFields("Target (MT)", "524.267");
    GamificationDashboardDynamicFields aa = GamificationDashboardDynamicFields("Achievement (MT)", "382.459");
    GamificationDashboardDynamicFields aaa = GamificationDashboardDynamicFields("Balance Target (MT)", "141.540");
    GamificationDashboardDynamicFields ab = GamificationDashboardDynamicFields("Points Earned", "350");
    GamificationDashboardDynamicFields ac = GamificationDashboardDynamicFields("Current Slab", "SLAB 3");
    GamificationDashboardDynamicFields ad = GamificationDashboardDynamicFields("Balance Point for next slab", "250");
    GamificationDashboardDynamicFields ae = GamificationDashboardDynamicFields("Total Earnings", "29561.48");
    GamificationDashboardDynamicFields af =
        GamificationDashboardDynamicFields("Message", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");

    _dynamicFields.add(a);
    _dynamicFields.add(aa);
    _dynamicFields.add(aaa);
    _dynamicFields.add(ab);
    _dynamicFields.add(ac);
    _dynamicFields.add(ad);
    _dynamicFields.add(ae);
    _dynamicFields.add(af);

    return _dynamicFields;
  }
}

bool isNumeric(String str) {
  if (str.isEmpty) {
    return false;
  }
  return double.tryParse(str) != null;
}
