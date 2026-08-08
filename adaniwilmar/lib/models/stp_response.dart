class SalesTourPlanChartViewDto {
  SalesTourPlanChartViewDto({
    required this.month,
    required this.plannedVisit,
    required this.actualVisit,
    required this.deviatedVisit,
  });
  late final int month;
  late final int plannedVisit;
  late final int actualVisit;
  late final int deviatedVisit;

  SalesTourPlanChartViewDto.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    plannedVisit = json['plannedVisit'];
    actualVisit = json['actualVisit'];
    deviatedVisit = json['deviatedVisit'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['month'] = month;
    _data['plannedVisit'] = plannedVisit;
    _data['actualVisit'] = actualVisit;
    _data['deviatedVisit'] = deviatedVisit;
    return _data;
  }
}

class TotalPCPByUsersViewDto {
  TotalPCPByUsersViewDto({
    this.cityId,
    this.city,
    this.dealers,
    this.noOfDealers,
    this.noOfVisit,
    this.hqVisitCount,
    this.bdoId,
    this.bdoName,
  });
  int? cityId;
  String? city;
  String? dealers;
  int? noOfDealers;
  double? noOfVisit;
  double? hqVisitCount;
  int? bdoId;
  String? bdoName;

  TotalPCPByUsersViewDto.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    city = json['city'];
    dealers = json['dealers'];
    noOfDealers = json['noOfDealers'];
    noOfVisit = json['noOfVisit'];
    hqVisitCount = json['hqVisitCount'];
    bdoId = json['bdoId'];
    bdoName = json['bdoName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cityId'] = cityId;
    _data['city'] = city;
    _data['dealers'] = dealers;
    _data['noOfDealers'] = noOfDealers;
    _data['noOfVisit'] = noOfVisit;
    _data['hqVisitCount'] = hqVisitCount;
    _data['bdoId'] = bdoId;
    _data['bdoName'] = bdoName;
    return _data;
  }
}

class ApprovedPermanentJourneyPlanByUserViewDto {
  ApprovedPermanentJourneyPlanByUserViewDto({
    required this.pjpId,
    required this.pjpNumber,
  });
  late final int pjpId;
  late final String pjpNumber;

  ApprovedPermanentJourneyPlanByUserViewDto.fromJson(
      Map<String, dynamic> json) {
    pjpId = json['pjpId'];
    pjpNumber = json['pjpNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pjpId'] = pjpId;
    _data['pjpNumber'] = pjpNumber;
    return _data;
  }
}

class CurrentOrUpcomingmonthViewDto {
  CurrentOrUpcomingmonthViewDto({
    this.date,
    this.mtpDateWiseCitiesDtos,
  });
  String? date;
  List<MtpDateWiseCitiesDtos>? mtpDateWiseCitiesDtos;

  CurrentOrUpcomingmonthViewDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if(json['mtpDateWiseCitiesDtos']!=null) {
      mtpDateWiseCitiesDtos = List.from(json['mtpDateWiseCitiesDtos'])
          .map((e) => MtpDateWiseCitiesDtos.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['mtpDateWiseCitiesDtos'] =
        mtpDateWiseCitiesDtos!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class MtpDateWiseCitiesDtos {
  MtpDateWiseCitiesDtos({
    this.date,
    this.townId,
    this.town,
    this.mtpDateWiseDealersDtos,
    this.noVisitHQ,
  });
  String? date;
  int? townId;
  String? town;
  List<MtpDateWiseDealersDtos>? mtpDateWiseDealersDtos;
  String? noVisitHQ;

  MtpDateWiseCitiesDtos.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    townId = json['townId'];
    town = json['town'];
    if(json['mtpDateWiseDealersDtos']!=null) {
      mtpDateWiseDealersDtos = List.from(json['mtpDateWiseDealersDtos'])
          .map((e) => MtpDateWiseDealersDtos.fromJson(e))
          .toList();
    }
    noVisitHQ = json['noVisitHQ'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['townId'] = townId;
    _data['town'] = town;
    if(mtpDateWiseDealersDtos!=null) {
      _data['mtpDateWiseDealersDtos'] =
          mtpDateWiseDealersDtos!.map((e) => e.toJson()).toList();
    }
    _data['noVisitHQ'] = noVisitHQ;
    return _data;
  }
}

class MtpDateWiseDealersDtos {
  MtpDateWiseDealersDtos({
    this.date,
    this.townId,
    this.dealerId,
    this.dealer,
  });
  String? date;
  int? townId;
  String? dealerId;
  String? dealer;

  MtpDateWiseDealersDtos.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    townId = json['townId'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['townId'] = townId;
    _data['dealerId'] = dealerId;
    _data['dealer'] = dealer;
    return _data;
  }
}

class HolidayViewDto {
  HolidayViewDto({
    required this.monthName,
    required this.holidayCount,
    required this.holidayDetails,
  });
  late final String monthName;
  late final int holidayCount;
  late final List<HolidayDetails> holidayDetails;

  HolidayViewDto.fromJson(Map<String, dynamic> json) {
    monthName = json['monthName'];
    holidayCount = json['holidayCount'];
    holidayDetails = List.from(json['holidayDetails'])
        .map((e) => HolidayDetails.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['monthName'] = monthName;
    _data['holidayCount'] = holidayCount;
    _data['holidayDetails'] = holidayDetails.map((e) => e.toJson()).toList();
    return _data;
  }
}

class HolidayDetails {
  HolidayDetails({
    required this.holidayDate,
    required this.day,
    required this.remarks,
  });
  late final String holidayDate;
  late final String day;
  late final String remarks;

  HolidayDetails.fromJson(Map<String, dynamic> json) {
    holidayDate = json['holidayDate'];
    day = json['day'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['holidayDate'] = holidayDate;
    _data['day'] = day;
    _data['remarks'] = remarks;
    return _data;
  }
}


class PCPManagerList {
  int? pjpId;
  String? pjpNumber;
  int? financialYearId;
  String? financialYear;
  String? remarks;
  int? createdBy;
  String? createdUser;
  int? statusId;
  String? status;
  String? effectiveFrom;
  String? effectiveTo;
  String? createdDate;

  PCPManagerList(
      {this.pjpId,
        this.pjpNumber,
        this.financialYearId,
        this.financialYear,
        this.remarks,
        this.createdBy,
        this.createdUser,
        this.statusId,
        this.status,
        this.effectiveFrom,
        this.effectiveTo,
        this.createdDate});

  PCPManagerList.fromJson(Map<String, dynamic> json) {
    pjpId = json['pjpId'];
    pjpNumber = json['pjpNumber'];
    financialYearId = json['financialYearId'];
    financialYear = json['financialYear'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    createdUser = json['createdUser'];
    statusId = json['statusId'];
    status = json['status'];
    effectiveFrom = json['effectiveFrom'];
    effectiveTo = json['effectiveTo'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pjpId'] = this.pjpId;
    data['pjpNumber'] = this.pjpNumber;
    data['financialYearId'] = this.financialYearId;
    data['financialYear'] = this.financialYear;
    data['remarks'] = this.remarks;
    data['createdBy'] = this.createdBy;
    data['createdUser'] = this.createdUser;
    data['statusId'] = this.statusId;
    data['status'] = this.status;
    data['effectiveFrom'] = this.effectiveFrom;
    data['effectiveTo'] = this.effectiveTo;
    data['createdDate'] = this.createdDate;
    return data;
  }
}


class PCPManagerDetail {
  int? pjpId;
  String? pjpNumber;
  int? statusId;
  String? status;
  int? financialYearId;
  String? financialYear;
  int? customerId;
  String? customer;
  int? loginUserId;
  int? createdBy;
  String? createdByName;
  String? remarks;
  String? reasonIds;
  String? effectiveFrom;
  String? effectiveTo;
  String? pjpApprovalInformationList;
  List<PermanentJourneyPlanDetails>? permanentJourneyPlanDetails;

  PCPManagerDetail(
      {this.pjpId,
        this.pjpNumber,
        this.statusId,
        this.status,
        this.financialYearId,
        this.financialYear,
        this.customerId,
        this.customer,
        this.loginUserId,
        this.createdBy,
        this.createdByName,
        this.remarks,
        this.reasonIds,
        this.effectiveFrom,
        this.effectiveTo,
        this.pjpApprovalInformationList,
        this.permanentJourneyPlanDetails});

  PCPManagerDetail.fromJson(Map<String, dynamic> json) {
    pjpId = json['pjpId'];
    pjpNumber = json['pjpNumber'];
    statusId = json['statusId'];
    status = json['status'];
    financialYearId = json['financialYearId'];
    financialYear = json['financialYear'];
    customerId = json['customerId'];
    customer = json['customer'];
    loginUserId = json['loginUserId'];
    createdBy = json['createdBy'];
    createdByName = json['createdByName'];
    remarks = json['remarks'];
    reasonIds = json['reasonIds'];
    effectiveFrom = json['effectiveFrom'];
    effectiveTo = json['effectiveTo'];
    pjpApprovalInformationList = json['pjpApprovalInformationList'];
    if (json['permanentJourneyPlanDetails'] != null) {
      permanentJourneyPlanDetails = <PermanentJourneyPlanDetails>[];
      json['permanentJourneyPlanDetails'].forEach((v) {
        permanentJourneyPlanDetails!
            .add(new PermanentJourneyPlanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pjpId'] = this.pjpId;
    data['pjpNumber'] = this.pjpNumber;
    data['statusId'] = this.statusId;
    data['status'] = this.status;
    data['financialYearId'] = this.financialYearId;
    data['financialYear'] = this.financialYear;
    data['customerId'] = this.customerId;
    data['customer'] = this.customer;
    data['loginUserId'] = this.loginUserId;
    data['createdBy'] = this.createdBy;
    data['createdByName'] = this.createdByName;
    data['remarks'] = this.remarks;
    data['reasonIds'] = this.reasonIds;
    data['effectiveFrom'] = this.effectiveFrom;
    data['effectiveTo'] = this.effectiveTo;
    data['pjpApprovalInformationList'] = this.pjpApprovalInformationList;
    if (this.permanentJourneyPlanDetails != null) {
      data['permanentJourneyPlanDetails'] =
          this.permanentJourneyPlanDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PermanentJourneyPlanDetails {
  int? id;
  int? pjpId;
  String? retailerId;
  String? retailers;
  String? retailer;
  int? monthId;
  String? month;
  String? noOfVisit;
  int? districtId;
  String? district;
  int? cityId;
  String? city;
  int? townId;
  String? noOfDirectDealer;
  String? noOfSubDealer;
  String? noOfWholeSeller;
  int? createdBy;
  int? financialYearId;
  String? financialYear;
  int? isDeleted;
  int? stateId;
  String? state;
  int? territoryId;
  String? territory;
  String? effectiveFrom;
  String? effectiveTo;
  String? remarks;
  bool? isDataChanged;
  int? inHQNoVisitId;
  String? inHQNoVisitName;

  PermanentJourneyPlanDetails(
      {this.id,
        this.pjpId,
        this.retailerId,
        this.retailers,
        this.retailer,
        this.monthId,
        this.month,
        this.noOfVisit,
        this.districtId,
        this.district,
        this.cityId,
        this.city,
        this.townId,
        this.noOfDirectDealer,
        this.noOfSubDealer,
        this.noOfWholeSeller,
        this.createdBy,
        this.financialYearId,
        this.financialYear,
        this.isDeleted,
        this.stateId,
        this.state,
        this.territoryId,
        this.territory,
        this.effectiveFrom,
        this.effectiveTo,
        this.remarks,
        this.isDataChanged,
        this.inHQNoVisitId,
        this.inHQNoVisitName});

  PermanentJourneyPlanDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pjpId = json['pjpId'];
    retailerId = json['retailerId'];
    retailers = json['retailers'];
    retailer = json['retailer'];
    monthId = json['monthId'];
    month = json['month'];
    noOfVisit = json['noOfVisit'];
    districtId = json['districtId'];
    district = json['district'];
    cityId = json['cityId'];
    city = json['city'];
    townId = json['townId'];
    noOfDirectDealer = json['noOfDirectDealer'];
    noOfSubDealer = json['noOfSubDealer'];
    noOfWholeSeller = json['noOfWholeSeller'];
    createdBy = json['createdBy'];
    financialYearId = json['financialYearId'];
    financialYear = json['financialYear'];
    isDeleted = json['isDeleted'];
    stateId = json['stateId'];
    state = json['state'];
    territoryId = json['territoryId'];
    territory = json['territory'];
    effectiveFrom = json['effectiveFrom'];
    effectiveTo = json['effectiveTo'];
    remarks = json['remarks'];
    isDataChanged = json['isDataChanged'];
    inHQNoVisitId = json['inHQNoVisitId'];
    inHQNoVisitName = json['inHQNoVisitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pjpId'] = this.pjpId;
    data['retailerId'] = this.retailerId;
    data['retailers'] = this.retailers;
    data['retailer'] = this.retailer;
    data['monthId'] = this.monthId;
    data['month'] = this.month;
    data['noOfVisit'] = this.noOfVisit;
    data['districtId'] = this.districtId;
    data['district'] = this.district;
    data['cityId'] = this.cityId;
    data['city'] = this.city;
    data['townId'] = this.townId;
    data['noOfDirectDealer'] = this.noOfDirectDealer;
    data['noOfSubDealer'] = this.noOfSubDealer;
    data['noOfWholeSeller'] = this.noOfWholeSeller;
    data['createdBy'] = this.createdBy;
    data['financialYearId'] = this.financialYearId;
    data['financialYear'] = this.financialYear;
    data['isDeleted'] = this.isDeleted;
    data['stateId'] = this.stateId;
    data['state'] = this.state;
    data['territoryId'] = this.territoryId;
    data['territory'] = this.territory;
    data['effectiveFrom'] = this.effectiveFrom;
    data['effectiveTo'] = this.effectiveTo;
    data['remarks'] = this.remarks;
    data['isDataChanged'] = this.isDataChanged;
    data['inHQNoVisitId'] = this.inHQNoVisitId;
    data['inHQNoVisitName'] = this.inHQNoVisitName;
    return data;
  }
}

class MTPManagerList {
  int? mtpId;
  String? mtpNumber;
  int? statusId;
  String? status;
  String? remarks;
  int? createdBy;
  String? createdUser;
  int? pjpId;
  int? monthId;
  String? reasonIds;
  String? createdDate;
  String? monthlyTourPlanDetailList;

  MTPManagerList(
      {this.mtpId,
        this.mtpNumber,
        this.statusId,
        this.status,
        this.remarks,
        this.createdBy,
        this.createdUser,
        this.pjpId,
        this.monthId,
        this.reasonIds,
        this.createdDate,
        this.monthlyTourPlanDetailList});

  MTPManagerList.fromJson(Map<String, dynamic> json) {
    mtpId = json['mtpId'];
    mtpNumber = json['mtpNumber'];
    statusId = json['statusId'];
    status = json['status'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    createdUser = json['createdUser'];
    pjpId = json['pjpId'];
    monthId = json['monthId'];
    reasonIds = json['reasonIds'];
    createdDate = json['createdDate'];
    monthlyTourPlanDetailList = json['monthlyTourPlanDetailList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mtpId'] = this.mtpId;
    data['mtpNumber'] = this.mtpNumber;
    data['statusId'] = this.statusId;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['createdBy'] = this.createdBy;
    data['createdUser'] = this.createdUser;
    data['pjpId'] = this.pjpId;
    data['monthId'] = this.monthId;
    data['reasonIds'] = this.reasonIds;
    data['createdDate'] = this.createdDate;
    data['monthlyTourPlanDetailList'] = this.monthlyTourPlanDetailList;
    return data;
  }
}

class MTPManagerDetail {
  int? mtpId;
  String? mtpNumber;
  int? statusId;
  String? status;
  String? remarks;
  int? createdBy;
  String? createdUser;
  int? pjpId;
  int? monthId;
  String? reasonIds;
  String? createdDate;
  List<MonthlyTourPlanDetailList>? monthlyTourPlanDetailList;

  MTPManagerDetail(
      {this.mtpId,
        this.mtpNumber,
        this.statusId,
        this.status,
        this.remarks,
        this.createdBy,
        this.createdUser,
        this.pjpId,
        this.monthId,
        this.reasonIds,
        this.createdDate,
        this.monthlyTourPlanDetailList});

  MTPManagerDetail.fromJson(Map<String, dynamic> json) {
    mtpId = json['mtpId'];
    mtpNumber = json['mtpNumber'];
    statusId = json['statusId'];
    status = json['status'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    createdUser = json['createdUser'];
    pjpId = json['pjpId'];
    monthId = json['monthId'];
    reasonIds = json['reasonIds'];
    createdDate = json['createdDate'];
    if (json['monthlyTourPlanDetailList'] != null) {
      monthlyTourPlanDetailList = <MonthlyTourPlanDetailList>[];
      json['monthlyTourPlanDetailList'].forEach((v) {
        monthlyTourPlanDetailList!
            .add(new MonthlyTourPlanDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mtpId'] = this.mtpId;
    data['mtpNumber'] = this.mtpNumber;
    data['statusId'] = this.statusId;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['createdBy'] = this.createdBy;
    data['createdUser'] = this.createdUser;
    data['pjpId'] = this.pjpId;
    data['monthId'] = this.monthId;
    data['reasonIds'] = this.reasonIds;
    data['createdDate'] = this.createdDate;
    if (this.monthlyTourPlanDetailList != null) {
      data['monthlyTourPlanDetailList'] =
          this.monthlyTourPlanDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonthlyTourPlanDetailList {
  int? id;
  int? mtpId;
  String? date;
  String? mtpDate;
  int? dayId;
  String? day;
  int? townId;
  String? town;
  String? area;
  String? dealerId;
  String? dealer;
  int? headquartersId;
  String? headquarters;
  String? remarks;
  String? visitRemarks;
  int? createdBy;
  int? isDeleted;
  String? travelTo;
  int? inHQNoVisitId;
  String? inHQNoVisitName;

  MonthlyTourPlanDetailList(
      {this.id,
        this.mtpId,
        this.date,
        this.mtpDate,
        this.dayId,
        this.day,
        this.townId,
        this.town,
        this.area,
        this.dealerId,
        this.dealer,
        this.headquartersId,
        this.headquarters,
        this.remarks,
        this.visitRemarks,
        this.createdBy,
        this.isDeleted,
        this.travelTo,
        this.inHQNoVisitId,
        this.inHQNoVisitName});

  MonthlyTourPlanDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mtpId = json['mtpId'];
    date = json['date'];
    mtpDate = json['mtpDate'];
    dayId = json['dayId'];
    day = json['day'];
    townId = json['townId'];
    town = json['town'];
    area = json['area'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    headquartersId = json['headquartersId'];
    headquarters = json['headquarters'];
    remarks = json['remarks'];
    visitRemarks = json['visitRemarks'];
    createdBy = json['createdBy'];
    isDeleted = json['isDeleted'];
    travelTo = json['travelTo'];
    inHQNoVisitId = json['inHQNoVisitId'];
    inHQNoVisitName = json['inHQNoVisitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mtpId'] = this.mtpId;
    data['date'] = this.date;
    data['mtpDate'] = this.mtpDate;
    data['dayId'] = this.dayId;
    data['day'] = this.day;
    data['townId'] = this.townId;
    data['town'] = this.town;
    data['area'] = this.area;
    data['dealerId'] = this.dealerId;
    data['dealer'] = this.dealer;
    data['headquartersId'] = this.headquartersId;
    data['headquarters'] = this.headquarters;
    data['remarks'] = this.remarks;
    data['visitRemarks'] = this.visitRemarks;
    data['createdBy'] = this.createdBy;
    data['isDeleted'] = this.isDeleted;
    data['travelTo'] = this.travelTo;
    data['inHQNoVisitId'] = this.inHQNoVisitId;
    data['inHQNoVisitName'] = this.inHQNoVisitName;
    return data;
  }
}
