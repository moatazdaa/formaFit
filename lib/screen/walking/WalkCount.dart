import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/walking/WalkKmNumberPicker.dart';
import 'package:formafit/screen/walking/WalkStepNumberPicker.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkCount extends StatefulWidget {
  const WalkCount({Key? key}) : super(key: key);

  @override
  State<WalkCount> createState() => _WalkCountState();
}

class _WalkCountState extends State<WalkCount> {
  Stream<StepCount>? stepCountStream;
  late Stream<PedestrianStatus> pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  String status = 'ابدا في الحركه';

  //متغير يستخدم لعرض الخطوات
  int currentSteps = 0;
  //متغير يستخدم لتخزين عدد الخطوات اللتي تم مشيها
  int lastResetSteps = 0;

  // متغير يستخدم لمعرفة حاله العداد هل يحسب الخطوات اولا
  bool isCountStop = false;

  Timer? timer;
  //متغير يستحدم لحساب التواني
  int seconds = 0;
// متغير يستخدم لتغيير العداد من خطوات الى كم
  bool isStep_Or_Km = false;

  Future<void> addWalkData(int steps, int seconds, double meters, int goolStep,
      double Cal, double kmGoal, double kmWalk) async {
    try {
      // احصل على المستخدم الحالي
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // مرجع المجموعة
        final userWalkRef = FirebaseFirestore.instance.collection("UserWalk");

        // احصل على التاريخ الحالي بدون وقت
        final today = DateTime.now();
        final dayStart = DateTime(today.year, today.month, today.day);

        // تحقق مما إذا كان المستند موجود أم لا
        final querySnapshot = await userWalkRef
            .where('UserId', isEqualTo: user.uid)
            .where('Day', isEqualTo: Timestamp.fromDate(dayStart))
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // المستند موجود، قم بجلب القيم الحالية وأضف القيم الجديدة
          final doc = querySnapshot.docs.first;
          final currentData = doc.data() as Map<String, dynamic>;

          final updatedSteps = currentData['Steps'] + steps;
          final updatedSeconds = currentData['Seconds'] + seconds;
          final updatedMeters = currentData['Meters'] + meters;
          final updatedCal = currentData['Cal'] + Cal;
          final updatedkmWalk = currentData['kmWalk'] + kmWalk;

          await doc.reference.update({
            'Steps': updatedSteps,
            'Seconds': updatedSeconds,
            'Meters': updatedMeters,
            'Cal': updatedCal,
            'kmWalk': updatedkmWalk
          });
        } else {
          // المستند غير موجود، قم بإنشاء مستند جديد
          await userWalkRef.add({
            'UserId': user.uid,
            'Steps': steps,
            'Seconds': seconds,
            'Meters': meters,
            'Day': Timestamp.fromDate(dayStart),
            'StepGoal': goolStep,
            'Cal': Cal,
            'kmGoal': kmGoal,
            'kmWalk': kmWalk
          });
          ;
        }
        print("Data added/updated successfully!");
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Failed to add/update data: $e");
    }
  }

  Future<void> fetcWalkhdata() async {
    try {
      // احصل على المستخدم الحالي
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // مرجع المجموعة
        final userWalkRef = FirebaseFirestore.instance.collection("UserWalk");

        // احصل على التاريخ الحالي بدون وقت
        final today = DateTime.now();
        final dayStart = DateTime(today.year, today.month, today.day);

        // تحقق مما إذا كان المستند موجود أم لا
        final querySnapshot = await userWalkRef
            .where('UserId', isEqualTo: user.uid)
            .where('Day', isEqualTo: Timestamp.fromDate(dayStart))
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // المستند موجود، جلب القيم المطلوبة
          final doc = querySnapshot.docs.first;
          final data = doc.data() as Map<String, dynamic>;

          // جلب القيمة المطلوبة
          circular_count = (data['StepGoal'] ?? 0)
              .toInt(); // استخدم قيمة الخطوات المخزنة، أو 0 إذا لم تكن موجودة

          setState(() {
            kmWalk = (data['kmWalk']) ?? 0;
            kmGoal = (data['kmGoal']) ?? 0;
            print("ظظظظظظظظظظظظظظظظظظظ ");
            print(kmWalk);
          });

          //  تحديث القيمة في Provider
          // Provider.of<Provfile2>(context, listen: false)
          //     .UpdateWalkKmProvide(kmwalk);

          // Provider.of<Provfile2>(context, listen: false)
          //     .UpdateWalkgoalProvide(kmgoal);
        } else {}
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Failed to fetch data $e");
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void ResetTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isCountStop = false;
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  String formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    loadSteps();
    resetSteps();

    fetcWalkhdata();
    print(kmWalk);
  }

//داله توقف الاستماع
  void cancelStreamSubscriptions() {
    _pedestrianStatusSubscription?.cancel();
    _stepCountSubscription?.cancel();
  }

//داله بدء الاستماع
  void initPlatformState() {
    pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusSubscription = pedestrianStatusStream.listen(
      onPedestrianStatusChanged,
      onError: onPedestrianStatusError,
    );

    stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = stepCountStream?.listen(
      onStepCount,
      onError: onStepCountError,
    );
  }

  Future<void> saveSteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedSteps', steps);
  }

  Future<void> deleteSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedSteps'); // حذف البيانات المحفوظة مسبقًا
  }

  Future<void> loadSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastResetSteps = prefs.getInt('savedSteps') ?? 0;
    });
  }

  Future<void> resetSteps() async {
    loadSteps();
    setState(() {
      currentSteps = 0;
    });
  }

  void onStepCount(StepCount event) {
    setState(() {
      currentSteps = event.steps - lastResetSteps;
      saveSteps(lastResetSteps + currentSteps); // حفظ العدد الجديد من الخطوات

      if (currentSteps >= circular_count) {
        cancelStreamSubscriptions();
        stopTimer();
      }
    });
  }

//تستخدم هدة الداله  لتوقف العداد
  double getPercentValue(int currentSteps, int circular_count) {
    double percent = currentSteps / circular_count;
    return percent > 1.0 ? 1.0 : percent;
  }

  double getPercentValuekm(double kmwalk, double kmgoal) {
    double percent = kmwalk / kmgoal;
    return percent > 1.0 ? 1.0 : percent;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      status = 'حالة المشاة غير متاحة';
    });
  }

  void onStepCountError(error) {
    setState(() {
      status = 'عدد الخطوات غير متاح';
    });
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    // هادا المتغير يستخدم لعرض البيانات المستهدفة

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Icon(
                    status == 'walking'&&isCountStop==true
                        ? Icons.directions_walk
                        : status == 'stopped'
                            ? Icons.accessibility_new
                            : Icons.error,
                    size: 45,
                  )),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // actions: [
        //   Text(
        //     //عرض الرمين بعد الفاصله
        //     "${formatDuration(seconds)} Time",

        //     style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        //   ),
        //   SizedBox(
        //     width: 20,
        //   ),
        // ],
        actions: [
          PopupMenuButton<String>(
            constraints: BoxConstraints(
                minHeight: 0.0,
                minWidth: 0.0,
                maxHeight: double.infinity,
                maxWidth: double.infinity),
            onSelected: (String value) {
              // تصرف بناءً على القيمة المختارة
              if (value == 'تعديل المسافة ') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KmNumberPiker()));
              }
              if (value == 'تعديل عدد الخطوات') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StepWalkNumperPicker()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'تعديل المسافة ',
                child: Text('تعديل المسافة '),
              ),
              PopupMenuItem<String>(
                value: 'تعديل عدد الخطوات',
                child: Text('تعديل عدد الخطوات'),
              ),
            ],
            icon: Icon(
              Icons.density_small_sharp,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),

                  CircularPercentIndicator(
                    radius: 130.0,
                    lineWidth: 15.0,
                    percent: isStep_Or_Km
                        ? getPercentValue(currentSteps, circular_count)
                        : getPercentValuekm(kmWalk, kmGoal),
                    center: Text(
                      isStep_Or_Km
                          ? "${currentSteps.toString()}/ ${circular_count.toString()}"
                          : "${kmGoal.toStringAsFixed(3)}/ ${kmWalk.toStringAsFixed(3)}",
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Bebas',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    progressColor: Colors.blue,
                  ),
                  // في حال وصول currentSteps إلى circular_count، استدعي الدالة
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isStep_Or_Km = !isStep_Or_Km;
                            });
                          },
                          child: Icon(
                            Icons.change_circle,
                            size: 30,
                          )),
                      Text(isStep_Or_Km ? "خطوة" : "كم",
                      style: TextStyle(
                  fontSize: 20,fontStyle: FontStyle.italic,
                      ),)
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Divider(
                    height: 25,
                    thickness: 3,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الزمن',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${formatDuration(seconds)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'CALORIES',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '259',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.bolt)
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'المسافة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${kmWalk.toStringAsFixed(3)} كم',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 3,
                    height: 25,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    height: 35,
                  ),

                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 0, 0),
                                    Color.fromARGB(255, 255, 61, 61)
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        3, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(
                                    8), // for rounded corners
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("اعادة ضبط عداد الخطوات"),
                                        content: Text(
                                            "هل أنت متأكد أنك تريد اعادة ضبط"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("إلغاء"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              {
                                                ResetTimer();
                                                resetSteps();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("تأكيد"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "إعادة تعيين",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 61, 100, 241),
                                    Color.fromARGB(255, 86, 125, 231)
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        3, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(
                                    8), // for rounded corners
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (currentSteps > 0)
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("حفظ البيانات"),
                                          content: Text(
                                              "هل أنت متأكد أنك تريد حفظ البيانات"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("إلغاء"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                {
                                                  await addWalkData(
                                                      currentSteps,
                                                      seconds,
                                                      currentSteps * 0.75,
                                                      circular_count,
                                                      1000,
                                                      kmGoal,
                                                      currentSteps / 1315);
                                                  await fetcWalkhdata();
                                                  ResetTimer();
                                                  resetSteps();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "تم حفظ البيانات بنجاح"),
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("تأكيد"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                },
                                child: Text(
                                  textAlign: TextAlign.right,
                                  "حفظ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: isCountStop
                                    ? LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 255, 0, 0),
                                          Color.fromARGB(255, 255, 61, 61)
                                        ],
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 25, 200, 13),
                                          Color.fromARGB(255, 15, 255, 51)
                                        ],
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        3, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(
                                    8), // for rounded corners
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (isCountStop == false) {
                                      initPlatformState();
                                      startTimer();
                                      isCountStop = true;
                                    } else {
                                      cancelStreamSubscriptions();
                                      stopTimer();
                                      isCountStop = false;
                                    }
                                  });
                                },
                                child: Text(
                                  textAlign: TextAlign.right,
                                  isCountStop ? "ايقاف" : "بدء",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 3,
                    height: 25,
                    color: Colors.grey[300],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
