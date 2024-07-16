import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';
import 'package:formafit/screen/HistoryFoodAdd.dart';

class AddNewFood extends StatefulWidget {
  final DateTime selectedDay;
  final Meal meal;

  const AddNewFood({Key? key, required this.selectedDay, required this.meal})
      : super(key: key);

  @override
  _AddNewFoodState createState() => _AddNewFoodState();
}

class _AddNewFoodState extends State<AddNewFood> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for each field
  final TextEditingController foodNameController= TextEditingController();
  final TextEditingController kalController = TextEditingController();
  final TextEditingController gramController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbohydratesController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController saturatedFatController = TextEditingController();
  final TextEditingController unsaturatedFatController =
      TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController b12Controller = TextEditingController();
  final TextEditingController b6Controller = TextEditingController();
  final TextEditingController cController = TextEditingController();
  final TextEditingController dController = TextEditingController();
  final TextEditingController feController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController mgController = TextEditingController();
  final TextEditingController kolistolController = TextEditingController();
  final TextEditingController pController = TextEditingController();
bool _isFormValid = false;

  void _validateForm() {
    final isValid = foodNameController.text.isNotEmpty &&
        kalController.text.isNotEmpty &&
        gramController.text.isNotEmpty &&
        proteinController.text.isNotEmpty &&
        carbohydratesController.text.isNotEmpty &&
        fatsController.text.isNotEmpty;

    setState(() {
      _isFormValid = isValid;
    });
  }

 @override
  void initState() {
    super.initState();
    foodNameController.addListener(_validateForm);
    kalController.addListener(_validateForm);
    gramController.addListener(_validateForm);
    proteinController.addListener(_validateForm);
    carbohydratesController.addListener(_validateForm);
    fatsController.addListener(_validateForm);
  }

  Future<void> _addFood() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User is logged in with UID: ${user.uid}');

      // إضافة مستند فارغ إذا لم يكن موجودًا
      final querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('userid', isEqualTo: user.uid)
          .where("Daydate", isEqualTo: widget.selectedDay.toUtc())
          .where("MealName", isEqualTo: widget.meal.MealName)
          .get();

      DocumentReference mealDoc;
      if (querySnapshot.docs.isEmpty) {
        print('No matching meal found, creating a new one');
        mealDoc = await FirebaseFirestore.instance.collection('meals').add({
          'userid': user.uid,
          'Daydate': widget.selectedDay.toUtc(),
          'MealName': widget.meal.MealName,
          'MealKal': widget.meal.MealKal,
          'CompletKal':widget.meal.CompletKal,
          'MealTime': widget.meal.MealTime,
        });
      } else {
        mealDoc = querySnapshot.docs.first.reference;
        print('Matching meal found, using existing document');
      }

      await mealDoc.collection('foods').add({
        // 'name': foodNameController.text,
        // 'Kal': double.parse(kalController.text),
        // 'gram': double.parse(gramController.text),
        // 'Protein': double.parse(proteinController.text),
        // 'Carbohydrates': double.parse(carbohydratesController.text),
        // 'Fats': double.parse(fatsController.text),
        // 'SaturatedFat': double.parse(saturatedFatController.text),
        // 'UnSaturatedFat': double.parse(unsaturatedFatController.text),
        // 'A': double.parse(aController.text),
        // 'B12': double.parse(b12Controller.text),
        // 'B6': double.parse(b6Controller.text),
        // 'C': double.parse(cController.text),
        // 'D': double.parse(dController.text),
        // 'Fe': double.parse(feController.text),
        // 'K': double.parse(kController.text),
        // 'Ca': double.parse(caController.text),
        // 'Mg': double.parse(mgController.text),
        // 'Kolistol': double.parse(kolistolController.text),
        // 'p': double.parse(pController.text),
          'name': foodNameController.text,
      'Kal': double.parse(kalController.text.isEmpty ? '0.0' : kalController.text),
      'gram': double.parse(gramController.text.isEmpty ? '0.0' : gramController.text),
      'Protein': double.parse(proteinController.text.isEmpty ? '0.0' : proteinController.text),
      'Carbohydrates': double.parse(carbohydratesController.text.isEmpty ? '0.0' : carbohydratesController.text),
      'Fats': double.parse(fatsController.text.isEmpty ? '0.0' : fatsController.text),
      'SaturatedFat': double.parse(saturatedFatController.text.isEmpty ? '0.0' : saturatedFatController.text),
      'UnSaturatedFat': double.parse(unsaturatedFatController.text.isEmpty ? '0.0' : unsaturatedFatController.text),
      'A': double.parse(aController.text.isEmpty ? '0.0' : aController.text),
      'B12': double.parse(b12Controller.text.isEmpty ? '0.0' : b12Controller.text),
      'B6': double.parse(b6Controller.text.isEmpty ? '0.0' : b6Controller.text),
      'C': double.parse(cController.text.isEmpty ? '0.0' : cController.text),
      'D': double.parse(dController.text.isEmpty ? '0.0' : dController.text),
      'Fe': double.parse(feController.text.isEmpty ? '0.0' : feController.text),
      'K': double.parse(kController.text.isEmpty ? '0.0' : kController.text),
      'Ca': double.parse(caController.text.isEmpty ? '0.0' : caController.text),
      'Mg': double.parse(mgController.text.isEmpty ? '0.0' : mgController.text),
      'Kolistol': double.parse(kolistolController.text.isEmpty ? '0.0' : kolistolController.text),
      'p': double.parse(pController.text.isEmpty ? '0.0' : pController.text),
      });

      print('Food added successfully');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Food added successfully')));
    } else {
      print('No user is logged in');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No user is logged in')));
    }
  }

  Future<void> AddFoodToUserList() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User is logged in with UID: ${user.uid}');

      // إضافة مستند فارغ إذا لم يكن موجودًا
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userfood')
          .where('userid', isEqualTo: user.uid)
          .get();
      DocumentReference FoodDoc;
      if (querySnapshot.docs.isEmpty) {
        print('No matching meal found, creating a new one');
        FoodDoc = await FirebaseFirestore.instance.collection('userfood').add({
          'userid': user.uid,
        });
      } else {
        FoodDoc = querySnapshot.docs.first.reference;
        print('Matching meal found, using existing document');
      }

      await FoodDoc.collection('foods').add({
            'name': foodNameController.text,
      'Kal': double.parse(kalController.text.isEmpty ? '0.0' : kalController.text),
      'gram': double.parse(gramController.text.isEmpty ? '0.0' : gramController.text),
      'Protein': double.parse(proteinController.text.isEmpty ? '0.0' : proteinController.text),
      'Carbohydrates': double.parse(carbohydratesController.text.isEmpty ? '0.0' : carbohydratesController.text),
      'Fats': double.parse(fatsController.text.isEmpty ? '0.0' : fatsController.text),
      'SaturatedFat': double.parse(saturatedFatController.text.isEmpty ? '0.0' : saturatedFatController.text),
      'UnSaturatedFat': double.parse(unsaturatedFatController.text.isEmpty ? '0.0' : unsaturatedFatController.text),
      'A': double.parse(aController.text.isEmpty ? '0.0' : aController.text),
      'B12': double.parse(b12Controller.text.isEmpty ? '0.0' : b12Controller.text),
      'B6': double.parse(b6Controller.text.isEmpty ? '0.0' : b6Controller.text),
      'C': double.parse(cController.text.isEmpty ? '0.0' : cController.text),
      'D': double.parse(dController.text.isEmpty ? '0.0' : dController.text),
      'Fe': double.parse(feController.text.isEmpty ? '0.0' : feController.text),
      'K': double.parse(kController.text.isEmpty ? '0.0' : kController.text),
      'Ca': double.parse(caController.text.isEmpty ? '0.0' : caController.text),
      'Mg': double.parse(mgController.text.isEmpty ? '0.0' : mgController.text),
      'Kolistol': double.parse(kolistolController.text.isEmpty ? '0.0' : kolistolController.text),
      'p': double.parse(pController.text.isEmpty ? '0.0' : pController.text),
      });

      print('Food added successfully');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Food added successfully')));
    } else {
      print('No user is logged in');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No user is logged in')));
    }
  }
  @override
  void dispose() {
    foodNameController.dispose();
    kalController.dispose();
    gramController.dispose();
    proteinController.dispose();
    carbohydratesController.dispose();
    fatsController.dispose();
    saturatedFatController.dispose();
    unsaturatedFatController.dispose();
    aController.dispose();
    b12Controller.dispose();
    b6Controller.dispose();
    cController.dispose();
    dController.dispose();
    feController.dispose();
    kController.dispose();
    caController.dispose();
    mgController.dispose();
    kolistolController.dispose();
    pController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
            
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
              ),
                height: 600,
                width: 300,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: foodNameController,
                        decoration: InputDecoration(labelText: 'اسم الوجبة'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال الاسم';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: kalController,
                        decoration: InputDecoration(labelText: 'السعرات الحرارية'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال قيمه السعرات الحرارية';
                          }
                          if (double.tryParse(value) == null) {
                            return 'الرجاء ادخال رقم صحيح';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: gramController,
                        decoration: InputDecoration(labelText: 'الوزن (جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال القيمه';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: proteinController,
                        decoration: InputDecoration(labelText: 'البروتين (جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال القيمه';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: carbohydratesController,
                        decoration: InputDecoration(labelText: 'الكاربوهيدرات(جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال القيمه';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: fatsController,
                        decoration: InputDecoration(labelText: 'الدهون(جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال القيمه';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: saturatedFatController,
                        decoration: InputDecoration(labelText: 'الدهون المشبعة(جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return saturatedFatController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: unsaturatedFatController,
                        decoration:
                            InputDecoration(labelText: 'الدهون الغير مشبعة(جرام)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return unsaturatedFatController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: aController,
                        decoration: InputDecoration(labelText: '(mg)A فيتامين '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                      return aController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: b12Controller,
                        decoration: InputDecoration(labelText: '(mg)B12 فيتامين '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                      return b12Controller.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: b6Controller,
                        decoration: InputDecoration(labelText: '(mg)B6 فيتامين '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                        return b6Controller.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: cController,
                        decoration: InputDecoration(labelText: '(mg)C فيتامين '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return cController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: dController,
                        decoration: InputDecoration(labelText: '(iu) D فيتامين '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return dController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: feController,
                        decoration: InputDecoration(labelText: '(mg) الحديد'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                              return feController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: kController,
                        decoration: InputDecoration(labelText: '(mg) البوتاسيوم'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return kController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: caController,
                        decoration: InputDecoration(labelText: '(mg) الكالسيوم'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return caController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                          return caController.text='0.0';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: mgController,
                        decoration: InputDecoration(labelText: '(mg) الماغنيسيوم'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return mgController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: kolistolController,
                        decoration: InputDecoration(labelText: '(mg) الكالسيوم'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                              return kolistolController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: pController,
                        decoration: InputDecoration(labelText: '(mg) الفسفور'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return pController.text='0.0';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                  
                    ],
                  ),
                ),
              ),
                 ElevatedButton(
                            onPressed: _isFormValid
                                ? () async {
                                    await _addFood();
                                    await AddFoodToUserList();
                                  
                                  }
                                : null,
                            child: Text('اضافة'),
                          ),
                        
            ],
          ),
        ),
      ),
    );
  }
}


class AddNewFoodTap extends StatefulWidget {
  final DateTime selectedDay;
  final Meal meal;
  const AddNewFoodTap(
      {super.key, required this.meal, required this.selectedDay});

  @override
  State<AddNewFoodTap> createState() => _AddNewFoodTapState();
}

class _AddNewFoodTapState extends State<AddNewFoodTap>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة وجبة جديدة '),
        bottom: TabBar(
          controller: _tabController, // تعيين TabController هنا
          tabs: [
            Tab(icon: Icon(Icons.fitness_center)),
            Tab(icon: Icon(Icons.home)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AddNewFood(selectedDay: widget.selectedDay, meal: widget.meal),
      Historyfoodadd(meal: widget.meal,SelectDay: widget.selectedDay)
        ],
      ),
    );
  }
}
