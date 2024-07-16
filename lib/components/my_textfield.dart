import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
    final Icon? prefixIcon; // إضافة المتغير prefixIcon هنا

  const MyTextField({super.key,
  required this.controller,
  required this.hintText,
  required this.obscureText,
  required this.prefixIcon,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
 
  @override
  Widget build(BuildContext context) {
    return    Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white ),
                  borderRadius: BorderRadius.circular(12),
                ),
                 focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 219, 120, 7) ),
                             borderRadius: BorderRadius.circular(12),

                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: IconButton(onPressed: null, 
                icon: Icon(Icons.remove_red_eye_sharp)),
              ),

            ),
          );
  }
}