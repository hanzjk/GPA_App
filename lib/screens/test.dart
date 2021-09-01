import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Container(
        color: Colors.indigo.shade50,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            /////////////////
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
                      ' 3.44 ',
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
              height: 20,
            ),
            /////////////////////////////////
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
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
                          'Semester 01',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          'Credits:23',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Column(
                      children: [
                        Text(
                          'SGPA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          '2.33',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.indigo.shade700,
                      size: 22,
                    )
                  ],
                ),
              ),
            ),
            /////////////////////////
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
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
                          'Semester 02',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          'Credits:23',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Column(
                      children: [
                        Text(
                          'SGPA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          '2.33',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.indigo.shade700,
                      size: 22,
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
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
                          'Semester 03',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          'Credits:23',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Column(
                      children: [
                        Text(
                          'SGPA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        Text(
                          '2.33',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.indigo.shade700,
                      size: 22,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
