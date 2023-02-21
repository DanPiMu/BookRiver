class Pivot {
  int? bookId;
  int? categoryId;

  Pivot({this.bookId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['category_id'] = this.categoryId;
    return data;
  }
}