import 'package:flutter/material.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:provider/provider.dart';

class HeightSelectionPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isSaveOrNext;

  HeightSelectionPage({required this.onNext, required this.onPrevious,required this.isSaveOrNext});

  @override
  _HeightSelectionPageState createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  int selectedHeightWhole = 0; // القيمة الافتراضية للطول الصحيح
  int selectedHeightDecimal = 0; // القيمة الافتراضية للطول العشري

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (height != null) {
        setState(() {
          selectedHeightWhole = height!.floor();
          selectedHeightDecimal =
              ((height! - selectedHeightWhole) * 10).round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              widget.isSaveOrNext?  'كم طولك ؟':'تعديل الطول',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
            widget.isSaveOrNext?    'الطول بالسنتيمتر لا تقلق يمكنك دائما تغييره لاحقا':'',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الجزء العشري من الطول
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.007,
                        diameterRatio: 1.2,
                        controller: FixedExtentScrollController(
                          initialItem: selectedHeightDecimal,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHeightDecimal = index;
                            userProvider.updateField(
                                'height',
                                selectedHeightWhole +
                                    selectedHeightDecimal / 10);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '$index',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: selectedHeightDecimal == index
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: selectedHeightDecimal == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                          childCount: 10,
                        ),
                      ),
                    ),
                    Text(
                      ' . ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    // الجزء الصحيح من الطول
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.007,
                        diameterRatio: 1.2,
                        controller: FixedExtentScrollController(
                          initialItem: selectedHeightWhole - 50,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHeightWhole = index + 50;
                            userProvider.updateField(
                                'height',
                                selectedHeightWhole +
                                    selectedHeightDecimal / 10);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '${index + 50}',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: selectedHeightWhole == index + 50
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: selectedHeightWhole == index + 50
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                          childCount: 200,
                        ),
                      ),
                    ),
                    Text(
                      ' سم',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    onPressed: () {
                      print("////////////////////////////////////   heghit");
                      if (selectedHeightWhole > 0) {
                        height =
                            selectedHeightWhole + selectedHeightDecimal / 10;
                        userProvider.updateField('height', height);

                        print(height);
                        widget.onNext();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('يرجى اختيار طولك للمتابعة')),
                        );
                      }
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
