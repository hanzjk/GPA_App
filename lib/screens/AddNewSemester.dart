import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home1.dart';

List<String> credit = [];
List<String> grade = [];
List<String> modules = [];

int count = 1;

class AddSemester extends StatefulWidget {
  const AddSemester({Key? key}) : super(key: key);

  @override
  _AddSemesterState createState() => _AddSemesterState();
}

class _AddSemesterState extends State<AddSemester> {
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

  String? sem = '1';

  addToSem(String? sem) async {
    FirebaseAuth? auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;

    debugPrint(count.toString());
    for (int num = 0; num < count; num++) {
      String id = FirebaseFirestore.instance
          .collection('semsterResults')
          .doc(uid)
          .collection('sem0' + sem!)
          .doc()
          .id
          .toString();

      await FirebaseFirestore.instance
          .collection('semsterResults')
          .doc(uid)
          .collection('sem0' + sem!)
          .doc(id)
          .set({
        'moduleID': id,
        'module': modules[num],
        'grade': grade[num],
        'credits': credit[num]
      }).then((value) async {
        Fluttertoast.showToast(msg: 'Modules Added');
      }).catchError((onError) => debugPrint(onError.toString()));
    }
    double SGPA = computeSGPA(grade, credit);
    double sum_credit = creditSum(credit);
    //debugPrint(SGPA.toString());

    String semid = FirebaseFirestore.instance
        .collection('GPAvalues')
        .doc(uid)
        .collection('sem0' + sem!)
        .doc()
        .id
        .toString();

    await FirebaseFirestore.instance
        .collection('GPAvalues')
        .doc(uid)
        .collection('sem0' + sem!)
        .doc(semid)
        .set({
      'semID': semid,
      'SGPA': SGPA.toStringAsFixed(2),
      'Totcredits': sum_credit.toString(),
    }).then((val) async {
      //////////////////////////////////OGPA/////////////////////////////////
      List<String> Totcredit_list = [];
      List<String> OGPA_list = [];

      for (int i = 0; i < 9; i++) {
        var collection = FirebaseFirestore.instance
            .collection('GPAvalues')
            .doc(uid)
            .collection('sem0' + i.toString());

        var querySnapshot = await collection.get();

        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();

          OGPA_list.add(data['SGPA']);
          Totcredit_list.add(data['Totcredits']);
        }
      }
      double multi = 0, tot = 0;

      for (int j = 0; j < Totcredit_list.length; j++) {
        multi = multi +
            double.parse(Totcredit_list[j]) * double.parse(OGPA_list[j]);
        tot = tot + double.parse(Totcredit_list[j]);
      }
      double OGPA = multi / tot;
      var collection_delOGP = FirebaseFirestore.instance
          .collection('GPAvalues')
          .doc(uid)
          .collection('overallResults');
      var querySnapshot_delOGP = await collection_delOGP.get();
      for (var queryDocumentSnapshot in querySnapshot_delOGP.docs) {
        queryDocumentSnapshot.reference.delete();
      }

      String Overallid = FirebaseFirestore.instance
          .collection('GPAvalues')
          .doc(uid)
          .collection('overallResults')
          .doc()
          .id
          .toString();
      await FirebaseFirestore.instance
          .collection('GPAvalues')
          .doc(uid)
          .collection('overallResults')
          .doc(Overallid)
          .set({
        'OGPA': OGPA.toStringAsFixed(2),
        'Totcredits': tot.toString(),
        'overallID': Overallid
      }).then((value) {
        Fluttertoast.showToast(
          msg: "OGPA Updated",
        );
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return Home1(int.parse(sem)); //send the sem no
      }));
    }).catchError((onError) => debugPrint(onError.toString()));
    ;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.generate(count, (int i) => Widget_return(i));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            count = count + 1;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo.shade500,
      ),
      appBar: AppBar(
        title: Text('Add New Semester'),
        backgroundColor: Colors.indigo.shade500,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height:MediaQuery.of(context).size.height,
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    padding: const EdgeInsets.only(
                        top: 3, bottom: 3, left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.indigo.shade600,
                        border: Border.all(color: Colors.indigo.shade700)),
                    child: Text(
                      'Choose Semester Number : ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      child: DropdownButton<String>(
                        value: sem,
                        //elevation: 5,
                        style: TextStyle(
                          color: Colors.black,
                          height: 0.8,
                          fontSize: 18.0,
                        ),

                        items: <String>[
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Semester",
                          style: TextStyle(
                            height: 0.8,
                            fontSize: 18.0,
                          ),
                        ),
                        onChanged: (String? value) {
                          // grade[widget.index!] = value!;

                          setState(() {
                            sem = value;
                            // grade1 = value;
                            // if (grade.asMap().containsKey(widget.index)) {
                            //   grade.removeAt(widget.index!);
                            //   grade.insert(widget.index!, value!);
                            // } else {
                            //   grade.insert(widget.index!, value!);
                            // }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < children.length; i++) children[i],
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.indigo.shade500),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.indigo.shade600),
                        ),
                      ),
                    ),
                    onPressed: () {
                      addToSem(sem);
                    },
                    child: Container(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_outlined),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Add New Semester",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Widget_return extends StatefulWidget {
  int? index;

  Widget_return(this.index) {}
  @override
  _Widget_returnState createState() => _Widget_returnState();
}

class _Widget_returnState extends State<Widget_return> {
  String? credit1, grade1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    onChanged: (String? value) {
                      setState(() {
                        if (modules.asMap().containsKey(widget.index)) {
                          modules.removeAt(widget.index!);
                          modules.insert(widget.index!, value!);
                        } else {
                          modules.insert(widget.index!, value!);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
                      hintText: 'Module Name',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.indigo.shade500,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.indigo.shade700,
                          width: 1.0,
                        ),
                      ),
                    ),
                    style: TextStyle(
                        height: 0.9,
                        fontSize: 18.0,
                        decoration: TextDecoration.none),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 1, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 45.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: Colors.indigo.shade500,
                          style: BorderStyle.solid,
                          width: 1.0),
                    ),
                    child: DropdownButton<String>(
                      value: credit1,
                      //elevation: 5,
                      style: TextStyle(
                        color: Colors.black,
                        height: 0.8,
                        fontSize: 18.0,
                      ),

                      items: <String>[
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Credits",
                        style: TextStyle(
                          height: 0.8,
                          fontSize: 18.0,
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          credit1 = value;
                          if (credit.asMap().containsKey(widget.index)) {
                            credit.removeAt(widget.index!);
                            credit.insert(widget.index!, value!);
                          } else {
                            credit.insert(widget.index!, value!);
                          }
                        });
                      },
                    ),
                  ),
                  new Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 52.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Colors.indigo.shade500,
                            style: BorderStyle.solid,
                            width: 1.0),
                      ),
                      child: DropdownButton<String>(
                        value: grade1,
                        //elevation: 5,
                        style: TextStyle(
                          color: Colors.black,
                          height: 0.8,
                          fontSize: 18.0,
                        ),

                        items: <String>[
                          'A+',
                          'A',
                          'A-',
                          'B+',
                          'B',
                          'B-',
                          'C+',
                          'C',
                          'R',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          "Grade",
                          style: TextStyle(
                            height: 0.8,
                            fontSize: 18.0,
                          ),
                        ),
                        onChanged: (String? value) {
                          // grade[widget.index!] = value!;

                          setState(() {
                            grade1 = value;
                            if (grade.asMap().containsKey(widget.index)) {
                              grade.removeAt(widget.index!);
                              grade.insert(widget.index!, value!);
                            } else {
                              grade.insert(widget.index!, value!);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  // Flexible(
                  //     child: FlatButton(
                  //   child: Icon(
                  //     Icons.close,
                  //     color: Colors.indigo.shade500,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       debugPrint(widget.index.toString());
                  //     });
                  //   },
                  // )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double computeSGPA(List<String> grades, List<String> credits) {
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
