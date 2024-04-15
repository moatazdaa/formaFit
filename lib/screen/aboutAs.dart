

import 'package:flutter/material.dart';

//  صفحة خاصة بي عن التطبيق   

class AboutAsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عن التطبيق'),
      ),
      body: Center(
        child: Text('FormaFit هوا تطبيق متكامل يهدف إلي تحسين اللياقة البدنية والتغذية الصحية للمستخدمين يقدم التطبيق مجموعة واسعة من المميزات والأدوات لمساعدة المستخدمين علي تحقيق أهدافهم الصحية والرياضة يمكن للمستخدمين تخصيص الخطط والنظام الغدائي وتتبع التقدم  ',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),),      
      )
    );
  }
}

