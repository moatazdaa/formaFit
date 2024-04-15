
import 'package:flutter/material.dart';

// صفحة خاصة بي  تمارين الارداف 
 
class Buttocks extends StatefulWidget {
  const Buttocks({Key? key}) : super(key: key);

  @override
  _ButtocksState createState() => _ButtocksState();
}

class _ButtocksState extends State<Buttocks> with SingleTickerProviderStateMixin {
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
        title: Text('الأرداف '),
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
         ButtocksGym(),
          ButtocksHome(),
        ],
      ),
    );
  }
}

class ButtocksGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Buttocks Gym'),
    );
  }
}

class ButtocksHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Buttocks Home'),
    );
  }
}