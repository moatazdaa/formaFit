import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/screen/MainFoods.dart';
import 'package:formafit/screen/MealMultiSelectCalender.dart';
import 'package:formafit/screen/MealsDeatils.dart';

import 'package:table_calendar/table_calendar.dart';

class HealthyNutrition extends StatefulWidget {
  @override
  State<HealthyNutrition> createState() => _HealthyNutritionState();
}

class _HealthyNutritionState extends State<HealthyNutrition> {

  List<DayMeal> _dayMeals = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    // Add default meal data
    _dayMeals.add(DayMeal(
      date: today,
      meals: [
        Meal(
          MealName: "وجبة الفطور",
          Daydate: today,
          MealTime: DateTime(today.year, today.month, today.day, 9, 0), // 9am
          MealKal: 0.0,
          CompletKal:0.0,
          isfindfood: false,
        ),
        Meal(
          MealName: "وجبة الغداء",
          Daydate: today,
          MealTime: DateTime(today.year, today.month, today.day, 14, 0), // 2pm
          MealKal: 0.0,
          CompletKal:0.0,
          isfindfood: false,
        ),
        Meal(
          MealName: "وجبة العشاء",
          Daydate: today,
          MealTime: DateTime(today.year, today.month, today.day, 22, 0), // 10pm
          MealKal: 0.0,
          CompletKal:0.0,
          isfindfood: false,
        ),

            Meal(
          MealName: "وجبات خفيفة",
          Daydate: today,
          MealTime: DateTime(today.year, today.month, today.day, 22, 0), // 10pm
          MealKal: 0.0,
          CompletKal:0.0,
          isfindfood: false,
        ),
      ],
    ));
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      if (!_dayMeals.any((dayMeal) => isSameDay(dayMeal.date, day))) {
        _dayMeals.add(DayMeal(
          date: day,
          meals: [
            Meal(
              MealName: "وجبة الفطور",
              Daydate: day,
              MealTime: DateTime(day.year, day.month, day.day, 9, 0),
              MealKal: 0.0,
              CompletKal:0.0,
              isfindfood: false,
            ),
            Meal(
              MealName: "وجبة الغداء",
              Daydate: day,
              MealTime: DateTime(day.year, day.month, day.day, 14, 0),
              MealKal: 0.0,
              CompletKal:0.0,
              isfindfood: false,
            ),
            Meal(
              MealName: "وجبة العشاء",
              Daydate: day,
              MealTime: DateTime(day.year, day.month, day.day, 22, 0),
              MealKal: 0.0,
              CompletKal:0.0,
              isfindfood: false,
            ),
              Meal(
          MealName: "وجبات خفيفة",
          Daydate: today,
          MealTime: DateTime(today.year, today.month, today.day, 22, 0), // 10pm
          MealKal: 0.0,
          CompletKal:0.0,
          isfindfood: false,
        ),
          ],
        ));
      }
    });
  }

  DayMeal getDayMeal(DateTime date) {
    return _dayMeals.firstWhere(
      (dayMeal) => isSameDay(dayMeal.date, date),
      orElse: () => DayMeal(date: date, meals: []),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayMeal = getDayMeal(today);

    return Scaffold(
      backgroundColor: Color.fromARGB(202, 169, 168, 166),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showCalendar();
          },
          icon: Icon(Icons.calendar_month_outlined,
              size: 30, color: Colors.green),
        ),
        title: Text(
          "${today.day}/${today.month}/${today.year}",
          style: TextStyle(fontSize: 18, color: Colors.black),
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
              if (value == 'نسخ الوجبة') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Mealmultiselectcalender(
                              today: today,
                            )));
              }
              if (value == 'حدف الكل ') {
                deleteMealsForDay(today);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'نسخ الوجبة',
                child: Text('نسخ الوجبة'),
              ),
              PopupMenuItem<String>(
                value: 'حدف الكل ',
                child: Text('حدف الكل '),
              ),
            ],
            icon: Icon(
              Icons.density_small_sharp,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Your calorie card widgets here
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: dayMeal.meals.length,
              itemBuilder: (context, index) {
                final meal = dayMeal.meals[index];
                return Column(
                  children: [
                    Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: ListTile(
                        title:Text(meal.MealName),
                        subtitle: Text("عدد العناصر"),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Mealsdeatils(
                                  
                                      meal: meal,
                                      SelectDay: today)),
                            );
                          },
                          icon: Icon(Icons.food_bank_sharp),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              meal.isfindfood = !meal.isfindfood;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainfoodsScreen(
                                        meal: meal, SelectDay: today)),
                              );
                            });
                          },
                          icon: Icon(Icons.add, size: 34, color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 480,
            width: 400,
            child: TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.saturday,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red),
              ),
              focusedDay: today,
              firstDay: DateTime(2024),
              lastDay: DateTime(2050),
              rowHeight: 65,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  onDaySelected(selectedDay, focusedDay);
                });
                Navigator.of(context).pop();
              },
              selectedDayPredicate: (day) => isSameDay(day, today),
              availableGestures: AvailableGestures.all,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إغلاق',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMealsForDay(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final _db = FirebaseFirestore.instance;

      try {
        final mealsCollection = _db.collection('meals');
        final querySnapshot = await mealsCollection
            .where('userid', isEqualTo: user.uid)
            .where('Daydate', isEqualTo: day.toUtc())
            .get();

        for (var mealDoc in querySnapshot.docs) {
          final foodsSnapshot =
              await mealDoc.reference.collection('foods').get();
          for (var foodDoc in foodsSnapshot.docs) {
            await foodDoc.reference.delete();
          }
          await mealDoc.reference.delete();
        }
      } catch (e) {
        print("Error deleting meals for day: $e");
      }
    } else {
      print("No user logged in");
    }
  }
}
