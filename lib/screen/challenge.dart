import 'package:flutter/material.dart';


// صفحة خاصة بي التحديات 

class ChallengeScreen extends StatefulWidget {
   const ChallengeScreen({Key? key}) : super(key: key);
  

  @override
// ignore: library_private_types_in_public_api
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  get tabController => null;
 
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Tab'),
       
      ),
     // body: 
    );
  }
}


       