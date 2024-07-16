import 'package:cloud_firestore/cloud_firestore.dart';

class exsrsis_item {
  String main_image;
  String name;
  int id;
  List<Round> round;
  int rating;
  List<String> explane;
  String image1;
  String image2;
  bool explane_state;
  bool isCompleted;
  Duration ExrsisTime;
  List<String> ExsrsisGoal;

  exsrsis_item({
    required this.main_image,
    required this.name,
    required this.id,
    required this.round,
    required this.rating,
    required this.explane,
    required this.image1,
    required this.image2,
    required this.explane_state,
    required this.isCompleted,
    required this.ExrsisTime,
    required this.ExsrsisGoal
  });

  factory exsrsis_item.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return exsrsis_item(
      main_image: data['main_image'] ?? '',
      name: data['name'] ?? '',
      id: data['id'] ?? 0,
      round: (data['round'] as List<dynamic>?)
              ?.map(
                  (round) => Round.fromFirestore(round as Map<String, dynamic>))
              .toList() ??
          [],
      rating: data['rating'] ?? 0,
      explane: List<String>.from(data['explane'] ?? []),
      image1: data['image1'] ?? '',
      image2: data['image2'] ?? '',
      explane_state: data['explane_state'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
      ExrsisTime: Duration(seconds: data['ExrsisTime'] ?? 0),
        ExsrsisGoal: List<String>.from(data['ExsrsisGoal'] ?? []),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'main_image': main_image,
      'name': name,
      'id': id,
      'rounds': round.map((round) => round.toFirestore()).toList(),
      'rating': rating,
      'explane': explane,
      'image1': image1,
      'image2': image2,
      'explane_state': explane_state,
      'isCompleted': isCompleted,
      'ExrsisTime': ExrsisTime.inSeconds,
      'ExsrsisGoal':ExsrsisGoal
    };
  }
}
////////////////////////////////////

////////////////////////////
class Round {
  int roundNumber;
  int count;

  Round({
    required this.roundNumber,
    required this.count,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'roundNumber': roundNumber,
      'count': count,
    };
  }

  factory Round.fromFirestore(Map<String, dynamic> data) {
    return Round(
      roundNumber: data['roundNumber'] ?? 0,
      count: data['count'] ?? 0,
    );
  }
}

class Day {
  String name;
  DateTime date;
  int order;
  String weekId;
  Map<int, bool> CompletedExsrsisTimes;
  bool dayState;

  Day({
    required this.name,
    required this.date,
    required this.order,
    required this.weekId,
    this.CompletedExsrsisTimes = const {},
    this.dayState = true,
  });

  factory Day.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Day(
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      order: data['order2'] ?? 0,
      weekId: data['weekId'] ?? '',
      dayState: data['dayState'] ?? true,
      CompletedExsrsisTimes: data['completedExsrsisTimes'] is Map<int, bool>
          ? Map<int, bool>.from(data['completedExsrsisTimes'])
          : {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      // 'date': date.toIso8601String(),
      'order2': order,
      //  'dayState': dayState,
      'completedExsrsisTimes': CompletedExsrsisTimes,
    };
  }
}

class Week {
  String id; // Add the id property
  String name;
  int order;

  Week({
    required this.id,
    required this.name,
    required this.order,
  });

  factory Week.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Week(
      id: doc.id, // Set the id from document id
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'order': order,
    };
  }
}

class Plans {
  String id; // Add the id property
  String userId;
  String name;
  String details;
  String goal;
  int harder;
  int WeekCount;

  Plans({
    required this.id,
    required this.userId,
    required this.name,
    required this.details,
    required this.goal,
    required this.harder,
    required this.WeekCount,
  });

  factory Plans.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Plans(
      id: doc.id, // Set the id from document id
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      details: data['details'] ?? '',
      goal: data['goal'] ?? '',
      harder: data['harder'] ?? 0,
      WeekCount: data['weekCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'details': details,
      'goal': goal,
      'harder': harder,
      'WeekCount': WeekCount,
    };
  }
}

extension RoundExtensions on Round {}

List<exsrsis_item> chest_list = [
  exsrsis_item(
      main_image: 'assets/images/v_up.gif',
      name: 'omadf',
      id: 1,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
      ],
      rating: 3,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
        'رفع وخفض الجسم على التواي وهادا ال',
        'رفع وخفض الج'
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 1),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],
      ),
  exsrsis_item(
      main_image: 'assets/images/v_up.gif',
      name: 'l',
      id: 2,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
      ],
      rating: 3,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين"
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 1),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],),
  exsrsis_item(
      main_image: 'assets/images/v_up.gif',
      name: 't',
      id: 3,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
          Round(roundNumber: 3, count: 11),
        Round(roundNumber: 4, count: 9),
          Round(roundNumber: 5, count: 20),
        Round(roundNumber: 6, count: 18),
      ],
      rating: 1,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
        'رفع وخفض الجسم على التواي وهادا ال',
        'رفع وخفض الج'
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 1),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],),
];

// قائمة خاصة بتمارين الارجل
List<exsrsis_item> legs_list = [
  exsrsis_item(
      main_image: 'assets/images/v_up.gif',
      name: 'a',
      id: 4,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
      ],
      rating: 1,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين"
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 1),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],),
  exsrsis_item(
      main_image: 'assets/images/back_fly.gif',
      name: 'b',
      id: 5,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
      ],
      rating: 1,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين"
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 3),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],),
  exsrsis_item(
      main_image: 'assets/images/v_up.gif',
      name: 'd',
      id: 6,
      round: [
        Round(roundNumber: 1, count: 20),
        Round(roundNumber: 2, count: 18),
      ],
      rating: 1,
      explane: [
        "رفع وخفض الجسم على التواي وهادا التمرين يعمل على عضلات الصدر والكتفين والظهر والساقين",
        'رفع وخفض الجسم على التواي وهادا ال',
        'رفع وخفض الج'
      ],
      image1: "assets/images/leg.jpg",
      image2: "assets/images/six_back.jpg",
      explane_state: false,
      isCompleted: false,
      ExrsisTime: Duration(minutes: 2),
        ExsrsisGoal: [
        "زيادة القوة العضلية",
        'زيادة التحمل ',
        'تقوية عضلة الصدر'
      ],)
];

//هدة القائمه خاصة بتمارين الارداف
List<exsrsis_item> buttocks_list = [];

//هدة القائمه خاصة بتمارين القوة
List<exsrsis_item> power_list = [];

//هدة القائمه خاصة بتمارين الظهر
List<exsrsis_item> back_list = [];

//هدة القائمه خاصة بتمارين اليدين
List<exsrsis_item> hand_list = [];

//هدة القائمه خاصة بتمارين السواعد
List<exsrsis_item> handCranks_list = [];

//هدة القائمه خاصة بتمارين الاكتاف
List<exsrsis_item> shoulder_list = [];

//هدة القائمه خاصة بتمارين المعدة
List<exsrsis_item> stomach_list = [];

//هدة القائمه خاصة بتمارين عضلة ثلاثية الرووس
List<exsrsis_item> triceps_list = [];
