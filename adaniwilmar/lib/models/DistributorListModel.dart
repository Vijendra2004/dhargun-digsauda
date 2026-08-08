
class DistributorListModel {
  final ResponseData? response;
  final String? message;

  DistributorListModel({
    this.response,
    this.message,
  });

  factory DistributorListModel.fromJson(Map<String, dynamic> json) {
    return DistributorListModel(
      response: json['response'] != null
          ? ResponseData.fromJson(json['response'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response?.toJson(),
      'message': message,
    };
  }
}

class ResponseData {
  final List<DistributorListItem> result;
  final int? id;
  final dynamic exception;
  final String? status;
  final bool? isCanceled;
  final bool? isCompleted;
  final String? creationOptions;
  final dynamic asyncState;
  final bool? isFaulted;

  ResponseData({
    required this.result,
    this.id,
    this.exception,
    this.status,
    this.isCanceled,
    this.isCompleted,
    this.creationOptions,
    this.asyncState,
    this.isFaulted,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      result: (json['result'] as List)
          .map((e) => DistributorListItem.fromJson(e))
          .toList(),
      id: json['id'],
      exception: json['exception'],
      status: json['status'],
      isCanceled: json['isCanceled'],
      isCompleted: json['isCompleted'],
      creationOptions: json['creationOptions'],
      asyncState: json['asyncState'],
      isFaulted: json['isFaulted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((e) => e.toJson()).toList(),
      'id': id,
      'exception': exception,
      'status': status,
      'isCanceled': isCanceled,
      'isCompleted': isCompleted,
      'creationOptions': creationOptions,
      'asyncState': asyncState,
      'isFaulted': isFaulted,
    };
  }
}


class DistributorListItem {
  int? id;
  String? code;
  String? name;

  DistributorListItem({
    this.id,
    this.code,
    this.name,
  });

  factory DistributorListItem.fromJson(Map<String, dynamic> json) {
    return DistributorListItem(
        id: json['id'],
        code: json['code'],
        name: json['name']);
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code
  };

}
