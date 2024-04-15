
import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين الكارديو  
 
class Cardio extends StatefulWidget {
  const Cardio({Key? key}) : super(key: key);

  @override
  _CardioState createState() => _CardioState();
}

class _CardioState extends State<Cardio> with SingleTickerProviderStateMixin {
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
        title: Text('كارديو '),
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
         CardioGym(),
          CardioHome(),
        ],
      ),
    );
  }
}

class CardioGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cardio Gym'),
    );
  }
}

class CardioHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cardio Home'),
    );
  }
}