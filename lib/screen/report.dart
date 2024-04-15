import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

// صفحة خاصة بي تقارير 
class ExerciseData {
  final String weekName;
  final int caloriesBurned;
  final double weight;
  final int duration;

  ExerciseData(
    this.weekName,
    this.caloriesBurned,
    this.weight,
    this.duration,
  );
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedMonth = 'الشهر الأول';
  String selectedWeek = 'الأسبوع الأول';
  double selectedWeight = 0.0;
  int selectedCalories = 0;
  int selectedDuration = 0;
  bool isMonthlyReport = true;

  List<charts.Series<ExerciseData, String>> seriesList = [];

  static List<charts.Series<ExerciseData, String>> _createSampleData() {
    final List<ExerciseData> month1Data = [
      ExerciseData('أسبوع 1', 7100, 60.0, 30),
      ExerciseData('أسبوع 2', 8000, 65.0, 40),
      ExerciseData('أسبوع 3', 7300, 62.5, 35),
      ExerciseData('أسبوع 4', 7600, 61.0, 32),
    ];

    final List<ExerciseData> month2Data = [
      ExerciseData('أسبوع 1', 8200, 63.0, 33),
      ExerciseData('أسبوع 2', 7800, 64.0, 36),
      ExerciseData('أسبوع 3', 7700, 62.0, 34),
      ExerciseData('أسبوع 4', 7900, 66.0, 42),
    ];

    return [
      charts.Series<ExerciseData, String>(
        id: 'calories',
        domainFn: (ExerciseData exercise, _) => exercise.weekName,
        measureFn: (ExerciseData exercise, _) => exercise.caloriesBurned,
        data: month1Data,
        colorFn: (_, __) => charts.Color.fromHex(code: '#FF0000'),
      ),
      charts.Series<ExerciseData, String>(
        id: 'weight',
        domainFn: (ExerciseData exercise, _) => exercise.weekName,
        measureFn: (ExerciseData exercise, _) => exercise.weight,
        data: month1Data,
        colorFn: (_, __) => charts.Color.fromHex(code: '#00FF00'),
      ),
      charts.Series<ExerciseData, String>(
        id: 'duration',
        domainFn: (ExerciseData exercise, _) => exercise.weekName,
        measureFn: (ExerciseData exercise, _) => exercise.duration,
        data: month1Data,
        colorFn: (_, __) => charts.Color.fromHex(code: '#0000FF'),
      ),
    ];
  }


  @override
    void initState() {
    super.initState();
    seriesList = _createSampleData();
    selectedCalories = seriesList[0].data[0].caloriesBurned;
    selectedWeight = seriesList[1].data[0].weight;
    selectedDuration = seriesList[2].data[0].duration;
  }
 void _showMonthsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الشهور'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('الشهر الأول'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = true;
                    seriesList = _createSampleData();
                    selectedMonth = 'الشهر الأول';
                    selectedWeek = seriesList[0].data[0].weekName;
                    selectedCalories = seriesList[0].data[0].caloriesBurned;
                    selectedWeight = seriesList[1].data[0].weight;
                    selectedDuration = seriesList[2].data[0].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
              ListTile(
                title: Text('الشهر الثاني'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = true;
                    seriesList = _createSampleData();
                    selectedMonth = 'الشهر الثاني';
                    selectedWeek = seriesList[0].data[0].weekName;
                    selectedCalories = seriesList[0].data[0].caloriesBurned;
                    selectedWeight = seriesList[1].data[0].weight;
                    selectedDuration = seriesList[2].data[0].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeeksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الأسابيع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('الأسبوع الأول'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = false;
                    selectedWeek = 'الأسبوع الأول';
                    selectedCalories = seriesList[0].data[0].caloriesBurned;
                    selectedWeight = seriesList[1].data[0].weight;
                    selectedDuration = seriesList[2].data[0].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
              ListTile(
                title: Text('الأسبوع الثاني'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = false;
                    selectedWeek = 'الأسبوع الثاني';
                    selectedCalories = seriesList[0].data[1].caloriesBurned;
                    selectedWeight = seriesList[1].data[1].weight;
                    selectedDuration = seriesList[2].data[1].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
              ListTile(
                title: Text('الأسبوع الثالث'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = false;
                    selectedWeek = 'الأسبوع الثالث';
                    selectedCalories = seriesList[0].data[2].caloriesBurned;
                    selectedWeight = seriesList[1].data[2].weight;
                    selectedDuration = seriesList[2].data[2].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
              ListTile(
                title: Text('الأسبوع الرابع'),
                onTap: () {
                  setState(() {
                    isMonthlyReport = false;
                    selectedWeek = 'الأسبوع الرابع';
                    selectedCalories = seriesList[0].data[3].caloriesBurned;
                    selectedWeight = seriesList[1].data[3].weight;
                    selectedDuration = seriesList[2].data[3].duration;
                  });
                  Navigator.pop(context); // إغلاق الحوار
                },
              ),
            ],
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('تقرير التمارين'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedMonth,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => _showMonthsDialog(context),
                child: Text('تغيير الشهر'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedWeek,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _showWeeksDialog(context),
                  child: Text('تغيير الأسبوع'),
                ),
              ],
            ),
          SizedBox(height: 16.0),
          Text(
            'السعرات الحرارية المحروقة: $selectedCalories',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'الوزن: $selectedWeight',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'المدة: $selectedDuration',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          SizedBox(height: 150.0),
    
          Expanded(
            child: Container(
            height: 250, // ارتفاع المخطط بالبكسل
            child: charts.BarChart(
            seriesList,
            animate: true,)),
          ),


        ],
      ),
    ),
  );
}}

//  domainAxis: charts.OrdinalAxisSpec(
//                 renderSpec: charts.SmallTickRendererSpec(
//                   // تعيين سمك الخطوط والنقاط
//                   lineStyle: charts.LineStyleSpec(
//            thickness: 1, // سمك الخطوط
//            color: charts.MaterialPalette.black, // لون الخطوط
//                   ),
//                   // تعيين حجم النقاط
//                   labelStyle: charts.TextStyleSpec(fontSize: 14), // حجم النص
//                   // تعيين حجم العلامات
//                   labelOffsetFromAxisPx: 2, // بعد العلامة عن الخط
//                   labelAnchor: charts.TickLabelAnchor.before, // موضع العلامة
//                 ),
//               ),
//               primaryMeasureAxis: charts.NumericAxisSpec(
//                 renderSpec: charts.GridlineRendererSpec(
//                   // تعيين سمك الخطوط والنقاط
//                   lineStyle: charts.LineStyleSpec(
//            thickness: 1, // سمك الخطوط
//            color: charts.MaterialPalette.black, // لون الخطوط
//                   ),
//                   // تعيين حجم النقاط
//                   labelStyle: charts.TextStyleSpec(fontSize: 12), // حجم النص
//                   // تعيين حجم العلامات
//                   labelOffsetFromAxisPx: 2, // بعد العلامة عن الخط
//                   labelAnchor: charts.TickLabelAnchor.before, // موضع العلامة
//                 ),
//               ),
