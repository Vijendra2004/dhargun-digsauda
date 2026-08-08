class ProspectiveDealerAddDto {
  ProspectiveDealerAddDto({
    required this.address,
    required this.businessPotentialPeryear,
    required this.cityId,
    required this.createdBy,
    required this.dealerId,
    required this.email,
    required this.fileList,
    required this.isActive,
    required this.mobileNumber,
    required this.name,
    required this.pincode,
    required this.prospectiveInterestLevel,
    required this.prospectiveSales,
    required this.stateId,
  });
  late final String address;
  late final int businessPotentialPeryear;
  late final int cityId;
  late final int createdBy;
  late final int dealerId;
  late final String email;
  late final List<FileList> fileList;
  late final bool isActive;
  late final String mobileNumber;
  late final String name;
  late final String pincode;
  late final int prospectiveInterestLevel;
  late final int prospectiveSales;
  late final int stateId;

  ProspectiveDealerAddDto.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    businessPotentialPeryear = json['businessPotentialPeryear'];
    cityId = json['cityId'];
    createdBy = json['createdBy'];
    dealerId = json['dealerId'];
    email = json['email'];
    fileList =
        List.from(json['fileList']).map((e) => FileList.fromJson(e)).toList();
    isActive = json['isActive'];
    mobileNumber = json['mobileNumber'];
    name = json['name'];
    pincode = json['pincode'];
    prospectiveInterestLevel = json['prospectiveInterestLevel'];
    prospectiveSales = json['prospectiveSales'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address'] = address;
    _data['businessPotentialPeryear'] = businessPotentialPeryear;
    _data['cityId'] = cityId;
    _data['createdBy'] = createdBy;
    _data['dealerId'] = dealerId;
    _data['email'] = email;
    _data['fileList'] = fileList.map((e) => e.toJson()).toList();
    _data['isActive'] = isActive;
    _data['mobileNumber'] = mobileNumber;
    _data['name'] = name;
    _data['pincode'] = pincode;
    _data['prospectiveInterestLevel'] = prospectiveInterestLevel;
    _data['prospectiveSales'] = prospectiveSales;
    _data['stateId'] = stateId;
    return _data;
  }
}

class FileList {
  FileList({
    required this.fileExtention,
    required this.fileName,
    required this.filePath,
    required this.id,
  });
  late final String fileExtention;
  late final String fileName;
  late final String filePath;
  late final int id;

  FileList.fromJson(Map<String, dynamic> json) {
    fileExtention = json['fileExtention'];
    fileName = json['fileName'];
    filePath = json['filePath'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fileExtention'] = fileExtention;
    _data['fileName'] = fileName;
    _data['filePath'] = filePath;
    _data['id'] = id;
    return _data;
  }
}
