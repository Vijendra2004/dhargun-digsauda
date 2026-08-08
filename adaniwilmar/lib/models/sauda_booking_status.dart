class SaudaBookingStatus{
  bool? isActive;
  String? message;
  SaudaBookingStatus({this.isActive});

  SaudaBookingStatus.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['message'] = message;
    return data;
  }
}