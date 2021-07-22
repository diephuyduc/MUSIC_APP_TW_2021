import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_music_app/core/text_avatar.dart';
import 'package:my_music_app/page/login.dart';

class MPerson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
         
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                // borderRadius: BorderRadius.circular()
              ),
              height: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset('assets/singer.gif'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                FirebaseAuth.instance.currentUser.email,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 250,
            ),
            Container(
              child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                      (route) => false);
                },
                child: Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(child: Container()),
            Text(
              "Copyright @2021",
            ),
          ],
        ),
      ),
    );
  }
}
