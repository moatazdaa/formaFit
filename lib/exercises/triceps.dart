import 'package:flutter/material.dart';

// صفحة خاصة بي تمارين الترايسبس

class Triceps extends StatefulWidget {
  const Triceps({Key? key}) : super(key: key);

  @override
  _TricepsState createState() => _TricepsState();
}

class _TricepsState extends State<Triceps> with SingleTickerProviderStateMixin {
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
        title: Text('ترايسبس '),
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
         TricepsGym(),
          TricepsHome(),
        ],
      ),
    );
  }
}

class TricepsGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Triceps Gym'),
    );
  }
}

class TricepsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Triceps Home'),
    );
  }
}