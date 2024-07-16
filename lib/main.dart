import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:formafit/Notification/MealNotification.dart';
import 'package:formafit/Notification/waterNotification.dart';
import 'package:formafit/authentication/Onboarding/onboardingPage.dart';
import 'package:formafit/firebase_options.dart';
import 'package:formafit/authentication/auth_page.dart';
import 'package:formafit/makalat.dart';
import 'package:formafit/provider/articleProvider.dart';
import 'package:formafit/provider/challengeProvider.dart';
import 'package:formafit/provider/google_signin.dart';
import 'package:formafit/provider/health_calculator.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:formafit/provider/waterProvider.dart';
import 'package:formafit/screen/HealthyNutrition.dart';
import 'package:formafit/screen/aboutAs.dart';
import 'package:formafit/screen/activity.dart';
import 'package:formafit/screen/calculator.dart';
import 'package:formafit/screen/challenges/challengDetail1.dart';
import 'package:formafit/screen/challenges/challengeList.dart';
import 'package:formafit/screen/favorit.dart';
import 'package:formafit/screen/mainExsrsis.dart';
import 'package:formafit/screen/plan.dart';
import 'package:formafit/screen/profile.dart';
import 'package:formafit/screen/train.dart';
import 'package:formafit/screen/walking/WalkCount.dart';
import 'package:formafit/screen/water.dart';
import 'package:formafit/testReport.dart';
import 'package:formafit/userInputData.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
    // تهيئة WorkManager

     Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // تهيئة Firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
//  for (var meal in meals) {
//         if (meal.isNotificationOpen) {
//           scheduleNotificationUsingWorkManager(meal);
//         }
//       }
      
   // تهيئة AwesomeNotifications
  AwesomeNotifications().initialize(
    'resource://drawable/notification', // مسار أيقونة التطبيق الخاصة بك
    [
     NotificationChannel(
        channelKey: 'meal_channel',
        channelName: 'Meal Channel',
        channelDescription: 'قناة لتذكير بالوجبات',
        channelShowBadge: true,
        playSound: true,
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.amber,
        enableLights: true,
        enableVibration: true,
      ),
           NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
         NotificationChannel(
        channelKey: 'daily_channel',
        channelName: 'Daily Notifications',
        channelDescription: 'Daily notifications for reminders',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'meal_channel_group',
        channelGroupName: 'Meal Channel',
      ),
     
    ],
    debug: true,
  );
  // إنشاء إشعارات دورية
  // NotificationService.createDailyNotifications();
 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Provfile2()),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create:(_)=>ArticleProvider()),

        
      ],
      child: FormaFit(),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print('Workmanager task executed: $task');
    NotificationService.createDailyNotifications(); // تأكد من استدعاء الدالة لإنشاء الإشعارات
    return Future.value(true);
  });
}

class FormaFit extends StatefulWidget {
  @override
  State<FormaFit> createState() => _FormaFitState();
}

class _FormaFitState extends State<FormaFit> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forma Fit',

      home: AuthPage(),
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
  final user = FirebaseAuth.instance.currentUser!;
  // sign user out method

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

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
    final userProvider = Provider.of<UserProvider>(context);

    return Directionality(
      textDirection:
          TextDirection.rtl, // جعل اتجاه التطبيق من اليمين إلى اليسار

      child: Scaffold(
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
        drawer: 
     
          
           Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // خاص بي ملف الشخصي
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                         
                              )),
                    );
                  },
                 child: UserAccountsDrawerHeader(
                  accountName: Text(fullName ?? 'اسم المستخدم',style: TextStyle(color: Colors.black,),),
                  accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'البريد الإلكتروني',style: TextStyle(color: Colors.black,),),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: ProvideimgName != null
                        ? NetworkImage(ProvideimgName!)
                        : AssetImage('assets/images/gym2.jpg') as ImageProvider<Object>,
                  ),
                  decoration: BoxDecoration(
                     color: Colors.amber,
                //        image: DecorationImage(
                //   image: AssetImage('assets/images/mainPic.jpeg'), // ضع هنا مسار الصورة التي تريد استخدامها كخلفية
                //   fit: BoxFit.cover, // يمكنك تعديل هذه الخاصية لتناسب تصميمك
                // ),
                  ),
                ),
              ),
                // المشي
                ListTile(
                  leading: Icon(
                    Icons.directions_walk,
                    color: Colors.amber,
                  ),
                  title: Text('المشي'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalkCount()),
                    );
                  },
                ),
                // التحديات
                ListTile(
                  leading: Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                  ),
                  title: Text('التحديات'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChallengeList()),
                    );
                  },
                ),
                // الاهداف

                ListTile(
                  leading: Icon(
                    Icons.list,
                    color:Colors.amber,
                  ),
                  title: Text('الأهداف'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanScreen()),
                    );
                  },
                ),
                // المفضله

                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.amber,
                  ),
                  title: Text('المفضلة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoritScreen()),
                    );
                  },
                ),
                // التقارير

                ListTile(
                  leading: Icon(
                    Icons.local_activity,
                    color: Colors.amber,
                  ),
                  title: Text('النشاطات'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityReportPage()),
                    );
                  },
                ),
                // حاسبة الصحة

                ListTile(
                  leading: Icon(
                    Icons.calculate,
                    color:Colors.amber,
                  ),
                  title: Text('حاسبة صحة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Calculator()),
                    );
                  },
                ),

                //  عن التطبيق

                ListTile(
                  leading: Icon(
                    Icons.help_outline_outlined,
                    color:Colors.amber,
                  ),
                  title: Text(' عن التطبيق'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),


                // اختبار التقارير

                ListTile(
                  leading: Icon(
                    Icons.help_outline_outlined,
                    color:Colors.amber,
                  ),
                  title: Text('اختبار تقارير '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerformanceTrackingPage()),
                    );
                  },
                ),


                // اختبار التوصيات  

                ListTile(
                  leading: Icon(
                    Icons.help_outline_outlined,
                    color:Colors.amber,
                  ),
                  title: Text('اختبار التوصيات '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserInputPage()),
                    );
                  },
                ),
      //  مقالات   

                ListTile(
                  leading: Icon(
                    Icons.help_outline_outlined,
                    color:Colors.amber,
                  ),
                  title: Text('مقالات  '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlesPage()),
                    );
                  },
                ),



                // تسجيل الخروج

                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color:Colors.amber,
                  ),
                  title: Text('تسجيل الخروج'),
                  onTap: () {
                    // تعديل السطر الذي يتم النقر عليه
                    // لتنفيذ الإجراء المطلوب

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('تسجيل الخروج'),
                          content: Text('هل أنت متأكد من تسجيل الخروج ؟'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // إغلاق نافذة الحوار
                                Navigator.pop(context);
                              },
                              child: Text('لا'),
                            ),
                            TextButton(
                              onPressed: signUserOut,
                              child: Text('نعم'),
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
       
 
      
        // تابع شريط السفلي

        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(),
            HealthyNutrition(),
            MainExercises(),
            PlanScreen(),
            ChallengeList(),
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
              icon: Icon(Icons.fastfood),
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
              icon: Icon(Icons.emoji_events),
              label: 'التحديات',
            ),
          ],

          backgroundColor: Colors.white, // لون خلفية الـ BottomNavigationBar
          unselectedItemColor: Colors.black, // لون الأيقونات غير المحددة
          selectedItemColor:
              Colors.amber, // لون الأيقونة المحددة
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [  
                SizedBox(height: 15),
                ExerciseSection(),      
                SizedBox(height: 25),
                DailySummary(),
                SizedBox(height: 15),
                QuickAccessButtons(),
                SizedBox(height: 15),
                // ChallengesSection(),
                RecommendedWorkouts(),
                SizedBox(height: 20),
                CurrentChallenges(),
                                     
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// الملخص اليومي 

class DailySummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الملخص اليومي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SummaryItem(title: 'Steps', value: '5000'),
                SummaryItem(title: 'Calories', value: '300'),
                SummaryItem(title: 'Active', value: '30 min'),
  // استخدام Consumer لعرض كمية المياه المستهلكة
                Consumer<WaterProvider>(
                  builder: (context, waterProvider, child) {
                    return SummaryItem(
                      title: 'Water',
                      value: '${waterProvider.dailyProgress / 1000} L', // عرض كمية المياه المستهلكة باللتر
                    );
                  },
                ),              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
          onPressed: () {},
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          )),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          // fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ]);
  }
}

// جزئية الخاصة بي عرض التمارين 

class ExerciseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text(
                "التمارين",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: TextButton(
                onPressed: () {
                  // عند النقر على عرض الكل
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainScreen()),
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
            // تمارين مختلفة
            ExerciseItem(
                imagePath: "assets/images/gym4.jpg", title: "تمارين الصدر",onPressed: (){}),
            ExerciseItem(
                imagePath: "assets/images/gym6.jpg", title: "تمارين القوة",onPressed: (){}),
            ExerciseItem(
                imagePath: "assets/images/gym5.jpg", title: "تمارين الأرجل",onPressed: (){}),
            ExerciseItem(
                imagePath: "assets/images/gym3.jpg", title: "تمارين الصدر",onPressed: (){}),
            ExerciseItem(
                imagePath: "assets/images/gym2.jpg", title: "تمارين بايسيبس",onPressed: (){}),
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
      ],
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final String imagePath;
  final String title;
    final VoidCallback onPressed;


  ExerciseItem({required this.imagePath, required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ازرار الوصول السريع 

class QuickAccessButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        QuickAccessButton(icon: Icons.fitness_center, label: 'Workout', onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainExercises()),
                    );
          // Handle workout button press
        }),
        QuickAccessButton(icon: Icons.fastfood, label: 'Meal', onPressed: () {
          // Handle meal button press
          
        }),
        QuickAccessButton(icon: Icons.local_drink, label: 'Water', onPressed: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaterTrackerPage()),
                    );
          // Handle sleep button press
        }),
      ],
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  QuickAccessButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32,color: Colors.amber,),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

// الخط الفاصل 

class ChallengesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),
        // هنا يمكن إضافة المزيد من المكونات لعرض التحديات
      ],
    );
  }
}

// التمارين الموصي بيها 

class RecommendedWorkouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التمارين الموصى بها', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            WorkoutItem(title: 'Morning Yoga', duration: '30 min'),
            WorkoutItem(title: 'Cardio Blast', duration: '45 min'),
            WorkoutItem(title: 'Strength Training', duration: '60 min'),
          ],
        ),
      ),
    );
  }
}

class WorkoutItem extends StatelessWidget {
  final String title;
  final String duration;

  WorkoutItem({required this.title, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(duration, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}

// جزئية التحديات 

class CurrentChallenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final challengeProvider = Provider.of<ChallengeProvider>(context);
    final selectedChallenges = challengeProvider.selectedChallenges;
     return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التحديات الحالية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (selectedChallenges.isEmpty)
              Text('لا يوجد تحديات حالية', style: TextStyle(fontSize: 14, color: Colors.grey))
            else
              ...selectedChallenges.map((challenge) {
                final progress = challengeProvider.getProgress(challenge);
                final progressPercent = ((progress / challenge.durationDays) * 100).toStringAsFixed(1) + '%';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChallengeDetailScreen(challenge: challenge),
                      ),
                    );
                  },
                  child: ChallengeItem(title: challenge.name, progress: progressPercent),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}


class ChallengeItem extends StatelessWidget {
  final String title;
  final String progress;

  ChallengeItem({required this.title, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(progress, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}