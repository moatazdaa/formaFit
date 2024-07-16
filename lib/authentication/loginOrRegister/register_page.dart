
import 'dart:math';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:formafit/authentication/Onboarding/onboardingPage.dart';
import 'package:formafit/components/snackbar.dart';
import 'package:formafit/provider/firebase_services/auth.dart';
import 'package:formafit/shared/contants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;


class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
 // Visibility flags for password fields
  bool isVisible = true;
  bool isVisible2 = true; 
  Uint8List? imgPath;
  String? imgName;

  // Text editing controllers
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


//  دالة تحميل الصورة 
  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

// دالة اختيار الصورة اما من الاستديو او الكاميرة 
  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


// دالة الانتقال الي صفحات ادخال المعلومات الشخصية 
void navigateToOnboarding(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => OnboardingPage()),
  );
}

// دالة انشاء الحساب 
 singUp() async {
    if (_formKey.currentState!.validate() &&
        imgName != null &&
        imgPath != null) {
      setState(() {
        isLoading = true;
      });
      await AuthMethods().register(
          email: emailController.text,
          password: passwordController.text,
          context: context,
          username: fullnameController.text,
          imgName: imgName,
          imgPath: imgPath);
  if(mounted){
       setState(() {
        isLoading = false;
      }); 
  }
     
    } else {
      showSnackBar(context, "ERROR");
    }
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      SizedBox(height: 25),
                          
                              Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber
                      ),
                      child: Stack(
                        children: [
                          imgPath == null
                              ? CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 225, 225, 225),
                                  radius: 71,
                                  backgroundImage:
                                      AssetImage("assets/images/avatarProfile.png"),
                                )
                              : CircleAvatar(
                                  radius: 71,
                                  backgroundImage: MemoryImage(imgPath!),
                                ),
                          Positioned(
                            left: 99,
                            bottom: -10,
                            child: IconButton(
                              onPressed: () {
                                showmodel();
                              },
                              icon: const Icon(Icons.add_a_photo),
                              color: Color.fromARGB(255, 208, 218, 224),
                            ),
                          ),
                        ],
                      ),
                    ),
      
                      SizedBox(height: 25),
      
                      Text(
                        " قم بإنشاء حساب  ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(height: 25),
      // الاسم كامل 
                      TextFormField(
                        validator: (fullname) {
                          return fullname!.contains(RegExp(r"^[a-zA-Z\s]+$"))
                              ? null
                              : "أدخل الإسم صحيح ";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: fullnameController,
                        keyboardType: TextInputType.name,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                          hintText: "الإسم كامل",
                          suffixIcon: Icon(Icons.person,),
                        ),
                      ),
                      SizedBox(height: 10),
      // الربيد الالكتروني 
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
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                          hintText: "البريد الالكتورني",
                          suffixIcon: Icon(Icons.email,),
                        ),
                      ),
                      SizedBox(height: 10),
      // كلمة المرور 
                        TextFormField(
                        validator: (password) {
                          return password!.length >= 8 &&
                                  password.contains(RegExp(r'\d')) &&
                                  password.contains(RegExp(r'[A-Z]')) &&
                                  password.contains(RegExp(r'[a-z]')) 
                              ? null
                              : "يجب أن تتكون كلمة المرور من 8 أحرف علي الأقل";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        obscureText: isVisible,
                        decoration: decorationTextfield.copyWith(
                          hintText: "كلمة المرور",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
      // تأكيد كلمة المرور 
                TextFormField(
                        validator: (value) {
                          return value == passwordController.text
                              ? null
                              : "كلمة المرور غير متطابقة ";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: confirmPasswordController,
                        obscureText: isVisible2,
                        decoration: decorationTextfield.copyWith(
                          hintText: "تأكيد كلمة المرور",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible2 = !isVisible2;
                              });
                            },
                            icon: isVisible2
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(height: 75),
      // زر انشاء حساب 
                      SizedBox(
                        width: 300,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : ()async {
                                  if (_formKey.currentState!.validate()) {
                                 singUp();
                                  }
                                     navigateToOnboarding(context);
                            // هنا يمكنك توجيه المستخدم إلى الشاشة الرئيسية بعد الحفظ
                                },
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "إنشاء حساب ",
                                  style: TextStyle(fontSize: 19,color: Colors.black),
                                ),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.amber),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.all(12),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
 
                      SizedBox(height: 70),
      // تحقق ماادا كان لديك حساب او لا 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'هل لديك حساب؟',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              'قم بتسجيل الدخول',
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
