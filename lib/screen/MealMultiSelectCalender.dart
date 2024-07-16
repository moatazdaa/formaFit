import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Mealmultiselectcalender extends StatefulWidget {
  final DateTime today;
  const Mealmultiselectcalender({super.key, required this.today});

  @override
  State<Mealmultiselectcalender> createState() =>
      _MealmultiselectcalenderState();
}

class _MealmultiselectcalenderState extends State<Mealmultiselectcalender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedSourceDay = DateTime.now();
  List<DateTime> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التقويم"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return selectedDays.contains(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (selectedDays.contains(selectedDay)) {
                  selectedDays.remove(selectedDay);
                } else {
                  selectedDays.add(selectedDay);
                }
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: selectedDays.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    DateFormat.yMMMMd().format(selectedDays[index]),
                  ),
                  subtitle: Text(
                    DateFormat.EEEE().format(selectedDays[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(232, 211, 214, 215),
        elevation: 20,
        clipBehavior: Clip.antiAlias,
        onPressed: () {
          _showConfirmationDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الإضافة"),
          content: Text("هل أنت متأكد أنك تريد إضافة العناصر؟"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () async {
                await copyMealsToDays(widget.today, selectedDays);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تمت إضافة العناصر بنجاح"),
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
  }

// داله تقوم باضافة الوجبات الى الايام المحددة
Future<void> copyMealsToDays(DateTime sourceDay, List<DateTime> targetDays) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final _db = FirebaseFirestore.instance;

    try {
      // جلب جميع مستندات الوجبات في اليوم المحدد
      final mealsCollection = _db.collection('meals');
      final sourceQuerySnapshot = await mealsCollection
          .where('userid', isEqualTo: user.uid)
          .where('Daydate', isEqualTo: sourceDay.toUtc())
          .get();

      // حذف جميع الوجبات والأطعمة في الأيام المستهدفة
      for (DateTime day in targetDays) {
        final targetQuerySnapshot = await mealsCollection
            .where('userid', isEqualTo: user.uid)
            .where('Daydate', isEqualTo: day.toUtc())
            .get();

        for (var mealDoc in targetQuerySnapshot.docs) {
          // حذف جميع الأطعمة المرتبطة بالوجبة
          final foodsSnapshot = await mealDoc.reference.collection('foods').get();
          for (var foodDoc in foodsSnapshot.docs) {
            await foodDoc.reference.delete();
          }
          // حذف الوجبة
          await mealDoc.reference.delete();
        }
      }

      // تكرار على كل مستند وجبة في اليوم المحدد
      for (var mealDoc in sourceQuerySnapshot.docs) {
        // جلب بيانات الوجبة
        final mealData = mealDoc.data();
        final foodsSnapshot = await mealDoc.reference.collection('foods').get();
        final foodList = foodsSnapshot.docs.map((doc) => doc.data()).toList();

        // إضافة الوجبات والأطعمة إلى الأيام المستهدفة
        for (DateTime day in targetDays) {
          // إضافة مستند وجبة جديد لكل يوم مستهدف
          DocumentReference newMealRef = await mealsCollection.add({
            'userid': user.uid,
            'MealName': mealData['MealName'],
            'Daydate': day.toUtc(),
            'MealTime': mealData['MealTime'],
            'MealKal': mealData['MealKal'],
            'CompletKal':mealData ['CompletKal'],
            'isfindfood': mealData['isfindfood'],
          });

          // إضافة الأطعمة المرتبطة بالوجبة الجديدة
          for (Map<String, dynamic> food in foodList) {
            await newMealRef.collection('foods').add(food);
          }
        }
      }
    } catch (e) {
      print("Error copying meals to days: $e");
    }
  }
}


}

// عرض التقويم:

// التقويم يعرض الأيام المختارة في قائمة.
// يمكن تحديد أو إلغاء تحديد الأيام بالنقر عليها في التقويم.
// أزرار النسخ والاستبدال:

// زر "تأكيد" يستخدم الدالة copyMealsToDays لنسخ الوجبات من اليوم المصدر إلى الأيام المستهدفة.
// زر "استبدال" يستخدم الدالة replaceMealsInDays لاستبدال الوجبات في الأيام المستهدفة بالوجبات من اليوم المصدر.
// دالة copyMealsToDays:

// تنسخ الوجبات من اليوم المصدر إلى الأيام المستهدفة.
// دالة replaceMealsInDays:

// تحذف الوجبات الموجودة في الأيام المستهدفة أولاً، ثم تضيف الوجبات من اليوم المصدر.
// استدعاء الدالة:
// في هذا المثال، يتم نسخ واستبدال الوجبات عند النقر على أزرار التأكيد والاستبدال في صندوق الحوار. تأكد من ضبط _selectedSourceDay حسب اليوم الذي تريد نسخ بياناته قبل استدعاء هذه الدوال.
