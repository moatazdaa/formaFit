import 'package:flutter/material.dart';
import 'package:formafit/screen/challenges/challengDetail1.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/challengeProvider.dart';

class ChallengeList extends StatefulWidget {
  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  final List<Challenge> challenges = [
    Challenge('تحدي الـ30 يوم تمرينات بطن', 'تمارين بطن يومية لمدة 30 يومًا', 30, 7, 'متوسط', 'assets/images/challBatan.jpg'),
    Challenge('تحدي الحبل', 'قفز بالحبل نصف ساعة يوميا لمدة شهرين', 60, 6, 'متوسط', 'assets/images/challJump.jpg'),
    Challenge('تحدي البلانك', 'تمارين البلانك لمدة أسبوعين ', 15, 5, 'صعب', 'assets/images/challPlank.jpg'),
    Challenge('تحدي الضغط', 'تمارين 25 ضغط ', 10, 7, 'سهل', 'assets/images/challPushUp.png'),
    Challenge('تحدي الجري 5 كيلو', 'جري يومي لمدة 10 أيام', 10, 7, 'سهل', 'assets/images/chall3.jpg'),
    Challenge('تحدي الـ10 آلاف خطوة', 'مشي 10 آلاف خطوة يوميًا لمدة 45 يومًا', 45, 7, 'سهل', 'assets/images/chall3.jpg'),
    Challenge('تحدي التسلق', 'تمارين التسلق لمدة 4 أسابيع', 28, 5, 'متوسط', 'assets/images/chall3.jpg'),
  ];

  void _handleSingleTap(ChallengeProvider challengeProvider, Challenge challenge) {
    challengeProvider.toggleChallenge(challenge, context);
  }

  void _handleDoubleTap(Challenge challenge) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChallengeDetailScreen(challenge: challenge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('التحديات'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          final isSelected = challengeProvider.selectedChallenges.any((c) => c.name == challenge.name);

          return GestureDetector(
            onTap: () => _handleSingleTap(challengeProvider, challenge),
            onDoubleTap: () => _handleDoubleTap(challenge),
            child: GridTile(
              child: Card(
                elevation: 5.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.asset(
                        challenge.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(challenge.description),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'تم اختيار هذا التحدي',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
