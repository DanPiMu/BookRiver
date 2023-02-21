import 'package:book_river/src/model/pivot.dart';

class Categories {
  int? id;
  String? nameEs;
  String? nameEn;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Categories(
      {this.id,
        this.nameEs,
        this.nameEn,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEs = json['name_es'];
    nameEn = json['name_en'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_es'] = this.nameEs;
    data['name_en'] = this.nameEn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}