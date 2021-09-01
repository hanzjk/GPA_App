import 'package:flutter/material.dart';
import 'package:todoapp/auth/authscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/screens/home1.dart';


import 'screens/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var fsconnect = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          //  primaryColor: Colors.purple,
          //  brightness: Brightness.dark,
          ),
      home: StreamBuilder(
          stream: fsconnect.authStateChanges(),
          builder: (context, usersnapshot) {
            if (usersnapshot.hasData) {
              return mainPage();
              //return Home();

            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
