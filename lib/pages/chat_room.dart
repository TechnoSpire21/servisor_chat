part of 'pages.dart';

class ChatRoom extends StatefulWidget {
  // const ChatRoom({ Key? key }) : super(key: key);
  final Room room;

  const ChatRoom({Key? key, required this.room}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  People _myPeople =
      new People(email: '', name: '', img: '', token: '', uid: '');
  Stream<QuerySnapshot>? _streamChat;
  String _inputMessage = '';
  var _controllerMessage = TextEditingController();

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });
    _streamChat = FirebaseFirestore.instance
        .collection('people')
        .doc(_myPeople.uid)
        .collection('room')
        .doc(widget.room.uid)
        .collection('chat')
        .snapshots(includeMetadataChanges: true);
  }

  void sendMessage(String type, String message) async {
    if (type == 'text') {
      _controllerMessage.clear();
    }

    Chat chat = Chat(
      dateTime: DateTime.now().microsecondsSinceEpoch,
      isRead: false,
      message: message,
      type: type,
      uidReceiver: widget.room.uid,
      uidSender: _myPeople.uid,
    );

    Room roomSender = Room(
        email: _myPeople.email,
        inRoom: true,
        lastChat: message,
        lastDateTime: chat.dateTime,
        lastUid: _myPeople.uid,
        name: _myPeople.name,
        img: _myPeople.img,
        type: type,
        uid: _myPeople.uid);

    Room roomReceiver = Room(
        email: widget.room.email,
        inRoom: false,
        lastChat: message,
        lastDateTime: chat.dateTime,
        lastUid: _myPeople.uid,
        name: widget.room.name,
        img: widget.room.img,
        type: type,
        uid: widget.room.uid);

    //sender room
    bool isSenderRoomExist = await EventChatRoom.checkRoomIsExist(
        isSender: true, myUid: _myPeople.uid, personUid: widget.room.uid);

    if (isSenderRoomExist) {
      EventChatRoom.updateRoom(
          isSender: true,
          myUid: _myPeople.uid,
          personUid: widget.room.uid,
          room: roomSender);
    } else {
      EventChatRoom.addRoom(
          isSender: true,
          myUid: _myPeople.uid,
          personUid: widget.room.uid,
          room: roomSender);
      EventChatRoom.addChat(
          chat: chat,
          isSender: true,
          myUid: _myPeople.uid,
          personUid: widget.room.uid);
    }
    ;

    //receiver room
    bool isReceiverRoomExist = await EventChatRoom.checkRoomIsExist(
        isSender: false, myUid: _myPeople.uid, personUid: widget.room.uid);

    if (isReceiverRoomExist) {
      EventChatRoom.updateRoom(
          isSender: false,
          myUid: _myPeople.uid,
          personUid: widget.room.uid,
          room: roomReceiver);
    } else {
      EventChatRoom.addRoom(
          isSender: false,
          myUid: _myPeople.uid,
          personUid: widget.room.uid,
          room: roomReceiver);
    }
    EventChatRoom.addChat(
        chat: chat,
        isSender: false,
        myUid: _myPeople.uid,
        personUid: widget.room.uid
    );

    String token = await EventPeople.getPeopleToken(widget.room.uid);
    if(token != ''){
      //notif
    }else{
      print(token);
    }
  }

  @override
  void initState() {
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('-----------------AppLifecycleState.inactive');
        break;
      case AppLifecycleState.resumed:
        // EventChatRoom.setMeInRoom(_myPeople.uid, widget.room.uid);
        print('-----------------AppLifecycleState.resumed');
        break;
      case AppLifecycleState.paused:
        // EventChatRoom.setMeOutRoom(_myPeople.uid, widget.room.uid);
        print('-----------------AppLifecycleState.paused');
        break;

      case AppLifecycleState.detached:
        print('-----------------AppLifecycleState.detached');
        break;
      default:
        print('-----------------default');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/servisor.png'),
                image: NetworkImage(widget.room.img),
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
              width: 8,
            ),
            Text(
              widget.room.name,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _streamChat,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data != null && snapshot.data!.docs.length > 0) {
                List<QueryDocumentSnapshot> listChatRoom = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: listChatRoom.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                      height: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    Chat chat = Chat.fromJson(
                        listChatRoom[index].data() as Map<String, dynamic>);
                    return itemChat(chat);
                  },
                );
              } else {
                return Center(
                  child: Text('Empty'),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blue,
              height: 50,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: _inputMessage.contains('\n') ? 4 : 8,
                        horizontal: 16,
                      ),
                      child: TextField(
                        controller: _controllerMessage,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _inputMessage = value;
                          });
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemChat(Chat chat) {
    if (chat.type == 'text') {
      return Text(chat.message);
    } else {
      return Container(
        height: 20,
        width: 100,
        color: Colors.blue,
      );
    }
  }
}
