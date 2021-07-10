part of 'event.dart';

class EventStorage {
  static void editPhoto({String? oldUrl, File? filePhoto, required String uid}) async {
    // if (oldUrl != '') deleteOldFile(oldUrl!);
    try {
      String fileName = basename(filePhoto!.path);
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref()
          .child('$uid/$fileName')
          .putFile(filePhoto);
      String newUrl = await taskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('people')
          .doc(uid)
          .update({'img': newUrl})
          .then((value) => null)
          .catchError((onError) => print(onError));
    } catch (e) {
      print(e);
    }
  }

  // static void deleteOldFile(String oldUrl) async {
  //   try {
  //     String urlFile = FirebaseStorage.instance.refFromURL(oldUrl).fullPath;
  //     await FirebaseStorage.instance.ref(urlFile).delete();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<String> uploadMessageImageAndGetUrl({
  //   File filePhoto,
  //   String myUid,
  //   String peopleUid,
  // }) async {
  //   String imageUrl = '';
  //   try {
  //     String fileName = basename(filePhoto.path);
  //     TaskSnapshot taskSnapshot = await FirebaseStorage.instance
  //         .ref()
  //         .child('$myUid/$peopleUid/$fileName')
  //         .putFile(filePhoto);
  //     imageUrl = await taskSnapshot.ref.getDownloadURL();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return imageUrl;
  // }
}
