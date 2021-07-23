part of 'pages.dart';

class EditProfile extends StatefulWidget {
  final People people;

  const EditProfile({Key? key, required this.people}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _controllerOldEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _controllerName = TextEditingController();
  var _controllerNewEmail = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> changeEmail() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _controllerOldEmail.text,
            password: _controllerPassword.text);
    if (userCredential != null) {
      await userCredential.user!.updateEmail(_controllerNewEmail.text);
      await userCredential.user!.sendEmailVerification();
      return true;
    } else {
      return false;
    }
  }

  void updateToFirestore() {
    Map<String, dynamic> newData = {
      'email': _controllerNewEmail.text,
      'name': _controllerName.text,
    };

    // update in people
    FirebaseFirestore.instance
        .collection('people')
        .doc(widget.people.uid)
        .update(newData)
        .then((value) => null)
        .catchError((onError) => print(onError));
    // update in contact
    FirebaseFirestore.instance.collection('people').get().then((value) {
      for (var docPeople in value.docs) {
        docPeople.reference
            .collection('contact')
            .where('uid', isEqualTo: widget.people.uid)
            .get()
            .then((snapshotContact) {
          for (var docContact in snapshotContact.docs) {
            docContact.reference.update(newData);
          }
        });
      }
    }).catchError((onError) => print(onError));
    // update in room
    FirebaseFirestore.instance.collection('people').get().then((value) {
      for (var docPeople in value.docs) {
        docPeople.reference
            .collection('room')
            .where('uid', isEqualTo: widget.people.uid)
            .get()
            .then((snapshotContact) {
          for (var docRoom in snapshotContact.docs) {
            docRoom.reference.update(newData);
          }
        });
      }
    }).catchError((onError) => print(onError));
  }

  void updateProfile() {
    if (_controllerOldEmail.text != _controllerNewEmail.text) {
      changeEmail().then((success) {
        if (success) {
          updateToFirestore();
          showNotif('Success Change Email & Update Profile');
        } else {
          showNotif('Failed Change Email & Update Profile');
        }
      });
    } else {
      updateToFirestore();
      showNotif('Succes Update Name');
    }
    EventPeople.getPeople(widget.people.uid).then((people) {
      Prefs.setPeople(people);
    });
  }

  void showNotif(String message) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    _controllerOldEmail.text = widget.people.email;
    _controllerName.text = widget.people.name;
    _controllerNewEmail.text = widget.people.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerOldEmail,
                validator: (value) => value == '' ? "Don't Empty" : null,
                decoration: InputDecoration(
                  hintText: 'Old Email',
                  labelText: 'Old Email',
                  prefixIcon: Icon(Icons.email),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              TextFormField(
                controller: _controllerPassword,
                validator: (value) => value == '' ? "Don't Empty" : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
              ),
              TextFormField(
                controller: _controllerName,
                validator: (value) => value == '' ? "Don't Empty" : null,
                decoration: InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              TextFormField(
                controller: _controllerNewEmail,
                validator: (value) => value == '' ? "Don't Empty" : null,
                decoration: InputDecoration(
                  hintText: 'New Email',
                  labelText: 'New Email',
                  prefixIcon: Icon(Icons.email),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              SizedBox(height: 16),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateProfile();
                    }
                  },
                  child: Text('Update Profile'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}