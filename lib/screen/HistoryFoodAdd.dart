import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/DetailsFood.dart';
import 'package:numberpicker/numberpicker.dart';

class Historyfoodadd extends StatefulWidget {
  final Meal meal;
  final DateTime SelectDay;
  const Historyfoodadd(
      {super.key, required this.meal, required this.SelectDay});

  @override
  State<Historyfoodadd> createState() => _HistoryfoodaddState();
}

class _HistoryfoodaddState extends State<Historyfoodadd> {
  late Future<List<DocumentSnapshot>> _mealsFuture;
  List<Foods> _foodsList = []; // قائمة الطعام
  List<int> selectindex = [];

  @override
  void initState() {
    super.initState();
    print(widget.SelectDay);
    _mealsFuture = _fetchMealsData();
  }

  @override
  final List<String> FoodName = [];
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 585,
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      itemCount: _foodsList.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectindex.contains(index);
                        final food = _foodsList[index];
                        return GestureDetector(
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
                                : Color.fromARGB(255, 255, 251, 251),
                            child: Slidable(
                              endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 1,
                                      autoClose: true,
                                      spacing: 1,
                                      padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
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
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("إلغاء"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    {
                                                      FoodName.add(food.name);
                                                      // إعداد الخريطة لاستدعاء دالة الحذف
                                                      Map<String, List<String>>
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
                                                              "تم حذف العنصر بنجاح"),
                                                        ),
                                                      );
                                                    }
                                                    Navigator.of(context).pop();
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
                                      padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                                      borderRadius: BorderRadius.circular(15),
                                      label: 'اضافة',
                                      icon: !food.FoodState
                                          ? Icons.done
                                          : Icons.done_all,
                                      backgroundColor:
                                          Color.fromARGB(255, 9, 176, 64),
                                    
                onPressed: (context) async {
                  print(FoodName);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("اضافة عناصر"),
                        content: Text("هل أنت متأكد أنك تريد اضافة العناصر؟"),
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
                                selectedFoods_to_list.add(food);
                                Meal newMeal = Meal(
                                  MealName: 'New Meal',
                                  Daydate: DateTime.now(),
                                  MealTime: DateTime.now(),
                                  MealKal: selectedFoods_to_list.fold(
                                      0.0, (sum, item) => sum + item.Kal),
                                  CompletKal: 0.0,
                                  isfindfood: true,
                                );
                                // إعداد الخريطة لاستدعاء دالة الحذف
                                await addMealWithFoods(newMeal);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("تم اضافة العناصر بنجاح"),
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
                ),
                                  ]),
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (FoodisFirstTap)
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return numberpicker(
                                                updatefood: (newGram) {
                                                  updateFoodGram(
                                                      widget.meal.MealName,
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
                                            : Icons.radio_button_unchecked,
                                        color: Colors.red,
                                        size: 30,
                                      )
                                  ],
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
                                              DetalsFoodScreen(Copyfood: food),
                                        ),
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            if (!FoodisFirstTap)
              ElevatedButton(
                onPressed: () async {
                  print(FoodName);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("اضافة عناصر"),
                        content: Text("هل أنت متأكد أنك تريد اضافة العناصر؟"),
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
                                Meal newMeal = Meal(
                                  MealName: 'New Meal',
                                  Daydate: DateTime.now(),
                                  MealTime: DateTime.now(),
                                  MealKal: selectedFoods_to_list.fold(
                                      0.0, (sum, item) => sum + item.Kal),
                                  CompletKal: 0.0,
                                  isfindfood: true,
                                );
                                // إعداد الخريطة لاستدعاء دالة الحذف
                                await addMealWithFoods(newMeal);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("تم اضافة العناصر بنجاح"),
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
                child: Text("Add foods"),
              ),
            SizedBox(
              height: 5,
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
                        size: 35,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 40,
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
                    SizedBox(width: 40),
                    TextButton(
                      onPressed: () async {
                        print(FoodName);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("تأكيد الحذف"),
                              content:
                                  Text("هل أنت متأكد أنك تريد حذف العناصر؟"),
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
                                      Map<String, List<String>> mealsToDelete =
                                          {widget.meal.MealName: FoodName};
                                      await deleteFoods(mealsToDelete);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                        size: 35,
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

  Future<List<DocumentSnapshot>> _fetchMealsData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userfood')
          .where('userid', isEqualTo: user.uid)
          .get();

      List<Foods> foodsList = [];

      for (var mealDoc in querySnapshot.docs) {
        final foodsQuerySnapshot = await FirebaseFirestore.instance
            .collection('userfood')
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
              FoodState: foodData['FoodState'] ?? false));
        }
      }

      setState(() {
        _foodsList = _foodsList = foodsList;
      });

      return querySnapshot.docs;
    } else {
      print("No user logged in");
      return [];
    }
  }

  Future<void> updateFoodGram(
      String mealId, String foodName, double newGram) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('userfood').get();

        for (var mealDoc in querySnapshot.docs) {
          final foodsQuerySnapshot = await FirebaseFirestore.instance
              .collection('userfood')
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

  Future<void> deleteAllFoods() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final collectionRef = FirebaseFirestore.instance
            .collection('userfood')
            .where('userid', isEqualTo: user.uid);
        final querySnapshot = await collectionRef.get();

        for (var mealDoc in querySnapshot.docs) {
          final mealId = mealDoc.id;
          final foodsQuerySnapshot = await FirebaseFirestore.instance
              .collection('userfood')
              .doc(mealId)
              .collection("foods")
              .get();

          for (var foodDoc in foodsQuerySnapshot.docs) {
            await foodDoc.reference.delete();
          }
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

  Future<void> deleteFoods(Map<String, List<String>> mealsToDelete) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        for (String mealName in mealsToDelete.keys) {
          List<String> selectedFoods = mealsToDelete[mealName]!;

          final collectionRef = FirebaseFirestore.instance
              .collection('userfood')
              .where('userid', isEqualTo: user.uid);

          final querySnapshot = await collectionRef.get();

          for (var mealDoc in querySnapshot.docs) {
            final mealId = mealDoc.id;
            final foodsQuerySnapshot = await FirebaseFirestore.instance
                .collection('userfood')
                .doc(mealId)
                .collection("foods")
                .get();

            for (var foodDoc in foodsQuerySnapshot.docs) {
              String foodName = foodDoc['name'].toString();
              if (selectedFoods.contains(foodName)) {
                await foodDoc.reference.delete();
              }
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

  Future<void> addMealWithFoods(Meal meal) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // احصل على مرجع لمجموعة الوثائق meals
        final mealsCollection = _db.collection('meals');

        // احصل على وثيقة تطابق المستند
        final existingDocument = await mealsCollection
            .where('userid', isEqualTo: user.uid)
            .where('Daydate', isEqualTo: widget.SelectDay.toUtc())
            .where('MealName', isEqualTo: widget.meal.MealName)
            .limit(1)
            .get();

        // إذا كان المستند موجودًا، قم بتحديثه
        if (existingDocument.docs.isNotEmpty) {
          final mealId = existingDocument.docs.first.id;
          await mealsCollection.doc(mealId).update({
            'MealKal': meal.MealKal,
            'CompletKal': meal.CompletKal,
            'isfindfood': meal.isfindfood,
            'MealTime': widget.meal.MealTime.toIso8601String(),
          });

          // تحديث الأطعمة أيضًا
          for (Foods food in selectedFoods_to_list) {
            await mealsCollection.doc(mealId).collection('foods').add({
              'name': food.name,
              'Kal': food.Kal,
              'gram': food.gram,
              'Protein': food.Protein,
              'Carbohydrates': food.Carbohydrates,
              'Fats': food.Fats,
              'SaturatedFat': food.SaturatedFat,
              'UnSaturatedFat': food.UnSaturatedFat,
              'A': food.A,
              'B12': food.B12,
              'B6': food.B6,
              'B2': food.B2,
              'C': food.C,
              'D': food.D,
              'Fe': food.Fe,
              'K': food.K,
              'Ca': food.Ca,
              'Mg': food.Mg,
              'Kolistol': food.Kolistol,
              'p': food.p,
              'FoodState': food.FoodState
            });
          }
        } else {
          // إذا كان المستند غير موجود، قم بإنشاء وثيقة جديدة
          DocumentReference mealRef = await mealsCollection.add({
            'userid': user.uid,
            'MealName': widget.meal.MealName,
            'Daydate': widget.SelectDay.toUtc(),
            'MealTime': widget.meal.MealTime.toIso8601String(),
            'MealKal': meal.MealKal,
            'CompletKal': meal.CompletKal,
            'isfindfood': meal.isfindfood,
          });

          // إضافة الأطعمة كتحصيل فرعي
          for (Foods food in selectedFoods_to_list) {
            await mealRef.collection('foods').add({
              'name': food.name,
              'Kal': food.Kal,
              'gram': food.gram,
              'Protein': food.Protein,
              'Carbohydrates': food.Carbohydrates,
              'Fats': food.Fats,
              'SaturatedFat': food.SaturatedFat,
              'UnSaturatedFat': food.UnSaturatedFat,
              'A': food.A,
              'B12': food.B12,
              'B6': food.B6,
              'B2': food.B2,
              'C': food.C,
              'D': food.D,
              'Fe': food.Fe,
              'K': food.K,
              'Ca': food.Ca,
              'Mg': food.Mg,
              'Kolistol': food.Kolistol,
              'p': food.p,
              'FoodState': food.FoodState
            });
          }
        }
      } catch (e) {
        print("Error adding meal with foods: $e");
      }
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
