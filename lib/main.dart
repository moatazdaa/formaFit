import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:formafit/screen/aboutAs.dart';
import 'package:formafit/screen/challenge.dart';
import 'package:formafit/screen/favorit.dart';
import 'package:formafit/screen/history.dart';
import 'package:formafit/screen/plan.dart';
import 'package:formafit/screen/report.dart';
import 'package:formafit/screen/train.dart';

void main() {
  runApp(FormaFit());
}

class FormaFit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forma Fit',
      theme: ThemeData(
         primarySwatch: Colors.blue,
        //  canvasColor: const Color.fromARGB(255, 167, 30, 30), // تعيين لون الـ BottomNavigationBar هنا

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Forma Fit"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // افتح القائمة الجانبية
          },
        ),
      ),

      // محتويات القائمة الجانبية
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Moataz Daafous'),
              accountEmail: Text('Moataz@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/3.jpg'), // استبدل بمسار شعار التطبيق الخاص بك
              ),
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 57, 140, 207), // لون خلفية الرأس
              ),
            ),
          
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/1.jpg'),
              ),
              title: Text(' Moataz Daafous'),
              subtitle: Text('Moataz@gmail.com'),
              onTap: () {
                // تنفيذ الإجراء المطلوب عند النقر على العنصر
              },
            ),
         
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.fitness_center),
                onPressed: () {},
              ),
              title: Text('التمارين'),
              onTap: () {
                // تعديل السطر الذي يتم النقر عليه
                // لتنفيذ الإجراء المطلوب
          
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TrainScreen()),);
             
              },
            ),

              ListTile(
              leading: IconButton(
                icon: Icon(Icons.route_rounded),
                onPressed: () {},
              ),
              title: Text('التحديات'),
              onTap: () {
              
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChallengeScreen()),);
             
              },
            ),

              ListTile(
              leading: IconButton(
                icon: Icon(Icons.list),
                onPressed: () {},
              ),
              title: Text('الأهداف'),
              onTap: () {
              
          
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlanScreen()),);
             
              },
            ),

              ListTile(
              leading: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
              title: Text('المفضلة'),
              onTap: () {
                // تعديل السطر الذي يتم النقر عليه
                // لتنفيذ الإجراء المطلوب
          
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FavoritScreen()),);
             
              },
            ),

              ListTile(
              leading: IconButton(
                icon: Icon(Icons.report),
                onPressed: () {},
              ),
              title: Text('التقارير'),
              onTap: () {
                // تعديل السطر الذي يتم النقر عليه
                // لتنفيذ الإجراء المطلوب
          
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen()),);
             
              },
            ),

             ListTile(
              leading: IconButton(
                icon: Icon(Icons.light_mode),
                onPressed: () {},
              ),
              title: Text('عن التطبيق'),
              onTap: () {
              
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutAsScreen()),);

              },
            ),
          
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {},
              ),
              title: Text('تسجيل خروج'),
              onTap: () {
                // تعديل السطر الذي يتم النقر عليه
                // لتنفيذ الإجراء المطلوب

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('تسجيل الخروج'),
                      content: Text('هل أنت متاكد من تسجيل الخروج '),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // إغلاق نافذة الحوار
                            Navigator.pop(context);
                          },
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('ACCEPT'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            
         
          ],
        ),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          HistoryScreen(),
          TrainScreen(),
          PlanScreen(),
          ChallengeScreen(),
        ],
      ),

      // الشريط السفلي 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'التغدية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_sharp),
            label: 'التمارين',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'الخطط',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_rounded),
            label: 'التحديات',
          ),
        ],

      //    backgroundColor: const Color.fromARGB(255, 167, 30, 30), // تعيين اللون هنا
      //  fixedColor: const Color.fromARGB(255, 0, 0, 0), // تعيين اللون هنا
          backgroundColor: Colors.white, // لون خلفية الـ BottomNavigationBar
        unselectedItemColor: Colors.black, // لون الأيقونات غير المحددة
        selectedItemColor: Colors.red, // لون الأيقونة المحددة
       
      ),
    );
  }
}



// الرئيسية
class HomeScreen extends StatefulWidget {
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Hello..."),),
      
      body: 
       ListView(
            shrinkWrap: true,
       
         children: [
           Column(
             children: [
                 Padding(
  padding: EdgeInsets.all(25.0),
  child: TextField(
   onChanged: (value) {
    setState(() {
      _searchText = value;
    });
  },
    decoration: InputDecoration(
      hintText: 'ابحث هنا...',
      prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: 1.0),
      ),
    ),
  ),
),
               SizedBox(height: 15),

// هدا السطر الخاص بي عرض التقارير عن عدد التمارين والسعرات 

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children :[
                  Column(children: [
                    TextButton(
                      onPressed: (){},
                     child: Text('عدد التمارين' ,
                     style: TextStyle(
                    //  color: Colors.black,
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                       ),) ),
                    Text('10 ', 
                     style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),), 
                    
                    ]),

                      Column(children: [
                    TextButton(onPressed: (){},
                     child: Text('السعرات المحروقة ',
                       style: TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                       ),) ),
                    Text('150 ',
                      style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),), 
                    
                    ]),

                      Column(children: [
                    TextButton(onPressed: (){}, 
                    child: Text('السعرات المطلوبة', 
                     style: TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                       ),) ),
                    Text('280 ',
                      style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),), 
                    
                    ]),

                  ],),


               SizedBox(height: 25),

      //  كود الخاص بي عرض التمارين 
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Padding(
                     padding: EdgeInsets.only(left: 10.0),
                     child: Text(
                       " التمارين",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(right: 10.0),
                     child: TextButton(
                       onPressed: () {
                         // عند النقر على View All
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => TrainScreen()),
                         );
                       },
                       child: Text(
                         "عرض الكل",
                         style: TextStyle(
                           fontSize: 16,
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 3),
       
               CarouselSlider(
                 items: [
                   // 1st Image of Slider
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الأولى
                     },
                     child: Container(
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/gym4.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "تمارين الصدر",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
       
                   // 2nd Image of Slider
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الثانية
                     },
                     child: Container(
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/gym6.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "تمارين القوة ",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
       
                   // 3rd Image of Slider
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الثالثة
                     },
                     child: Container(
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/gym5.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "تمارين الأرجل ",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
       
                   // 4th Image of Slider
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الرابعة
                     },
                     child: Container(
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/gym3.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "تمارين الصدر ",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
       
                   // 5th Image of Slider
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الخامسة
                     },
                     child: Container(
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/gym2.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "تمارين بايسيبس",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
                 options: CarouselOptions(
                   height: 180.0,
                   enlargeCenterPage: true,
                   autoPlay: true,
                   aspectRatio: 16 / 9,
                   autoPlayCurve: Curves.fastOutSlowIn,
                   enableInfiniteScroll: true,
                   autoPlayAnimationDuration: Duration(milliseconds: 800),
                   viewportFraction: 0.8,
                 ),
               ),
             
               SizedBox(height: 15),
      //  كود الخاص بي عرض التحديات 
               //2222222222
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Padding(
                     padding: EdgeInsets.only(left: 10.0),
                     child: Text(
                       " التحديات",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(right: 10.0),
                     child: TextButton(
                       onPressed: () {
                         // عند النقر على View All
                       },
                       child: Text(
                         "عرض الكل ",
                         style: TextStyle(
                           fontSize: 16,
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 3),
       
               CarouselSlider(
                 items: [
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الأولى في قسم Planning
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.7,
                       height: 100,
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/chall1.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "العقلة",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الثانية في قسم Planning
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.7,
                       height: 100,
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/chall2.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               "ضغط ",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الثالثة في قسم Planning
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.7,
                       height: 100,
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/chall3.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               " الجري",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       // افتح واجهة أخرى بعد النقر على الصورة الأولى في قسم Planning
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.7,
                       height: 100,
                       margin: EdgeInsets.all(6.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8.0),
                         image: DecorationImage(
                           image: AssetImage("assets/images/chall4.jpg"),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: Stack(
                         children: [
                           Positioned(
                             bottom: 10,
                             left: 10,
                             child: Text(
                               " المعدة",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
                 options: CarouselOptions(
                   height: 180.0,
                   enlargeCenterPage: true,
                   autoPlay: true,
                   aspectRatio: 16 / 9,
                   autoPlayCurve: Curves.fastOutSlowIn,
                   enableInfiniteScroll: true,
                   autoPlayAnimationDuration: Duration(milliseconds: 800),
                   viewportFraction: 0.8,
                 ),
               ),
               SizedBox(height: 15),

   
           
             ],
           ), 
         ], 
       ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Home page '),
    //     bottom: TabBar(
    //       controller: tabController, // تعيين TabController هنا
    //       tabs: [
    //         Tab(icon: Icon(Icons.home)),
    //         Tab(icon: Icon(Icons.search)),
    //         Tab(icon: Icon(Icons.favorite)),
    //         Tab(icon: Icon(Icons.train)),
    //         Tab(icon: Icon(Icons.settings)),
    //       ],
    //     ),
    //   ),
    //   body: TabBarView(
    //     controller: tabController,
    //     children: [
    //       Center(
    //         child: Text('Home Tab Content'),
    //       ),
    //       SearchScreen(),
    //       TrainScreen(),
    //       PlanScreen(),
    //       SettingScreen(),
    //     ],
    //   ),
    // );
  }
}
