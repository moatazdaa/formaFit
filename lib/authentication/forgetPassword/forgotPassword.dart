
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formafit/authentication/forgetPassword/verifyEmail.dart';
import 'package:formafit/authentication/loginOrRegister/login.dart';
import 'package:formafit/components/snackbar.dart';
import 'package:formafit/shared/contants.dart';

class ForgotPassword extends StatefulWidget {
   

  ForgotPassword
  ({super.key,});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController =TextEditingController();
    final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // initially show login page 
  bool showLoginPage =true;

  // toogle between login and regester page 
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }


resetpassword()async{
     try {
     await FirebaseAuth.instance
    .sendPasswordResetEmail(email:emailController.text);
            if(!mounted)return;
           showSnackBar(context, "تم إرسال رمز التحقق إلى البريد الإلكتروني");  
             
        //        Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>verifyCode(email: emailController.text )),);
         Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage( onTap:(){} ,)),);


    } on  FirebaseAuthException catch (e) {
        showSnackBar(context, "Error : ${e.code}");
           if(!mounted)return;
      Navigator.pop(context);
             

    }
}

 @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[700],
          // title: Text("Profile"),
      ),
        
        body:  Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [    
                    const SizedBox(height: 25,),                 
                   Text("هل نسيت كلمة المرور ",style: TextStyle(fontSize: 20)),
                    Text("الرجاء إدخال البريد الإلكتروني ",style: TextStyle(fontSize: 18),),
 
                        Text("Please enter your email address to recieve averification code",style: TextStyle(fontSize: 20),),
                           const SizedBox(height: 25,),                 
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
                          suffixIcon: Icon(Icons.email,color: Colors.orange[700],),
                        ),
                      ),
                      //button
                              const SizedBox(height: 25,),                 

              // زر اعادة كلمة المرور 
                    SizedBox(
                      width: 300, // عرض الزر المطلوب
                      height: 55, // ارتفاع الزر المطلوب
                      child: ElevatedButton(
                       onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    resetpassword();
                                  }
                                },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "إرسال",
                                style: TextStyle(fontSize: 19,color: Colors.black),
                              ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.orange[700]),
                          padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                    ),
                                  const SizedBox(height: 25,),                 

                  ],
                ),
            ),
          ),
        ),
         
      ),
    );
  }
}