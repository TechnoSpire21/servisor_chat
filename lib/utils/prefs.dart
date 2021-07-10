part of 'utils.dart';

class Prefs{
  static Future<People> getPeople() async{
    late People people;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? peopleString = pref.getString('people');
      print('masuk oe');
      print(peopleString);
      Map<String, dynamic> peopleJson = json.decode(peopleString!); 
      people = People.fromJson(peopleJson);
      print('MASUK DI TRY');
    } catch (e) {
      print(e);
      print('MASUK DI ERROR');
    }
    return people;
  }

  static void setPeople (People people) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('people', json.encode(people.toJson()));
  }

  static void clear() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}