part of 'fragment.dart';

class ListContact extends StatefulWidget {
  const ListContact({Key? key}) : super(key: key);

  @override
  _ListContactState createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  var _emailController = TextEditingController();

  People _myPeople =
      new People(email: '', name: '', img: '', token: '', uid: '');

  // CollectionReference contactCollection = FirebaseFirestore.instance.collection("")

  //error screen merah
  Stream<QuerySnapshot>? _streamContact;

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });
    _streamContact = FirebaseFirestore.instance
        .collection('people')
        .doc(_myPeople.uid)
        .collection('contact')
        .snapshots(includeMetadataChanges: true);
  }

  void addNewContact() async {
    var value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          contentPadding: EdgeInsets.all(16),
          title: Text("Add Contact"),
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'email@example.com',
              ),
              textAlignVertical: TextAlignVertical.bottom,
            ),

            SizedBox(
              height: 16,
            ),

            RaisedButton(
              child: Text("Add"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context, 'add'),
            ),
            OutlineButton(
              child: Text("Close"),
              color: Colors.blue,
              textColor: Colors.blue,
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
    if(value == 'add'){
      String peopleUid = await EventPeople.checkEmail(_emailController.text);
      if(peopleUid != ''){
        EventPeople.getPeople(peopleUid).then((people){
          EventContact.addContact(myUid: _myPeople.uid, people: people);
        });
      }
    }
    _emailController.clear();
  }

  @override
  void initState() {
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _streamContact,
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
                  People people = People.fromJson(
                      listContact[index].data() as Map<String, dynamic>);
                  return itemContact(people);
                },
              );
            } else {
              return Center(
                child: Text('Empty'),
              );
            }
            // return ListView.separated(
            //   itemBuilder: null,
            //   separatorBuilder: null,
            //   itemCount: null
            // );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: (){
              addNewContact();
            },
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget itemContact(People people) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProfilePeople(
          //       people: people,
          //       myUid: _myPeople.uid,
          //     ),
          //   ),
          // );
        },
        child: SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/servisor.png'),
              image: NetworkImage(people.img),
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
        ),
      ),
      title: Text(people.name),
      subtitle: Text(people.email),
      trailing: IconButton(
        icon: Icon(Icons.message),
        onPressed: () {
          Room room = Room(
            email: people.email,
            inRoom: false,
            lastChat: '',
            lastDateTime: 0,
            lastUid: '',
            name: people.name,
            img: people.img,
            type: '',
            uid: people.uid,
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ChatRoom(room: room)),
          // );
        },
      ),
    );
  }
}
