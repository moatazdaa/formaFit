import 'package:flutter/material.dart';

class UserInputPage extends StatefulWidget {
  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  String _goal = 'Maintain';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدخال بيانات المستخدم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'العمر'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال العمر';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'الطول (سم)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الطول';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'الوزن (كجم)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الوزن';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'الجنس'),
                items: ['Male', 'Female']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                decoration: InputDecoration(labelText: 'مستوى النشاط'),
                items: [
                  'Sedentary',
                  'Lightly active',
                  'Moderately active',
                  'Very active',
                  'Extra active'
                ]
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _goal,
                decoration: InputDecoration(labelText: 'الهدف'),
                items: [
                  'Lose weight',
                  'Maintain',
                  'Gain weight'
                ]
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _goal = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationPage(
                          age: int.parse(_ageController.text),
                          height: double.parse(_heightController.text),
                          weight: double.parse(_weightController.text),
                          gender: _gender,
                          activityLevel: _activityLevel,
                          goal: _goal,
                        ),
                      ),
                    );
                  }
                },
                child: Text('احصل على التوصيات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendationPage extends StatelessWidget {
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String activityLevel;
  final String goal;

  RecommendationPage({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final double bmr = _calculateBMR();
    final double tdee = _calculateTDEE(bmr);
    final double waterIntake = _calculateWaterIntake();
    final double calorieGoal = _calculateCalorieGoal(tdee);
    final List<String> workoutRecommendations = _getWorkoutRecommendations();
    final List<String> mealRecommendations = _getMealRecommendations(calorieGoal);

    return Scaffold(
      appBar: AppBar(
        title: Text('التوصيات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'السعرات الحرارية اليومية: ${calorieGoal.toStringAsFixed(2)} سعرة حرارية',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'الاحتياج اليومي من الماء: ${waterIntake.toStringAsFixed(2)} لتر',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'توصيات التمارين:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...workoutRecommendations.map((recommendation) => ListTile(
                  title: Text(recommendation),
                )),
            SizedBox(height: 20),
            Text(
              'توصيات الوجبات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...mealRecommendations.map((recommendation) => ListTile(
                  title: Text(recommendation),
                )),
          ],
        ),
      ),
    );
  }

  double _calculateBMR() {
    if (gender == 'Male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  double _calculateTDEE(double bmr) {
    double activityFactor;

    switch (activityLevel) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly active':
        activityFactor = 1.375;
        break;
      case 'Moderately active':
        activityFactor = 1.55;
        break;
      case 'Very active':
        activityFactor = 1.725;
        break;
      case 'Extra active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.2;
    }

    return bmr * activityFactor;
  }

  double _calculateWaterIntake() {
    return weight * 0.033;
  }

  double _calculateCalorieGoal(double tdee) {
    switch (goal) {
      case 'Lose weight':
        return tdee - 500;
      case 'Gain weight':
        return tdee + 500;
      default:
        return tdee;
    }
  }

  List<String> _getWorkoutRecommendations() {
    if (goal == 'Lose weight') {
      return [
        'الكارديو: مثل الجري، المشي السريع، نط الحبل',
        'تمارين المقاومة: مثل رفع الأثقال، تمارين البطن',
        'الكروس فيت: تدريب متنوع وعالي الكثافة',
      ];
    } else if (goal == 'Gain weight') {
      return [
        'تمارين القوة: مثل رفع الأثقال الثقيلة',
        'تمارين البناء العضلي: مثل تمارين الضغط والسكوات',
        'تمارين المركبة: مثل تمرين الرفع المركب',
      ];
    } else {
      return [
        'تمارين التوازن: مثل اليوغا والبيلاتس',
        'تمارين القوة المعتدلة: مثل رفع الأثقال الخفيفة والمتوسطة',
        'تمارين الكارديو: مثل المشي والسباحة',
      ];
    }
  }

  List<String> _getMealRecommendations(double calorieGoal) {
    int mealsPerDay = 4;
    double caloriesPerMeal = calorieGoal / mealsPerDay;
    double proteinPerMeal = caloriesPerMeal * 0.3 / 4; // assuming 30% protein
    double carbsPerMeal = caloriesPerMeal * 0.4 / 4; // assuming 40% carbs
    double fatsPerMeal = caloriesPerMeal * 0.3 / 9; // assuming 30% fats

    return [
      'يجب أن تحتوي كل وجبة على ${caloriesPerMeal.toStringAsFixed(2)} سعرة حرارية',
      'بروتين لكل وجبة: ${proteinPerMeal.toStringAsFixed(2)} جرام',
      'كربوهيدرات لكل وجبة: ${carbsPerMeal.toStringAsFixed(2)} جرام',
      'دهون لكل وجبة: ${fatsPerMeal.toStringAsFixed(2)} جرام',
      'يُنصح بتناول 4-6 وجبات يوميًا',
    ];
  }
}


