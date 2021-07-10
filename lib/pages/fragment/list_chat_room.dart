part of 'fragment.dart';

class ListChatRoom extends StatefulWidget {
  const ListChatRoom({ Key? key }) : super(key: key);

  @override
  _ListChatRoomState createState() => _ListChatRoomState();
}

class _ListChatRoomState extends State<ListChatRoom> {
  People _myPeople =
      new People(email: '', name: '', img: '', token: '', uid: '');

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });
  }

  @override
  void initState() {
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("List Chat Room"),
    );
  }
}