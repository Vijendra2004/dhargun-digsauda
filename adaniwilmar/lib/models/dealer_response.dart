// ignore_for_file: prefer_collection_literals, duplicate_ignore

class DistributorList {
  int? id;
  String? employeeCode;
  String? employeeName;
  String? branch;
  int? verticalId;
  String? vertical;
  int? reportingTo;
  int? organizationReportingToId;
  int? salesReportingToId;
  int? specialityFatReportingToId;
  int? cmsReportingToId;
  String? email;
  String? mobileNumber;
  String? additionalMobileNumber;
  String? salesAccess;
  String? designation;
  int? headquartersId;
  String? headquarters;
  int? stateId;
  String? state;
  String? territory;
  String? zone;
  String? acedns;
  String? district;
  String? city;
  String? address;
  String? address1;
  String? address2;
  String? pincode;
  String? password;
  bool? isActive;
  String? frieghtZone;
  String? frieghtRoute;
  SaudaAndBiddingChances? saudaAndBiddingChances;
  bool? isBroker;
  int? bdoCount;
  int? saudaBookingTypeId;
  double? loadability;
  double? depotLoadability;
  String? saudaBookingType;
  String? organizationReportingToName;
  String? salesReportingToName;
  String? customerCode;
  String? roleName;
  List<DealerLocation>? dealerLocation;

  DistributorList(
      {this.id,
      this.employeeCode,
      this.employeeName,
      this.branch,
      this.verticalId,
      this.vertical,
      this.reportingTo,
      this.organizationReportingToId,
      this.salesReportingToId,
      this.specialityFatReportingToId,
      this.cmsReportingToId,
      this.email,
      this.mobileNumber,
      this.additionalMobileNumber,
      this.salesAccess,
      this.designation,
      this.headquartersId,
      this.headquarters,
      this.stateId,
      this.state,
      this.territory,
      this.zone,
      this.acedns,
      this.district,
      this.city,
      this.address,
      this.address1,
      this.address2,
      this.pincode,
      this.password,
      this.isActive,
      this.frieghtZone,
      this.frieghtRoute,
      this.saudaAndBiddingChances,
      this.isBroker,
      this.bdoCount,
      this.saudaBookingTypeId,
      this.loadability,
      this.depotLoadability,
      this.saudaBookingType,
      this.organizationReportingToName,
      this.salesReportingToName,
      this.customerCode,
      this.roleName,
      this.dealerLocation});

  DistributorList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeCode = json['employeeCode'];
    employeeName = json['employeeName'];
    branch = json['branch'];
    verticalId = json['verticalId'];
    vertical = json['vertical'];
    reportingTo = json['reportingTo'];
    organizationReportingToId = json['organizationReportingToId'];
    salesReportingToId = json['salesReportingToId'];
    specialityFatReportingToId = json['specialityFatReportingToId'];
    cmsReportingToId = json['cmsReportingToId'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    additionalMobileNumber = json['additionalMobileNumber'];
    salesAccess = json['salesAccess'];
    designation = json['designation'];
    headquartersId = json['headquartersId'];
    headquarters = json['headquarters'];
    stateId = json['stateId'];
    state = json['state'];
    territory = json['territory'];
    zone = json['zone'];
    acedns = json['acedns'];
    district = json['district'];
    city = json['city'];
    address = json['address'];
    address1 = json['address1'];
    address2 = json['address2'];
    pincode = json['pincode'];
    password = json['password'];
    isActive = json['isActive'];
    frieghtZone = json['frieghtZone'];
    frieghtRoute = json['frieghtRoute'];
    if (json['saudaAndBiddingChances'] != null) {
      saudaAndBiddingChances =
          SaudaAndBiddingChances.fromJson(json['saudaAndBiddingChances']);
    }
    isBroker = json['isBroker'];
    bdoCount = json['bdoCount'];
    saudaBookingTypeId = json['saudaBookingTypeId'];
    loadability = json['loadability'];
    depotLoadability = json['depotLoadability'];
    // if (json['loadability'] != null) {
    //   loadability = <double>[];
    //   json['loadability'].forEach((v) {
    //     loadability!.add(v);
    //   });
    // }
    // if (json['depotLoadability'] != null) {
    //   depotLoadability = <double>[];
    //   json['depotLoadability'].forEach((v) {
    //     depotLoadability!.add(v);
    //   });
    // }
    saudaBookingType = json['saudaBookingType'];
    organizationReportingToName = json['organizationReportingToName'];
    salesReportingToName = json['salesReportingToName'];
    customerCode = json['customerCode'];
    roleName = json['roleName'];
    if (json['dealerLocation'] != null) {
      dealerLocation = <DealerLocation>[];
      json['dealerLocation'].forEach((v) {
        dealerLocation!.add(DealerLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['employeeCode'] = employeeCode;
    data['employeeName'] = employeeName;
    data['branch'] = branch;
    data['verticalId'] = verticalId;
    data['vertical'] = vertical;
    data['reportingTo'] = reportingTo;
    data['organizationReportingToId'] = organizationReportingToId;
    data['salesReportingToId'] = salesReportingToId;
    data['specialityFatReportingToId'] = specialityFatReportingToId;
    data['cmsReportingToId'] = cmsReportingToId;
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['additionalMobileNumber'] = additionalMobileNumber;
    data['salesAccess'] = salesAccess;
    data['designation'] = designation;
    data['headquartersId'] = headquartersId;
    data['headquarters'] = headquarters;
    data['state'] = state;
    data['territory'] = territory;
    data['zone'] = zone;
    data['acedns'] = acedns;
    data['district'] = district;
    data['city'] = city;
    data['address'] = address;
    data['address1'] = address1;
    data['address2'] = address2;
    data['pincode'] = pincode;
    data['password'] = password;
    data['isActive'] = isActive;
    data['frieghtZone'] = frieghtZone;
    data['frieghtRoute'] = frieghtRoute;
    if (saudaAndBiddingChances != null) {
      data['saudaAndBiddingChances'] = saudaAndBiddingChances;
    }
    data['isBroker'] = isBroker;
    data['bdoCount'] = bdoCount;
    data['saudaBookingTypeId'] = saudaBookingTypeId;
    data['loadability'] = loadability;
    data['depotLoadability'] = depotLoadability;
    data['saudaBookingType'] = saudaBookingType;
    data['organizationReportingToName'] = organizationReportingToName;
    data['salesReportingToName'] = salesReportingToName;
    data['customerCode'] = customerCode;
    data['roleName'] = roleName;
    if (dealerLocation != null) {
      data['dealerLocation'] = dealerLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaudaAndBiddingChances {
  double? totalSaudaLimit;
  double? availableSaudaLimit;
  int? totalChances;
  int? chancesLeft;

  SaudaAndBiddingChances(
      {this.totalSaudaLimit,
      this.availableSaudaLimit,
      this.totalChances,
      this.chancesLeft});

  SaudaAndBiddingChances.fromJson(Map<String, dynamic> json) {
    totalSaudaLimit = json['totalSaudaLimit'];
    availableSaudaLimit = json['availableSaudaLimit'];
    totalChances = json['totalChances'];
    chancesLeft = json['chancesLeft'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['totalSaudaLimit'] = totalSaudaLimit;
    data['availableSaudaLimit'] = availableSaudaLimit;
    data['totalChances'] = totalChances;
    data['chancesLeft'] = chancesLeft;
    return data;
  }
}

class DealerLocation {
  int? id;
  int? userId;
  int? stateId;
  int? districtId;
  int? cityId;
  String? state;
  String? district;
  String? city;
  String? address;

  DealerLocation(
      {this.id,
      this.userId,
      this.stateId,
      this.districtId,
      this.cityId,
      this.state,
      this.district,
      this.city,
      this.address});

  DealerLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    cityId = json['cityId'];
    state = json['state'];
    district = json['district'];
    city = json['city'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['stateId'] = stateId;
    data['districtId'] = districtId;
    data['cityId'] = cityId;
    data['state'] = state;
    data['district'] = district;
    data['city'] = city;
    data['address'] = address;
    return data;
  }
}
