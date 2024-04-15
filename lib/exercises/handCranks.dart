
import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين السواعد  
 
class HandCranks extends StatefulWidget {
  const HandCranks({Key? key}) : super(key: key);

  @override
  _HandCranksState createState() => _HandCranksState();
}

class _HandCranksState extends State<HandCranks> with SingleTickerProviderStateMixin {
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
        title: Text('السواعد '),
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
         HandCranksGym(),
          HandCranksHome(),
        ],
      ),
    );
  }
}

class HandCranksGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('HandCranks Gym'),
    );
  }
}

class HandCranksHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('HandCranks Home'),
    );
  }
}