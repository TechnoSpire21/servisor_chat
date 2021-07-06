part of 'model.dart';

class Person{
  String email;
  String name;
  String img;
  String token;
  String uid;

  Person({
    this.email, 
    this.name, 
    this.img, 
    this.token, 
    this.uid
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    img: json['img'] ?? '',
    token: json['token'] ?? '',
    uid: json['uid'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'img': img,
    'token': token,
    'uid': uid,
  };
}