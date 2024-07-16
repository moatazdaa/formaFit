
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
   MyButton({super.key,
  required this.onTap,
  required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 218, 103, 10),
          borderRadius: BorderRadius.circular(12),
          ),
        child: Center(
          child: Text(text,
          style: const TextStyle(color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          ),),
        ),
      ),
    );
  }
}