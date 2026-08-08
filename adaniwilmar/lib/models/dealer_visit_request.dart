class DealerVisitRequest {
  List<BdoCompetitorAddDto>? bdoCompetitorAddDto;
  int? createdBy;
  List<AddPendingSaudaRemarksDto>? addPendingSaudaRemarksDto;
  List<AddMarketScenarioDto>? addMarketScenarioDto;

  DealerVisitRequest(
      {this.bdoCompetitorAddDto,
        this.createdBy,
        this.addPendingSaudaRemarksDto,
        this.addMarketScenarioDto});

  DealerVisitRequest.fromJson(Map<String, dynamic> json) {
    if (json['bdoCompetitorAddDto'] != null) {
      bdoCompetitorAddDto = <BdoCompetitorAddDto>[];
      json['bdoCompetitorAddDto'].forEach((v) {
        bdoCompetitorAddDto!.add(new BdoCompetitorAddDto.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    if (json['addPendingSaudaRemarksDto'] != null) {
      addPendingSaudaRemarksDto = <AddPendingSaudaRemarksDto>[];
      json['addPendingSaudaRemarksDto'].forEach((v) {
        addPendingSaudaRemarksDto!
            .add(new AddPendingSaudaRemarksDto.fromJson(v));
      });
    }
    if (json['addMarketScenarioDto'] != null) {
      addMarketScenarioDto = <AddMarketScenarioDto>[];
      json['addMarketScenarioDto'].forEach((v) {
        addMarketScenarioDto!.add(new AddMarketScenarioDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bdoCompetitorAddDto != null) {
      data['bdoCompetitorAddDto'] =
          this.bdoCompetitorAddDto!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = this.createdBy;
    if (this.addPendingSaudaRemarksDto != null) {
      data['addPendingSaudaRemarksDto'] =
          this.addPendingSaudaRemarksDto!.map((v) => v.toJson()).toList();
    }
    if (this.addMarketScenarioDto != null) {
      data['addMarketScenarioDto'] =
          this.addMarketScenarioDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BdoCompetitorAddDto {
  int? dealerId;
  bool? isActive;
  int? userType;
  String? competitorHeaderName;
  String? name;
  List<FileList>? fileList;
  List<BdoCompetitorSkuDetails>? bdoCompetitorSkuDetails;
  String? remarks;

  BdoCompetitorAddDto(
      {this.dealerId,
        this.isActive,
        this.userType,
        this.competitorHeaderName,
        this.name,
        this.fileList,
        this.bdoCompetitorSkuDetails,
        this.remarks});

  BdoCompetitorAddDto.fromJson(Map<String, dynamic> json) {
    dealerId = json['DealerId'];
    isActive = json['IsActive'];
    userType = json['UserType'];
    competitorHeaderName = json['competitorHeaderName'];
    name = json['Name'];
    if (json['fileList'] != null) {
      fileList = <FileList>[];
      json['fileList'].forEach((v) {
        fileList!.add(new FileList.fromJson(v));
      });
    }
    if (json['BdoCompetitorSkuDetails'] != null) {
      bdoCompetitorSkuDetails = <BdoCompetitorSkuDetails>[];
      json['BdoCompetitorSkuDetails'].forEach((v) {
        bdoCompetitorSkuDetails!.add(new BdoCompetitorSkuDetails.fromJson(v));
      });
    }
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DealerId'] = this.dealerId;
    data['IsActive'] = this.isActive;
    data['UserType'] = this.userType;
    data['competitorHeaderName'] = this.competitorHeaderName;
    data['Name'] = this.name;
    if (this.fileList != null) {
      data['fileList'] = this.fileList!.map((v) => v.toJson()).toList();
    }
    if (this.bdoCompetitorSkuDetails != null) {
      data['BdoCompetitorSkuDetails'] =
          this.bdoCompetitorSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['Remarks'] = this.remarks;
    return data;
  }
}

class FileList {
  String? fileExtention;
  String? fileName;
  String? filePath;
  int? id;

  FileList({this.fileExtention, this.fileName, this.filePath, this.id});

  FileList.fromJson(Map<String, dynamic> json) {
    fileExtention = json['fileExtention'];
    fileName = json['fileName'];
    filePath = json['filePath'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileExtention'] = this.fileExtention;
    data['fileName'] = this.fileName;
    data['filePath'] = this.filePath;
    data['id'] = this.id;
    return data;
  }
}

class BdoCompetitorSkuDetails {
  int? createdBy;
  String? price;
  String? skuName;
  String? quanityPerMt;

  BdoCompetitorSkuDetails(
      {this.createdBy, this.price, this.skuName, this.quanityPerMt});

  BdoCompetitorSkuDetails.fromJson(Map<String, dynamic> json) {
    createdBy = json['CreatedBy'];
    price = json['Price'];
    skuName = json['SkuName'];
    quanityPerMt = json['QuanityPerMt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreatedBy'] = this.createdBy;
    data['Price'] = this.price;
    data['SkuName'] = this.skuName;
    data['QuanityPerMt'] = this.quanityPerMt;
    return data;
  }
}

class AddPendingSaudaRemarksDto {
  String? remarks;
  int? createdBy;
  int? dealerId;
  int? saudaId;

  AddPendingSaudaRemarksDto(
      {this.remarks, this.createdBy, this.dealerId, this.saudaId});

  AddPendingSaudaRemarksDto.fromJson(Map<String, dynamic> json) {
    remarks = json['Remarks'];
    createdBy = json['CreatedBy'];
    dealerId = json['DealerId'];
    saudaId = json['SaudaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Remarks'] = this.remarks;
    data['CreatedBy'] = this.createdBy;
    data['DealerId'] = this.dealerId;
    data['SaudaId'] = this.saudaId;
    return data;
  }
}

class AddMarketScenarioDto {
  int? dealerId;
  String? remarks;
  String? title;

  AddMarketScenarioDto({this.dealerId, this.remarks, this.title});

  AddMarketScenarioDto.fromJson(Map<String, dynamic> json) {
    dealerId = json['DealerId'];
    remarks = json['Remarks'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DealerId'] = this.dealerId;
    data['Remarks'] = this.remarks;
    data['Title'] = this.title;
    return data;
  }
}


class WholesalerVisitRequest {
  int? createdBy;
  int? dealerId;
  int? wholeSellerId;
  String? wholeSellerName;
  List<BdoCompetitorAddDto>? bdoCompetitorAddDto;
  List<WholeSellerSalesDetailDto>? wholeSellerSalesDetailDto;

  WholesalerVisitRequest(
      {this.createdBy,
        this.dealerId,
        this.wholeSellerId,
        this.wholeSellerName,
        this.bdoCompetitorAddDto,
        this.wholeSellerSalesDetailDto});

  WholesalerVisitRequest.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    dealerId = json['dealerId'];
    wholeSellerId = json['wholeSellerId'];
    wholeSellerName = json['wholeSellerName'];
    if (json['bdoCompetitorAddDto'] != null) {
      bdoCompetitorAddDto = <BdoCompetitorAddDto>[];
      json['bdoCompetitorAddDto'].forEach((v) {
        bdoCompetitorAddDto!.add(new BdoCompetitorAddDto.fromJson(v));
      });
    }
    if (json['wholeSellerSalesDetailDto'] != null) {
      wholeSellerSalesDetailDto = <WholeSellerSalesDetailDto>[];
      json['wholeSellerSalesDetailDto'].forEach((v) {
        wholeSellerSalesDetailDto!
            .add(new WholeSellerSalesDetailDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['dealerId'] = this.dealerId;
    data['wholeSellerId'] = this.wholeSellerId;
    data['wholeSellerName'] = this.wholeSellerName;
    if (this.bdoCompetitorAddDto != null) {
      data['bdoCompetitorAddDto'] =
          this.bdoCompetitorAddDto!.map((v) => v.toJson()).toList();
    }
    if (this.wholeSellerSalesDetailDto != null) {
      data['wholeSellerSalesDetailDto'] =
          this.wholeSellerSalesDetailDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WholeSellerSalesDetailDto {
  String? oilType;
  int? oilTypeId;
  double? price;
  int? quantityPerMt;
  int? skuId;
  String? skuName;

  WholeSellerSalesDetailDto(
      {this.oilType,
        this.oilTypeId,
        this.price,
        this.quantityPerMt,
        this.skuId,
        this.skuName});

  WholeSellerSalesDetailDto.fromJson(Map<String, dynamic> json) {
    oilType = json['oilType'];
    oilTypeId = json['oilTypeId'];
    price = json['price'];
    quantityPerMt = json['quantityPerMt'];
    skuId = json['skuId'];
    skuName = json['skuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oilType'] = this.oilType;
    data['oilTypeId'] = this.oilTypeId;
    data['price'] = this.price;
    data['quantityPerMt'] = this.quantityPerMt;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    return data;
  }
}

class PerspectiveVisitRequest {
  ProspectiveDealerAddDto? prospectiveDealerAddDto;

  PerspectiveVisitRequest({this.prospectiveDealerAddDto});

  PerspectiveVisitRequest.fromJson(Map<String, dynamic> json) {
    prospectiveDealerAddDto = json['prospectiveDealerAddDto'] != null
        ? new ProspectiveDealerAddDto.fromJson(json['prospectiveDealerAddDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prospectiveDealerAddDto != null) {
      data['prospectiveDealerAddDto'] = this.prospectiveDealerAddDto!.toJson();
    }
    return data;
  }
}

class ProspectiveDealerAddDto {
  String? address;
  double? businessPotentialPeryear;
  int? cityId;
  int? createdBy;
  int? dealerId;
  String? email;
  List<FileList>? fileList;
  bool? isActive;
  String? mobileNumber;
  String? name;
  String? pincode;
  double? prospectiveInterestLevel;
  double? prospectiveSales;
  int? stateId;

  ProspectiveDealerAddDto(
      {this.address,
        this.businessPotentialPeryear,
        this.cityId,
        this.createdBy,
        this.dealerId,
        this.email,
        this.fileList,
        this.isActive,
        this.mobileNumber,
        this.name,
        this.pincode,
        this.prospectiveInterestLevel,
        this.prospectiveSales,
        this.stateId});

  ProspectiveDealerAddDto.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    businessPotentialPeryear = json['businessPotentialPeryear'];
    cityId = json['cityId'];
    createdBy = json['createdBy'];
    dealerId = json['dealerId'];
    email = json['email'];
    if (json['fileList'] != null) {
      fileList = <FileList>[];
      json['fileList'].forEach((v) {
        fileList!.add(new FileList.fromJson(v));
      });
    }
    isActive = json['isActive'];
    mobileNumber = json['mobileNumber'];
    name = json['name'];
    pincode = json['pincode'];
    prospectiveInterestLevel = json['prospectiveInterestLevel'];
    prospectiveSales = json['prospectiveSales'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['businessPotentialPeryear'] = this.businessPotentialPeryear;
    data['cityId'] = this.cityId;
    data['createdBy'] = this.createdBy;
    data['dealerId'] = this.dealerId;
    data['email'] = this.email;
    if (this.fileList != null) {
      data['fileList'] = this.fileList!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = this.isActive;
    data['mobileNumber'] = this.mobileNumber;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['prospectiveInterestLevel'] = this.prospectiveInterestLevel;
    data['prospectiveSales'] = this.prospectiveSales;
    data['stateId'] = this.stateId;
    return data;
  }
}

