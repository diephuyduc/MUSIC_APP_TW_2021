import 'package:flutter/material.dart';
import 'package:my_music_app/model/AuthenticationFirebase.dart';

import 'package:my_music_app/page/home.dart';
import 'package:my_music_app/page/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                 Text("Đăng Nhập ứng dụng", style: TextStyle(fontSize: 30),),
                mTextfied(
                  "email",
                  Icons.email,
                  _email,
                ),
                mTextfied(
                  "password",
                  Icons.lock,
                  _password,
                ),
                mButton("Đăng nhập", () async {
                  var result = await AuthenticationService()
                      .signIn(email: _email.text, password: _password.text);
                  if (result == 'Signed In') {
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
                  child: Text("Tạo tài khoản"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
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
