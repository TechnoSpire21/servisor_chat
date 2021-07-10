part of 'event.dart';

class EventContact{
  static void addContact({String? myUid, People? people}){
    try {
      FirebaseFirestore.instance.collection('people')
      .doc(myUid)
      .collection('contact')
      .doc(people!.uid)
      .set(people.toJson())
      .then((value) => null)
      .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }
}