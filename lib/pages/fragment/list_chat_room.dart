part of 'fragment.dart';

class ListChatRoom extends StatefulWidget {
  const ListChatRoom({Key? key}) : super(key: key);

  @override
  _ListChatRoomState createState() => _ListChatRoomState();
}

class _ListChatRoomState extends State<ListChatRoom> {
  People _myPeople =
      new People(email: '', name: '', img: '', token: '', uid: '');

  Stream<QuerySnapshot>? _streamRoom;

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });

    _streamRoom = FirebaseFirestore.instance
        .collection('people')
        .doc(_myPeople.uid)
        .collection('room')
        .snapshots(includeMetadataChanges: true);
  }

  @override
  void initState() {
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _streamRoom,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data != null && snapshot.data!.docs.length > 0) {
          List<QueryDocumentSnapshot> listContact = snapshot.data!.docs;
          return ListView.separated(
            itemCount: listContact.length,
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1,
                height: 1,
              );
            },
            itemBuilder: (context, index) {
              Room room = Room.fromJson(ListChatRoom[index].data());
              return itemRoom(room);
            },
          );
        } else {
          return Center(
            child: Text('Empty'),
          );
        }
      },
    );
  }

  Widget itemRoom(Room room) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/servisor.png'),
              image: NetworkImage(room.img),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/servisor.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(room.name), Text(room.lastChat)],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${room.lastDateTime}'),
              Text("Badge"),
            ],
          )
        ],
      ),
    );
  }
}
