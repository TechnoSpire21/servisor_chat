part of 'event.dart';

class EventChatRoom {
  static Future<bool> checkRoomIsExist({
    required bool isSender,
    required String myUid,
    required String personUid,
  }) async {
    DocumentSnapshot response = await FirebaseFirestore.instance
        .collection('people')
        .doc(isSender ? personUid : myUid)
        .collection('room')
        .doc(isSender ? myUid : personUid)
        .get();
    return response.exists;
  }

  static updateRoom(
      {required bool isSender,
      required String myUid,
      required String personUid,
      required Room room}) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? personUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : personUid)
          .update(room.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static addRoom(
      {required bool isSender,
      required String myUid,
      required String personUid,
      required Room room}) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? personUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : personUid)
          .set(room.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static addChat(
      {required bool isSender,
      required String myUid,
      required String personUid,
      required Chat chat}) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? personUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : personUid)
          .collection('chat')
          .doc(chat.dateTime.toString())
          .set(chat.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }
}
