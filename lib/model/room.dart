part of 'model.dart';

class Room{
  String email;
  bool inRoom;
  String lastChat;
  int lastDateTime;
  String lastUid;
  String name;
  String img;
  String type;
  String uid;

  Room({
    required this.email, 
    required this.inRoom,
    required this.lastChat,
    required this.lastDateTime,
    required this.lastUid,
    required this.name,
    required this.img,
    required this.type,
    required this.uid
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    email: json['email'] ?? '',
    inRoom: json['inRoom'] ?? false,
    lastChat: json['lastChat'] ?? '',
    lastDateTime: json['lastDateTime'] ?? 0,
    lastUid: json['lastUid'] ?? '',
    name: json['name'] ?? '',
    img: json['img'] ?? '',
    type: json['type'] ?? '',
    uid: json['uid'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'inRoom': inRoom,
    'lastChat': lastChat,
    'lastDateTime': lastDateTime,
    'lastUid': lastUid,
    'name': name,
    'img': img,
    'type': type,
    'uid': uid,
  };
}