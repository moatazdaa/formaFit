
import 'package:flutter/material.dart';

// صفحة خاصة بي خطط التمرين 

class PlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Tab'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings'),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // تنفيذ إجراء تسجيل الخروج
              },
            ),
          ],
        ),
      ),
    );
  }
}

