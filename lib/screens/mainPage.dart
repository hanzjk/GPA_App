import 'package:flutter/material.dart';
import 'package:todoapp/screens/home1.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AddNewSemester.dart';

List<String> SGPA_values = [];
List<String> sem_credits = [];

class mainPage extends StatefulWidget {
  double credits = 0, gpa = 0;
  mainPage() {}
  mainPage.copyContructor(this.credits, this.gpa) {}

  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  String overallGPA = '0.00';

  String? uid;
  @override
  initState() {
    getuid();

    super.initState();
  }

  getuid() async {
    FirebaseAuth? auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    debugPrint('user: ' + user!.uid);
    setState(() {
      uid = user.uid;
    });
    getOGP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('GPA Calculator'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade500,
                ),
                child: Text(
                  '4.0 Scale',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'A+',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '4.00',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'A',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    SizedBox(width: 83),
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        '4.00',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'A-',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 74, top: 20),
                      child: Text(
                        '3.70',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'B+',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '3.30',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'B  ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    SizedBox(width: 73),
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        '3.00',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'B- ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '2.70',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'C+',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '2.30',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'C  ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '2.00',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, top: 20),
                      child: Text(
                        'R  ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 20),
                      child: Text(
                        '0.00',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo.shade50,
          //  height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo.shade600,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.star,
                        size: 45,
                        color: Colors.white,
                      ),
                      Text(
                        ' Overall GPA',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        overallGPA,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              ///print data to screen
              ///
              ///
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(30, 10, 100, 10),
                  child: OutlineButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return AddSemester(); //send the sem no
                        }));
                      },
                      borderSide: BorderSide(color: Colors.indigo.shade400),
                      shape: StadiumBorder(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.indigo.shade700,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Add New Semester',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ],
                      ))),
              Container(
                color: Colors.indigo.shade50,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    semResults('1'),
                    semResults('2'),
                    semResults('3'),
                    semResults('4'),
                    semResults('5'),
                    semResults('6'),
                    semResults('7'),
                    semResults('8'),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget semResults(String sem) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('GPAvalues')
          .doc(uid)
          .collection('sem0' + sem)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 10.0,
            width: 10.0,
            child: CircularProgressIndicator(),
          );
          // ignore: dead_code, dead_code
        } else {
          final docs = (snapshot.data! as QuerySnapshot).docs;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              SGPA_values.add(docs[index]['SGPA'].toString());
              sem_credits.add(docs[index]['Totcredits'].toString());

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.indigo.shade600,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            'Semester 0' + sem,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          Text(
                            'Credits : ' + docs[index]['Totcredits'].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 61,
                      ),
                      Column(
                        children: [
                          Text(
                            'SGPA',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          Text(
                            docs[index]['SGPA'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return Home1(int.parse(sem)); //send the sem no
                          }));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.indigo.shade700,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }, //Text(docs[index]['module'].toString()),
          );

          ;
        }
      },
    );
  }

  Future<double> computeGPA() async {
    List<String> credit_list = [];
    List<String> grade_list = [];

    for (int i = 0; i < 9; i++) {
      var collection = FirebaseFirestore.instance
          .collection('GPAvalues')
          .doc(uid)
          .collection('sem0' + i.toString());

      var querySnapshot = await collection.get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        grade_list.add(data['SGPA']);
        credit_list.add(data['Totcredits']);
      }
    }
    double multi = 0, tot = 0;
    for (int j = 0; j < credit_list.length; j++) {
      multi =
          multi + double.parse(credit_list[j]) * double.parse(grade_list[j]);
      tot = tot + double.parse(credit_list[j]);
    }
    double OGPA = multi / tot;
    //overallGPA = OGPA;
    debugPrint('OGPA1:' + OGPA.toString());
    debugPrint('OGPA2:' + overallGPA.toString());

    return OGPA;
  }

  getOGP() async {
    var collection = FirebaseFirestore.instance
        .collection('GPAvalues')
        .doc(uid)
        .collection('overallResults');

    var querySnapshot = await collection.get();
    String temp = '0.00';
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      temp = data['OGPA'];
    }
    setState(() {
      overallGPA = temp;
    });
  }
}
