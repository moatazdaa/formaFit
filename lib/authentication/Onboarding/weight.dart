import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/userProvider.dart';

class WeightSelectionPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
    final bool isSaveOrNext;

  WeightSelectionPage({required this.onNext, required this.onPrevious,required this.isSaveOrNext});

  @override
  _WeightSelectionPageState createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  int selectedWeightWhole = 30; // الجزء الصحيح من الوزن
  int selectedWeightDecimal = 0; // الجزء العشري من الوزن

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (weight != null) {
        setState(() {
          selectedWeightWhole = weight!.floor();
          selectedWeightDecimal =
              ((weight! - selectedWeightWhole) * 10).round();
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
              widget.isSaveOrNext?  'كم وزنك ؟':'تعديل الوزن',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
            widget.isSaveOrNext?    'الوزن بالكيلو جرام لا تقلق يمكنك دائما تغييره لاحقا':'',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الجزء العشري من الوزن
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.007,
                        diameterRatio: 1.2,
                        controller: FixedExtentScrollController(
                          initialItem: selectedWeightDecimal,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedWeightDecimal = index;
                            userProvider.updateField(
                                'weight',
                                selectedWeightWhole +
                                    selectedWeightDecimal / 10);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '$index',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: selectedWeightDecimal == index
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: selectedWeightDecimal == index
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
                    // الجزء الصحيح من الوزن
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.007,
                        diameterRatio: 1.2,
                        controller: FixedExtentScrollController(
                          initialItem: selectedWeightWhole - 30,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedWeightWhole = index + 30;
                            userProvider.updateField(
                                'weight',
                                selectedWeightWhole +
                                    selectedWeightDecimal / 10);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '${index + 30}',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: selectedWeightWhole == index + 30
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: selectedWeightWhole == index + 30
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
                      ' كجم',
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
                      print("///////////////////  weghit");
                      if (selectedWeightWhole > 0) {
                        weight =
                            selectedWeightWhole + selectedWeightDecimal / 10;
                        userProvider.updateField('weight', weight);
                        print(weight);
                        widget.onNext();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('يرجى اختيار وزنك للمتابعة')),
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
