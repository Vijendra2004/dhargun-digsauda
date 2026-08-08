class DueForTomorrowList {
  double? totalBookedValuePendingDue;
  double? totalBookedValueOverDue;
  List<DueDetail>? overAndPendingDueWithDealerDetails;

  DueForTomorrowList(
      {this.totalBookedValuePendingDue,
      this.totalBookedValueOverDue,
      this.overAndPendingDueWithDealerDetails});

  DueForTomorrowList.fromJson(Map<String, dynamic> json) {
    totalBookedValuePendingDue = json['totalBookedValuePendingDue'];
    totalBookedValueOverDue = json['totalBookedValueOverDue'];
    if (json['overAndPendingDueWithDealerDetails'] != null) {
      overAndPendingDueWithDealerDetails = <DueDetail>[];
      json['overAndPendingDueWithDealerDetails'].forEach((v) {
        overAndPendingDueWithDealerDetails!.add(DueDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBookedValuePendingDue'] = totalBookedValuePendingDue;
    data['totalBookedValueOverDue'] = totalBookedValueOverDue;
    if (overAndPendingDueWithDealerDetails != null) {
      data['dueDetail'] =
          overAndPendingDueWithDealerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DueDetail {
  String? dealerName;
  String? dealerCode;
  double? overDue;
  double? pendingDue;
  String? referenceNo;
  String? dueDate;

  DueDetail({this.dealerName, this.dealerCode, this.overDue, this.pendingDue,this.referenceNo,this.dueDate});

  DueDetail.fromJson(Map<String, dynamic> json) {
    dealerName = json['dealerName'];
    dealerCode = json['dealerCode'];
    overDue = json['overDue'];
    pendingDue = json['pendingDue'];
    referenceNo = json['referenceNo'];
    dueDate = json['dueDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerName'] = dealerName;
    data['dealerCode'] = dealerCode;
    data['overDue'] = overDue;
    data['pendingDue'] = pendingDue;
    return data;
  }
}
