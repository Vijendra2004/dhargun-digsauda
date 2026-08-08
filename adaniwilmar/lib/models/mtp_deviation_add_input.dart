// ignore_for_file: non_constant_identifier_names

class MTPDeviation {
  MTPDeviation({
    required this.CreatedBy,
    required this.monthlyTourPlanDetailsId,
    required this.reasons,
    required this.remarks,
    required this.revisedDate,
  });
  late final int CreatedBy;
  late final int monthlyTourPlanDetailsId;
  late final String reasons;
  late final String remarks;
  late final String revisedDate;

  MTPDeviation.fromJson(Map<String, dynamic> json) {
    CreatedBy = json['CreatedBy'];
    monthlyTourPlanDetailsId = json['monthlyTourPlanDetailsId'];
    reasons = json['reasons'];
    remarks = json['remarks'];
    revisedDate = json['revisedDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CreatedBy'] = CreatedBy;
    _data['monthlyTourPlanDetailsId'] = monthlyTourPlanDetailsId;
    _data['reasons'] = reasons;
    _data['remarks'] = remarks;
    _data['revisedDate'] = revisedDate;
    return _data;
  }
}
