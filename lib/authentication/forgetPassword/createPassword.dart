import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formafit/authentication/loginOrRegister/login.dart';
import 'package:formafit/components/snackbar.dart';

class CreateNewPassword extends StatefulWidget {
final String email;

  CreateNewPassword({required this.email, });
  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
   final newPasswordController = TextEditingController();
 final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    newPasswordController.dispose();
        confirmPasswordController.dispose();

    super.dispose();
  }

  void createPassword() async {
   if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(newPasswordController.text);
          showSnackBar(context, "تم إعادة تعيين كلمة المرور بنجاح");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(onTap: null),
            ),
          );
        } else {
          showSnackBar(context, "لم يتم العثور على المستخدم");
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, "Error : ${e.code}");
      }
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    } else if (password.length < 8) {
      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إعادة تعيين كلمة المرور')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextFormField(
                  validator: validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: obscureNewPassword,
                  decoration: InputDecoration(
                    hintText: "كلمة المرور الجديدة",
                    suffixIcon: IconButton(
                      icon: Icon(obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureNewPassword = !obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 TextFormField(
                  validator: (password) {
                    if (password != newPasswordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "تأكيد كلمة المرور",
                    suffixIcon: IconButton(
                      icon: Icon(obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
             
             
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createPassword();
                    }
                  },
                  child: Text('إعادة تعيين'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}