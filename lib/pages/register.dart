part of 'pages.dart';

class Register extends StatefulWidget {
  // const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _scaffoldKey = GlobalKey<FormState>();

  void registerAccount() async {
    // if (await EventPeople.checkEmail(_emailController.text) == '') {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text, password: _passController.text);
        if (userCredential.user!.uid != null) {
          print('Akun terbuat');
          People people = People(
            email: _emailController.text,
            name: _nameController.text,
            img: '',
            token: '',
            uid: userCredential.user!.uid,
          );
          EventPeople.addPeople(people);
          await userCredential.user!.sendEmailVerification();
          _nameController.clear();
          _emailController.clear();
          _passController.clear();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    // }
    _nameController.clear();
    _emailController.clear();
   _passController.clear();
  }

  // void showNotifSnackBar(String message){
  //   _scaffoldKey.currentState!.showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 16,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah ada akun? "),
                  SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Klik di sini!",
                      style: TextStyle(
                        color: Color(0xFF45A1E4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/servisor.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) =>
                              value == '' ? 'Isi kolom ini!' : null,
                          decoration: InputDecoration(
                              hintText: 'nama anda...',
                              prefixIcon: Icon(Icons.person)),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) =>
                              value == '' ? 'Isi kolom ini!' : null,
                          decoration: InputDecoration(
                            hintText: 'email@example.com',
                            prefixIcon: Icon(Icons.email),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _passController,
                          validator: (value) =>
                              value == '' ? 'Isi kolom ini!' : null,
                          decoration: InputDecoration(
                            hintText: 'password...',
                            prefixIcon: Icon(Icons.vpn_key),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //Register Auth function
                                registerAccount();
                              }
                            },
                            child: Text("Register"),
                            color: Color(0xFF45A1E4),
                            textColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
