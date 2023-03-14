import 'package:book_river/src/model/ratings.dart';

import 'categories.dart';

class Book {
  int? id;
  String? title;
  String? author;
  num? price;
  String? description;
  num? avgRating;
  String? createdAt;
  String? updatedAt;
  List<Caratula>? caratula;
  List<BookImgs>? bookImgs;
  List<Categories> categories = [];
  int units =1;



  Book(
      this.id,
      this.title,
      this.author,
      this.price,
      this.description,
      this.avgRating,
      this.createdAt,
      this.updatedAt,
      this.caratula,
      this.bookImgs,
      this.categories,);

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    price = json['price'];
    description = json['description'];
    avgRating = json['avg_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['caratula'] != null) {
      caratula = <Caratula>[];
      json['caratula'].forEach((v) {
        caratula!.add(new Caratula.fromJson(v));
      });
    }
    if (json['book_imgs'] != null) {
      bookImgs = <BookImgs>[];
      json['book_imgs'].forEach((v) {
        bookImgs!.add(new BookImgs.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
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
    if (this.caratula != null) {
      data['caratula'] = this.caratula!.map((v) => v.toJson()).toList();
    }
    if (this.bookImgs != null) {
      data['book_imgs'] = this.bookImgs!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Caratula {
  String? img;

  Caratula({this.img});

  Caratula.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
class BookImgs {
  String? img;

  BookImgs({this.img});

  BookImgs.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}




