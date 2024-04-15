// ignore: unused_import
// ignore_for_file: empty_constructor_bodies

// ignore: unused_import

import 'package:flutter/material.dart';
//مكتبة خاصة للموقت
import 'dart:async';







class item {
  String main_image;
  String name;
  String count;
  String explane;
  String image1;
  String image2;
  bool explane_state;

  item({required this.main_image,required this.name,required this.count,
  required this.explane,required this.image1,required this.image2,
  required this.explane_state,});

}


List<item>exsrsis_list=[
item(main_image:'assets/images/v_up.gif', name: 'v_up', count: '20 X2',
 explane: "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
  image1: "assets/images/leg.jpg", image2: "assets/images/six_back.jpg", explane_state: false)
,
item(main_image:'assets/images/pull_up.gif', name: 'pull_up', count: '16 X2',
 explane: "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
  image1: "assets/images/leg.jpg", image2: "assets/images/six_back.jpg", explane_state: false)
,

item(main_image:'assets/images/squats.gif', name: 'squats', count: '20 X3',
 explane: "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
  image1: "assets/images/leg.jpg", image2: "assets/images/six_back.jpg", explane_state: false)
,
item(main_image:'assets/images/bicycle_crunches.gif', name: 'bicycle_crunches', count: '35 X1',
 explane: "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
  image1: "assets/images/leg.jpg", image2: "assets/images/six_back.jpg", explane_state: false)
,
item(main_image:'assets/images/abdominal.gif', name: 'abdominal', count: ' 40 X2',
 explane: "وضع ساق واحدة الى الامام مع ثني الركبة واصابع القدم على الارض بينما يتم وضع الساق الاخرى الى الخلف",
  image1: "assets/images/six_back.jpg", image2: "assets/images/back.jpg", explane_state: false)
,
item(main_image:'assets/images/alternating_lunge.gif', name: 'alternating_lunge', count: ' 30 X1',
 explane: "في وضع الرقود على الظهر ومع اليدين خلف الراس نرجع الجزء العلوي من الجسم من على الارض الى الاعلى بقدر الامكان ونعود ببطء الى وضع الرقود",
  image1: "assets/images/leg.jpg", image2: "assets/images/back.jpg", explane_state: false)
,
];



//هدة اللست خاصة بتمارين الصاله
List<item>hall_list=[
item(main_image:'assets/images/oblique_dumbell.gif', name: 'Oblique Dumbell', count: '25 X3',
 explane: "ابدا بالجلوس على مقعد مائل مع تتبيث قدميك على الارض احمل دراعيك الى جانبك مع ابقاء المعصم مستقيم قدر الامكان",
  image1: "assets/images/arm.jpg", image2: "assets/images/bay.jpg", explane_state: false)
,
item(main_image:'assets/image/back_pull.gif', name: 'Back pull', count: '17 X2',
 explane: "تبث الركب على الارض واجلس بشكل مستقيم ثم قم بسحب الوزن الى الخلف حتى تصل يديك الى خفل راسك ثم قم برد الوزن ودراعيك بشكل مستقيم",
  image1: "assets/images/back.jpg", image2: "assets/images/arm.jpg", explane_state: false)
,

item(main_image:'assets/image/back_fly.gif', name: 'Back fly', count: '30 X1',
 explane: "اجلس على مقعد الجهاز وقم بضغط مرفقيك الى المام والخلف مع الالتزام بالشهيق والزفير",
  image1: "assets/images/arm.jpg", image2: "assets/images/back.jpg", explane_state: false)
,
item(main_image:'assets/images/pull_down_bar.gif', name: 'Pull down bar', count: '20 X2',
 explane: "اجلس في مواجهه الاله واسند ركبيك على الوسادة خد شهيقا واسحب الوزن الى الاسفل ثم ارجع مرفقيك مرة اخرى",
  image1: "assets/images/back.jpg", image2: "assets/images/bay.jpg", explane_state: false)
,

item(main_image:'assets/images/dumbblee_lunge.gif', name: 'Dumbblee lunge', count: '24 X1',
 explane: "قف مع المباعدة بين قدميك على عرض الوسط وارفع ثقلا خفيفا الى اعلى الكتفين  خد شهيقا وخد خطوة مريحة الى الامام مع ابقاء الجدع في وضع مستقيم",
  image1: "assets/images/leg.jpg", image2: "assets/images/leg.jpg", explane_state: false)
,
item(main_image:'assets/images/squatting.gif', name: 'Squatting', count: '10 X2',
 explane: "هدة الحركة هي نفس حركة القرفزاء العادية لاكن ساقيك متبتعدة على نطاق واسع مع توجيه اصابع قدميك الى الخارج",
  image1: "assets/images/leg.jpg", image2: "assets/images/leg.jpg", explane_state: false)
,
];

class tip_item{
 String titl;
 String contant;
 bool read_state;

 tip_item({required this.titl,required this.contant,required this.read_state,});
}
 










// ignore: non_constant_identifier_names
bool check_state = false;

class MyCounter extends StatefulWidget {
  @override
  _MyCounterState createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int minutes = 1;
  int seconds = 30;
  late Timer timer;
  bool isTimerRunning = true;

  @override
  
  void initState() {
    super.initState();
    startTimer();
  }


  void startTimer() {

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
          
          
            timer.cancel();
          
          }
        }
      });
    });
  }

  void toggleTimer() {
    if (isTimerRunning) {
      timer.cancel();
    } else {
      startTimer();
    }
    setState(() {
      isTimerRunning = !isTimerRunning;
    });
  }

  Color getButtonColor() {
    return isTimerRunning ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Color.fromARGB(245, 245, 247, 252),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(239, 145, 149, 159),
        title: Text('Timer', 
        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold)
        ,),
      ),
      body: Container(
                      decoration: BoxDecoration(
                          //  تدريج الوان
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                             Color.fromARGB(196, 192, 196, 203),
                            Color.fromRGBO(221, 223, 232, 0.692)
                          ])),
                                  width: double.infinity,
                                  height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$minutes:${seconds < 10 ? '0' : ''}$seconds',
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: toggleTimer,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(getButtonColor()),
                ),
                child: Text(
                  isTimerRunning ? 'Stop' : 'Start',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  
                  timer.cancel();
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  
  }
}
