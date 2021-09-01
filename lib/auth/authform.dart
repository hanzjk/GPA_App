import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //------------------------------------
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _pwd = '';
  var _username = '';
  bool isLogin = false;
  //-------------------------------------
  startAuthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState!.save();
      submitForm(_email, _pwd, _username);
    }
  }

  submitForm(String email, String pwd, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult =
            await auth.signInWithEmailAndPassword(email: email, password: pwd);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: pwd);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  //-------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100, left: 30, right: 30),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Form(
                key: _formkey, //to validate form data
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLogin)
                      TextFormField(
                        //Username

                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide()),
                          labelText: 'Enter Username',
                          labelStyle: GoogleFonts.roboto(),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      //Email Address
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide()),
                        labelText: 'Enter Email',
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      //password
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      key: ValueKey('pwd'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _pwd = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide()),
                        labelText: 'Enter Password',
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      height: 60.0,
                      width: double.infinity,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          startAuthentication();
                        },
                        color: Colors.indigo,
                        child: isLogin
                            ? Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              )
                            : Text(
                                'SignUp',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      //To toggle between two forms
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: isLogin
                            ? Text('Not a member')
                            : Text('Already has an account'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
