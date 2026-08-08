class ActiveZone {
  int? id;
  String? encryptedId;
  String? name;
  bool? isActive;
  String? states;
  bool? postStatus;
  String? postMessage;

  ActiveZone(
      {this.id,
        this.encryptedId,
        this.name,
        this.isActive,
        this.states,
        this.postStatus,
        this.postMessage});

  ActiveZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedId = json['encryptedId'];
    name = json['name'];
    isActive = json['isActive'];
    states = json['states'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['encryptedId'] = this.encryptedId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['states'] = this.states;
    data['postStatus'] = this.postStatus;
    data['postMessage'] = this.postMessage;
    return data;
  }
}
