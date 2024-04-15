// تمارين المعدة 

import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين الارداف 
 
class Stomach extends StatefulWidget {
  const Stomach({Key? key}) : super(key: key);

  @override
  _StomachState createState() => _StomachState();
}

class _StomachState extends State<Stomach> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المعدة '),
        bottom: TabBar(
          controller: _tabController, // تعيين TabController هنا
          tabs: [ 
              Tab(icon: Icon(Icons.fitness_center)),
            Tab(icon: Icon(Icons.home)),
         
           
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
         StomachGym(),
          StomachHome(),
        ],
      ),
    );
  }
}

class StomachGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Stomach Gym'),
    );
  }
}

class StomachHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Stomach Home'),
    );
  }
}