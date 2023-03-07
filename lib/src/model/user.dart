import 'package:book_river/src/model/ratings.dart';

import 'book.dart';
import 'shelves.dart';

class User {
  int? id;
  String? username;
  String? email;
  String? birthDate;
  String? userImg;
  String? createdAt;
  List<Ratings>? ratings;
  List<Shelves> libraries = [];

  User(
      {this.id,
        this.username,
        this.email,
        this.birthDate,
        this.userImg,
        this.createdAt, this.ratings, required this.libraries});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    birthDate = json['birth_date'];
    userImg = json['user_img'];
    createdAt = json['created_at'];
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings?.add(new Ratings.fromJson(v));
      });
    }
    if (json['libraries'] != null) {
      libraries = <Shelves>[];
      json['libraries'].forEach((v) {
        libraries.add(new Shelves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['birth_date'] = this.birthDate;
    data['user_img'] = this.userImg;
    data['created_at'] = this.createdAt;
    return data;
  }
}
/*
"id": 17,
            "username": "mhita",
            "email": "mhita@apiabalit.com",
            "birth_date": null,
            "user_img": null,
            "created_at": "2023-01-19T06:42:42.000000Z"
*/