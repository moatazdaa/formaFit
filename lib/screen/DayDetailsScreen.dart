import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formafit/classes/exsrsis_in_plan.dart';
import 'package:formafit/exercises/chest.dart';

import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/StartExsrsis.dart';
import 'package:formafit/classes/gym_exercises.dart';

class DayDetailsScreen extends StatefulWidget {
  final String dayid;

  DayDetailsScreen({required this.dayid});

  @override
  State<DayDetailsScreen> createState() => _DayDetailsScreenState();
}

class _DayDetailsScreenState extends State<DayDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ExsrsisRef = FirebaseFirestore.instance
        .collection("days")
        .doc(widget.dayid)
        .collection("exercises");

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 169, 12),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            constraints: BoxConstraints(
                minHeight: 0.0,
                minWidth: 0.0,
                maxHeight: double.infinity,
                maxWidth: double.infinity),
            onSelected: (String value) {
              // تصرف بناءً على القيمة المختارة
              if (value == 'اضافة تمارين') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChestGym()),
                );
              }
              if (value == 'انجاز الكل') {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'اضافة تمارين',
                child: Text('اضافة تمارين'),
              ),
              PopupMenuItem<String>(
                value: 'انجاز الكل',
                child: Text('انجاز الكل'),
              ),
            ],
            icon: Icon(
              Icons.density_small_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ExsrsisRef.snapshots(),
          builder: (context, ExsrsisSnapshot) {
            if (ExsrsisSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!ExsrsisSnapshot.hasData ||
                ExsrsisSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No exsrsis available'));
            }

            var ListExsrsisFromFirebase = ExsrsisSnapshot.data!.docs.map((doc) {
              return exsrsis_item.fromFirestore(doc);
            }).toList();

            return Stack(children: [
              exsrsis_in_plan(
                myList: ListExsrsisFromFirebase,
                selectindex: [],
              ),
              Positioned(
                bottom: 1,
                child: Row(
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () {
                          if (!ListExsrsisFromFirebase.isEmpty)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => startexsrsis(
                                  exrsisplan: ListExsrsisFromFirebase,
                                  dayid: dayDocId,
                                ),
                              ),
                            );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.sports,
                              size: 40,
                              color: Colors.blue[800],
                            ),
                            SizedBox(width: 6),
                            Text(
                              "بدء التمرين",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                  ],
                ),
              )
            ]);
          }),
    );
  }
}
