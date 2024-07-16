import 'package:flutter/material.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:provider/provider.dart'; // استيراد مزود الحالة

class ActivityLevelPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
    final bool isSaveOrNext;

  ActivityLevelPage({required this.onNext, required this.onPrevious,required this.isSaveOrNext});

  @override
  Widget build(BuildContext context) {
      final isOnNextEmpty = identical( onNext, () {});
    final userProvider = Provider.of<UserProvider>(context);

    List<String> activityLevels = [
      'معدوم النشاط',
      'نشاط خفيف',
      'نشاط متوسط',
      'نشاط عالي',
    ];

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            isSaveOrNext?'مستوى النشاط البدني':'تعديل مستوى النشاط البدني',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
              isOnNextEmpty?  'اختر مستوى نشاطك المعتاد فهذا سيساعدك على تخصيص الخطة لك':'',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Column(
                children: activityLevels.map((activity) {
                  bool isSelected = activityLevel == activity;
                  return InkWell(
                    onTap: () {
                      print("//////////////// activity");
                      userProvider.updateActivityLevel(activity);
                      print(activity);
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
                            activity,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  isSelected ? Colors.blueAccent : Colors.black,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check,
                                color: Colors.blueAccent, size: 24),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Spacer(),
                if ( isSaveOrNext == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onPrevious,
                    child: Text('السابق'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        activityLevel != null && activityLevel!.isNotEmpty
                            ? onNext
                            : null,
                    child: Text('التالي'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  
                ],
              ),
                if ( isSaveOrNext == false)
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
}
