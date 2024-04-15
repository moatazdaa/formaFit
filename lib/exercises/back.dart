
import 'package:flutter/material.dart';

// صفحة خاصة بي تمرين الظهر 
class Backk extends StatefulWidget {
  const Backk({Key? key}) : super(key: key);

  @override
  _BackkState createState() => _BackkState();
}

class _BackkState extends State<Backk> with SingleTickerProviderStateMixin {
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
        title: Text('الظهر '),
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
         BackkGym(),
          BackkHome(),
        ],
      ),
    );
  }
}

class BackkGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Back Gym'),
    );
  }
}

class BackkHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Back Home'),
    );
  }
}