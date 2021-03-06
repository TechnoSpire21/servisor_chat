part of 'fragment.dart';

class ListChatRoom extends StatefulWidget {
  // const ListChatRoom({Key? key}) : super(key: key);

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
          List<QueryDocumentSnapshot> listRoom = snapshot.data!.docs;
          return ListView.separated(
            itemCount: listRoom.length,
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1,
                height: 1,
              );
            },
            itemBuilder: (context, index) {
              Room room =
                  Room.fromJson(listRoom[index].data() as Map<String, dynamic>);
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
    String today = DateFormat('yyyy/MM/dd').format(DateTime.now());
    String yesterday = DateFormat('yyyy/MM/dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    DateTime roomDateTime =
        DateTime.fromMicrosecondsSinceEpoch(room.lastDateTime);
    String stringLastDateTime = DateFormat('yyyy/MM/dd').format(roomDateTime);
    String time = '';
    if (stringLastDateTime == today) {
      time = DateFormat('HH:mm').format(roomDateTime);
    } else if (stringLastDateTime == yesterday) {
      time = 'Yesterday';
    } else {
      time = DateFormat('yyyy/MM/dd').format(roomDateTime);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatRoom(room: room)));
      },
      child: Container(
        padding: EdgeInsets.all(16),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(room.name),
                  Row(
                    children: [
                      SizedBox(
                        child: room.type == 'image'
                            ? Icon(
                                Icons.image,
                                size: 15,
                                color: Colors.grey[700],
                              )
                            : null,
                      ),
                      SizedBox(height: 4),
                      Text(
                        room.type == 'text'
                            ? room.lastChat.length > 20
                                ? room.lastChat.substring(0, 20) + '...'
                                : room.lastChat
                            : ' <Image>',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$time',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4,),
                countUnreadMessage(room.uid, room.lastDateTime),
                
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget countUnreadMessage(String peopleUid, int lastDateTime){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('people')
      .doc(_myPeople.uid)
      .collection('room')
      .doc(peopleUid)
      .collection('chat')
      .snapshots(includeMetadataChanges: true),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        if(snapshot.data == null){
          return SizedBox();
        }
        List<QueryDocumentSnapshot> listChat = snapshot.data!.docs;
        QueryDocumentSnapshot lastChat = listChat.where((element) =>
        element.get('dateTime') == lastDateTime).toList()[0];

        Chat lastDataChat = Chat.fromJson(lastChat.data() as Map<String, dynamic>);
        if(lastDataChat.uidSender == _myPeople.uid){
          return Icon(
            Icons.check,
            size: 20,
            color: lastDataChat.isRead? Colors.blue:Colors.grey,
          );
        }else{
          int unRead = 0;
          for (var doc in listChat) {
            Chat docChat = Chat.fromJson(doc.data() as Map<String, dynamic>);
            if(!docChat.isRead && docChat.uidSender == peopleUid){
              print("ini doc" + doc.data().toString());
              unRead = unRead + 1;
            }
          }
          if(unRead == 0){
            return SizedBox();
          }else{
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(4),
              child: Text(
                unRead.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }
        }
      },
    );
  }
}
