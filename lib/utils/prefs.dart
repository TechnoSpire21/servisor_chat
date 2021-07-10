part of 'utils.dart';

class Prefs{
  static Future<People> getPeople() async{
    late People people;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? peopleString = pref.getString('people');
      Map<String, dynamic> peopleJson = json.decode(peopleString!); 
      people = People.fromJson(peopleJson);
    } catch (e) {
      print(e);
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