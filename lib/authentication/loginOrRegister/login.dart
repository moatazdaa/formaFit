import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:formafit/authentication/forgetPassword/forgotPassword.dart';
import 'package:formafit/provider/firebase_services/auth.dart';
import 'package:formafit/provider/google_signin.dart';
import 'package:formafit/shared/contants.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

// دالة تسجيل الدخول
  signIn() async {
    setState(() {
      isLoading = true;
    });

    await AuthMethods().signIn(
        email: emailController.text,
        password: passwordController.text,
        context: context);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return Directionality(
      textDirection:
          TextDirection.rtl, // جعل اتجاه التطبيق من اليمين إلى اليسار
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                Image(image: AssetImage("assets/images/formafit2.jpg"),
                height: 200,
                ),
                      const SizedBox(height: 40),
                   
            // البريد الالكتروني  
                      TextFormField(
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'الرجاء إدخال بريد إلكتروني';
                          }
                          return EmailValidator.validate(email)
                              ? null
                              : 'الرجاء إدخال بريد إلكتروني صالح';
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: decorationTextfield.copyWith(
                          hintText: "البريد الإلكتروني",
                          suffixIcon: Icon(Icons.email,),
                        ),
                      ),
                      const SizedBox(height: 10),
           // كلمة المرور  
                      TextFormField(
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          if (password.length < 8) {
                            return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: obscurePassword,
                        decoration: decorationTextfield.copyWith(
                          hintText: "كلمة المرور",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
              // نسيت كلمة المرور
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              "نسيت كلمة المرور؟",style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
            // زر تسجيل الدخول 
                      SizedBox(
                        width: 300,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    // signUserIn();
                                    signIn();
                                  }
                                },
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(fontSize: 19,color: Colors.black),

                                ),
                          style: ButtonStyle(
                            backgroundColor:
                             WidgetStateProperty.all(Colors.amber),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(12)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "أو قم بالتسجيل باستخدام",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                  // تسجيل عن طريق القوقل  
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: GestureDetector(
                          onTap: () {
                            googleSignInProvider.googlelogin();
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              "assets/images/google.png",
                              color: Colors.red,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                  //  الانتقال الي  انشاء الحساب
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              'سجل الآن',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
