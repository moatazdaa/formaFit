import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerformanceTrackingPage extends StatefulWidget {
  @override
  _PerformanceTrackingPageState createState() => _PerformanceTrackingPageState();
}

class _PerformanceTrackingPageState extends State<PerformanceTrackingPage> {
  DateTime selectedDate = DateTime.now();
    double currentWeight = 55.0;
  double targetWeight = 65.0;
  double dailyCalories = 0.0;
  List<Map<String, dynamic>> calorieData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع الأداء'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _loadLastMonthData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'جدول غذائي'),
            _buildDietReport(),
            _buildSectionTitle(context, 'جدول تمارين'),
            _buildWorkoutReport(),
            _buildSectionTitle(context, 'تتبع معدل شرب المياه'),
            _buildWaterIntakeReport(),
            _buildSectionTitle(context, 'تتبع الخطوات/المسافة'),
            _buildStepsDistanceReport(),
                   _buildWeightInfo(),
              SizedBox(height: 20),
              _buildCalorieTracker(),
              SizedBox(height: 20),
              _buildProgressInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        //  style: Theme.of(context).textTheme.headline6,

      ),
    );
  }

  Widget _buildDietReport() {
    // هذه البيانات افتراضية، يمكن استبدالها ببيانات حقيقية من قاعدة البيانات
    final dietData = [
      {'food': 'تفاح', 'calories': 95, 'carbs': 25, 'proteins': 0.5, 'fats': 0.3},
      {'food': 'صدر دجاج', 'calories': 165, 'carbs': 0, 'proteins': 31, 'fats': 3.6},
    ];

    return _buildReportTable(dietData, ['الطعام', 'السعرات', 'الكربوهيدرات', 'البروتينات', 'الدهون']);
  }

  Widget _buildWorkoutReport() {
    final workoutData = [
      {'exercise': 'الجري', 'duration': '30 دقيقة', 'calories': 300},
      {'exercise': 'رفع الأثقال', 'duration': '45 دقيقة', 'calories': 200},
    ];

    return _buildReportTable(workoutData, ['التمرين', 'المدة', 'السعرات المحروقة']);
  }

  Widget _buildWaterIntakeReport() {
    final waterIntakeData = [
      {'day': 'الاثنين', 'intake': '2 لتر'},
      {'day': 'الثلاثاء', 'intake': '1.5 لتر'},
    ];

    return _buildReportTable(waterIntakeData, ['اليوم', 'كمية الماء']);
  }

  Widget _buildStepsDistanceReport() {
    final stepsDistanceData = [
      {'day': 'الاثنين', 'steps': 5000, 'distance': '4 كم'},
      {'day': 'الثلاثاء', 'steps': 6000, 'distance': '4.8 كم'},
    ];

    return _buildReportTable(stepsDistanceData, ['اليوم', 'الخطوات', 'المسافة']);
  }

  Widget _buildReportTable(List<Map<String, dynamic>> data, List<String> columns) {
    return DataTable(
      columns: columns.map((column) => DataColumn(label: Text(column))).toList(),
      rows: data.map((row) {
        return DataRow(
          cells: row.values.map((value) => DataCell(Text(value.toString()))).toList(),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // هنا يمكنك تحميل البيانات للفترة الزمنية المحددة
      });
    }
  }

  void _loadLastMonthData() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
      // هنا يمكنك تحميل البيانات للشهر السابق
    });
  }

    Widget _buildWeightInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الوزن الحالي: $currentWeight كجم',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'الوزن المستهدف: $targetWeight كجم',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildCalorieTracker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السعرات الحرارية اليومية',
              style: TextStyle(fontSize: 18),
            ),
            ...calorieData.map((data) {
              return ListTile(
                title: Text(data['description']),
                trailing: Text('${data['calories']} سعرة حرارية'),
              );
            }).toList(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'الوصف',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        calorieData.add({
                          'description': value,
                          'calories': dailyCalories,
                        });
                        dailyCalories = 0.0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'السعرات الحرارية',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      dailyCalories = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressInfo() {
    double progress = (currentWeight - 55.0) / (targetWeight - 55.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقدم نحو الهدف',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
            SizedBox(height: 10),
            Text(
              '${(progress * 100).toStringAsFixed(2)}% تم الوصول إليه',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


