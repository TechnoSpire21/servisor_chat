part of 'pages.dart';

class Login extends StatefulWidget {
  // const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login"),
      ),
    );
  }
}