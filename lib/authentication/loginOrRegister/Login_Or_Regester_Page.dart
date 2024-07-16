import 'package:flutter/cupertino.dart';
import 'package:formafit/authentication/loginOrRegister/login.dart';
import 'package:formafit/authentication/loginOrRegister/register_page.dart';

class LoginOrRegesterPage extends StatefulWidget {
  const LoginOrRegesterPage({super.key});

  @override
  State<LoginOrRegesterPage> createState() => _LoginOrRegesterPageState();
}

class _LoginOrRegesterPageState extends State<LoginOrRegesterPage> {
  
  // initially show login page 
  bool showLoginPage =true;

  // toogle between login and regester page 
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    }
    else{

      return RegisterPage(onTap: togglePages,);
    }
  }
}