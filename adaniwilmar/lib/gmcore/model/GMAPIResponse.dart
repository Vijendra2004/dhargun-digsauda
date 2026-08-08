// ignore_for_file: prefer_collection_literals, unnecessary_string_interpolations

class GMAPIResponse {
  String id = "";
  String result = "";
  String token = "";
  String error = "";

  GMAPIResponse(
      {required this.id,
      required this.result,
      required this.token,
      required this.error});

  GMAPIResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'].toString();
    result = json['Y77T3XP2B'].toString();
    token = json['E6DYES1Q2'].toString();
    error = json['SXVI7XCEU'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['$id'] = id;
    data['Y77T3XP2B'] = result;
    data['E6DYES1Q2'] = token;
    data['SXVI7XCEU'] = error;
    return data;
  }
}
