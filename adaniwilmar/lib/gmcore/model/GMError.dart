class GMError {
  String message = "";
  String errorCode = "";

  GMError({required this.message, required this.errorCode});

  GMError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['errorcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    data['errorcode'] = errorCode;
    return data;
  }
}
