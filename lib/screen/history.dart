
import 'package:flutter/material.dart';

// صفحة خاصة بالسجلات اخر التمارين  

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History screen'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Result 1'),
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Result 2'),
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Result 3'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

