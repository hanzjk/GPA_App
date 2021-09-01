import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/auth/authscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/screens/home1.dart';

class AddNewModule extends StatefulWidget {
  String sem;
  AddNewModule(this.sem);

  @override
  _AddNewModule createState() => _AddNewModule();
}

class _AddNewModule extends State<AddNewModule> {
  TextEditingController moduleController = TextEditingController();

  String? uid;

  List<String> credits = ['1', '2', '3', '4', '5'];
  List<String> grade = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'R'];

  String? credit_val;
  String? grade_val;
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

  Widget build(BuildContext context) {
    var time = DateTime.now();

    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: moduleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Module Name',
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: DropdownButtonFormField(
                  items: credits.map((String category) {
                    return new DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: <Widget>[
                            Text(category),
                          ],
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    // do other stuff with _category
                    setState(() => credit_val = newValue!);
                    debugPrint(credit_val);
                  },
                  value: credit_val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Credits',
                  ),
                )),
                Flexible(
                    child: DropdownButtonFormField(
                  items: grade.map((String category) {
                    return new DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: <Widget>[
                            Text(category),
                          ],
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    // do other stuff with _category
                    setState(() => grade_val = newValue!);
                  },
                  value: grade_val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Grade',
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              //Can choose color

              onPressed: () async {
                String id = FirebaseFirestore.instance
                    .collection('semsterResults')
                    .doc(uid)
                    .collection('sem0' + widget.sem)
                    .doc()
                    .id
                    .toString();
                await FirebaseFirestore.instance
                    .collection('semsterResults')
                    .doc(uid)
                    .collection('sem0' + widget.sem)
                    .doc(id)
                    .set({
                  'module': moduleController.text,
                  'grade': grade_val,
                  'credits': credit_val,
                  'moduleID': id
                }).then((value) async {
                  Fluttertoast.showToast(
                    msg: "Module Added",
                  );

                  var collection = FirebaseFirestore.instance
                      .collection('semsterResults')
                      .doc(uid)
                      .collection('sem0' + widget.sem);
                  var querySnapshot = await collection.get();
                  List<String> credit_list = [];
                  List<String> grade_list = [];

                  for (var queryDocumentSnapshot in querySnapshot.docs) {
                    Map<String, dynamic> data = queryDocumentSnapshot.data();
                    // debugPrint('grade:' +
                    //     data['grade'] +
                    //     '\tcredits: ' +
                    //     data['credits']);

                    grade_list.add(data['grade']);

                    credit_list.add(data['credits']);
                  }

                  double newSGP = updateSGPA(grade_list, credit_list);
                  for (int i = 0; i < credit_list.length; i++) {
                    debugPrint('credits :' +
                        credit_list[i] +
                        'grade :' +
                        grade_list[i]);
                  }
                  double newCredits = creditSum(credit_list);

                  debugPrint('Totcredits:' + newCredits.toStringAsFixed(2));
                  debugPrint('SGPA:' + newSGP.toStringAsFixed(2));

                  String semid = FirebaseFirestore.instance
                      .collection('GPAvalues')
                      .doc(uid)
                      .collection('sem0' + widget.sem)
                      .doc()
                      .id
                      .toString();

                  var collection_del = FirebaseFirestore.instance
                      .collection('GPAvalues')
                      .doc(uid)
                      .collection('sem0' + widget.sem);
                  var querySnapshot_del = await collection_del.get();
                  for (var queryDocumentSnapshot in querySnapshot_del.docs) {
                    queryDocumentSnapshot.reference.delete();
                  }

                  await FirebaseFirestore.instance
                      .collection('GPAvalues')
                      .doc(uid)
                      .collection('sem0' + widget.sem)
                      .doc(semid)
                      .set({
                    'semID': semid,
                    'SGPA': newSGP.toStringAsFixed(2),
                    'Totcredits': newCredits.toString(),
                  }).then((val) async {
                    Fluttertoast.showToast(
                      msg: "SGPA Updated",
                    );

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
                        Map<String, dynamic> data =
                            queryDocumentSnapshot.data();

                        OGPA_list.add(data['SGPA']);
                        Totcredit_list.add(data['Totcredits']);
                      }
                    }
                    double multi = 0, tot = 0;

                    for (int j = 0; j < Totcredit_list.length; j++) {
                      multi = multi +
                          double.parse(Totcredit_list[j]) *
                              double.parse(OGPA_list[j]);
                      tot = tot + double.parse(Totcredit_list[j]);
                    }
                    double OGPA = multi / tot;
                    var collection_delOGP = FirebaseFirestore.instance
                        .collection('GPAvalues')
                        .doc(uid)
                        .collection('overallResults');
                    var querySnapshot_delOGP = await collection_delOGP.get();
                    for (var queryDocumentSnapshot
                        in querySnapshot_delOGP.docs) {
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
                    }).then((value) async {
                      Fluttertoast.showToast(
                        msg: "OGPA Updated",
                      );
                    });
                  }).catchError((onError) => debugPrint(onError.toString()));
                }).catchError((onError) => debugPrint(onError.toString()));
                ;
              },

              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.indigo.shade300; //when clicking
                return Colors.indigo; //not clicking
              })),
              child: Text(
                'Add Module',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
    );
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
