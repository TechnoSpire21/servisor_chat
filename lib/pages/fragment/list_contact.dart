part of 'fragment.dart';

class ListContact extends StatefulWidget {
  const ListContact({ Key? key }) : super(key: key);

  @override
  _ListContactState createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {

  People _myPeople =
      new People(email: '', name: '', img: '', token: '', uid: '');

  late Stream<QuerySnapshot> _streamContact;  

  Future<void> getMyPeople() async {
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();

    setState(() {
      _myPeople = people;
    });
    FirebaseFirestore.instance.collection('people')
      .doc(_myPeople.uid)
      .collection('contact')
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
      stream: _streamContact,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong')
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
        if(snapshot.data != null && snapshot.data!.docs.length > 0){
          List<QueryDocumentSnapshot> listContact = snapshot.data!.docs;
          return ListView.separated(
            itemCount: listContact.length,
            separatorBuilder: (context, index){
              return Divider(
                thickness: 1,
                height: 1,
              );
            }, 
            itemBuilder: (context, index){
              People people = People.fromJson(listContact[index].data() as Map<String, dynamic>);
              return itemContact(people);
            }, 
            
          );
        }else{
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
    );
  }

  Widget itemContact(People people){
    return ListTile(
      title: Text('Name'),
      subtitle: Text('Email'),
    );
  }
}