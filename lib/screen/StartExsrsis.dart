import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formafit/classes/gym_exercises.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class startexsrsis extends StatefulWidget {
  final List<exsrsis_item> exrsisplan;
  final String dayid;

  startexsrsis({required this.exrsisplan, required this.dayid});

  @override
  _ExsrsisInPlanState createState() => _ExsrsisInPlanState();
}

class _ExsrsisInPlanState extends State<startexsrsis> {
  int _currentIndex = 0;
  late Timer _timer;
  late Duration _currentTime;
  bool _isPaused = false; // متغير يحدد حالة التوقف/الاستمرار
  List<Duration> completedTimes = [];

  @override
  void initState() {
    super.initState();

    // جلب بيانات التمارين المنجزة من Firestore عند فتح الصفحة
    _fetchDayData();

    if (widget.exrsisplan.isNotEmpty) {
      _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
      _startTimer();
    }
  }

  void _fetchDayData() async {
    DocumentSnapshot dayDoc = await FirebaseFirestore.instance
        .collection('days')
        .doc(widget.dayid)
        .get();
    if (dayDoc.exists) {
      Map<String, dynamic> dayData = dayDoc.data() as Map<String, dynamic>;
      setState(() {
        Map<dynamic, dynamic> completedExsrsisTimes =
            dayData['completedExsrsisTimes'] ?? {};
        completedExsrsisTimes.forEach((key, value) {
          int exerciseId = int.parse(key);
          int index = widget.exrsisplan
              .indexWhere((exercise) => exercise.id == exerciseId);
          if (index != -1) {
            widget.exrsisplan[index].isCompleted = value;
          }
        });
      });

      // يتم تعيين القيم المطلوبة فقط إذا كانت القائمة فارغة
      if (widget.exrsisplan.isEmpty) {
        _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!_isPaused) {
          if (_currentTime.inSeconds > 0) {
            _currentTime -= Duration(seconds: 1);
          } else {
            if (_currentIndex < widget.exrsisplan.length - 1) {
              _currentIndex++;
              _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
            } else {
              timer.cancel();
            }
          }
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused; // تبديل حالة التوقف/الاستمرار
    });
  }

  void nextexsrsis() {
    setState(() {
      if (_currentIndex < widget.exrsisplan.length - 1 && !_isPaused) {
        _currentIndex++;
        _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
      }
    });
  }

  void lastexsrsis() {
    setState(() {
      if (_currentIndex > 0 && !_isPaused) {
        _currentIndex--;
        _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
      }
    });
  }

  void add10Second() {
    setState(() {
      _currentTime += Duration(seconds: 10);
    });
  }

  void addMinutes() {
    setState(() {
      _currentTime += Duration(minutes: 1);
    });
  }

  // دالة تستخدم لانجاز التمرين واضافة الزمن الى متغير في provid
  // دالة لتحديث قيمة isCompleted في Firestore عند الانتهاء من التمرين
  void CompletedExsrsis() async {
    setState(() {
      _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
      widget.exrsisplan[_currentIndex].isCompleted = true;
    });

    int exerciseId = widget.exrsisplan[_currentIndex].id;

    // جلب الوثيقة باستخدام استعلام where للتحقق من وجود المستند
    QuerySnapshot exerciseSnapshot = await FirebaseFirestore.instance
        .collection("days")
        .doc(widget.dayid)
        .collection("exercises")
        .where("id", isEqualTo: exerciseId)
        .limit(1)
        .get();

    // التحقق من وجود الوثيقة
    if (exerciseSnapshot.docs.isNotEmpty) {
      // تحديث حالة التمرين في Firestore
      try {
        // استخراج معرف المستند من الوثيقة المسترجعة
        String docId = exerciseSnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection("days")
            .doc(widget.dayid)
            .collection("exercises")
            .doc(docId)
            .update({"isCompleted": true});
        print("تم التعديل");
      } catch (error) {
        print("Error updating document: $error");
      }
    } else {
      print("Document does not exist.");
    }
    nextexsrsis();
  }

  void resetExsrsis() async {
    setState(() {
      _currentTime = widget.exrsisplan[_currentIndex].ExrsisTime;
      widget.exrsisplan[_currentIndex].isCompleted = false;
    });

    int exerciseId = widget.exrsisplan[_currentIndex].id;

    // جلب الوثيقة باستخدام استعلام where للتحقق من وجود المستند
    QuerySnapshot exerciseSnapshot = await FirebaseFirestore.instance
        .collection("days")
        .doc(widget.dayid)
        .collection("exercises")
        .where("id", isEqualTo: exerciseId)
        .limit(1)
        .get();

    // التحقق من وجود الوثيقة
    if (exerciseSnapshot.docs.isNotEmpty) {
      // تحديث حالة التمرين في Firestore
      try {
        // استخراج معرف المستند من الوثيقة المسترجعة
        String docId = exerciseSnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection("days")
            .doc(widget.dayid)
            .collection("exercises")
            .doc(docId)
            .update({"isCompleted": false});
        print("تم التعديل");
      } catch (error) {
        print("Error updating document: $error");
      }
    } else {
      print("Document does not exist.");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    completedTimes = List.filled(widget.exrsisplan.length, Duration.zero);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
        ),
      ),
      body: FractionallySizedBox(
        widthFactor: 0.98,
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Image.asset(
              widget.exrsisplan[_currentIndex].main_image,
              width: 350,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              widget.exrsisplan[_currentIndex].name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: addMinutes,
                        child: Text(
                          '+1 دقيقة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: _togglePause,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              _isPaused ? Colors.red : Colors.green,
                        ),
                        child: Text(
                          _isPaused ? 'استمرار' : 'إيقاف',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 10,
                    percent: (widget.exrsisplan[_currentIndex].isCompleted
                            ? 1.0
                            : _currentTime.inSeconds /
                                widget.exrsisplan[_currentIndex].ExrsisTime
                                    .inSeconds)
                        .clamp(0.0, 1.0),
                    center: Text(
                      widget.exrsisplan[_currentIndex].isCompleted
                          ? '00:00'
                          : "${_currentTime.inMinutes}:${(_currentTime.inSeconds % 60).toString().padLeft(2, '0')}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.grey,
                    progressColor: widget.exrsisplan[_currentIndex].isCompleted
                        ? Color.fromARGB(255, 124, 126, 128)
                        : Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: add10Second,
                        child: Text(
                          '+10 ثانية',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: resetExsrsis,
                          child: Text(
                            "اعادة تعيين",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 140,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Card(
                    child: InkWell(
                      onTap: lastexsrsis,
                      child: ListTile(
                        leading: Icon(Icons.arrow_back_ios),
                        title: Text(
                          "السابق",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Card(
                    color: widget.exrsisplan[_currentIndex].isCompleted
                        ? Colors.green
                        : Colors.blue,
                    child: InkWell(
                      onTap: () {
                        if (!widget.exrsisplan[_currentIndex].isCompleted) {
                          CompletedExsrsis();
                        }
                      },
                      child: ListTile(
                        title: Text(
                          widget.exrsisplan[_currentIndex].isCompleted
                              ? "   منجز "
                              : "    تم",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Card(
                    child: InkWell(
                      onTap: nextexsrsis,
                      child: ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "التالي",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
