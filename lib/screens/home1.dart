import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/screens/mainPage.dart';

import 'AddnewModule.dart';
import 'updateModule.dart';

List<String> credits = [];
List<String> grade = [];
List<String> modules = [];

int count = 0;
String OverallGPA = '0.00';

class Home1 extends StatefulWidget {
  int sem;
  Home1(this.sem);
  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
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
  }

  String sgpa = '0.00';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester 0' + widget.sem.toString() + ' Results'),
        backgroundColor: Colors.indigo.shade500,
        centerTitle: true,
        
       
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 40),
      //               child: Text(
      //                 'Add New Module ',
      //                 style: TextStyle(
      //                     color: Colors.indigo.shade700,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //             content: AddNewModule(widget.sem.toString()),
      //           );
      //         });
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.indigo.shade500,
      // ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('GPAvalues')
                    .doc(uid)
                    .collection('sem0' + widget.sem.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = (snapshot.data! as QuerySnapshot).docs;

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        sgpa = docs[index]['SGPA'].toString();
                        return Row(
                          children: [
                            SizedBox(
                              width: 80,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(60, 20, 60, 20),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      size: 45,
                                      color: Colors.indigo.shade600,
                                    ),
                                    Text(
                                      ' Semester GPA',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.indigo.shade600),
                                    ),
                                    Text(
                                      sgpa,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.indigo.shade600,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(90, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(30, 10, 100, 10),
                  child: FlatButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    'Add New Module ',
                                    style: TextStyle(
                                        color: Colors.indigo.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: AddNewModule(widget.sem.toString()),
                              );
                            });
                      },
                      color: Colors.indigo.shade600,
                      shape: StadiumBorder(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Add New Module',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ))),
              SizedBox(
                height: 0,
              ),

              ///print data to screen
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('semsterResults')
                    .doc(uid)
                    .collection('sem0' + widget.sem.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = (snapshot.data! as QuerySnapshot).docs;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        String credit1 = docs[index]['credits'];
                        String grade1 = docs[index]['grade'];

                        return /////////////////////////////////
                            Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 330,
                                      child: Text(
                                        docs[index]['module'].toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo.shade600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Credits : ' +
                                                docs[index]['credits']
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.indigo.shade600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Grade : ' +
                                                docs[index]['grade'].toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.indigo.shade600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 50),
                                          child: IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 40),
                                                        child: Text(
                                                            'Update Module Info',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .indigo
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      content: updateModule(
                                                          widget.sem.toString(),
                                                          index,
                                                          credit1,
                                                          grade1),
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.edit),
                                            color: Colors.indigo.shade600,
                                            iconSize: 30,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: IconButton(
                                            iconSize: 30,
                                            onPressed: () async {
                                              debugPrint(index.toString());
                                              await FirebaseFirestore.instance
                                                  .collection('semsterResults')
                                                  .doc(uid)
                                                  .collection('sem0' +
                                                      widget.sem.toString())
                                                  .doc(docs[index]['moduleID'])
                                                  .delete()
                                                  .then((value) async {
                                                Fluttertoast.showToast(
                                                  msg: "Module Deleted",
                                                );

                                                var collection =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'semsterResults')
                                                        .doc(uid)
                                                        .collection('sem0' +
                                                            widget.sem
                                                                .toString());
                                                var querySnapshot =
                                                    await collection.get();
                                                List<String> credit_list = [];
                                                List<String> grade_list = [];

                                                for (var queryDocumentSnapshot
                                                    in querySnapshot.docs) {
                                                  Map<String, dynamic> data =
                                                      queryDocumentSnapshot
                                                          .data();

                                                  grade_list.add(data['grade']);

                                                  credit_list
                                                      .add(data['credits']);
                                                }

                                                double newSGP = updateSGPA(
                                                    grade_list, credit_list);
                                                for (int i = 0;
                                                    i < credit_list.length;
                                                    i++) {
                                                  debugPrint('credits :' +
                                                      credit_list[i] +
                                                      'grade :' +
                                                      grade_list[i]);
                                                }
                                                double newCredits =
                                                    creditSum(credit_list);

                                                debugPrint('Totcredits:' +
                                                    newCredits
                                                        .toStringAsFixed(2));
                                                debugPrint('SGPA:' +
                                                    newSGP.toStringAsFixed(2));

                                                String semid = FirebaseFirestore
                                                    .instance
                                                    .collection('GPAvalues')
                                                    .doc(uid)
                                                    .collection('sem0' +
                                                        widget.sem.toString())
                                                    .doc()
                                                    .id
                                                    .toString();

                                                var collection_del =
                                                    FirebaseFirestore.instance
                                                        .collection('GPAvalues')
                                                        .doc(uid)
                                                        .collection('sem0' +
                                                            widget.sem
                                                                .toString());
                                                var querySnapshot_del =
                                                    await collection_del.get();
                                                for (var queryDocumentSnapshot
                                                    in querySnapshot_del.docs) {
                                                  queryDocumentSnapshot
                                                      .reference
                                                      .delete();
                                                }

                                                await FirebaseFirestore.instance
                                                    .collection('GPAvalues')
                                                    .doc(uid)
                                                    .collection('sem0' +
                                                        widget.sem.toString())
                                                    .doc(semid)
                                                    .set({
                                                  'semID': semid,
                                                  'SGPA':
                                                      newSGP.toStringAsFixed(2),
                                                  'Totcredits':
                                                      newCredits.toString(),
                                                }).then((val) async {
                                                  Fluttertoast.showToast(
                                                    msg: "SGPA Updated",
                                                  );
//////////////////////////////////OGPA/////////////////////////////////
                                                  List<String> Totcredit_list =
                                                      [];
                                                  List<String> OGPA_list = [];

                                                  for (int i = 0; i < 9; i++) {
                                                    var collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'GPAvalues')
                                                            .doc(uid)
                                                            .collection('sem0' +
                                                                i.toString());

                                                    var querySnapshot =
                                                        await collection.get();

                                                    for (var queryDocumentSnapshot
                                                        in querySnapshot.docs) {
                                                      Map<String, dynamic>
                                                          data =
                                                          queryDocumentSnapshot
                                                              .data();

                                                      OGPA_list.add(
                                                          data['SGPA']);
                                                      Totcredit_list.add(
                                                          data['Totcredits']);
                                                    }
                                                  }
                                                  double multi = 0, tot = 0;

                                                  for (int j = 0;
                                                      j < Totcredit_list.length;
                                                      j++) {
                                                    multi = multi +
                                                        double.parse(
                                                                Totcredit_list[
                                                                    j]) *
                                                            double.parse(
                                                                OGPA_list[j]);
                                                    tot = tot +
                                                        double.parse(
                                                            Totcredit_list[j]);
                                                  }
                                                  double OGPA = multi / tot;
                                                  var collection_delOGP =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'GPAvalues')
                                                          .doc(uid)
                                                          .collection(
                                                              'overallResults');
                                                  var querySnapshot_delOGP =
                                                      await collection_delOGP
                                                          .get();
                                                  for (var queryDocumentSnapshot
                                                      in querySnapshot_delOGP
                                                          .docs) {
                                                    queryDocumentSnapshot
                                                        .reference
                                                        .delete();
                                                  }

                                                  String Overallid =
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'GPAvalues')
                                                          .doc(uid)
                                                          .collection(
                                                              'overallResults')
                                                          .doc()
                                                          .id
                                                          .toString();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('GPAvalues')
                                                      .doc(uid)
                                                      .collection(
                                                          'overallResults')
                                                      .doc(Overallid)
                                                      .set({
                                                    'OGPA':
                                                        OGPA.toStringAsFixed(2),
                                                    'Totcredits':
                                                        tot.toString(),
                                                    'overallID': Overallid
                                                  }).then((value) async {
                                                    Fluttertoast.showToast(
                                                      msg: "OGPA Updated",
                                                    );
                                                  });
                                                  ////////////////////////////////////////////////////////////////////////
                                                }).catchError((onError) =>
                                                        debugPrint(onError
                                                            .toString()));
                                              }).catchError((onError) =>
                                                      debugPrint(
                                                          onError.toString()));
                                              ;
                                            },
                                            icon: Icon(Icons.delete),
                                            color: Colors.indigo.shade600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        /////////////////////////;
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
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
            physics: NeverScrollableScrollPhysics(),

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

  getOGP() async {
    var collection = FirebaseFirestore.instance
        .collection('GPAvalues')
        .doc(uid)
        .collection('overallResults');

    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      OverallGPA = data['OGPA'];
    }
  }
}

double updateSGPA(List<String> grades, List<String> credits) {
  double multi = 0, sum = 0;
  for (int i = 0; i < grades.length; i++) {
    double gradeVal = gpaValue(grades[i]);
    sum = sum + double.parse(credits[i]);
    multi = multi + double.parse(credits[i]) * gradeVal;
    // debugPrint(gradeVal.toString() + 'and' + credits[i].toString());
  }
  double gpa = multi / sum;
  return gpa;
}

double gpaValue(String? Grade) {
  double gradeVal = 0;

  if (Grade == 'A+') {
    gradeVal = 4;
  }

  if (Grade == 'A') {
    gradeVal = 4;
  }
  if (Grade == 'A-') {
    gradeVal = 3.7;
  }
  if (Grade == 'B+') {
    gradeVal = 3.3;
  }
  if (Grade == 'B') {
    gradeVal = 3;
  }
  if (Grade == 'B-') {
    gradeVal = 2.7;
  }
  if (Grade == 'C+') {
    gradeVal = 2.3;
  }
  if (Grade == 'C') {
    gradeVal = 2;
  }
  if (Grade == 'R') {
    gradeVal = 0;
  }

  return gradeVal;
}

double creditSum(List<String> credits) {
  double sum = 0;
  for (int i = 0; i < credits.length; i++) {
    sum = sum + double.parse(credits[i]);
  }
  return sum;
}
