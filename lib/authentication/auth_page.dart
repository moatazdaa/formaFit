import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:formafit/authentication/Onboarding/onboardingPage.dart';
import 'package:formafit/authentication/loginOrRegister/Login_Or_Regester_Page.dart';
import 'package:formafit/components/snackbar.dart';
import 'package:formafit/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // bool _showOnboarding = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkOnboardingStatus();
  // }

  // Future<void> _checkOnboardingStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');
  //   if (hasSeenOnboarding == true) {
  //     setState(() {
  //       _showOnboarding = false;
  //     });
  //   }
  // }

  // Future<void> _finishOnboarding() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('hasSeenOnboarding', true);
  //   setState(() {
  //     _showOnboarding = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:
        // _showOnboarding
      //     ? OnboardingPage(onFinish: _finishOnboarding)
      //     :
           StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else if (snapshot.hasError) {
                  return showSnackBar(context, "Something went wrong");
                }
                // user is logged in
                else if (snapshot.hasData) {
                  return MyHomePage();
                }

                // user is NOT logged in
                else {
                  return LoginOrRegesterPage();
                }
              },
            ),
    );
  }
}
