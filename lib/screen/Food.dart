import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/DetailsFood.dart';


class Foodscreen extends StatefulWidget {
  final MainFoods CopyMainfood;
  final List<int> selectindex;
  final Meal meal;
  final DateTime SelectDay;
  const Foodscreen({
    Key? key,
    required this.CopyMainfood,
    required this.selectindex,
    required this.meal,
    required this.SelectDay,
  });

  @override
  State<Foodscreen> createState() => _FoodscreenState();
}

class _FoodscreenState extends State<Foodscreen> {
  String searchText = '';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String userId = ''; // تعريف متغير لتخزين معرف المستخدم

  @override
  void initState() {
    super.initState();
    getUserIdAfterLogin();
  }

  void getUserIdAfterLogin() {
    // استرجاع معرف المستخدم بعد تسجيل الدخول
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> addMealWithFoods(Meal meal) async {
    try {
      // احصل على مرجع لمجموعة الوثائق meals
      final mealsCollection = _db.collection('meals');

      // احصل على وثيقة تطابق المستند
      final existingDocument = await mealsCollection
          .where('userid', isEqualTo: userId)
          .where('Daydate', isEqualTo: widget.SelectDay.toUtc())
          .where('MealName', isEqualTo: widget.meal.MealName)
          .limit(1)
          .get();

      // إذا كان المستند موجودًا، قم بتحديثه
      if (existingDocument.docs.isNotEmpty) {
        final mealId = existingDocument.docs.first.id;
        await mealsCollection.doc(mealId).update({
          'MealKal': meal.MealKal,
          'isfindfood': meal.isfindfood,
          'CompletKal':meal.CompletKal,
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
            'FoodState':food.FoodState
          });
        }
      } else {
        // إذا كان المستند غير موجود، قم بإنشاء وثيقة جديدة
        DocumentReference mealRef = await mealsCollection.add({
          'userid': userId,
          'MealName': widget.meal.MealName,
          'Daydate': widget.SelectDay.toUtc(),
          'MealTime': widget.meal.MealTime.toIso8601String(),
          'MealKal': meal.MealKal,
          'CompletKal':meal. CompletKal,
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
            'FoodState':food.FoodState
          });
        }
      }
    } catch (e) {
      print("Error adding meal with foods: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // تصفية القائمة بناءً على النص المدخل في مربع البحث
    List<Foods> filteredFoods = widget.CopyMainfood.FoodsTolist.where((food) {
      return food.name.contains(searchText);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_outlined),
        ),
      ),
      body: Column(
        children: [
          if (!FoodisFirstTap)
            Container(
              color: Color.fromARGB(207, 142, 143, 155),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          widget.selectindex.clear();
                          FoodisFirstTap = true;
                          selectedFoods_to_list.clear();
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
                    " تم تحديد ${selectedFoods_to_list.length} من العناصر",
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.playlist_add_check, size: 20),
                  SizedBox(width: 55),
                  TextButton(
                    onPressed: () async {
                      Meal newMeal = Meal(
                        MealName: 'New Meal',
                        Daydate: DateTime.now(),
                        MealTime: DateTime.now(),
                        MealKal: selectedFoods_to_list.fold(
                            0.0, (sum, item) => sum + item.Kal),
                            CompletKal:0.0,
                        isfindfood: true,
                      );
                      await addMealWithFoods(newMeal);
                      setState(() {
                        widget.selectindex.clear();
                        FoodisFirstTap = true;
                        selectedFoods_to_list.clear();
                            Navigator.of(context).pop();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تمت إضافة الوجبة مع الأطعمة بنجاح!'),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_box,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(22.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث هنا...',
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(width: 1.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                bool isSelected = widget.selectindex
                    .contains(index); // تحقق مما إذا كان العنصر محددًا
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (FoodisFirstTap) {
                        // هذه هي الضغطة الأولى
                        FoodisFirstTap = false;
                        if (isSelected) {
                          widget.selectindex.remove(
                              index); // إزالة العنصر المحدد إذا كان محددًا بالفعل
                          selectedFoods_to_list
                              .remove(widget.CopyMainfood.FoodsTolist[index]);
                        } else {
                          widget.selectindex
                              .add(index); // إضافة العنصر إذا لم يكن محددًا
                          selectedFoods_to_list
                              .add(widget.CopyMainfood.FoodsTolist[index]);
                        }
                      }
                    });
                  },
                  child: Container(
                      color: widget.selectindex.contains(index)
                          ? Color.fromARGB(26, 0, 106, 255)
                          : Color.fromARGB(255, 255, 251, 251),
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filteredFoods[index].name,
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(
                                width:
                                    8), // تغيير الفراغ بين الرمز والنص حسب الحاجة

                            if (!FoodisFirstTap)
                              Icon(
                                widget.selectindex.contains(index)
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: Colors.red,
                                size: 30,
                              )
                          ],
                        ),
                        leading: Text(
                          'سعرات حرارية: ${filteredFoods[index].Kal}',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            if (!FoodisFirstTap) {
                              print("onTap");
                              if (isSelected) {
                                widget.selectindex.remove(index);
                                selectedFoods_to_list.remove(
                                    widget.CopyMainfood.FoodsTolist[index]);
                              } else {
                                widget.selectindex.add(index);
                                selectedFoods_to_list.add(
                                    widget.CopyMainfood.FoodsTolist[index]);
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalsFoodScreen(
                                        Copyfood: filteredFoods[index])),
                              );
                            }
                          });
                        },
                      )),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(height: 10, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
