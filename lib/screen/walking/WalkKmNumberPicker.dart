import 'package:flutter/material.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class KmNumberPiker extends StatefulWidget {
  const KmNumberPiker({super.key});

  @override
  State<KmNumberPiker> createState() => _KmNumberPikerState();
}

class _KmNumberPikerState extends State<KmNumberPiker> {
  //هادا المتغير خاص بالاحاد
  var Onse = 0;
//هادا المتغير خاص بالعشرات
  var Hundreds = 0;
//هادا المتغير خاص بالعشرات
  var Dozen = 0;

  @override
  Widget build(BuildContext context) {
    final prov1 = Provider.of<Provfile2>(context);
    double TotalEditKm = (Onse * 0.01) + (Dozen * 0.1) + Hundreds;
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل المسافة المستهدفة'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                prov1.UpdateWalkGoalKmProvide(TotalEditKm);
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
              "${TotalEditKm.toStringAsFixed(2)} km",
              style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // hundreds
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 50,
                    itemHeight: 70,
                    itemWidth: 65,
                    value: Hundreds,
                    onChanged: (value) {
                      setState(() {
                        Hundreds = value;
                      });
                    },
                  ),
                  Text(
                    ".",
                    style: TextStyle(fontSize: 30),
                  ),
                  //Dozen  العشرات
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemHeight: 70,
                    itemWidth: 70,
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
                    itemWidth: 55,
                    itemHeight: 70,
                    value: Onse,
                    onChanged: (value) {
                      setState(() {
                        Onse = value;
                      });
                    },
                  ),
                  //هادا المتغير خاص بالاف   tousend

                  Text("كم")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
