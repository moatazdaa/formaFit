import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formafit/authentication/forgetPassword/createPassword.dart';
import 'package:formafit/components/snackbar.dart';

class verifyCode extends StatefulWidget {
  final String email;
    // final String code;


  verifyCode({required this.email 
  // ,required this.code
  });

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<verifyCode> {
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void verifyCode() {
    // if (codeController.text == widget.code) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => CreateNewPassword(email: widget.email),
    //     ),
    //   );
    // } else {
    //   showSnackBar(context, "رمز التحقق غير صحيح");
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                       const SizedBox(height: 40),
                Text("إدخال رمز التحقق"),
                    
                          const SizedBox(height: 20),
                TextFormField(
                  validator: (code) {
                    if (code == null || code.isEmpty) {
                      return 'الرجاء إدخال رمز التحقق';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "رمز التحقق"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      verifyCode();
                    }
                  },
                  child: Text('تأكيد'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
