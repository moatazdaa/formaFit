import 'package:flutter/material.dart';
import 'package:formafit/authentication/auth_page.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalSelectionPage extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onPrevious;
  final bool isSaveOrNext;

  GoalSelectionPage(
      {required this.onFinish,
      required this.onPrevious,
      required this.isSaveOrNext});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  List<String> goals = [
    'بناء العضلات',
    'خسارة الوزن',
    'كسب الوزن',
    'تنشيف الجسم',
    'تحسين القدرة على التحمل',
    'أخرى',
  ];

  List<String> selectedGoals = [];

  @override
  void initState() {
    super.initState();
    loadSelectedGoals();
  }

  void loadSelectedGoals() {
    if (goalList != null && goalList is List<dynamic>) {
      setState(() {
        selectedGoals = (goalList as List<dynamic>).cast<String>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isOnNextEmpty = identical(widget.onFinish, () {});
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isSaveOrNext ? 'ما هو هدفك ؟' : 'تعديل الهدف',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.isSaveOrNext
                    ? 'يمكنك اختيار أكثر من واحد، لا تقلق يمكنك دائمًا تغييره لاحقًا'
                    : '',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    bool isSelected = selectedGoals.contains(goal);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedGoals.remove(goal);
                          } else {
                            selectedGoals.add(goal);
                          }
                          print("/////////// goal");
                          userProvider.updateField('goal', selectedGoals);

                          print(goalList);
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.blueAccent : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check,
                                  color: Colors.blueAccent, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (widget.isSaveOrNext == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.onPrevious,
                    child: Text('السابق'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedGoals.isNotEmpty
                        ? () async {
                            await finishOnboarding();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage()),
                            );
                          }
                        : null,
                    child: Text('ابدأ الآن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  if (widget.isSaveOrNext == false)
                    ElevatedButton(
                      onPressed: () async {
                        await SaveUserData();
                        Navigator.pop(context);
                      },
                      child: Text('حفظ'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                ],
              ),
                if (widget.isSaveOrNext == false)
                    ElevatedButton(
                      onPressed: () async {
                        await SaveUserData();
                        Navigator.pop(context);
                      },
                      child: Text('حفظ'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }
}
