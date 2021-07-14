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
  Chat? _selectedChat;

  void getSelectedDefault() {
    setState(() {
      _selectedChat = Chat(
        dateTime: 0,
        isRead: false,
        message: '',
        type: '',
        uidReceiver: '',
        uidSender: '',
      );
    });
  }

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });
    EventChatRoom.setMeInRoom(_myPeople.uid, widget.room.uid);
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

    bool peopleInRoom = await EventChatRoom.checkIsPersonInRoom(
        myUid: _myPeople.uid, peopleUid: widget.room.uid);

    Room roomSender = Room(
        email: _myPeople.email,
        inRoom: peopleInRoom,
        lastChat: message,
        lastDateTime: chat.dateTime,
        lastUid: _myPeople.uid,
        name: _myPeople.name,
        img: _myPeople.img,
        type: type,
        uid: _myPeople.uid);

    Room roomReceiver = Room(
        email: widget.room.email,
        inRoom: peopleInRoom,
        lastChat: message,
        lastDateTime: chat.dateTime,
        lastUid: _myPeople.uid,
        name: widget.room.name,
        img: widget.room.img,
        type: type,
        uid: widget.room.uid);

    // Sender Room
    bool isSenderRoomExist = await EventChatRoom.checkRoomIsExist(
      isSender: true,
      myUid: _myPeople.uid,
      peopleUid: widget.room.uid,
    );
    if (isSenderRoomExist) {
      EventChatRoom.updateRoom(
        isSender: true,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
        room: roomSender,
      );
    } else {
      EventChatRoom.addRoom(
        isSender: true,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
        room: roomSender,
      );
    }
    EventChatRoom.addChat(
      chat: chat,
      isSender: true,
      myUid: _myPeople.uid,
      peopleUid: widget.room.uid,
    );

    // Receiver Room
    bool isReceiverRoomExist = await EventChatRoom.checkRoomIsExist(
      isSender: false,
      myUid: _myPeople.uid,
      peopleUid: widget.room.uid,
    );
    if (isReceiverRoomExist) {
      EventChatRoom.updateRoom(
        isSender: false,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
        room: roomReceiver,
      );
    } else {
      EventChatRoom.addRoom(
        isSender: false,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
        room: roomReceiver,
      );
    }
    EventChatRoom.addChat(
      chat: chat,
      isSender: false,
      myUid: _myPeople.uid,
      peopleUid: widget.room.uid,
    );

    String token = await EventPeople.getPeopleToken(widget.room.uid);
    if (token != '') {
      //notif
      await NotifController.sendNotification(
        myLastChat: message,
        myUid: _myPeople.name,
        myName: _myPeople.uid,
        photo: _myPeople.img,
        peopleToken: token,
        type: type,
      );
    } else {
      print(token);
    }

    if (peopleInRoom) {
      EventChatRoom.updateChatIsRead(
        chatId: chat.dateTime.toString(),
        isSender: true,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
      );
      EventChatRoom.updateChatIsRead(
        chatId: chat.dateTime.toString(),
        isSender: false,
        myUid: _myPeople.uid,
        peopleUid: widget.room.uid,
      );
    }
  }

  void pickAndCropImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        //method send image
        EventStorage.uploadMessageImageAndGetUrl(
                filePhoto: File(croppedFile.path),
                myUid: _myPeople.uid,
                peopleUid: widget.room.uid)
            .then((imageUrl) {
          sendMessage('image', imageUrl);
        });
      }
    }
    getMyPeople();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    getSelectedDefault();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.addObserver(this);
    EventChatRoom.setMeOutRoom(_myPeople.uid, widget.room.uid);
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
        EventChatRoom.setMeInRoom(_myPeople.uid, widget.room.uid);
        print('-----------------AppLifecycleState.resumed');
        break;
      case AppLifecycleState.paused:
        EventChatRoom.setMeOutRoom(_myPeople.uid, widget.room.uid);
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
        actions: [
          SizedBox(
            child: _selectedChat!.message != '' && _selectedChat!.type == 'text'
                ? IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      FlutterClipboard.copy(_selectedChat!.message)
                          .then((value) => print('copied'));
                      getSelectedDefault();
                    },
                  )
                : null,
          ),
        ],
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
                return GroupedListView<QueryDocumentSnapshot, String>(
                  elements: listChatRoom, 
                  groupBy: (element){
                    Chat chat = Chat.fromJson(element.data() as Map<String, dynamic>);
                    DateTime chatDateTime = DateTime.fromMicrosecondsSinceEpoch(chat.dateTime);
                    String dateTime = DateFormat('yyyy/MM/dd').format(chatDateTime);
                    return dateTime;
                  },
                  groupSeparatorBuilder: (value) {
                    String group = '';
                    String today =
                        DateFormat('yyyy/MM/dd').format(DateTime.now());
                    String yesterday = DateFormat('yyyy/MM/dd')
                        .format(DateTime.now().subtract(Duration(days: 1)));
                    if (value == today) {
                      group = 'Today';
                    } else if (value == yesterday) {
                      group = 'Yesterday';
                    } else {
                      group = value;
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          group,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  itemComparator: (item1, item2) => item1.id.compareTo(item2.id),
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  indexedItemBuilder: (context, element, index){
                    final reverseIndex = listChatRoom.length - 1 - index;
                    Chat chat = Chat.fromJson(
                        listChatRoom[reverseIndex].data() as Map<String, dynamic>);
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _selectedChat = chat;
                        });
                      },
                      onTap: (){
                        getSelectedDefault();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom:  reverseIndex == listChatRoom.length - 1 ? 65 : 0
                        ),
                        padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                        color: _selectedChat!.dateTime == chat.dateTime
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.transparent,
                        child: itemChat(chat),
                      ),
                    );
                  },
                );
                // return ListView.builder(
                //   itemCount: listChatRoom.length,
                //   itemBuilder: (context, index) {
                    
                //   },
                // );
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
                      onPressed: () {
                        pickAndCropImage();
                      },
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
                      onPressed: () {
                        sendMessage('text', _controllerMessage.text);
                      },
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
    DateTime chatDateTime = DateTime.fromMicrosecondsSinceEpoch(chat.dateTime);
    String dateTime = DateFormat('HH:mm').format(chatDateTime);

    // if (chat.type == 'text') {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: chat.uidSender == _myPeople.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      //icon read ato gak
      children: [
        SizedBox(
          child: chat.uidSender == _myPeople.uid && chat.isRead
              ? Icon(Icons.check, size: 20, color: Colors.blue)
              : null,
        ),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          child: chat.uidSender == _myPeople.uid
              ? Text(
                  dateTime,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                )
              : null,
        ),
        SizedBox(
          width: 4,
        ),
        chat.type == 'text' ? messageText(chat) : messageImage(chat),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          child: chat.uidSender == widget.room.uid
              ? Text(
                  dateTime,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                )
              : null,
        ),
        SizedBox(
          width: 4,
        ),
      ],
    );
    // }
  }

  Widget messageText(Chat chat) => Container(
        // width: MediaQuery.of(context).size.width * 0.6,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        decoration: BoxDecoration(
            color: chat.uidSender == _myPeople.uid
                ? Colors.blue
                : Colors.blue[300],
            borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(chat.uidSender == _myPeople.uid ? 10 : 0),
              topRight:
                  Radius.circular(chat.uidSender == _myPeople.uid ? 0 : 10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        padding: EdgeInsets.all(8),
        child: ParsedText(
          text: chat.message,
          style: TextStyle(color: Colors.white70),
          parse: [
            MatchText(
                type: ParsedType.EMAIL,
                style: TextStyle(
                  color: Colors.yellow,
                ),
                onTap: (url) {
                  launch("mailto:" + url);
                }),
            MatchText(
                type: ParsedType.URL,
                style: TextStyle(
                  color: Colors.yellow,
                ),
                onTap: (url) async {
                  var a = await canLaunch(url);
                  if (a) launch(url);
                }),
            MatchText(
                type: ParsedType.PHONE,
                style: TextStyle(
                  color: Colors.yellow,
                ),
                onTap: (url) {
                  launch("tel:" + url);
                }),
          ],
        ),
      );

  Widget messageImage(Chat chat) => GestureDetector(
        onTap: () => showImageFull(chat.message),
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: chat.uidSender == _myPeople.uid
                ? Colors.blue
                : Colors.blue[800],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                chat.uidSender == _myPeople.uid ? 10 : 0,
              ),
              topRight: Radius.circular(
                chat.uidSender == _myPeople.uid ? 0 : 10,
              ),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                chat.uidSender == _myPeople.uid ? 10 : 0,
              ),
              topRight: Radius.circular(
                chat.uidSender == _myPeople.uid ? 0 : 10,
              ),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/servisor.png'),
              image: NetworkImage(chat.message),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
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
        ),
      );

  void showImageFull(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          PhotoView(
            enableRotation: true,
            imageProvider: NetworkImage(imageUrl),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.5),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
