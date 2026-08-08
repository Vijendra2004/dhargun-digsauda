class CompetitorList {
  int? competitorId;
  String? name;
  String? state;

  CompetitorList({this.competitorId, this.name, this.state});

  CompetitorList.fromJson(Map<String, dynamic> json) {
    competitorId = json['competitorId'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['competitorId'] = competitorId;
    data['name'] = name;
    data['state'] = state;
    return data;
  }
}
