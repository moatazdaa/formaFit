import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formafit/components/snackbar.dart';
import 'package:formafit/provider/firebase_services/storage.dart';
import 'package:formafit/provider/firebase_services/user.dart';


class AuthMethods {

// دالة خاصة بي انشاء حساب وحفظ البيانات في قاعدة البيانات 
  register({
    required email,
    required password,
    required context,
    required username,
    required imgName,
    required imgPath,
  }) async {

    try {
          // إنشاء المستخدم باستخدام Firebase Authentication
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
// ______________________________________________________________________
  
    // رفع صورة المستخدم والحصول على الرابط
      String urlll = await getImgURL(imgName: imgName, imgPath: imgPath);

// _______________________________________________________________________
    // إضافة بيانات المستخدم إلى Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('UserProfile');

      UserDate userr = UserDate(
        email: email,
        password: password,
        username: username,
        profileImg: urlll,
        uid: credential.user!.uid,
      );

      users
          .doc(credential.user!.uid)
          .set(userr.convert2Map());
              showSnackBar(context, "تم إنشاء حساب بنجاح");

    } on FirebaseAuthException catch (e) {
        switch (e.code) {
      case 'email-already-in-use':
        showSnackBar(context, "البريد الإلكتروني مستخدم بالفعل");
        break;
      case 'invalid-email':
        showSnackBar(context, "البريد الإلكتروني غير صالح");
        break;
      case 'operation-not-allowed':
        showSnackBar(context, "عملية غير مسموح بها");
        break;
      case 'weak-password':
        showSnackBar(context, "كلمة المرور ضعيفة للغاية");
        break;
      default:
        showSnackBar(context, "خطأ في التسجيل: ${e.code}");
        break;
    }
    } catch (e) {
      print(e);
    }

  }


// دالة تسجيل الدخول 
  signIn({required email, required password, required context}) async {
    try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
        showSnackBar(context, "تم تسجيل الدخول ");

    } on FirebaseAuthException catch (e) {
      switch (e.code){
      case 'user-not-found':
        showSnackBar(context, "البريد الإلكتروني غير موجود");
        break;
      case 'wrong-password':
        showSnackBar(context, "كلمة المرور غير صحيحة");
        break;
      case 'invalid-email':
        showSnackBar(context, "البريد الإلكتروني غير صحيح");
        break;
      case 'user-disabled':
        showSnackBar(context, "تم تعطيل حساب المستخدم");
        break;
      default:
        showSnackBar(context, "خطأ في التسجيل: ${e.code}");
        break;
    }
    } catch (e) {
      print(e);
    }
  } 
}