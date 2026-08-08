class CategoryResponse {
  List<Category>? response;
  String? message;

  CategoryResponse({this.response, this.message});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Category>[];
      json['response'].forEach((v) {
        response!.add(Category.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  bool? isActive;

  Category({this.id, this.name, this.isActive});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    return data;
  }
}
