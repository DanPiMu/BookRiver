import 'book.dart';

class Shelves{
  int? id;
  String? name;
  String? img;
  String? description;
  List<Book> books =[];

  Shelves(this.id, this.name, this.img, this.description, this.books);


  Shelves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    description = json['description'];
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books.add(new Book.fromJson(v));
      });
    }
  }
}

