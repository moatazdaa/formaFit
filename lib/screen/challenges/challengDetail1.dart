import 'package:flutter/material.dart';
import 'package:formafit/screen/challenges/challengeList.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/challengeProvider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  ChallengeDetailScreen({required this.challenge});

  @override
  _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);

    // Get the progress of the challenge
    int progress = challengeProvider.getProgress(widget.challenge);
    bool isChallengeStarted = progress > 0;
    bool isChallengeCompleted = progress >= widget.challenge.durationDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('تأكيد الحذف'),
                    content: Text('هل أنت متأكد أنك تريد حذف هذا التحدي؟'),
                    actions: [
                      TextButton(
                        child: Text('إلغاء'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('حذف'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                // عند حذف التحدي
                await challengeProvider.removeChallenge(widget.challenge);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف التحدي بنجاح')),
                );
                Navigator.of(context).pop(); // Return to the previous screen
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة التحدي
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  widget.challenge.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // اسم التحدي
            Text(
              widget.challenge.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            // وصف التحدي
            Text(
              widget.challenge.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            // مؤشر التقدم
            LinearProgressIndicator(
              value: progress / widget.challenge.durationDays,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              'التقدم: ${((progress / widget.challenge.durationDays) * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            // معلومات أساسية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مدة التحدي: ${widget.challenge.durationDays} يوم',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  'مستوى الصعوبة: ${widget.challenge.difficulty}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 16),
            // جدول الأيام مع الأقفال
            Text(
              'جدول التحدي:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: widget.challenge.durationDays,
                  itemBuilder: (context, index) {
                    bool isUnlocked = index < progress;
                    bool isToday = index == progress - 1;

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text('اليوم ${index + 1}'),
                              subtitle: isUnlocked
                                  ? (isToday
                                      ? Text('مكتمل',
                                          style: TextStyle(color: Colors.green))
                                      : null)
                                  : Text('مغلق',
                                      style: TextStyle(color: Colors.red)),
                              leading: Icon(
                                isUnlocked ? Icons.lock_open : Icons.lock,
                                color: isUnlocked ? Colors.green : Colors.red,
                              ),
                              tileColor: isToday
                                  ? Colors.blue[50]
                                  : (isUnlocked
                                      ? Colors.green[50]
                                      : Colors.red[50]),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            // زر بدء التحدي
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (isChallengeCompleted) {
                    // Show congratulations screen
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('تهانينا!'),
                          content: Text(
                              'لقد أكملت التحدي بنجاح. هل ترغب في إعادة التحدي أو استكشاف تحديات جديدة؟'),
                          actions: [
                            TextButton(
                              child: Text('إعادة التحدي'),
                              onPressed: () async {
                                await challengeProvider
                                    .resetChallenge(widget.challenge);
                                Navigator.of(context).pop(); // Close the dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('تم إعادة التحدي بنجاح')),
                                );
                                setState(() {}); // Update the UI
                              },
                            ),
                            TextButton(
                              child: Text('تحديات جديدة'),
                              onPressed: () {
                                // Navigate to the list of new challenges
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChallengeList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    if (!isChallengeStarted) {
                      await challengeProvider.startChallenge(widget.challenge);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم بدء التحدي بنجاح')),
                      );
                      // Update the UI by calling setState
                      setState(() {});
                    } else {
                      // Progress to the next day
                      await challengeProvider
                          .progressChallenge(widget.challenge);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم التقدم إلى اليوم التالي')),
                      );
                      setState(() {});
                    }
                  }
                },
                child: Text(isChallengeCompleted
                    ? 'إعادة التحدي'
                    : (isChallengeStarted
                        ? 'التقدم إلى اليوم التالي'
                        : 'بدء التحدي')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
