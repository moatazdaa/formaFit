import 'package:flutter/material.dart';

// مزود للحسابات الصحية
class CalculatorProvider extends ChangeNotifier {
  // تعريف أسماء العمليات والنشاط كفئات ثابتة
  static const String operationSelect = 'اختر العملية';
  static const String operationBMI = 'مؤشر كتلة الجسم';
  static const String operationCalories = 'السعرات الحرارية';
  static const String operationIdealWeight = 'الوزن المثالي';
  static const String operationCaloriesBurned = 'السعرات الحرارية المحروقة';
  static const String operationNutrients = 'المغذيات';

  static const String activitySelect = 'اختر النشاط';
  static const String activityNone = 'معدوم النشاط';
  static const String activityLight = 'نشاط خفيف';
  static const String activityModerate = 'نشاط متوسط';
  static const String activityHigh = 'نشاط عالي';

  // المتغيرات الخاصة بحالة المزود
  String _selectedOperation = operationSelect;
  String _gender = 'ذكر';
  double _currentWeight = 70.0;
  double _currentHeight = 170.0;
  int _currentAge = 25;
  String _activityLevel = activitySelect;
  double _result = 0.0;
  double _proteinResult = 0.0;
  double _fatResult = 0.0;
  double _carbsResult = 0.0;

  double _idealWeightLowerBound = 0.0;
  double _idealWeightUpperBound = 0.0;
  bool _showResult = false;

  // البيانات لنسبة المغذيات
  List<NutrientData> _nutrientsData = [];

  // Getters - للوصول إلى القيم الحالية
  String get selectedOperation => _selectedOperation;
  String get gender => _gender;
  double get currentWeight => _currentWeight;
  double get currentHeight => _currentHeight;
  int get currentAge => _currentAge;
  String get activityLevel => _activityLevel;
  String get result => _result.toStringAsFixed(2);
  double get proteinResult => _proteinResult;
  double get fatResult => _fatResult;
  double get carbsResult => _carbsResult;
  double get idealWeightLowerBound => _idealWeightLowerBound;
  double get idealWeightUpperBound => _idealWeightUpperBound;
  bool get showResult => _showResult;
  List<NutrientData> get nutrientsData => _nutrientsData;

  // Update methods - لتحديث القيم وإعلام المستمعين بالتغييرات
  void updateSelectedOperation(String operation) {
    _selectedOperation = operation;
    _showResult = false;
    notifyListeners(); // إعلام المستمعين بالتغيير
  }

  void updateGender(String newGender) {
    _gender = newGender;
    notifyListeners();
  }

  void updateWeight(double newWeight) {
    _currentWeight = newWeight;
    notifyListeners();
  }

  void updateHeight(double newHeight) {
    _currentHeight = newHeight;
    notifyListeners();
  }

  void updateAge(int newAge) {
    _currentAge = newAge;
    notifyListeners();
  }

  void updateActivityLevel(String newActivityLevel) {
    _activityLevel = newActivityLevel;
    notifyListeners();
  }

  // Calculation methods - لتنفيذ العمليات الحسابية بناءً على العملية المختارة
  void calculate() {
    _result = 0.0; // إعادة تعيين النتيجة
    _showResult = true;

    switch (_selectedOperation) {
      case operationBMI:
        _result = calculateBMI();
        break;
      case operationCalories:
        _result = calculateCalories();
        break;
      case operationIdealWeight:
        calculateIdealWeight();
        break;
      case operationCaloriesBurned:
        _result = calculateCaloriesBurned();
        break;
      case operationNutrients:
        calculateNutrients();
        break;
      default:
        _showResult = false;
        break;
    }
    notifyListeners(); // إعلام المستمعين بالتغيير
  }

  // حساب مؤشر كتلة الجسم
  double calculateBMI() {
    return _currentWeight / ((_currentHeight / 100) * (_currentHeight / 100));
  }

  // حساب السعرات الحرارية
  double calculateCalories() {
    if (_gender == 'ذكر') {
      return 88.36 + (13.4 * _currentWeight) + (4.8 * _currentHeight) - (5.7 * _currentAge);
    } else {
      return 447.6 + (9.2 * _currentWeight) + (3.1 * _currentHeight) - (4.3 * _currentAge);
    }
  }

  // حساب الوزن المثالي
  void calculateIdealWeight() {
    _idealWeightLowerBound = 18.5 * ((_currentHeight / 100) * (_currentHeight / 100));
    _idealWeightUpperBound = 24.9 * ((_currentHeight / 100) * (_currentHeight / 100));
  }

  // حساب السعرات الحرارية المحروقة بناءً على مستوى النشاط
  double calculateCaloriesBurned() {
    double bmr = calculateCalories();
    switch (_activityLevel) {
      case activityNone:
        return bmr * 1.2;
      case activityLight:
        return bmr * 1.375;
      case activityModerate:
        return bmr * 1.55;
      case activityHigh:
        return bmr * 1.725;
      default:
        return bmr; // إذا لم يتم اختيار مستوى نشاط صالح، إرجاع BMR
    }
  }

  // حساب المغذيات بناءً على إجمالي استهلاك الطاقة اليومي
  void calculateNutrients() {
    double tdee = calculateCaloriesBurned(); // إجمالي استهلاك الطاقة اليومي

    // توزيع المغذيات بنسبة 30% بروتين، 25% دهون، 45% كربوهيدرات
    _proteinResult = (tdee * 0.3) / 4; // 1 جرام بروتين = 4 سعرات حرارية
    _fatResult = (tdee * 0.25) / 9; // 1 جرام دهون = 9 سعرات حرارية
    _carbsResult = (tdee * 0.45) / 4; // 1 جرام كربوهيدرات = 4 سعرات حرارية

    _nutrientsData = [
      NutrientData('البروتين', _proteinResult),
      NutrientData('الدهون', _fatResult),
      NutrientData('الكربوهيدرات', _carbsResult),
    ];
  }

  // حساب مؤشر الوزن بناءً على الوزن المثالي
  double get weightIndicatorValue {
    if (_currentWeight < _idealWeightLowerBound) {
      return 0.0;
    } else if (_currentWeight > _idealWeightUpperBound) {
      return 1.0;
    } else {
      return (_currentWeight - _idealWeightLowerBound) / (_idealWeightUpperBound - _idealWeightLowerBound);
    }
  }
}

// فئة لتمثيل بيانات المغذيات
class NutrientData {
  final String nutrient;
  final double percentage;

  NutrientData(this.nutrient, this.percentage);
}
