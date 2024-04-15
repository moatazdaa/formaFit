
import 'package:flutter/material.dart';

// صفحة خاصة بالمفضلة 

class FavoritScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit Screen'),
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

