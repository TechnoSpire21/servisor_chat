part of 'event.dart';

class EventPeople {
  static Future<String> checkEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('people')
        .where('email', isEqualTo: email)
        .get()
        .catchError((onError) => print(onError));
    if (querySnapshot != null && querySnapshot.docs.length > 0) {
      if (querySnapshot.docs.length > 0) {
        return querySnapshot.docs[0].get('uid').toString();
      } else {
        return '';
      }
    }
    return '';
  }

  static void addPeople(People people) async {
    try {
      await FirebaseFirestore.instance
          .collection('people')
          .doc(people.uid)
          .set(people.toJson())
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  static void updatePeopleToken(String myUid, String token) async {
    try {
      //update profile
      FirebaseFirestore.instance
          .collection('people')
          .doc(myUid)
          .update({
            'token': token,
          })
          .then((value) => null)
          .catchError((onError) => print(onError));
      //update contact
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('people').get();
      querySnapshot.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
        queryDocumentSnapshot.reference
            .collection('contact')
            .where('uid', isEqualTo: myUid)
            .get()
            .then((value) {
          value.docs.forEach((docContact) {
            docContact.reference
                .update({
                  'token': token,
                })
                .then((value) => null)
                .catchError((onError) => print(onError));
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<People> getPeople(String uid) async {
    People? people;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('people')
        .doc(uid)
        .get()
        .catchError((onError) => print("${onError.error}"));
    people = People.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return people;
  }

  static Future<String> getPersonToken(String uid) async{
    try {
      String token = '';
    DocumentSnapshot response = await FirebaseFirestore.instance.collection('people')
    .doc(uid)
    .get()
    .catchError((onError)=>print(onError));
    token = response.data()!['token'];
    } catch (e) {
      print(e)
    }
    return token;
  }
}
