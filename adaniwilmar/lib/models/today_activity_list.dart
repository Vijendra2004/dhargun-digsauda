class TodayActivity {
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

  TodayActivity(
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

  TodayActivity.fromJson(Map<String, dynamic> json) {
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
