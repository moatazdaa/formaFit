import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int dailyGoal = 2000;
  int dailyProgress = 0;
  List<WaterIntake> intakes = [];

  WaterProvider() {
    _loadData();
  }

  // تحميل البيانات من Firestore
  void _loadData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          dailyGoal = data['waterIntake']['dailyGoal'] ?? 2000;
          
          final snapshot = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('waterIntakes')
              .where('date', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, 1))
              .where('date', isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month + 1, 0))
              .get();

          intakes = snapshot.docs
              .map((doc) => WaterIntake.fromFirestore(doc.data()))
              .toList();

          dailyProgress = intakes
              .where((intake) => intake.date.day == DateTime.now().day)
              .fold(0, (sum, item) => sum + item.amount);

          notifyListeners();
        }
      }
    }
  }

  // إضافة كمية مياه جديدة إلى Firestore
  void addWater(int amount) async {
    User? user = _auth.currentUser;
    if (user != null) {
      final intake = WaterIntake(
        date: DateTime.now(),
        amount: amount,
      );

      await _addWaterIntakeToFirestore(user.uid, intake);
      dailyProgress += amount;
      await _updateDailyProgressInFirestore(user.uid, dailyProgress);

      intakes.add(intake);
      notifyListeners();
    }
  }

  // تحديث هدف المياه اليومي
  void updateDailyGoal(int newGoal) async {
    User? user = _auth.currentUser;
    if (user != null) {
      dailyGoal = newGoal;
      await _updateDailyGoalInFirestore(user.uid, newGoal);
      notifyListeners();
    }
  }

  // دالة لتحديث هدف المياه في Firestore
  Future<void> _updateDailyGoalInFirestore(String userId, int newGoal) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'waterIntake.dailyGoal': newGoal,
      });
    } catch (e) {
      print("Error updating daily goal: $e");
    }
  }

  // دالة لتحديث تقدم استهلاك المياه في Firestore
  Future<void> _updateDailyProgressInFirestore(String userId, int newProgress) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'waterIntake.dailyProgress': newProgress,
      });
    } catch (e) {
      print("Error updating daily progress: $e");
    }
  }

  // دالة لإضافة استهلاك المياه إلى Firestore
  Future<void> _addWaterIntakeToFirestore(String userId, WaterIntake intake) async {
    try {
      await _firestore.collection('users').doc(userId).collection('waterIntakes').add(intake.toFirestore());
    } catch (e) {
      print("Error adding water intake: $e");
    }
  }
}

class WaterIntake {
  final DateTime date;
  final int amount;

  WaterIntake({required this.date, required this.amount});

  // تحويل البيانات إلى صيغة Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'amount': amount,
    };
  }

  // تحويل البيانات من Firestore
  static WaterIntake fromFirestore(Map<String, dynamic> data) {
    return WaterIntake(
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'] as int,
    );
  }
}
