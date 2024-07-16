import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool _isLoading = false;
bool get isLoading => _isLoading;
//______________________________

String? gender;
double? weight;
double? height;
int? age;
String? activityLevel;
List<String>? goalList;
String? fullName;

var ProvideimgName;

//______________________________
void cleanVarable() {
  gender = '';
  age = 0;
  height = 0;
  weight = 0;
  activityLevel = '';
  goalList = [];
}

Future <void> updateImageData(var img)  async{
  ProvideimgName = img;
}

class UserProvider extends ChangeNotifier {
  void updateField(String key, dynamic value) {
    switch (key) {
      case 'gender':
        gender = value;
        break;
      case 'height':
        height = double.tryParse(value.toString());
        break;
      case 'age':
        age = int.tryParse(value.toString());
        break;
      case 'weight':
        weight = double.tryParse(value.toString());
        break;
      case 'activityLevel':
        activityLevel = value;
        break;
      case 'goal':
        goalList = List<String>.from(value);
        break;
    }
    notifyListeners();
  }

  void updateFullName(String Name) {
    fullName = Name;

    notifyListeners();
    print(fullName);
  }

  void updateActivityLevel(String activityLevele) {
    activityLevel = activityLevele;
    notifyListeners();
  }

  void updateUser(String gender, String activity, double width, double height,
      int age, List<String> gool) {
    gender = gender;
    age = age;
    weight = width;
    height = height;
    activityLevel = activity;
    goalList = gool;
    notifyListeners();
  }
}

Future<void> SaveUserData() async {
  try {
    // احصل على المستخدم الحالي
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // مرجع المجموعة
      final userRef = FirebaseFirestore.instance.collection("UserProfile");

      // تحقق مما إذا كان المستند موجود أم لا
      final querySnapshot =
          await userRef.where('UserId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // المستند موجود، قم بجلب القيم الحالية وأضف القيم الجديدة
        final doc = querySnapshot.docs.first;

        await doc.reference.update({
          'gender': gender,
          'activity': activityLevel,
          'weight': weight,
          'height': height,
          'age': age,
          'goal': goalList,
          'imageUrl': ProvideimgName, // قم بتحديث عنوان URL للصورة هنا
          'fullName': fullName
        });
      } else {
        // المستند غير موجود، قم بإنشاء مستند جديد
        await userRef.add({
          'UserId': user.uid,
          'gender': gender,
          'activity': activityLevel,
          'weight': weight,
          'height': height,
          'age': age,
          'goal': goalList,
          'imageUrl': ProvideimgName, // قم بتخزين عنوان URL للصورة هنا
          'fullName': fullName
        });
      }
      print("Data added/updated successfully!");
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Failed to add/update data: $e");
  }
}

// 11111111111
Future<void> fetchProfileData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection("UserProfile");

      final querySnapshot =
          await userRef.where('UserId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        weight = (data["weight"] ?? 0.0); // تحديث قيمة الوزن
        gender = (data["gender"] ?? "");
        activityLevel = (data["activity"] ?? "");
        height = (data["height"] ?? 0.0);
        age = (data["age"] ?? 0);
        fullName = (data["fullName"] ?? "");
        ProvideimgName = (data["imageUrl"] ?? "");

        // تحقق من نوع قائمة الأهداف وتحويلها إلى List<String> إذا كانت موجودة
        if (data["goal"] is List<dynamic>) {
          goalList = List<String>.from(data["goal"]);
        } else {
          goalList = []; // أو يمكنك تعيين قيمة افتراضية حسب الحاجة
        }
      } else {
        // إذا لم يكن هناك مستند موجود
        // يمكنك تنفيذ التعامل مع هذه الحالة إن كانت مطلوبة
      }
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Failed to fetch data $e");
  }
}

Future<void> EditUserName() async {
  try {
    // احصل على المستخدم الحالي
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // مرجع المجموعة
      final userRef = FirebaseFirestore.instance.collection("UserProfile");

      // تحقق مما إذا كان المستند موجود أم لا
      final querySnapshot =
          await userRef.where('UserId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // المستند موجود، قم بجلب القيم الحالية وأضف القيم الجديدة
        final doc = querySnapshot.docs.first;

        await doc.reference.update({'fullName': fullName});
      } else {
        // المستند غير موجود، قم بإنشاء مستند جديد
        await userRef.add({'fullName': fullName});
      }

      print("Data added/updated successfully!");
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Failed to add/update data: $e");
  }
}



Future<void> EditUserImg() async {
  try {
    // احصل على المستخدم الحالي
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // مرجع المجموعة
      final userRef = FirebaseFirestore.instance.collection("UserProfile");

      // تحقق مما إذا كان المستند موجود أم لا
      final querySnapshot =
          await userRef.where('UserId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // المستند موجود، قم بجلب القيم الحالية وأضف القيم الجديدة
        final doc = querySnapshot.docs.first;

        await doc.reference.update({'imageUrl': ProvideimgName});
      } else {
        // المستند غير موجود، قم بإنشاء مستند جديد
        await userRef.add({'imageUrl': ProvideimgName});
      }

      print("Data added/updated successfully!");
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Failed to add/update data: $e");
  }
}
