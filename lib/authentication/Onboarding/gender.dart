import 'package:flutter/material.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:provider/provider.dart';

class GenderSelectionPage extends StatelessWidget {
  final VoidCallback onNext;
  final bool isSaveOrNext;

  GenderSelectionPage({required this.onNext, required this.isSaveOrNext});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSaveOrNext ? 'أخبرنا عن نفسك' : 'تعديل الجنس',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                isSaveOrNext
                    ? 'نحن بحاجة إلى معرفة معلوماتك الشخصية لنوفر لك أفضل تجربة ممكنة'
                    : "",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              // الجنس
              SizedBox(height: 50),
              Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          gender = 'ذكر';
                          provider.updateField('gender', 'ذكر');
                          print(gender);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: gender == 'ذكر'
                                ? Colors.blueAccent.withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.amber,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                      AssetImage('assets/images/male.png'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'ذكر',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: gender == 'ذكر'
                                      ? Colors.blueAccent
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          gender = 'ذكر';
                          provider.updateField('gender', 'أنثى');
                          print(gender);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: gender == 'أنثى'
                                ? Colors.pinkAccent.withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.amber,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                      AssetImage('assets/images/female.png'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'أنثى',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: gender == 'أنثى'
                                      ? Colors.pinkAccent
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Spacer(),

              if (isSaveOrNext == true)
                ElevatedButton(
                  onPressed: gender != null ? onNext : null,
                  child: Text('التالي'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              if (isSaveOrNext == false)
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
