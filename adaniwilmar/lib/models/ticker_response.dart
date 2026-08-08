class TickerList {
  String? content;
  String? fromHours;
  String? toHours;
  String? colorCode;

  TickerList({this.content, this.fromHours, this.toHours, this.colorCode});

  TickerList.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    fromHours = json['fromHours'];
    toHours = json['toHours'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['fromHours'] = this.fromHours;
    data['toHours'] = this.toHours;
    data['colorCode'] = this.colorCode;
    return data;
  }
}
