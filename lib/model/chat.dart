part of 'model.dart';

class Chat{
  int dateTime;
  bool isRead;
  String message;
  String type;
  String uidReceiver;
  String uidSender;

  Chat({
    required this.dateTime, 
    required this.isRead, 
    required this.message, 
    required this.type,
    required this.uidReceiver, 
    required this.uidSender
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    dateTime: json['dateTime'] ?? 0,
    isRead: json['isRead'] ?? false,
    message: json['message'] ?? '',
    type: json['type'] ?? '',
    uidReceiver: json['uidReceiver'] ?? '',
    uidSender: json['uidSender'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'dateTime': dateTime,
    'isRead': isRead,
    'message': message,
    'type': type,
    'uidReceiver': uidReceiver,
    'uidSender': uidSender,
  };
}