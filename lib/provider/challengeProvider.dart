import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Challenge {
  final String name;
  final String description;
  final int durationDays;
  final int daysPerWeek;
  final String difficulty;
  final String imageUrl;

  Challenge(this.name, this.description, this.durationDays, this.daysPerWeek, this.difficulty, this.imageUrl);
}

class ChallengeProvider extends ChangeNotifier {
  List<Challenge> _selectedChallenges = [];
  Map<String, int> _challengeProgress = {}; // Using Challenge id as key
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChallengeProvider() {
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    final uid = await _getUserUid();
    if (uid == null) return;

    try {
      final snapshot = await _firestore.collection('users').doc(uid).collection('challenges').get();
      _selectedChallenges = snapshot.docs.map((doc) {
        final data = doc.data();
        final challenge = Challenge(
          data['name'] ?? '',
          data['description'] ?? '',
          data['durationDays'] ?? 0,
          data['daysPerWeek'] ?? 0,
          data['difficulty'] ?? '',
          data['imageUrl'] ?? '',
        );
        _challengeProgress[challenge.name] = data['progress'] ?? 0;
        return challenge;
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error loading challenges: $e");
    }
  }

  Future<void> _saveChallenge(Challenge challenge) async {
    final uid = await _getUserUid();
    if (uid == null) return;

    try {
      await _firestore.collection('users').doc(uid).collection('challenges').doc(challenge.name).set({
        'name': challenge.name,
        'description': challenge.description,
        'durationDays': challenge.durationDays,
        'daysPerWeek': challenge.daysPerWeek,
        'difficulty': challenge.difficulty,
        'imageUrl': challenge.imageUrl,
        'progress': _challengeProgress[challenge.name] ?? 0,
      });
    } catch (e) {
      print("Error saving challenge: $e");
    }
  }

  Future<void> _deleteChallenge(Challenge challenge) async {
    final uid = await _getUserUid();
    if (uid == null) return;

    try {
      await _firestore.collection('users').doc(uid).collection('challenges').doc(challenge.name).delete();
    } catch (e) {
      print("Error deleting challenge: $e");
    }
  }

  List<Challenge> get selectedChallenges => _selectedChallenges;
 
 Future<void> toggleChallenge(Challenge challenge, BuildContext context) async {
    if (_selectedChallenges.any((c) => c.name == challenge.name)) {
      // Challenge already exists, show a message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تحذير'),
            content: Text('هذا التحدي موجود مسبقًا في قائمة التحديات.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    } else {
      _selectedChallenges.add(challenge);
      _challengeProgress[challenge.name] = 0;
      await _saveChallenge(challenge);
      // Optionally, show a confirmation dialog or snackbar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('نجاح'),
            content: Text('تم إضافة التحدي بنجاح.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
    notifyListeners();
  }

Future<void> removeChallenge(Challenge challenge) async {
  _selectedChallenges.remove(challenge);
  _challengeProgress.remove(challenge.name);
  await _deleteChallenge(challenge);
  notifyListeners();
}


  int getProgress(Challenge challenge) {
    return _challengeProgress[challenge.name] ?? 0;
  }

  void incrementProgress(Challenge challenge) async {
    if (_challengeProgress.containsKey(challenge.name)) {
      _challengeProgress[challenge.name] = _challengeProgress[challenge.name]! + 1;
      await _saveChallenge(challenge);
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  Future<String?> _getUserUid() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return null;
    }
    return user.uid;
  }

  Future<void> startChallenge(Challenge challenge) async {
    if (_challengeProgress.containsKey(challenge.name)) {
      // Initialize challenge progress
      _challengeProgress[challenge.name] = 1; // Open the first lock
      await _saveChallenge(challenge);
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  Future<void> progressChallenge(Challenge challenge) async {
    if (_challengeProgress.containsKey(challenge.name)) {
      int currentProgress = _challengeProgress[challenge.name]!;
      if (currentProgress < challenge.durationDays) {
        _challengeProgress[challenge.name] = currentProgress + 1;
        await _saveChallenge(challenge);
      }
    }
    notifyListeners(); // Notify listeners to update the UI
  }
    // Reset challenge progress to start from day 1
  Future<void> resetChallenge(Challenge challenge) async {
    if (_challengeProgress.containsKey(challenge.name)) {
      _challengeProgress[challenge.name] = 0; // Reset progress
      await _saveChallenge(challenge);
      await startChallenge(challenge);
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
