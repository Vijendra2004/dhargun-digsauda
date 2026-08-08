class ConstractNoModel {
  List<ContractNoItem>? response;
  String? message;

  ConstractNoModel({this.response, this.message});

  factory ConstractNoModel.fromJson(Map<String, dynamic> json) {
    return ConstractNoModel(
      response: json['response'] != null
          ? List<ContractNoItem>.from(
          json['response'].map((x) => ContractNoItem.fromJson(x)))
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.map((x) => x.toJson()).toList(),
    "message": message,
  };
}

class ContractNoItem {
  int? id;
  String? saudaNumber;

  ContractNoItem({
    this.id,
    this.saudaNumber,
  });

  factory ContractNoItem.fromJson(Map<String, dynamic> json) {
    return ContractNoItem(
        id: json['id'],
        saudaNumber: json['saudaNumber'],
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "saudaNumber": saudaNumber,
  };

}
