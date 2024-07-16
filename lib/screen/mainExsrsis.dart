import 'package:flutter/material.dart';
import 'package:formafit/classes/ExsrsisPage.dart';

class MainExercises extends StatefulWidget {
  const MainExercises({super.key});

  @override
  State<MainExercises> createState() => _MainExercisesState();
}

class _MainExercisesState extends State<MainExercises> {
  // قائمة لتتبع حالة الضغط لكل عنصر
  List<bool> tapped = [];
  String? selectedImagePath;
  int? lastTappedIndex;

  @override
  void initState() {
    super.initState();
    // تهيئة القائمة بحالة غير مضغوط لكل عنصر
    tapped = List<bool>.filled(ListPageExsrsis.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: -30,
            top: 50,
            child: Container(
              height: 600,
              width: 350,
              child: Image.asset(selectedImagePath ?? 'assets/images/FrontBodyPage.jpg'),
            ),
          ),
          Positioned(
            top: 180,
            right: 15,
            child: Container(
              height: 388,
              width: 150,
              child: ListView.builder(
                itemCount: ListPageExsrsis.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: tapped[index] ? Color.fromARGB(255, 241, 135, 15) : Colors.white,
                    child: ListTile(
                      title: Text(
                        ListPageExsrsis[index].name,
                        style: TextStyle(
                          color: tapped[index] ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: tapped[index] ? Icon(Icons.arrow_forward, color: Colors.white) : null,
                      onTap: () {
                        setState(() {
                          if (tapped[index] && lastTappedIndex == index) {
                            // إذا تم الضغط على العنصر نفسه مرة أخرى، الانتقال إلى الصفحة
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPageExsrsis[index].page,
                              ),
                            );
                          } else {
                            // إعادة تعيين جميع العناصر إلى الحالة الافتراضية
                            tapped = List<bool>.filled(ListPageExsrsis.length, false);
                            // تعيين العنصر الحالي كـ"محدد"
                            tapped[index] = true;
                            // تحديث الصورة المعروضة
                            selectedImagePath = ListPageExsrsis[index].imagePath;
                            // تحديث آخر عنصر تم النقر عليه
                            lastTappedIndex = index;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
        
          ),
    
    
    Positioned
    (
      right: 20,
      top: 90,
      child: 
    Text(
      'اختر التمارين',
      style: TextStyle(
        fontSize: 24,
        fontStyle: FontStyle.italic,
        color: Colors.black,

      ),
    )
    )
        ],
      ),
    );
  }
}
