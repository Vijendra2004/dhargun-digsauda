class CommentsViewDto {
  CommentsViewDto({
    required this.id,
    required this.description,
    required this.componentId,
    required this.component,
    required this.impactId,
    required this.impact,
    required this.featureId,
    required this.feature,
    required this.statusId,
    required this.status,
    required this.stateId,
    required this.state,
    required this.sla,
    required this.createdDateTime,
    required this.modifiedDateTime,
    required this.issueRaisedBy,
    required this.issueRaisedByUserName,
    required this.resolvedDateTime,
    required this.timeTakenToResolve,
    required this.deviceId,
    required this.issueFromDevice,
    required this.issueComments,
    required this.loginUserId,
    required this.postStatus,
    required this.postMessage,
    required this.comments,
    required this.attachments,
  });
  late final int id;
  late final String description;
  late final int componentId;
  late final String component;
  late final int impactId;
  late final String impact;
  late final int featureId;
  late final String feature;
  late final int statusId;
  late final String status;
  late final int stateId;
  late final String state;
  late final String sla;
  late final String createdDateTime;
  late final String modifiedDateTime;
  late final int issueRaisedBy;
  late final String issueRaisedByUserName;
  late final String resolvedDateTime;
  late final String timeTakenToResolve;
  late final int deviceId;
  late final String issueFromDevice;
  late final String issueComments;
  late final int loginUserId;
  late final bool postStatus;
  late final String postMessage;
  late final List<Comments> comments;
  late final List<Attachments> attachments;

  CommentsViewDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    componentId = json['componentId'];
    component = json['component'];
    impactId = json['impactId'];
    impact = json['impact'];
    featureId = json['featureId'];
    feature = json['feature'];
    statusId = json['statusId'];
    status = json['status'];
    stateId = json['stateId'];
    state = json['state'];
    sla = json['sla'];
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    issueRaisedBy = json['issueRaisedBy'];
    issueRaisedByUserName = json['issueRaisedByUserName'];
    resolvedDateTime = json['resolvedDateTime'];
    timeTakenToResolve = json['timeTakenToResolve'];
    deviceId = json['deviceId'];
    issueFromDevice = json['issueFromDevice'];
    issueComments = json['issueComments'];
    loginUserId = json['loginUserId'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    comments =
        List.from(json['comments']).map((e) => Comments.fromJson(e)).toList();
    attachments = List.from(json['attachments'])
        .map((e) => Attachments.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['description'] = description;
    _data['componentId'] = componentId;
    _data['component'] = component;
    _data['impactId'] = impactId;
    _data['impact'] = impact;
    _data['featureId'] = featureId;
    _data['feature'] = feature;
    _data['statusId'] = statusId;
    _data['status'] = status;
    _data['stateId'] = stateId;
    _data['state'] = state;
    _data['sla'] = sla;
    _data['createdDateTime'] = createdDateTime;
    _data['modifiedDateTime'] = modifiedDateTime;
    _data['issueRaisedBy'] = issueRaisedBy;
    _data['issueRaisedByUserName'] = issueRaisedByUserName;
    _data['resolvedDateTime'] = resolvedDateTime;
    _data['timeTakenToResolve'] = timeTakenToResolve;
    _data['deviceId'] = deviceId;
    _data['issueFromDevice'] = issueFromDevice;
    _data['issueComments'] = issueComments;
    _data['loginUserId'] = loginUserId;
    _data['postStatus'] = postStatus;
    _data['postMessage'] = postMessage;
    _data['comments'] = comments.map((e) => e.toJson()).toList();
    _data['attachments'] = attachments.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Comments {
  Comments({
    required this.commentid,
    required this.commentname,
  });
  late final int commentid;
  late final String commentname;

  Comments.fromJson(Map<String, dynamic> json) {
    commentid = json['commentid'];
    commentname = json['commentname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['commentid'] = commentid;
    _data['commentname'] = commentname;
    return _data;
  }
}

class Attachments {
  Attachments({
    required this.attachmentid,
    required this.attachmentname,
  });
  late final int attachmentid;
  late final String attachmentname;

  Attachments.fromJson(Map<String, dynamic> json) {
    attachmentid = json['attachmentid'];
    attachmentname = json['attachmentname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['attachmentid'] = attachmentid;
    _data['attachmentname'] = attachmentname;
    return _data;
  }
}
