import 'package:flutter/material.dart';

// صفحة خاصة بي تمارين البايسبس

class Biceps extends StatefulWidget {
  const Biceps({Key? key}) : super(key: key);

  @override
  _BicepsState createState() => _BicepsState();
}

class _BicepsState extends State<Biceps> with SingleTickerProviderStateMixin {
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
        title: Text('يايسبس '),
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
         BicepsGym(),
          BicepsHome(),
        ],
      ),
    );
  }
}

class BicepsGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Biceps Gym'),
    );
  }
}

class BicepsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Biceps Home'),
    );
  }
}