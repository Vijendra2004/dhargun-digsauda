class CommonTable {
  int id = 0;
  String cid = "";
  String englishContent = "";
  String tamilContent = "";

  CommonTable(
      {this.cid = "", this.tamilContent = "", this.englishContent = ""});

  CommonTable.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    englishContent = json['englishContent'];
    tamilContent = json['tamilContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cid'] = cid;
    data['englishContent'] = englishContent;
    data['tamilContent'] = tamilContent;
    return data;
  }

  void setId(int id) {
    this.id = id;
  }
}
