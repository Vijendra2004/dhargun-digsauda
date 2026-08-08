class Notification {
  Notification({
    required this.request,
    required this.requestId,
    required this.notification,
    required this.biddingDate,
    required this.fromHour,
    required this.toHour,
    required this.notificationDateTime,
    required this.statusId,
    required this.referenceId,
    required this.saudaId,
  });
  late final String request;
  late final int requestId;
  late final String notification;
  late final String biddingDate;
  late final String fromHour;
  late final String toHour;
  late final String notificationDateTime;
  late final int statusId;
  late final int referenceId;
  late final int saudaId;

  Notification.fromJson(Map<String, dynamic> json) {
    request = json['request'];
    requestId = json['requestId'];
    notification = json['notification'];
    biddingDate = json['biddingDate'];
    fromHour = json['fromHour'];
    toHour = json['toHour'];
    notificationDateTime = json['notificationDateTime'];
    statusId = json['statusId'];
    referenceId = json['referenceId'];
    saudaId = json['saudaId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['request'] = request;
    _data['requestId'] = requestId;
    _data['notification'] = notification;
    _data['biddingDate'] = biddingDate;
    _data['fromHour'] = fromHour;
    _data['toHour'] = toHour;
    _data['notificationDateTime'] = notificationDateTime;
    _data['statusId'] = statusId;
    _data['referenceId'] = referenceId;
    _data['saudaId'] = saudaId;
    return _data;
  }
}
