import 'package:flutter/material.dart';
import 'package:formafit/classes/AddNewFood.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/screen/Food.dart';


class MainfoodsScreen extends StatefulWidget {
  final Meal meal;
  final DateTime SelectDay;
  const MainfoodsScreen(
      {Key? key, required this.meal, required this.SelectDay});

  @override
  State<MainfoodsScreen> createState() => _foodsScreenState();
}

class _foodsScreenState extends State<MainfoodsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(212, 148, 142, 125),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text("قائمة الاطعمه",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewFoodTap(selectedDay: widget.SelectDay,meal: widget.meal,)));
              },
              child: Text(
                "اضافة يدويا",
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 255, 255, 255)),
              )),
      Icon(Icons.settings)
        ],
      ),
      body: Column(
      
        children: [
        
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                itemCount: mainfoods.length,
                itemBuilder: (context, index) {
                  return Card(
        
                  
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Foodscreen(
                                    CopyMainfood: mainfoods[index],
                                    selectindex: [],
                                    meal: widget.meal,
                                    SelectDay: widget.SelectDay,
                                  )),
                        );
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            mainfoods[index]
                                .image, // استبدال الرابط برابط الصورة الفعلي
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180, // ارتفاع الصورة الخلفية
                          ),
                          Positioned(
                            bottom: 10,
                            right: 15,
                            child: Text(
                              mainfoods[index].name,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
      
                            ),
                          )
                        ],
                      ),
                    ),
                    
                  );
                  
                }
                ),
          )
        
        ],
      ),
    );
  }
}
