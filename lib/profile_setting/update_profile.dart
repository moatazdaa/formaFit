import 'package:flutter/material.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Update_Profile extends StatefulWidget {
  const Update_Profile({super.key});

  @override
  State<Update_Profile> createState() => _Update_ProfileState();
}

class _Update_ProfileState extends State<Update_Profile> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _activityLevelController =
      TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  @override
  void dispose() {
    _genderController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _activityLevelController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      // Initialize text controllers with current user data if available
      _genderController.text = gender ?? '';
      _weightController.text = weight?.toString() ?? '';
      _heightController.text = height?.toString() ?? '';
      _ageController.text = age?.toString() ?? '';
      _activityLevelController.text = activityLevel ?? '';
      _goalsController.text = goalList?.join(', ') ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('gender', value);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('weight', value);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('height', value);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('age', value);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _activityLevelController,
                decoration: InputDecoration(labelText: 'Activity Level'),
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('activityLevel', value);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _goalsController,
                decoration: InputDecoration(labelText: 'Goals'),
                onChanged: (value) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateField('goal', value.split(','));
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  await SaveUserData();

                  Navigator.pop(
                      context, true); // تمرير true كإشارة للصفحة السابقة
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
