import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/userProvider.dart';

class AgeSelectionPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
    final bool isSaveOrNext;


  AgeSelectionPage({required this.onNext, required this.onPrevious,required this.isSaveOrNext});

  @override
  _AgeSelectionPageState createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  int? selectedAge; // العمر الافتراضي عند بدء التطبيق


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        selectedAge = age ?? 25; // القيمة الافتراضية
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  
    
    final userProvider = Provider.of<UserProvider>(context);
      // التحقق مما إذا كانت الدالة onNext فارغة
  

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            widget.isSaveOrNext?  'كم عمرك ؟':'تعديل العمر',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.isSaveOrNext?  'العمر بالسنوات سيساعدنا ذلك علي تخصيص خطة التمرين التي تناسبك':'',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      perspective: 0.007,
                      diameterRatio: 1.2,
                      controller: FixedExtentScrollController(
                          initialItem:
                              selectedAge != null ? selectedAge! - 1 : 24),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedAge = index + 1;
                          userProvider.updateField('age', selectedAge!);
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          return Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: selectedAge == index + 1
                                        ? Colors.amber
                                        : Colors.black,
                                    fontWeight: selectedAge == index + 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (selectedAge == index + 1)
                                  Positioned(
                                    top: -25,
                                    child: Container(
                                      height: 1,
                                      width: 100,
                                      color: Colors.amber,
                                    ),
                                  ),
                                if (selectedAge == index + 1)
                                  Positioned(
                                    bottom: -25,
                                    child: Container(
                                      height: 1,
                                      width: 100,
                                      color: Colors.amber,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        childCount: 100,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget. isSaveOrNext == true)
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
                    // onPressed: selectedAge != null ? widget.onNext : null,
                    onPressed: () {
                      print("//////////////////// age");
                      age = selectedAge;
                      print(age);
                      widget.onNext;
                    },
                    child: Text('التالي'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                
                ],
              ),
                if (widget. isSaveOrNext == false)
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
