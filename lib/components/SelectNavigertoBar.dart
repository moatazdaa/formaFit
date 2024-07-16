import 'package:flutter/material.dart';
import 'package:formafit/classes/exsrsise.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/DayDetailsScreen.dart';
import 'package:formafit/screen/plan.dart';


class selectnavigetorbar extends StatefulWidget {
  final List<int> selectindex;
  const selectnavigetorbar({super.key, required this.selectindex});


  @override
  State<selectnavigetorbar> createState() => _selectnavigetorbarState();
  
}


class _selectnavigetorbarState extends State<selectnavigetorbar> {

  void resetIsFirstTap() {
isFirstTap = true;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(116, 255, 193, 7),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
            
                setState(() {
                      widget.selectindex.clear();
                  resetIsFirstTap();
                  Clear_selectedexsrsis_to_list();
         
                });
                    
                
              },
              icon: Icon(
                Icons.close,
                size: 33,
                color: Colors.red,
              )),
          SizedBox(

            width: 55,
          ),
          Text(
            " تم تحديد ${selectedexsrsis_to_list.length} من العناصر",
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.menu, size: 30),
          SizedBox(width: 40),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlanScreen()),
              ); // إجراء عند الضغط على الزر
            },
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: Colors.green,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
