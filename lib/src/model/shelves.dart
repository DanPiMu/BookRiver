import 'book.dart';

class Shelves{
  int? id;
  String? name;
  String? img;
  String? description;
  int? privacity;
  List<Book> books =[];

  Shelves(this.id, this.name, this.img, this.description, this.books, this.privacity);


  Shelves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    description = json['description'];
    privacity = json['privacity'];
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books.add(new Book.fromJson(v));
      });
    }
  }
}

