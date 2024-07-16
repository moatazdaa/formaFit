import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formafit/classes/gym_exercises.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/DayDetailsScreen.dart';

class WeekDetailsScreen extends StatefulWidget {
  final CollectionReference collectionWeeks;
  final int planIndex;
  final CollectionReference CollectionDays;

  WeekDetailsScreen(
      {required this.collectionWeeks,
      required this.CollectionDays,
      required this.planIndex});

  @override
  State<WeekDetailsScreen> createState() => _WeekDetailsScreenState();
}

/////////////////////////////////////////////////////////
class _WeekDetailsScreenState extends State<WeekDetailsScreen> {
// تحويل اليوم الى يوم راحة
  Future<void> ChangeDayToDayOff(String dayId) async {
    try {
      await FirebaseFirestore.instance
          .collection('days')
          .doc(dayId)
          .update({"dayState": true});
      print("تم التعديل بنجاح");
    } catch (error) {
      print("Error updating document: $error");
    }
  }

// داله تحويل اليوم الى يوم تمارين
  Future<void> ChangeDayToDayOn(String dayId) async {
    try {
      await FirebaseFirestore.instance
          .collection('days')
          .doc(dayId)
          .update({"dayState": false});
      print("تم التعديل بنجاح");
    } catch (error) {
      print("Error updating document: $error");
    }
  }

/////////////////////////////////////////////// داله حدف العناصر من اليوم
  Future<void> removeAllExsrsisFromDay(String dayId) async {
    CollectionReference collectionDay = FirebaseFirestore.instance
        .collection('days')
        .doc(dayId)
        .collection('exercises');
    // جلب جميع المستندات في المجموعة الفرعية
    QuerySnapshot exercisesSnapshot = await collectionDay.get();
    // حذف كل مستند
    for (QueryDocumentSnapshot doc in exercisesSnapshot.docs) {
      await doc.reference.delete();
      print("Deleted exercise: ${doc.id}");
    }
    ChangeDayToDayOff(dayId);
  }

  /// داله اضافة التمارين الى اليوم
  Future<void> addExsrsisToDay(String dayId) async {
    CollectionReference collectionDay = FirebaseFirestore.instance
        .collection('days')
        .doc(dayId)
        .collection('exercises');

    for (var exercise in selectedexsrsis_to_list) {
      await collectionDay.add(exercise.toFirestore());
      print("Adding exercise: ${exercise.name}");
    }
    ChangeDayToDayOn(dayId);
  }

// داله تستخدم لنسخ التمارين الخاصة باليوم
  Future<void> CopyExsrsisFromDay(String dayId) async {
    CollectionReference collectionDay = FirebaseFirestore.instance
        .collection('days')
        .doc(dayId)
        .collection('exercises');

    QuerySnapshot exercisesSnapshot = await collectionDay.get();
    selectedexsrsis_to_list.clear();
    selectedexsrsis_to_list = exercisesSnapshot.docs!.map((doc) {
      return exsrsis_item.fromFirestore(doc);
    }).toList();
  }


  Day? selectedDay;
  bool dayOff = true;
///////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_rounded, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.collectionWeeks.orderBy('order').snapshots(),
        builder: (context, weeksnapshot) {
          if (weeksnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!weeksnapshot.hasData || weeksnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No weeks available'));
          }

          var weeks = weeksnapshot.data!.docs.map((doc) {
            return Week.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: weeks.length,
            itemBuilder: (context, weekIndex) {
              String weekId = weeksnapshot.data!.docs[weekIndex].id;

              return FutureBuilder<QuerySnapshot>(
                future: widget.CollectionDays.orderBy('order2')
                    .where('weekId', isEqualTo: weekId)
                    .get(),
                builder: (context, daySnapshot) {
                  if (daySnapshot.connectionState == ConnectionState.waiting) {
                    return ExpansionTile(
                      title: Text(weeks[weekIndex].name),
                      children: [Center(child: CircularProgressIndicator())],
                    );
                  }
                  if (!daySnapshot.hasData || daySnapshot.data!.docs.isEmpty) {
                    return ExpansionTile(
                      title: Text(weeks[weekIndex].name),
                      children: [Center(child: Text('No days available'))],
                    );
                  }

                  var days = daySnapshot.data!.docs.map((doc) {
                    return Day.fromFirestore(doc);
                  }).toList();

                  return ExpansionTile(
                    title: Text(weeks[weekIndex].name),
                    children: days.map((day) {
                      String dayId = daySnapshot.data!.docs
                          .firstWhere((doc) => doc['name'] == day.name)
                          .id;

                      return GestureDetector(
                        onTap: () {
                          selectedDay = day;

                          if (selectedexsrsis_to_list.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("تأكيد الإضافة"),
                                  content: Text(
                                      "هل أنت متأكد أنك تريد إضافة العناصر؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("إلغاء"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (selectedexsrsis_to_list
                                            .isNotEmpty) {
                                          await addExsrsisToDay(dayId);
                                          setState(() {
                                            selectedexsrsis_to_list.clear();
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "تمت إضافة العناصر بنجاح"),
                                            ),
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("تأكيد"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            //هادا متغير موجود في provid لتخزين رقم المستند الخاص باليوم
                            dayDocId = dayId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DayDetailsScreen(dayid: dayId),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          selectedDay = day;

                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 120,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading:
                                            Icon(Icons.delete_forever_sharp),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("إلغاء"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (selectedDay != null) {
                                                        await removeAllExsrsisFromDay(
                                                            dayId);
                                                        setState(() {});
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "تم حذف العناصر بنجاح"),
                                                          ),
                                                        );
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("تأكيد"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                            Icons.notifications_paused_sharp),
                                        title: Text("نسخ"),
                                        onTap: () {
                                          setState(() {
                                            CopyExsrsisFromDay(dayId);
                                          });
                                        },
                                      ),
                                  ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(day.name),
                          trailing: day.dayState
                              ? Icon(Icons.notifications_off_rounded)
                              : Icon(Icons.offline_bolt, color: Colors.blue),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
