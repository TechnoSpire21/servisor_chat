part of 'pages.dart';

class ForgotPassword extends StatelessWidget {
  // const ForgotPassword({ Key? key }) : super(key: key);
  var _emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void resetPassword(){
    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text('Link untuk reset password sudah dikirim ke email anda.'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) => value == '' ? 'Isi kolom ini!' : null,
                decoration: InputDecoration(
                  hintText: 'email@example.com',
                  prefixIcon: Icon(Icons.email),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              SizedBox(height: 16,),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //reset pass
                      resetPassword();
                    }
                  },
                  child: Text("Reset Password"),
                  color: Color(0xFF45A1E4),
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
