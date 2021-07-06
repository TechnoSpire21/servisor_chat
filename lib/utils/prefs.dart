part of 'utils.dart';

class Prefs{
  static Future<Person> getPerson() async{
    Person person;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String personString = pref.getString('person');
      Map<String, dynamic> personJson = json.decode(personString); 
      person = Person.fromJson(personJson);
    } catch (e) {
      print(e);
    }
    return person;
  }

  static void setPerson (Person person) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('person', json.encode(person.toJson()));
  }

  static void clear() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}