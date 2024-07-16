import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/DetailsFood.dart';
import 'package:formafit/screen/MultiSelectCalender.dart';
import 'package:numberpicker/numberpicker.dart';

class Mealsdeatils extends StatefulWidget {
  final Meal meal;
  final DateTime SelectDay;

  const Mealsdeatils({Key? key, required this.meal, required this.SelectDay})
      : super(key: key);

  @override
  State<Mealsdeatils> createState() => _MealsdeatilsState();
}

class _MealsdeatilsState extends State<Mealsdeatils> {
  late Future<List<DocumentSnapshot>> _mealsFuture;
  List<int> selectindex = [];
  List<Foods> _foodsList = []; // قائمة الطعام
  double TotalKal = 0;
  double TotalProtein = 0;
  double TotalCarbohydrates = 0;
  double TotalFats = 0;
  double TotalGram = 0;

  @override
  void initState() {
    super.initState();
    print(widget.SelectDay);
    _mealsFuture = _fetchMealsData();
  }

  final List<String> FoodName = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        backgroundColor: Color.fromARGB(255, 236, 169, 12),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            constraints: BoxConstraints(
                minHeight: 0.0,
                minWidth: 0.0,
                maxHeight: double.infinity,
                maxWidth: double.infinity),
            onSelected: (String value) {
              // تصرف بناءً على القيمة المختارة
              if (value == 'نسخ الوجبة') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Multiselectcalender(
                              meal: widget.meal,
                              foodlist: convertFoodsListToMapList(_foodsList),
                            )));
              }
              if (value == 'حدف الكل ') {
                deleteAllFoods();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'نسخ الوجبة',
                child: Text('نسخ الوجبة'),
              ),
              PopupMenuItem<String>(
                value: 'حدف الكل ',
                child: Text('حدف الكل '),
              ),
            ],
            icon: Icon(
              Icons.density_small_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 190,
              width: double.infinity,
              color: Color.fromRGBO(255, 255, 255, 0.788),
              child: Stack(
                children: [
                  Positioned(
                    left: 2,
                    bottom: 10,
                    top: 10,
                    child: Container(
                      width: 195,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //////////////////////////////////////////////////
                          ListTile(
                            title: Text(
                              "الكربوهيدرات",
                              style: TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                            leading: Icon(Icons.square, color: Colors.green),
                          ),
                          //////////////////////////////////////////////////////
                          ListTile(
                            title: Text("الدهون",
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic)),
                            leading: Icon(Icons.square, color: Colors.orange),
                          ),
        ////////////////////////////////////////////////////////////////////
                          ListTile(
                            title: Text("البروتين",
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic)),
                            leading: Icon(
                              Icons.square,
                              color: Colors.red,
                            ),
                          ),
        //////////////////////////////////////////////////////////////////
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 5,
                    child: Container(
                      width: 190,
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.red,
                              value: TotalProtein,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Color.fromARGB(208, 255, 82, 82)
                                ],
                              ), // تعيين التدريج اللوني
                              title: '${TotalProtein.toStringAsFixed(2)} g ',
                              titleStyle: TextStyle(
                                  fontStyle:
                                      FontStyle.italic), // تعيين النص بشكل مائل
                            ),
                            PieChartSectionData(
                              color: Colors.green,
                              value: TotalCarbohydrates,
                              titlePositionPercentageOffset: 0.38,
                              gradient: LinearGradient(
                                colors: [Colors.green, Colors.lightGreen],
                              ), // تعيين التدريج اللوني
                              title:
                                  '${TotalCarbohydrates.toStringAsFixed(2)} g ',
                              titleStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                              ), // تعيين النص بشكل مائل
                            ),
                            PieChartSectionData(
                              color: Colors.orange,
                              value: TotalFats,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange,
                                  const Color.fromARGB(181, 255, 153, 0),
                                ],
                              ), // تعيين التدريج اللوني
                              title: '${TotalFats.toStringAsFixed(2)} g ',
                              titleStyle: TextStyle(
                                  fontStyle:
                                      FontStyle.italic), // تعيين النص بشكل مائل
                            ),
                          ],
                          sectionsSpace: 3,
                          centerSpaceRadius: 45,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 4,
              height: 25,
              indent: 15,
              endIndent: 15,
              color: Color.fromARGB(255, 167, 176, 179),
            ),
            Container(
              color: Color.fromARGB(149, 255, 255, 255),
              width: double.infinity,
              height: 65,
              child: Stack(children: [
                Positioned(
                  right: 30,
                  top: 5,
                  child: Text(
                    "اجمالي عدد السعرات الحرارية ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Positioned(
                  right: 35,
                  top: 40,
                  child: Text(
                    "${TotalKal.toStringAsFixed(1)} Cal",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 5,
                  child: Text(
                    "وزن الوجبة الكلي",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 25,
                  child: Text(
                    "${TotalGram.toStringAsFixed(1)} g",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ]),
            ),
            Divider(
              thickness: 4,
              height: 25,
              indent: 15,
              endIndent: 15,
              color: Color.fromARGB(255, 167, 176, 179),
            ),
            Container(
              height: 380,
              width: double.infinity,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _mealsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemExtent: 80,
                      itemCount: _foodsList.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectindex.contains(index);
                        final food = _foodsList[index];
        
                        return Column(
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  if (FoodisFirstTap) {
                                    FoodisFirstTap = false;
                                    if (isSelected) {
                                      FoodName.remove(food.name);
                                      selectindex.remove(index);
                                      selectedFoods_to_list.remove(food);
                                    } else {
                                      FoodName.add(food.name);
                                      selectindex.add(index);
                                      selectedFoods_to_list.add(food);
                                    }
                                  }
                                });
                              },
                              child: Container(
                                color: selectindex.contains(index)
                                    ? Color.fromARGB(26, 0, 106, 255)
                                    : Color.fromARGB(255, 255, 255, 255),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                      motion: StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          autoClose: true,
                                          spacing: 1,
                                          padding:
                                              EdgeInsets.fromLTRB(1, 5, 1, 5),
                                          borderRadius: BorderRadius.circular(15),
                                          label: 'حدف',
                                          icon: Icons.remove,
        
                                          backgroundColor: Colors.red,
                                          // مزال لين تخدم البروفايد لان تبي تمرير المتغير الى داله من صفحة الى اخرى
                                          onPressed: (context) async {
                                            print(FoodName);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("تأكيد الحذف"),
                                                  content: Text(
                                                      "هل أنت متأكد أنك تريد حذف العناصر؟"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("إلغاء"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        {
                                                          FoodName.add(food.name);
                                                          // إعداد الخريطة لاستدعاء دالة الحذف
                                                          Map<String,
                                                                  List<String>>
                                                              mealsToDelete = {
                                                            widget.meal.MealName:
                                                                FoodName
                                                          };
                                                          await deleteFoods(
                                                              mealsToDelete);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  "تم حذف العناصر بنجاح"),
                                                            ),
                                                          );
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          FoodName.clear();
                                                          selectedFoods_to_list
                                                              .clear();
                                                          FoodisFirstTap = true;
                                                          selectindex.clear();
                                                        });
                                                      },
                                                      child: Text("تأكيد"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        SlidableAction(
                                          flex: 1,
                                          autoClose: true,
                                          spacing: 1,
                                          padding:
                                              EdgeInsets.fromLTRB(1, 5, 1, 5),
                                          borderRadius: BorderRadius.circular(15),
                                          label:
                                              !food.FoodState ? 'انجاز' : 'الغاء',
                                          icon: !food.FoodState
                                              ? Icons.done
                                              : Icons.done_all,
        
                                          backgroundColor: !food.FoodState
                                              ? Color.fromARGB(255, 9, 176, 64)
                                              : Colors.red,
                                          // مزال لين تخدم البروفايد لان تبي تمرير المتغير الى داله من صفحة الى اخرى
                                          onPressed: (context) async {
                                            await updateFoodState(
                                              food.name,
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ]),
                                  child: ListTile(
                                    trailing: !food.FoodState
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (FoodisFirstTap)
                                                IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      context: context,
                                                      builder: (context) {
                                                        return numberpicker(
                                                          updatefood: (newGram) {
                                                            updateFoodGram(
                                                                widget.meal
                                                                    .MealName,
                                                                food.name,
                                                                newGram);
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons.edit),
                                                ),
                                              SizedBox(width: 8),
                                              if (!FoodisFirstTap)
                                                Icon(
                                                  selectindex.contains(index)
                                                      ? Icons.check_circle
                                                      : Icons
                                                          .radio_button_unchecked,
                                                  color: Colors.red,
                                                  size: 30,
                                                )
                                            ],
                                          )
                                        : Text(
                                            'completed',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic),
                                          ),
                                    title: Text(food.name),
                                    subtitle: Text(
                                        ' ${food.Kal.toStringAsFixed(2)} Cal /${food.gram.toStringAsFixed(2)} g'),
                                    onTap: () {
                                      setState(() {
                                        if (!FoodisFirstTap) {
                                          print("onTap");
                                          if (isSelected) {
                                            FoodName.remove(food.name);
                                            selectindex.remove(index);
                                            selectedFoods_to_list.remove(food);
                                          } else {
                                            FoodName.add(food.name);
                                            selectindex.add(index);
                                            selectedFoods_to_list.add(food);
                                          }
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalsFoodScreen(
                                                      Copyfood: food),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            if (!FoodisFirstTap)
              Container(
                color: Color.fromARGB(207, 142, 143, 155),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectindex.clear();
                          FoodisFirstTap = true;
                          selectedFoods_to_list.clear();
                          FoodName.clear();
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 33,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 43,
                    ),
                    Text(
                      " تم تحديد ${selectedFoods_to_list.length} من العناصر",
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            selectindex = List.generate(
                                _foodsList.length, (index) => index);
                            selectedFoods_to_list = List.from(_foodsList);
                            for (var food in selectedFoods_to_list) {
                              var name = food.name;
                              FoodName.add(name);
                            }
                          });
                        },
                        icon: Icon(Icons.playlist_add_check, size: 35)),
                    SizedBox(width: 43),
                    TextButton(
                      onPressed: () async {
                        print(FoodName);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("تأكيد الحذف"),
                              content: Text("هل أنت متأكد أنك تريد حذف العناصر؟"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    {
                                      // إعداد الخريطة لاستدعاء دالة الحذف
                                      Map<String, List<String>> mealsToDelete = {
                                        widget.meal.MealName: FoodName
                                      };
                                      await deleteFoods(mealsToDelete);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("تم حذف العناصر بنجاح"),
                                        ),
                                      );
                                    }
                                    Navigator.of(context).pop();
                                    setState(() {
                                      FoodName.clear();
                                      selectedFoods_to_list.clear();
                                      FoodisFirstTap = true;
                                      selectindex.clear();
                                    });
                                  },
                                  child: Text("تأكيد"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // داله حدف الاطعمه بناء على قاءمه من الاسماء اللتي تم تحديدها
Future<void> deleteFoods(Map<String, List<String>> mealsToDelete) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      for (String mealName in mealsToDelete.keys) {
        List<String> selectedFoods = mealsToDelete[mealName]!;

        final collectionRef = FirebaseFirestore.instance
            .collection('meals')
            .where('userid', isEqualTo: user.uid)
            .where("Daydate", isEqualTo: widget.SelectDay.toUtc())
            .where("MealName", isEqualTo: mealName);

        final querySnapshot = await collectionRef.get();

        for (var mealDoc in querySnapshot.docs) {
          final mealId = mealDoc.id;
          final foodsQuerySnapshot = await FirebaseFirestore.instance
              .collection('meals')
              .doc(mealId)
              .collection("foods")
              .get();

          double totalCaloriesToRemove = 0;

          for (var foodDoc in foodsQuerySnapshot.docs) {
            String foodName = foodDoc['name'].toString();
            if (selectedFoods.contains(foodName)) {
              final foodData = foodDoc.data() as Map<String, dynamic>;
              double foodCalories = foodData['Kal'] ?? 0;
              totalCaloriesToRemove += foodCalories;
              await foodDoc.reference.delete();
            }
          }

          // تحديث mealkal في مستند الوجبة
          if (totalCaloriesToRemove > 0) {
            final mealData = mealDoc.data() as Map<String, dynamic>;
            double currentMealKal = mealData['Mealkal'] ?? 0;
            double updatedMealKal = currentMealKal - totalCaloriesToRemove;

            await mealDoc.reference.update({'Mealkal': updatedMealKal});
          }
        }
      }

      _mealsFuture = _fetchMealsData();
      setState(() {});
    } catch (e) {
      print("Error deleting foods: $e");
    }
  } else {
    print("No user logged in");
  }
}

Future<void> deleteAllFoods() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('meals')
          .where('userid', isEqualTo: user.uid)
          .where("Daydate", isEqualTo: widget.SelectDay.toUtc())
          .where("MealName", isEqualTo: widget.meal.MealName);

      final querySnapshot = await collectionRef.get();

      for (var mealDoc in querySnapshot.docs) {
        final mealId = mealDoc.id;
        final foodsQuerySnapshot = await FirebaseFirestore.instance
            .collection('meals')
            .doc(mealId)
            .collection("foods")
            .get();

        for (var foodDoc in foodsQuerySnapshot.docs) {
          await foodDoc.reference.delete();
        }

        // تعيين قيمة mealkal إلى صفر
        await mealDoc.reference.update({'MealKal': 0});

        // حذف مستند الوجبة الرئيسي بعد تحديث mealkal
        await mealDoc.reference.delete();
      }

      _mealsFuture = _fetchMealsData();
      setState(() {});
    } catch (e) {
      print("Error deleting foods: $e");
    }
  } else {
    print("No user logged in");
  }
}
// داله تحديت وزن الوجبة
  Future<void> updateFoodGram(
      String mealId, String foodName, double newGram) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('meals')
            .where('userid', isEqualTo: user.uid)
            .where("Daydate", isEqualTo: widget.SelectDay.toUtc())
            .where("MealName", isEqualTo: widget.meal.MealName)
            .get();

        for (var mealDoc in querySnapshot.docs) {
          final foodsQuerySnapshot = await FirebaseFirestore.instance
              .collection('meals')
              .doc(mealDoc.id)
              .collection("foods")
              .where("name", isEqualTo: foodName)
              .get();
      
          for (var foodDoc in foodsQuerySnapshot.docs) {
            final foodData = foodDoc.data() as Map<String, dynamic>;
            final oldGram = foodData['gram'] ?? 0;
            if (oldGram == 0) continue;

            final ratio = newGram / oldGram;

            double formatValue(double value) {
              return double.parse(value.toStringAsFixed(2));
            }

          final  oldMealCalories = foodData['Kal'] ?? 0;
          final  newMealCalories = formatValue(oldMealCalories * ratio);
            final newCalories = formatValue((foodData['Kal'] ?? 0) * ratio);
            final newProtein = formatValue((foodData['Protein'] ?? 0) * ratio);
            final newCarbohydrates =
                formatValue((foodData['Carbohydrates'] ?? 0) * ratio);
            final newFats = formatValue((foodData['Fats'] ?? 0) * ratio);
            final newSaturatedFat =
                formatValue((foodData['SaturatedFat'] ?? 0) * ratio);
            final newUnSaturatedFat =
                formatValue((foodData['UnSaturatedFat'] ?? 0) * ratio);
            final newA = formatValue((foodData['A'] ?? 0) * ratio);
            final newB12 = formatValue((foodData['B12'] ?? 0) * ratio);
            final newB6 = formatValue((foodData['B6'] ?? 0) * ratio);
            final newB2 = formatValue((foodData['B2'] ?? 0) * ratio);
            final newC = formatValue((foodData['C'] ?? 0) * ratio);
            final newD = formatValue((foodData['D'] ?? 0) * ratio);
            final newFe = formatValue((foodData['Fe'] ?? 0) * ratio);
            final newK = formatValue((foodData['K'] ?? 0) * ratio);
            final newCa = formatValue((foodData['Ca'] ?? 0) * ratio);
            final newMg = formatValue((foodData['Mg'] ?? 0) * ratio);
            final newKolistol =
                formatValue((foodData['Kolistol'] ?? 0) * ratio);
            final newP = formatValue((foodData['p'] ?? 0) * ratio);

            await foodDoc.reference.update({
              'gram': newGram,
              'Kal': newCalories,
              'Protein': newProtein,
              'Carbohydrates': newCarbohydrates,
              'Fats': newFats,
              'SaturatedFat': newSaturatedFat,
              'UnSaturatedFat': newUnSaturatedFat,
              'A': newA,
              'B12': newB12,
              'B6': newB6,
              'B2': newB2,
              'C': newC,
              'D': newD,
              'Fe': newFe,
              'K': newK,
              'Ca': newCa,
              'Mg': newMg,
              'Kolistol': newKolistol,
              'p': newP,
            });
            if (oldMealCalories > 0 && newMealCalories > 0) {
              final mealData = mealDoc.data() as Map<String, dynamic>;
              double currentMealKal = mealData['MealKal'] ?? 0;
              double updatedMealKal =
                  currentMealKal - oldMealCalories + newMealCalories;

              await mealDoc.reference.update({'MealKal': updatedMealKal});
            }
          }
        }
        _mealsFuture = _fetchMealsData();
        setState(() {});
      } catch (e) {
        print("Error updating food: $e");
      }
    } else {
      print("No user logged in");
    }
  }

// داله جلب البيانات الاطعمه الموجودة في الوجبة
  Future<List<DocumentSnapshot>> _fetchMealsData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('userid', isEqualTo: user.uid)
          .where("Daydate", isEqualTo: widget.SelectDay.toUtc())
          .where("MealName", isEqualTo: widget.meal.MealName)
          .get();

      List<Foods> foodsList = [];

      for (var mealDoc in querySnapshot.docs) {
        final foodsQuerySnapshot = await FirebaseFirestore.instance
            .collection('meals')
            .doc(mealDoc.id)
            .collection("foods")
            .get();

        for (var foodDoc in foodsQuerySnapshot.docs) {
          final foodData = foodDoc.data() as Map<String, dynamic>;
          foodsList.add(Foods(
              name: foodData['name'] ?? "",
              Kal: foodData['Kal'] ?? 0,
              gram: foodData['gram'] ?? 0,
              Protein: foodData['Protein'] ?? 0,
              Carbohydrates: foodData['Carbohydrates'] ?? 0,
              Fats: foodData['Fats'] ?? 0,
              SaturatedFat: foodData['SaturatedFat'] ?? 0,
              UnSaturatedFat: foodData['UnSaturatedFat'] ?? 0,
              A: foodData['A'] ?? 0,
              B12: foodData['B12'] ?? 0,
              B6: foodData['B6'] ?? 0,
              B2: foodData['B2'] ?? 0,
              C: foodData['C'] ?? 0,
              D: foodData['D'] ?? 0,
              Fe: foodData['Fe'] ?? 0,
              K: foodData['K'] ?? 0,
              Ca: foodData['Ca'] ?? 0,
              Mg: foodData['Mg'] ?? 0,
              Kolistol: foodData['Kolistol'] ?? 0,
              p: foodData['p'] ?? 0,
              FoodState: foodData['FoodState'] ?? false
              // تعيين FoodState بناءً على البيانات
              ));
        }
      }

      setState(() {
        _foodsList = _foodsList = foodsList;
        TotalKal = _foodsList.fold(0, (sum, food) => sum + food.Kal);
        TotalProtein = _foodsList.fold(0, (sum, food) => sum + food.Protein);
        TotalCarbohydrates =
            _foodsList.fold(0, (sum, food) => sum + food.Carbohydrates);
        TotalFats = _foodsList.fold(0, (sum, food) => sum + food.Fats);
        TotalGram = _foodsList.fold(0, (sum, food) => sum + food.gram);
      });

      return querySnapshot.docs;
    } else {
      print("No user logged in");
      return [];
    }
  }

//داله تستخدم لتعديل حاله الوجبة هل تم انجازها ام لا
Future<void> updateFoodState(String foodName) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('userid', isEqualTo: user.uid)
          .where("Daydate", isEqualTo: widget.SelectDay.toUtc())
          .where("MealName", isEqualTo: widget.meal.MealName)
          .get();

      for (var mealDoc in querySnapshot.docs) {
        final mealId = mealDoc.id;
        final foodsQuerySnapshot = await FirebaseFirestore.instance
            .collection('meals')
            .doc(mealId)
            .collection("foods")
            .where("name", isEqualTo: foodName)
            .get();

        for (var foodDoc in foodsQuerySnapshot.docs) {
          bool currentFoodState =
              foodDoc['FoodState'] ?? false; // الحالة الحالية للطعام
          bool newFoodState =
              !currentFoodState; // تغيير القيمة إلى القيمة المعاكسة

          double foodCalories = foodDoc['Kal'] ?? 0.0; // قيمة الكالوري للطعام

          // تحديث حالة الطعام
          await foodDoc.reference.update({'FoodState': newFoodState});

          // تحديث قيمة CompletKal في مستند الوجبة
          double currentCompletKal = mealDoc['CompletKal'] ?? 0.0;
          double newCompletKal = currentCompletKal;

          if (newFoodState) {
            newCompletKal += foodCalories; // إضافة الكالوري إذا تم إنجاز الطعام
          } else {
            newCompletKal -= foodCalories; // طرح الكالوري إذا لم يتم إنجاز الطعام
          }

          await mealDoc.reference.update({'CompletKal': newCompletKal});
        }
      }
      _mealsFuture = _fetchMealsData();
      setState(() {});
    } catch (e) {
      print("Error updating food: $e");
    }
  } else {
    print("No user logged in");
  }
}

}

class numberpicker extends StatefulWidget {
  final Function(double) updatefood;

  const numberpicker({
    required this.updatefood,
  });

  @override
  State<numberpicker> createState() => _numberpickerState();
}

var Right_currentValue = 0;
var left_currentValue = 0;
var center_currentValue = 0;

class _numberpickerState extends State<numberpicker> {
  @override
  Widget build(BuildContext context) {
    double TotalEditGram = (left_currentValue * 100) +
        (center_currentValue * 10) +
        Right_currentValue.toDouble();
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل وزن الوجبة'),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.updatefood(TotalEditGram);
              Navigator.of(context).pop();
            },
            child: Text("Update"),
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
              '${TotalEditGram}  g ',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemHeight: 70,
                    itemWidth: 100,
                    value: left_currentValue,
                    onChanged: (value) {
                      setState(() {
                        left_currentValue = value;
                      });
                    },
                  ),
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemHeight: 70,
                    itemWidth: 100,
                    value: center_currentValue,
                    onChanged: (value) {
                      setState(() {
                        center_currentValue = value;
                      });
                    },
                  ),
                  NumberPicker(
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 9,
                    itemWidth: 100,
                    itemHeight: 70,
                    value: Right_currentValue,
                    onChanged: (value) {
                      setState(() {
                        Right_currentValue = value;
                      });
                    },
                  ),
                  Text("غرام")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
