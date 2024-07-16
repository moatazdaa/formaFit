import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';

class ActivityReportPage extends StatefulWidget {
  @override
  _ActivityReportPageState createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _selectedDay = 'Monday';

  final List<DayInWeek> _days = [
    DayInWeek(  "Mon",dayKey: "Monday"),
    DayInWeek( "Tue",dayKey: "Tuesday"),
    DayInWeek( "Wed",dayKey: "Wednesday"),
    DayInWeek( "Thu",dayKey: "Thursday"),
    DayInWeek( "Fri",dayKey: "Friday"),
    DayInWeek( "Sat",dayKey: "Saturday"),
    DayInWeek( "Sun",dayKey: "Sunday"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Report'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: Column(
            children: [
              SelectWeekDays(
                border: false,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.orangeAccent],
                  ),
                ),
                selectedDayTextColor: Colors.white,
                unSelectedDayTextColor: Colors.orange,
                days: _days,
                onSelect: (values) {
                  setState(() {
                    _selectedDay = values.first.name;
                  });
                },
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Exercise Report'),
                  Tab(text: 'Diet Report'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ExerciseReport(selectedDay: _selectedDay),
                DietReport(selectedDay: _selectedDay),
              ],
            ),
          ),
          Container(
            color: Colors.orange.shade100,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Challenges Progress:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                Text('Challenge 1: 80% completed', style: TextStyle(fontSize: 16)),
                Text('Challenge 2: 50% completed', style: TextStyle(fontSize: 16)),
                // أضف المزيد من التفاصيل حسب الحاجة
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseReport extends StatelessWidget {
  final String selectedDay;

  ExerciseReport({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exercise Details for $selectedDay:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
          Text('Total Exercises: 5', style: TextStyle(fontSize: 16)),
          Text('Calories Burned: 500', style: TextStyle(fontSize: 16)),
          Text('Weight Lost: 1 kg', style: TextStyle(fontSize: 16)),
          Text('Duration: 45 minutes', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Text('Score: 85%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}

class DietReport extends StatelessWidget {
  final String selectedDay;

  DietReport({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diet Details for $selectedDay:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
          Text('Calories Intake: 1500 kcal', style: TextStyle(fontSize: 16)),
          Text('Protein: 100 g', style: TextStyle(fontSize: 16)),
          Text('Carbs: 200 g', style: TextStyle(fontSize: 16)),
          Text('Fats: 50 g', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Text('Score: 90%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}
