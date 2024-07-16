import 'package:cloud_firestore/cloud_firestore.dart';

class UserDate {
  String password;
  String email;
  String username;
  String profileImg;
  String uid;
 

  UserDate({
    required this.email,
    required this.password,
    required this.username,
    required this.profileImg,
    required this.uid,
  });

// To convert the UserData(Data type) to   Map<String, Object>
  Map<String, dynamic> convert2Map() {
    return {
      "password": password,
      "email": email,
      "username": username,
      "profileImg": profileImg,
      "uid": uid,
    
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserDate(
      password: snapshot["password"],
      email: snapshot["email"],
      username: snapshot["username"],
      profileImg: snapshot["profileImg"],
      uid: snapshot["uid"],
   
    );
  }
}