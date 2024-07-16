import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formafit/classes/gym_exercises.dart';
import 'package:formafit/screen/WeekDetailsScreen.dart';

import 'package:formafit/screen/addNewPlan.dart'; // Assuming you have an AddPlanScreen

class PlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlanList(),
    );
  }
}

String imageplan = "";
///////////////////////////////////حدف الخطه
Future<void> removePlan(String planId) async {
  final User? user1 = FirebaseAuth.instance.currentUser;
  if (user1 == null) {
    throw Exception("User is not signed in");
  }
  
  // الحصول على مرجع الوثيقة للخطة
  DocumentReference planDoc = FirebaseFirestore.instance
      .collection('plans')
      .doc(planId);
  
  // الحصول على مرجع مجموعة الأسابيع
  CollectionReference weeksCollection = planDoc.collection('weeks');

  // جلب جميع الأسابيع في الخطة
  QuerySnapshot weeksSnapshot = await weeksCollection.get();
  CollectionReference daysCollection =
      FirebaseFirestore.instance.collection('days');

  for (QueryDocumentSnapshot weekDoc in weeksSnapshot.docs) {
    // استخدام كل وثيقة لجلب الأيام المرتبطة بها
    QuerySnapshot daysSnapshot =
        await daysCollection.where('weekId', isEqualTo: weekDoc.id).get();

    for (QueryDocumentSnapshot dayDoc in daysSnapshot.docs) {
      // جلب التمارين لكل يوم
      CollectionReference exercisesCollection =
          dayDoc.reference.collection('exercises');
      QuerySnapshot exercisesSnapshot = await exercisesCollection.get();

      for (QueryDocumentSnapshot exerciseDoc in exercisesSnapshot.docs) {
        // حذف كل تمرين
        await exerciseDoc.reference.delete();
      }
      // حذف كل يوم
      await dayDoc.reference.delete();
    }
    // حذف الأسبوع
    await weekDoc.reference.delete();
  }
  // حذف الخطة بعد حذف جميع الأسابيع والأيام
  await planDoc.delete();
}


///////////////////////////////////اهادة ضبط الخطه
Future<void> resetPlan(String planId) async {
  final User? user1 = FirebaseAuth.instance.currentUser;
  if (user1 == null) {
    throw Exception("User is not signed in");
  }
  // الحصول على مرجع المجموعة الأساسية للخطط
  CollectionReference plansCollection =
      FirebaseFirestore.instance.collection('plans');
  DocumentReference planDoc = plansCollection.doc(planId);
  CollectionReference weeksCollection = planDoc.collection('weeks');

  // جلب جميع الأسابيع في الخطة
  QuerySnapshot weeksSnapshot = await weeksCollection.get();
  CollectionReference daysCollection =
      FirebaseFirestore.instance.collection('days');

  for (QueryDocumentSnapshot weekDoc in weeksSnapshot.docs) {
    // استخدام كل وثيقة لجلب الأيام المرتبطة بها
    QuerySnapshot daysSnapshot =
        await daysCollection.where('weekId', isEqualTo: weekDoc.id).get();

    for (QueryDocumentSnapshot dayDoc in daysSnapshot.docs) {
      // حذف كل تمرين داخل اليوم
      CollectionReference exercisesCollection =
          dayDoc.reference.collection('exercises');
      QuerySnapshot exercisesSnapshot = await exercisesCollection.get();

      for (QueryDocumentSnapshot exerciseDoc in exercisesSnapshot.docs) {
        await exerciseDoc.reference.delete();
      }
    }
  }
}

String planimage(String image) {
  if (image == "انقاص الوزن") {
    return 'assets/images/losewight.jpeg';
  } else if (image == 'بناء العضلات') {
    return 'assets/images/fat.jpg';
  } else {
    return 'assets/images/addwight.jpg';
  }
}

class PlanList extends StatefulWidget {
  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  final User? user1 = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (user1 != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Exercise Plans'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('plans')
              .where('userId', isEqualTo: user1!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text('No plans available'));
            }

            var plans = snapshot.data!.docs.map((doc) {
              return Plans.fromFirestore(doc);
            }).toList();

            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, pindex) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      CollectionReference collectionWeeks = FirebaseFirestore
                          .instance
                          .collection('plans')
                          .doc(snapshot.data!.docs[pindex].id)
                          .collection('weeks');

                      CollectionReference collectionDays =
                          FirebaseFirestore.instance.collection('days');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeekDetailsScreen(
                            collectionWeeks: collectionWeeks,
                            CollectionDays: collectionDays,
                            planIndex: pindex,
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 120,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.delete_forever_sharp),
                                    title: Text("حذف العناصر"),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("تأكيد الحذف"),
                                            content: Text(
                                                "هل أنت متأكد أنك تريد حذف العناصر؟"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("إلغاء"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await removePlan(snapshot
                                                      .data!.docs[pindex].id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "تم حذف العناصر بنجاح"),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("تأكيد"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
///////////////////////////////////// اعادة ضبط
                                  ListTile(
                                    leading: Icon(Icons.delete_forever_sharp),
                                    title: Text("اعادة ضبط"),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("تاكيد"),
                                            content: Text(
                                                "هل أنت متأكد أنك تريد اعادة ضبط الخطه؟"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("إلغاء"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await resetPlan(snapshot
                                                      .data!.docs[pindex].id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "تم اعادة ضبط الخطه بنجاح"),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("تأكيد"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            planimage(plans[pindex].goal),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  plans[pindex].name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Weeks: ${plans[pindex].WeekCount}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  plans[pindex].goal,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ' ${plans[pindex].details}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 10,
                            bottom: 3,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 40,
                                  color: Colors.amber,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 40,
                                  color: plans[pindex].harder >= 2
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 40,
                                  color: plans[pindex].harder >= 3
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 40,
                                  color: plans[pindex].harder >= 4
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 40,
                                  color: plans[pindex].harder >= 5
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPlanScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      );
    } else {
      return Center(
        child: Text("خطاء في جلب عنوان المستخدم"),
      );
    }
  }
}
