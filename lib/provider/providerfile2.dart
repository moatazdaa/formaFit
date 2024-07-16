import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/classes/gym_exercises.dart';

//يستخدم هادا المتغير لحساب وقت التمارين المنجزة
late Duration ExsrsisTimeComplet = Duration.zero;

mixin zero {}

mixin duration {}

//متغير يستخدم لمعرفة حاله النقرة الاولي
bool isFirstTap = true;
bool FoodisFirstTap = true;
//متغير مستخدم لمعرفة عنوان العنصر المحدد
bool isExerciseSelected = false;
bool isFoodSelected = false;

List<Foods> selectedFoods_to_list = [];

List<exsrsis_item> selectedexsrsis_to_list = [];
//قائمه تستخدم لنسخ التمارين من اليوم
List<exsrsis_item> ListCopyExsrsisFromDay = [];
//يستخدم هادا المتغير لتخزين عنزان مستند اليوم
String dayDocId = "";
//يستخدم هادا المتغير لتخزين عنوان اندكس التمرين
int SelectExsrsisId = 0;
//يستخدم هادا المتغير لتخزين قيمه القرامات المطلوب تعديلها في الوجبة  لكي يستخدم في داله التعديل
var TotalEditGram = 0;

//متغير يخزن قيمه اليوم
DateTime today = DateTime.now();

// //  متغير يستحدم لجلب  التواني
// int secondsFromFirestore = 0;

Future<void> removeExerciseFromDay(String dayDocId, int exerciseId) async {
  try {
    CollectionReference exercisesRef = FirebaseFirestore.instance
        .collection('days')
        .doc(dayDocId)
        .collection('exercises');

    QuerySnapshot querySnapshot =
        await exercisesRef.where('id', isEqualTo: exerciseId).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot exerciseDoc = querySnapshot.docs.first;
      await exercisesRef.doc(exerciseDoc.id).delete();
      print('Exercise removed successfully.');
    } else {
      print('Exercise not found.');
    }
  } catch (e) {
    print('Error removing exercise: $e');
  }
}



// داله تستخدم لتعيل الخطوات المستهدفة والمسافة
Future<void> UpdateStepGoal(var goolStep, var kmGoal) async {
  try {
    // احصل على المستخدم الحالي
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // مرجع المجموعة
      final userWalkRef = FirebaseFirestore.instance.collection("UserWalk");

      // احصل على التاريخ الحالي بدون وقت
      final today = DateTime.now();
      final dayStart = DateTime(today.year, today.month, today.day);

      // تحقق مما إذا كان المستند موجود أم لا
      final querySnapshot = await userWalkRef
          .where('UserId', isEqualTo: user.uid)
          .where('Day', isEqualTo: Timestamp.fromDate(dayStart))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // المستند موجود، قم بجلب القيم الحالية وأضف القيم الجديدة
        final doc = querySnapshot.docs.first;

        await doc.reference.update({'StepGoal': goolStep, 'kmGoal': kmGoal});


      } else {
        print("data is not found");
      }
      print("Data added/updated successfully!");
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Failed to add/update data: $e");
  }
}
void Clear_selectedexsrsis_to_list() {
  selectedexsrsis_to_list.clear();
}

//متغير يستخدم لتحديد الخطوات المستهدفة
int circular_count = 100;
//متغير يستخدم لحساب المسافة بالكيلو متر
double kmGoal = 0;
// متغير يستخدم للتعامل مع المسافة المقطوعة بال كم
double kmWalk = 0;

class Provfile2 with ChangeNotifier {
  // متغير يستخدم للتعامل مع المسافة المقطوعة بال كم
  double kmWalk = 0;



// داله تستخدم لتحديت قيمه الخطوات المستهدفة وتستخدم في داله التعديل في قاعدة البيانات
  void UpdateWalkCountGoalProvide(int value) {
    circular_count = value;
    kmGoal = circular_count / 1315;
    notifyListeners();
  }

// داله تستخدم لتحديت قيمه المسافة المستهدفة وتستخدم في داله التعديل في قاعدة البيانات
  void UpdateWalkGoalKmProvide(double value) {
    kmGoal = value;
    circular_count = (kmGoal * 1315).toInt();
    notifyListeners();
  }

  // يستخدم ل تحديت قيمه المسافة المقطوعه ويستخدم في داله جلب البيانات
  void UpdateWalkKmProvide(double value) {
    kmWalk = value;
    notifyListeners();
  }

  // يستخدم ل تحديت قيمه المسافة المستهدفة ويستخدم في داله جلب البيانات
  void UpdateWalkgoalProvide(double value) {
    kmGoal = value;
    notifyListeners();
  }
}
