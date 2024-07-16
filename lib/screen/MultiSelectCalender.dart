import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // تأكد من استيراد FirebaseAuth
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Multiselectcalender extends StatefulWidget {
  final Meal meal;
  final List<Map<String, dynamic>> foodlist; // تأكد من استخدام نوع Map<String, dynamic>
  
  const Multiselectcalender({
    super.key, 
    required this.meal, 
    required this.foodlist
  });

  @override
  State<Multiselectcalender> createState() => _MultiselectcalenderState();
}
class _MultiselectcalenderState extends State<Multiselectcalender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> selectedDays = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التقويم "),
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
                      await addMealWithFoods(
                          widget.meal, selectedDays, widget.foodlist);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("تمت إضافة العناصر بنجاح"),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text("تأكيد"),
                  ),
////////////////////////////

              TextButton(
                    onPressed: () async {
                      await addMealAndResetWithFoods(
                          widget.meal, selectedDays, widget.foodlist);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("تمت إضافة العناصر بنجاح"),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text("استبدال"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addMealWithFoods(
      Meal meal, List<DateTime> days, List<Map<String, dynamic>> foodlist) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final _db = FirebaseFirestore.instance;

      try {
        for (DateTime day in days) {
          final mealsCollection = _db.collection('meals');
          final existingDocument = await mealsCollection
              .where('userid', isEqualTo: user.uid)
              .where('Daydate', isEqualTo: day.toUtc())
              .where('MealName', isEqualTo: widget.meal.MealName)
              .limit(1)
              .get();

          if (existingDocument.docs.isNotEmpty) {
            final mealId = existingDocument.docs.first.id;
            await mealsCollection.doc(mealId).update({
              'MealKal': meal.MealKal,
              'CompletKal':meal.CompletKal,
              'isfindfood': meal.isfindfood,
              'MealTime': widget.meal.MealTime.toIso8601String(),
            });

            for (Map<String, dynamic> food in foodlist) {
              await mealsCollection.doc(mealId).collection('foods').add(food);
            }
          } else {
            DocumentReference mealRef = await mealsCollection.add({
              'userid': user.uid,
              'MealName': widget.meal.MealName,
              'Daydate': day.toUtc(),
              'MealTime': widget.meal.MealTime.toIso8601String(),
              'MealKal': meal.MealKal,
              'CompletKal':meal.CompletKal,
              'isfindfood': meal.isfindfood,
            });

            for (Map<String, dynamic> food in foodlist) {
              await mealRef.collection('foods').add(food);
            }
          }
        }
      } catch (e) {
        print("Error adding meal with foods: $e");
      }
    }
  }
}

/////// داله استبدال العناصر
Future<void> addMealAndResetWithFoods(
    Meal meal, List<DateTime> days, List<Map<String, dynamic>> foodlist) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final _db = FirebaseFirestore.instance;

    try {
      for (DateTime day in days) {
        final mealsCollection = _db.collection('meals');
        final existingDocument = await mealsCollection
            .where('userid', isEqualTo: user.uid)
            .where('Daydate', isEqualTo: day.toUtc())
            .where('MealName', isEqualTo: meal.MealName)
            .limit(1)
            .get();

        if (existingDocument.docs.isNotEmpty) {
          final mealId = existingDocument.docs.first.id;

          // حذف الأطعمة القديمة
          final foodsCollection = mealsCollection.doc(mealId).collection('foods');
          final foodsSnapshot = await foodsCollection.get();
          for (var foodDoc in foodsSnapshot.docs) {
            await foodDoc.reference.delete();
          }

          // تحديث مستند الوجبة
          await mealsCollection.doc(mealId).update({
            'MealKal': meal.MealKal,
            'CompletKal':meal.CompletKal,
            'isfindfood': meal.isfindfood,
            'MealTime': meal.MealTime.toIso8601String(),
          });

          // إضافة الأطعمة الجديدة
          for (Map<String, dynamic> food in foodlist) {
            await mealsCollection.doc(mealId).collection('foods').add(food);
          }
        } else {
          // إضافة مستند وجبة جديد
          DocumentReference mealRef = await mealsCollection.add({
            'userid': user.uid,
            'MealName': meal.MealName,
            'Daydate': day.toUtc(),
            'MealTime': meal.MealTime.toIso8601String(),
            'MealKal': meal.MealKal,
            'CompletKal':meal.CompletKal,
            'isfindfood': meal.isfindfood,
          });

          // إضافة الأطعمة الجديدة
          for (Map<String, dynamic> food in foodlist) {
            await mealRef.collection('foods').add(food);
          }
        }
      }
    } catch (e) {
      print("Error adding meal with foods: $e");
    }
  }
}





// دالة مساعدة لتحويل قائمة من Foods إلى قائمة من الخرائط
List<Map<String, dynamic>> convertFoodsListToMapList(List<Foods> foodsList) {
  return foodsList.map((food) => {
    'name': food.name,
    'Kal': food.Kal,
    'gram': food.gram,
    'Protein': food.Protein,
    'Carbohydrates': food.Carbohydrates,
    'Fats': food.Fats,
    'SaturatedFat': food.SaturatedFat,
    'UnSaturatedFat': food.UnSaturatedFat,
    'A': food.A,
    'B12': food.B12,
    'B6': food.B6,
    'B2': food.B2,
    'C': food.C,
    'D': food.D,
    'Fe': food.Fe,
    'K': food.K,
    'Ca': food.Ca,
    'Mg': food.Mg,
    'Kolistol': food.Kolistol,
    'p': food.p,
    'FoodState':food.FoodState
  }).toList();

//داله استبدال العناصر

}