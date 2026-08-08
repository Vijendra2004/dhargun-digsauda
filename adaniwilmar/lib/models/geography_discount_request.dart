import 'geography_discount_list.dart';

class GeographyDiscountRequest {
  int? id;
  String? discountReason;
  List<int>? skuIds;
  List<Cities>? cities;
  double? actualDiscount;
  int? loginUserId;
  String? salesOrganization;
  int? oilTypeId = 1;
  int? packGroupId = 1;
  int? packGroupTypeId = 1;
  String? validFrom;
  String? validTo;
  bool? isActive;

  GeographyDiscountRequest(
      {this.id,
        this.discountReason,
        this.skuIds,
        this.cities,
        this.actualDiscount,
        this.loginUserId,
        this.salesOrganization,
        this.validFrom,
        this.validTo,
      this.isActive = false});

  GeographyDiscountRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    discountReason = json['DiscountReason'];
    skuIds = json['SkuIds'].cast<int>();
    if (json['Cities'] != null) {
      cities = <Cities>[];
      json['Cities'].forEach((v) {
        cities?.add(Cities.fromJson(v));
      });
    }
    isActive = json['IsActive'] ?? false;
    salesOrganization = json['SalesOrganization'];
    actualDiscount = json['ActualDiscount'];
    loginUserId = json['LoginUserId'];
    oilTypeId = json['OilTypeId'];
    packGroupId = json['PackGroupId'];
    packGroupTypeId = json['PackTypeId'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = id;
    data['DiscountReason'] = discountReason;
    data['SkuIds'] = skuIds;
    data['IsActive'] = isActive;
    final cities = this.cities;
    if (cities != null) {
      data['Cities'] = cities.map((v) => v.toJson()).toList();
    }
    data['SalesOrganization'] = salesOrganization;
    data['ActualDiscount'] = actualDiscount;
    data['LoginUserId'] = loginUserId;
    data['ValidFrom'] = validFrom;
    data['OilTypeId'] = oilTypeId;
    data['PackGroupId'] = packGroupId;
    data['PackTypeId'] = packGroupTypeId;
    data['ValidTo'] = validTo;
    return data;
  }
}
