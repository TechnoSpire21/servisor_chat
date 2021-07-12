part of 'event.dart';

// class EventChatRoom {
//   static Future<bool> checkRoomIsExist({
//     required bool isSender,
//     required String myUid,
//     required String personUid,
//   }) async {
//     DocumentSnapshot response = await FirebaseFirestore.instance
//         .collection('people')
//         .doc(isSender ? personUid : myUid)
//         .collection('room')
//         .doc(isSender ? myUid : personUid)
//         .get();
//     return response.exists;
//   }

//   static updateRoom(
//       {required bool isSender,
//       required String myUid,
//       required String personUid,
//       required Room room}) {
//     try {
//       FirebaseFirestore.instance
//           .collection('people')
//           .doc(isSender ? personUid : myUid)
//           .collection('room')
//           .doc(isSender ? myUid : personUid)
//           .update(room.toJson())
//           .then((value) => null)
//           .catchError((onError) => print(onError));
//     } catch (e) {
//       print(e);
//     }
//   }

//   static addRoom(
//       {required bool isSender,
//       required String myUid,
//       required String personUid,
//       required Room room}) {
//     try {
//       FirebaseFirestore.instance
//           .collection('people')
//           .doc(isSender ? personUid : myUid)
//           .collection('room')
//           .doc(isSender ? myUid : personUid)
//           .set(room.toJson())
//           .then((value) => null)
//           .catchError((onError) => print(onError));
//     } catch (e) {
//       print(e);
//     }
//   }

//   static addChat(
//       {required bool isSender,
//       required String myUid,
//       required String personUid,
//       required Chat chat}) {
//     try {
//       FirebaseFirestore.instance
//           .collection('people')
//           .doc(isSender ? personUid : myUid)
//           .collection('room')
//           .doc(isSender ? myUid : personUid)
//           .collection('chat')
//           .doc(chat.dateTime.toString())
//           .set(chat.toJson())
//           .then((value) => null)
//           .catchError((onError) => print(onError));
//     } catch (e) {
//       print(e);
//     }
//   }

//   static Future<bool> checkIsPersonInRoom({required String myUid, required String peopleUid}) async {
//     bool inRoom = false;
//     try {
//       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//       .collection('people')
//       .doc(myUid)
//       .collection('room')
//       .doc(peopleUid)
//       .get()
//       .catchError((onError) => print(onError));
//       // inRoom = documentSnapshot.data()!['inRoom'];
//       inRoom = documentSnapshot.get('inRoom');
//     } catch (e) {
//       print(e);
//     }
//     return inRoom;
//   }

//   static updateChatIsRead({
//     required bool isSender,
//     required String myUid,
//     required String personUid,
//     required String chatId}) {
//     try {
//       FirebaseFirestore.instance
//           .collection('people')
//           .doc(isSender ? personUid : myUid)
//           .collection('room')
//           .doc(isSender ? myUid : personUid)
//           .collection('chat')
//           .doc(chatId)
//           .update({'isRead':true})
//           .then((value) => null)
//           .catchError((onError) => print(onError));
//     } catch (e) {
//       print(e);
//     }
//   }
class EventChatRoom {
  static Future<bool> checkRoomIsExist({
    required bool isSender,
    required String myUid,
    required String peopleUid,
  }) async {
    DocumentSnapshot response = await FirebaseFirestore.instance
        .collection('people')
        .doc(isSender ? peopleUid : myUid)
        .collection('room')
        .doc(isSender ? myUid : peopleUid)
        .get();
    return response.exists;
  }

  static updateRoom({
    required bool isSender,
    required String myUid,
    required String peopleUid,
    required Room room,
  }) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? peopleUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : peopleUid)
          .update(room.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static addRoom({
    required bool isSender,
    required String myUid,
    required String peopleUid,
    required Room room,
  }) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? peopleUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : peopleUid)
          .set(room.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static addChat({
    required bool isSender,
    required String myUid,
    required String peopleUid,
    required Chat chat,
  }) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? peopleUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : peopleUid)
          .collection('chat')
          .doc(chat.dateTime.toString())
          .set(chat.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkIsPersonInRoom({
    required String myUid,
    required String peopleUid,
  }) async {
    bool inRoom = false;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('people')
          .doc(myUid)
          .collection('room')
          .doc(peopleUid)
          .get()
          .catchError((onError) => print(onError));
      // inRoom = documentSnapshot.data()['inRoom'];
      inRoom = documentSnapshot.get('inRoom');
    } catch (e) {
      print(e);
    }
    return inRoom;
  }

  static updateChatIsRead({
    required bool isSender,
    required String myUid,
    required String peopleUid,
    required String chatId}) {
    try {
      FirebaseFirestore.instance
          .collection('people')
          .doc(isSender ? peopleUid : myUid)
          .collection('room')
          .doc(isSender ? myUid : peopleUid)
          .collection('chat')
          .doc(chatId)
          .update({'isRead':true})
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }
}
