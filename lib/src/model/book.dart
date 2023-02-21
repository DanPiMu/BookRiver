import 'categories.dart';

class Book {
  int? id;
  String? title;
  String? author;
  int? price;
  String? description;
  int? avgRating;
  String? createdAt;
  String? updatedAt;
  List<Categories>? categories;

  Book(
      {this.id,
        this.title,
        this.author,
        this.price,
        this.description,
        this.avgRating,
        this.createdAt,
        this.updatedAt,
        this.categories});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    price = json['price'];
    description = json['description'];
    avgRating = json['avg_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author'] = this.author;
    data['price'] = this.price;
    data['description'] = this.description;
    data['avg_rating'] = this.avgRating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




