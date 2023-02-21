class User {
  int? id;
  String? username;
  String? email;
  String? birthDate;
  String? userImg;
  String? createdAt;

  User(
      {this.id,
        this.username,
        this.email,
        this.birthDate,
        this.userImg,
        this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    birthDate = json['birth_date'];
    userImg = json['user_img'];
    createdAt = json['created_at'];
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