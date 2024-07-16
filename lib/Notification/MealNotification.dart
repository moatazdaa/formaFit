import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// تعريف الكلاس MealNotification
class MealNotification {
   String MealName;
  DateTime MealTime;
  bool isNotificationOpen;

  MealNotification({
    required this.MealName,
    required this.MealTime,
    required this.isNotificationOpen,
  });

  Map<String, dynamic> toJson() => {
        'MealName': MealName,
        'MealTime': MealTime.toIso8601String(),
        'isNotificationOpen': isNotificationOpen,
      };

  factory MealNotification.fromJson(Map<String, dynamic> json) =>
      MealNotification(
        MealName: json['MealName'],
        MealTime: DateTime.parse(json['MealTime']),
        isNotificationOpen: json['isNotificationOpen'],
      );
}

// تعريف قائمة الوجبات
List<MealNotification> meals = [];

class MealReminderScreen extends StatefulWidget {
  @override
  _MealReminderScreenState createState() => _MealReminderScreenState();
}

class _MealReminderScreenState extends State<MealReminderScreen> {
  bool _isLoading = true; // متغير لمتابعة حالة التحميل

    bool openIndex = false; // تعريف المتغير لتخزين الفهرس الحالي


  @override
  void initState() {
    super.initState();
    checkAndRequestNotificationPermission();
    loadMealsFromPreferences().then((_) {
      setState(() {
        _isLoading = false; // بمجرد تحميل البيانات، توقف عن عرض التحميل
      });
    });

    for (var meal in meals) {
      if (meal.isNotificationOpen) {
        scheduleNotificationUsingWorkManager(meal);
      }
    }
  }

  void checkAndRequestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تفعيل الإشعارات'),
          content: Text('يجب تفعيل الإشعارات لاستخدام هذا التطبيق بشكل كامل.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AwesomeNotifications().requestPermissionToSendNotifications();
              },
              child: Text('سماح'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('عدم السماح'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _addNewMeal() async {
    TextEditingController mealNameController = TextEditingController();
    TimeOfDay currentTime = TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('إضافة وجبة جديدة'),
          content: TextField(
            controller: mealNameController,
            decoration: InputDecoration(hintText: "اسم الوجبة"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (mealNameController.text.isNotEmpty) {
                  setState(() {
                    meals.add(
                      MealNotification(
                        MealName: mealNameController.text,
                        MealTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          pickedTime.hour,
                          pickedTime.minute,
                        ),
                        isNotificationOpen: false,
                      ),
                    );
                    saveMealsToPreferences();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _editMeal(MealNotification meal) async {
    TextEditingController mealNameController = TextEditingController(text: meal.MealName);
    TimeOfDay mealTime = TimeOfDay.fromDateTime(meal.MealTime);

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: mealTime,
    );

    if (pickedTime != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تعديل الوجبة'),
          content: TextField(
            controller: mealNameController,
            decoration: InputDecoration(hintText: "اسم الوجبة"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (mealNameController.text.isNotEmpty) {
                  setState(() {
                    meal.MealName = mealNameController.text;
                    meal.MealTime = DateTime(
                      meal.MealTime.year,
                      meal.MealTime.month,
                      meal.MealTime.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    if (meal.isNotificationOpen) {
                      scheduleNotificationUsingWorkManager(meal);
                    }
                    saveMealsToPreferences();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deleteMeal(MealNotification meal) async {
    setState(() {
      meals.remove(meal);
      cancelNotification(meal.hashCode);
      saveMealsToPreferences();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تذكير بالوجبات'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // عرض التحميل أثناء التحميل
          : meals.isEmpty
              ? Center(
                  child: Text('لا توجد وجبات محفوظة')) // إذا لم تكن هناك بيانات
              : ListView.builder(
             itemExtent:80,
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    MealNotification meal = meals[index];
                    return Slidable(
              
                         key: Key(meal.MealName),
                      endActionPane: ActionPane(motion: StretchMotion(), children: [
        
                  SlidableAction(
                
                  flex: 1,
                 autoClose: true,
                    spacing: 7,
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    borderRadius: BorderRadius.circular(15),
                    label: 'delet',
                    icon: Icons.remove,
                     
                    backgroundColor: Colors.red,
                    // مزال لين تخدم البروفايد لان تبي تمرير المتغير الى داله من صفحة الى اخرى
                    onPressed: (context) => {
               _deleteMeal(meal),
                      
                    },
                  ),
                  
                ]),
                      child: ListTile(
                        title: Text(meal.MealName),
                        subtitle:
                            Text('${meal.MealTime.hour}:${meal.MealTime.minute}'),
                        trailing: Switch(
                          value: meal.isNotificationOpen,
                          onChanged: (bool value) {
                            setState(() {
                              meal.isNotificationOpen = value;
                              if (value) {
                                scheduleNotificationUsingWorkManager(meal);
                              } else {
                                cancelNotification(meal.hashCode);
                              }
                              saveMealsToPreferences();
                            });
                          },
                        ),
                        onTap: () {
    
                          _editMeal(meal);
                        },
                        
                      ),
                      
                    );
                  },
                
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewMeal,
        child: Icon(Icons.add),
      ),
    );
  }
}

// داله تقوم بحفظ البيانات في الهاتف بشكل دائم
void saveMealsToPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> mealStrings =
      meals.map((meal) => jsonEncode(meal.toJson())).toList();
  await prefs.setStringList('meals', mealStrings);
}

// داله تقوم بتحميل البيانات من الداكرة
Future<void> loadMealsFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? mealStrings = prefs.getStringList('meals');
  if (mealStrings != null) {
    meals = mealStrings
        .map((mealString) => MealNotification.fromJson(jsonDecode(mealString)))
        .toList();
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (task == 'show_notification_task') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'meal_channel',
          title: 'تذكير بالوجبة',
          body: 'حان الوقت لتناول الوجبة المجدولة!',
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
    return Future.value(true);
  });
}

void scheduleNotificationUsingWorkManager(MealNotification meal) {
  TimeOfDay now = TimeOfDay.now();
  TimeOfDay mealTime = TimeOfDay.fromDateTime(meal.MealTime);

  int hourDifference = mealTime.hour - now.hour;
  int minuteDifference = mealTime.minute - now.minute;

  Duration initialDelay = Duration(
    hours: hourDifference,
    minutes: minuteDifference,
  );

  if (initialDelay.isNegative) {
    initialDelay = Duration(
      hours: 24 + hourDifference,
      minutes: minuteDifference,
    );
  }

  Workmanager().registerOneOffTask(
    meal.hashCode.toString(),
    'show_notification_task',
    inputData: <String, dynamic>{'meal_name': meal.MealName},
    initialDelay: initialDelay,
  );
}

void cancelNotification(int id) {
  AwesomeNotifications().cancel(id);
  Workmanager().cancelByUniqueName(id.toString());
}
