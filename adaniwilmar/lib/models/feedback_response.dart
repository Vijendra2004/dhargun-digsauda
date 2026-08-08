class FeedbackType {
  FeedbackType({
    required this.id,
    required this.name,
    required this.isActive,
    required this.states,
    required this.postStatus,
    required this.postMessage,
  });
  late final int id;
  late final String name;
  late final bool isActive;
  late final String states;
  late final bool postStatus;
  late final String postMessage;

  FeedbackType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    states = json['states'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['isActive'] = isActive;
    _data['states'] = states;
    _data['postStatus'] = postStatus;
    _data['postMessage'] = postMessage;
    return _data;
  }
}

class Questions {
  Questions({
    required this.id,
    required this.question,
    required this.validFrom,
    required this.validTo,
    required this.isActive,
    required this.loginUserId,
    required this.postMessage,
    required this.postStatus,
    required this.comments,
  });
  late final int id;
  late final String question;
  late final String validFrom;
  late final String validTo;
  late final bool isActive;
  late final int loginUserId;
  late final String postMessage;
  late final bool postStatus;
  late final List<Comments> comments;

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    isActive = json['isActive'];
    loginUserId = json['loginUserId'];
    postMessage = json['postMessage'];
    postStatus = json['postStatus'];
    comments =
        List.from(json['comments']).map((e) => Comments.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['question'] = question;
    _data['validFrom'] = validFrom;
    _data['validTo'] = validTo;
    _data['isActive'] = isActive;
    _data['loginUserId'] = loginUserId;
    _data['postMessage'] = postMessage;
    _data['postStatus'] = postStatus;
    _data['comments'] = comments.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Comments {
  Comments({
    required this.commentid,
    required this.comment,
  });
  late final int commentid;
  late final String comment;

  Comments.fromJson(Map<String, dynamic> json) {
    commentid = json['commentid'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['commentid'] = commentid;
    _data['comment'] = comment;
    return _data;
  }
}
