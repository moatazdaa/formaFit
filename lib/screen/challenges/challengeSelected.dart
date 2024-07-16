import 'package:flutter/material.dart';
import 'package:formafit/screen/challenges/challengDetail1.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/challengeProvider.dart';

class SelectedChallenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final challenges = challengeProvider.selectedChallenges;

    return Scaffold(
      appBar: AppBar(
        title: Text('التحديات المختارة'),
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          final progress = challengeProvider.getProgress(challenge);
          final isCompleted = progress >= challenge.durationDays;

          return ListTile(
            leading: Image.asset(
              challenge.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(challenge.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التقدم: ${((progress / challenge.durationDays) * 100).toStringAsFixed(1)}%'),
                LinearProgressIndicator(
                  value: progress / challenge.durationDays,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ],
            ),
            trailing: isCompleted
                ? Icon(Icons.check, color: Colors.green)
                : ElevatedButton(
                    child: Text('بدء التحدي'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengeDetailScreen(challenge: challenge),
                        ),
                      ).then((_) {
                        // تحديث الحالة عند العودة من صفحة التفاصيل
                        challengeProvider.incrementProgress(challenge);
                      });
                    },
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeDetailScreen(challenge: challenge),
                ),
              ).then((_) {
                // تحديث الحالة عند العودة من صفحة التفاصيل
                challengeProvider.incrementProgress(challenge);
              });
            },
            onLongPress: () {
              _showOptionsDialog(context, challenge, challengeProvider);
            },
          );
        },
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, Challenge challenge, ChallengeProvider challengeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خيارات'),
          content: Text('ماذا تريد أن تفعل بالتحدي؟'),
          actions: [
            TextButton(
              child: Text('حذف التحدي'),
              onPressed: () {
                challengeProvider.removeChallenge(challenge);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
