import 'package:flutter/material.dart';
import 'package:my_music_app/model/AuthenticationFirebase.dart';
import 'package:my_music_app/page/home.dart';
import 'package:my_music_app/page/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Container(
          child: SingleChildScrollView(
                      child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Container(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/music.gif"),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text("TTD Music", style: TextStyle(fontSize: 35, color: Colors.red),),),
                Text("Đăng ký tài khoản", style: TextStyle(fontSize: 30),),
                mTextfied(
                  "Email",
                  Icons.email,
                  _email,
                ),
                mTextfied(
                  "Mật khẩu",
                  Icons.lock,
                  _password,
                ),
                mButton("Đăng ký", () async {
                  String resl = await AuthenticationService()
                      .signUp(email: _email.text, password: _password.text);
                  if (resl == "Signed In") {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                  }
                }),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Text("Đăng nhập"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  mTextfied(String lable, IconData icon,
      TextEditingController textEditingController) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
         border: Border.all(color: Colors.blueAccent)
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: lable,
        ),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  mButton(String lable, Function onPressed) {
    return FloatingActionButton.extended(
        onPressed: onPressed, label: Text(lable));
  }
}
