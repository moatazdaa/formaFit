
import 'package:flutter/material.dart';

class ImageTextPage extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onNext;

  ImageTextPage({required this.imagePath, required this.text, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset(imagePath, height: 300),
            SizedBox(height: 20),
            Text(
              text,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onNext,
              child: Text('التالي'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}