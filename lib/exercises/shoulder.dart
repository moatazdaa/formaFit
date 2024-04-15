
import 'package:flutter/material.dart';

//  صفحة خاصة بي  تمارين الاكتاف
 
class Shoulder extends StatefulWidget {
  const Shoulder({Key? key}) : super(key: key);

  @override
  _ShoulderState createState() => _ShoulderState();
}

class _ShoulderState extends State<Shoulder> with SingleTickerProviderStateMixin {
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
        title: Text('الأكتاف '),
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
         ShoulderGym(),
          ShoulderHome(),
        ],
      ),
    );
  }
}

class ShoulderGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Shuolder Gym'),
    );
  }
}

class ShoulderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Shoulder Home'),
    );
  }
}