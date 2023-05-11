import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inteligentny_dom_5/app/features/homepage/home_page.dart';
import 'package:inteligentny_dom_5/app/features/loginpage/login_page.dart';



class RootPage extends StatelessWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return HomePage(
              user: user,
            );
          }
        });
  }
}
