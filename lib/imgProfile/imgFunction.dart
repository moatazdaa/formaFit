import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';


import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' show basename;

  var imgPath;
  var imgName;

  Future<String> getImgURL(
      {required var imgName, required var imgPath}) async {
    // Upload image to firebase storage
    final storageRef = FirebaseStorage.instance.ref("profileIMG/$imgName");
    UploadTask uploadTask = storageRef.putData(imgPath);
    TaskSnapshot snap = await uploadTask;

    // Get img url
    var urll = await snap.ref.getDownloadURL();
    return urll;
  }

  uploadImage2Screen(ImageSource source) async {
  
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
    
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
    
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

Future<void> deleteOldImage(String imgUrl) async {
  try {
    // تحويل URL إلى Reference
    final ref = FirebaseStorage.instance.refFromURL(imgUrl);
    await ref.delete();
    print("Image deleted successfully");
  } catch (e) {
    print("Failed to delete image: $e");
  }
}

