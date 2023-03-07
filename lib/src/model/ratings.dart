import 'User.dart';
import 'book.dart';

class Ratings {
  int? id;
  int? stars;
  String? review;
  User? user;
  Book? book;
  String? createdAt;

  Ratings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stars = json['stars'];
    review = json['review'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stars'] = this.stars;
    data['review'] = this.review;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

