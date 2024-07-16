
// عداد خاص بتعديل عدد الخطوات المستهدفة
import 'package:flutter/material.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class StepWalkNumperPicker extends StatefulWidget {
  const StepWalkNumperPicker({super.key});

  @override
  State<StepWalkNumperPicker> createState() => _StepWalkNumperPickerState();
}

class _StepWalkNumperPickerState extends State<StepWalkNumperPicker> {

  //هادا المتغير خاص بالاحاد
var Onse = 0;
//هادا المتغير خاص بالعشرات
var Hundreds = 0;
//هادا المتغير خاص بالعشرات
var Dozen = 0;
//هادا المتغير خاص بالاف
var Tousend = 0;
  @override
  Widget build(BuildContext context) {
      final prov1 = Provider.of<Provfile2>(context);
    int TotalEditGram =
        (Tousend * 1000) + (Hundreds * 100) + (Dozen * 10) + Onse;
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل عدد الخطوات المستهدفة '),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                prov1.UpdateWalkCountGoalProvide(TotalEditGram);
                UpdateStepGoal(circular_count, kmGoal);
              });

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.edit,
            size: 30,
            color: Color.fromARGB(255, 0, 0, 0),),
          ),
          SizedBox(
            width: 1,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${TotalEditGram}',
              style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  TenTousend هادا المتغير خاص  الالاف
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 65,
                    itemWidth: 65,
                    itemHeight: 70,
                    value: Tousend,
                    onChanged: (value) {
                      setState(() {
                        Tousend = value;
                      });
                    },
                  ),

                  // hundreds
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemHeight: 70,
                    itemWidth: 65,
                    value: Hundreds,
                    onChanged: (value) {
                      setState(() {
                        Hundreds = value;
                      });
                    },
                  ),
                  //Dozen  العشرات
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemHeight: 65,
                    itemWidth: 80,
                    value: Dozen,
                    onChanged: (value) {
                      setState(() {
                        Dozen = value;
                      });
                    },
                  ),
                  //onse  الاحاد
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemWidth: 65,
                    itemHeight: 70,
                    value: Onse,
                    onChanged: (value) {
                      setState(() {
                        Onse = value;
                      });
                    },
                  ),
                  //هادا المتغير خاص بالاف   tousend

                  Text("خطوة")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}