
import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين الارجل  
 
class Legs extends StatefulWidget {
  const Legs({Key? key}) : super(key: key);

  @override
  _LegsState createState() => _LegsState();
}

class _LegsState extends State<Legs> with SingleTickerProviderStateMixin {
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
        title: Text('الأرجل '),
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
         LegsGym(),
          LegsHome(),
        ],
      ),
    );
  }
}

class LegsGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Legs Gym'),
    );
  }
}

class LegsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Legs Home'),
    );
  }
}