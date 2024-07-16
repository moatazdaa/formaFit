import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPlanScreen extends StatefulWidget {
  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  TextEditingController planName = TextEditingController();
  TextEditingController planPurpose = TextEditingController();
  TextEditingController weekCountController = TextEditingController();
  String selectedExerciseType = 'انقاص الوزن'; // تعيين القيمة الافتراضية
  int selectedExerciseHarder = 3; // تعيين الصعوبة الافتراضية
  late String userId = "";

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Failed to get user ID: $e');
    }
  }

 Future<void> addPlanToFirestore(String userId, String name, int numberOfWeeks,
      String purpose, String goal, int harder) async {
    try {
      CollectionReference plansCollection =
          FirebaseFirestore.instance.collection('plans');
      DocumentReference docRef = await plansCollection.add({
        'userId': userId,
        'name': name,
        'details': purpose,
        'goal': goal,
        'harder': harder,
        'weekCount': numberOfWeeks,
      });

      for (int i = 0; i < numberOfWeeks; i++) {
        DocumentReference weekDocRef = await docRef
            .collection('weeks')
            .add({'name': 'Week ${i + 1}', 'order': i});

        for (int j = 0; j < 7; j++) {
          CollectionReference daysCollection = FirebaseFirestore.instance.collection('days');
          await daysCollection.add({
            'name': 'Day ${j + 1}',
         'date': Timestamp.fromDate(DateTime.now()),
            'order2': j,
            'weekId': weekDocRef.id,  // إضافة معرف الأسبوع للمرجع
         'dayState': true,  // تأكد من إضافة الحقول الأخرى إذا كانت مطلوبة
       'completedExsrsisTimes': {},
          });
          print("Adding day:");
        }
      }
    } catch (e) {
      print("Error adding plan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Plan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: planName,
                decoration: InputDecoration(labelText: 'اسم الخطه'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: planPurpose,
                decoration: InputDecoration(labelText: 'الوصف'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: weekCountController,
                      decoration: InputDecoration(labelText: 'عدد الاسابيع'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'أسبوع',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButton<String>(
                      value: selectedExerciseType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedExerciseType = newValue!;
                        });
                      },
                      items: <String>[
                        'انقاص الوزن',
                        'بناء العضلات',
                        'زيادة الوزن'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'الهدف',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButton<int>(
                      value: selectedExerciseHarder,
                      onChanged: (newValue) {
                        setState(() {
                          selectedExerciseHarder = newValue!;
                        });
                      },
                      items: <int>[1, 2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'الصعوبة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int numberOfWeeks = int.tryParse(weekCountController.text) ?? 0;
                  addPlanToFirestore(
                      userId,
                      planName.text,
                      numberOfWeeks,
                      planPurpose.text,
                      selectedExerciseType,
                      selectedExerciseHarder);
                  Navigator.pop(context);
                },
                child: Text('Add Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
