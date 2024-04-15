
import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين الصدر  
 
class Chest extends StatefulWidget {
  const Chest({Key? key}) : super(key: key);

  @override
  _ChestState createState() => _ChestState();
}

class _ChestState extends State<Chest> with SingleTickerProviderStateMixin {
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
        title: Text('الصدر '),
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
         ChestGym(),
          ChestHome(),
        ],
      ),
    );
  }
}

class ChestGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chest Gym'),
    );
  }
}

class ChestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chest Home'),
    );
  }
}