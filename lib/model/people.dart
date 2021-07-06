part of 'model.dart';

class People{
  String email;
  String name;
  String img;
  String token;
  String uid;

  People({
    required this.email, 
    required this.name, 
    required this.img, 
    required this.token, 
    required this.uid
  });

  factory People.fromJson(Map<String, dynamic> json) => People(
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