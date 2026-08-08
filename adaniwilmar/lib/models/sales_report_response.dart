class TodayActivitiesViewDto {
  TodayActivitiesViewDto({
    required this.id,
    required this.mtpId,
    required this.date,
    required this.mtpDate,
    required this.dayId,
    required this.day,
    required this.townId,
    required this.town,
    required this.area,
    required this.dealerId,
    required this.dealer,
    required this.headquartersId,
    required this.headquarters,
    required this.remarks,
    required this.visitRemarks,
    required this.createdBy,
    required this.isDeleted,
    required this.travelTo,
    required this.inHQNoVisitId,
    required this.inHQNoVisitName,
  });
  late final int id;
  late final int mtpId;
  late final String date;
  late final String mtpDate;
  late final int dayId;
  late final String day;
  late final int townId;
  late final String town;
  late final String area;
  late final String dealerId;
  late final String dealer;
  late final int headquartersId;
  late final String headquarters;
  late final String remarks;
  late final String visitRemarks;
  late final int createdBy;
  late final int isDeleted;
  late final String travelTo;
  late final int inHQNoVisitId;
  late final String inHQNoVisitName;

  TodayActivitiesViewDto.fromJson(Map<String, dynamic> json) {
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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['mtpId'] = mtpId;
    _data['date'] = date;
    _data['mtpDate'] = mtpDate;
    _data['dayId'] = dayId;
    _data['day'] = day;
    _data['townId'] = townId;
    _data['town'] = town;
    _data['area'] = area;
    _data['dealerId'] = dealerId;
    _data['dealer'] = dealer;
    _data['headquartersId'] = headquartersId;
    _data['headquarters'] = headquarters;
    _data['remarks'] = remarks;
    _data['visitRemarks'] = visitRemarks;
    _data['createdBy'] = createdBy;
    _data['isDeleted'] = isDeleted;
    _data['travelTo'] = travelTo;
    _data['inHQNoVisitId'] = inHQNoVisitId;
    _data['inHQNoVisitName'] = inHQNoVisitName;
    return _data;
  }
}

class SecondarySalesFortheDayDetailViewDto {
  SecondarySalesFortheDayDetailViewDto({
    this.wholesellerId,
    this.wholeseller,
    this.skuId,
    this.skuName,
    this.oilTypeId,
    this.oilType,
    this.quantity,
    this.price,
  });
  int? wholesellerId;
  String? wholeseller;
  int? skuId;
  String? skuName;
  int? oilTypeId;
  String? oilType;
  double? quantity;
  double? price;

  SecondarySalesFortheDayDetailViewDto.fromJson(Map<String, dynamic> json) {
    wholesellerId = json['wholesellerId'];
    wholeseller = json['wholeseller'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['wholesellerId'] = wholesellerId;
    _data['wholeseller'] = wholeseller;
    _data['skuId'] = skuId;
    _data['skuName'] = skuName;
    _data['oilTypeId'] = oilTypeId;
    _data['oilType'] = oilType;
    _data['quantity'] = quantity;
    _data['price'] = price;
    return _data;
  }
}

class SecondarySalesFortheDayViewDto {
  SecondarySalesFortheDayViewDto({
    this.visitDate,
    this.wholesellerSecondarySales,
  });
  String? visitDate;
  List<WholesellerSecondarySales>? wholesellerSecondarySales;

  SecondarySalesFortheDayViewDto.fromJson(Map<String, dynamic> json) {
    visitDate = json['visitDate'];
    wholesellerSecondarySales = List.from(json['wholesellerSecondarySales'])
        .map((e) => WholesellerSecondarySales.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['visitDate'] = visitDate;
    _data['wholesellerSecondarySales'] =
        wholesellerSecondarySales!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class WholesellerSecondarySales {
  WholesellerSecondarySales({
    this.wholesellerId,
    this.name,
    this.dealerId,
    this.dealer,
    this.visitDate,
    this.totalQuantity,
    this.totalPrice,
  });
  int? wholesellerId;
  String? name;
  int? dealerId;
  String? dealer;
  String? visitDate;
  double? totalQuantity;
  double? totalPrice;

  WholesellerSecondarySales.fromJson(Map<String, dynamic> json) {
    wholesellerId = json['wholesellerId'];
    name = json['name'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    visitDate = json['visitDate'];
    totalQuantity = json['totalQuantity'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['wholesellerId'] = wholesellerId;
    _data['name'] = name;
    _data['dealerId'] = dealerId;
    _data['dealer'] = dealer;
    _data['visitDate'] = visitDate;
    _data['totalQuantity'] = totalQuantity;
    _data['totalPrice'] = totalPrice;
    return _data;
  }
}
