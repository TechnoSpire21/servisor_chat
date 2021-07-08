part of 'pages.dart';

class Login extends StatefulWidget {
  // const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void loginWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text);
      if (userCredential.user!.uid != null) {
        if (userCredential.user!.emailVerified) {
          String token = await NotifController.getTokenFromDevice();
          EventPeople.updatePeopleToken(userCredential.user!.uid, token);
          // EventPeople.getPeople(userCredential.user!.uid).then((people) {
          //   Prefs.setPeople(people);
          // });
          showNotifSnackBar('Berhasil login');
          print("Berhasil login");
           Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
          _emailController.clear();
          _passController.clear();
        } else {
          print("Email belum ter-verifikasi");
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
            content: Text('Email belum ter-verifikasi'),
            action: SnackBarAction(
              label: "Send Verif",
              onPressed: () async{
                await userCredential.user!.sendEmailVerification();
              },
            ),
          ));
        }
      } else {
        showNotifSnackBar('Failed');
        print("Failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showNotifSnackBar('Tidak ada user dengan email itu.');
        print('Tidak ada user dengan email itu.');
      } else if (e.code == 'wrong-password') {
        showNotifSnackBar('Email atau password salah.');
        print('Email atau password salah.');
      }
    }
    _emailController.clear();
    _passController.clear();
  }

  void showNotifSnackBar(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

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
                  Text("Tidak ada akun? "),
                  SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
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
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Text("Lupa password? ")),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //login Auth function
                                loginWithEmailAndPassword();
                              }
                            },
                            child: Text("Login"),
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
