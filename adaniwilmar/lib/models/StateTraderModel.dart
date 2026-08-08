class TradersNameModel {
  List<TradersNameItems>? response;
  String? message;

  TradersNameModel({this.response, this.message});

  factory TradersNameModel.fromJson(Map<String, dynamic> json) {
    return TradersNameModel(
      response: json['response'] != null
          ? List<TradersNameItems>.from(
          json['response'].map((x) => TradersNameItems.fromJson(x)))
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.map((x) => x.toJson()).toList(),
    "message": message,
  };
}

class TradersNameItems {
  int? id;
  String? name;

  TradersNameItems({
    this.id,
    this.name,
  });

  factory TradersNameItems.fromJson(Map<String, dynamic> json) {
    return TradersNameItems(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
