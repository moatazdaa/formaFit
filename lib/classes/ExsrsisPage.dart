import 'package:flutter/material.dart';
import 'package:formafit/exercises/chest.dart';

class ExercisePage {
  final String name;
  final String imagePath;
  final Widget page;

  ExercisePage({required this.name, required this.imagePath, required this.page});

  
}
  final List<ExercisePage> ListPageExsrsis = [
    ExercisePage(
      name: 'الصدر',
      imagePath: 'assets/images/ChestPage.jpg',
      page: Chest(),
    ),
    ExercisePage(
      name: 'دات الراسين',
      imagePath: 'assets/images/ArmPage.jpg',
  page: Chest(),
    ),
      ExercisePage(
      name: 'الساعد',
      imagePath: 'assets/images/CranksPage.jpg',
      page: Chest(),
    ),
    ExercisePage(
      name: 'البطن',
      imagePath:'assets/images/SixBackPage.jpg',
  page: Chest(),
    ),
      ExercisePage(
      name: 'الجوانب',
      imagePath: 'assets/images/Sides.jpg',
      page: Chest(),
    ),
      ExercisePage(
      name: 'الرقبه',
      imagePath: 'assets/images/NeckPage.jpg',
      page: Chest(),
    ),
      ExercisePage(
      name: 'الساق',
      imagePath: 'assets/images/EndLegsPage.jpg',
      page: Chest(),
    ),
      ExercisePage(
      name: 'الفخد',
      imagePath: 'assets/images/LegPage.jpg',
      page: Chest(),
    ),
    
      ExercisePage(
      name: 'الظهر',
      imagePath: 'assets/images/BackPage.jpg',
      page: Chest(),
    ),
      ExercisePage(
      name: 'ثلاثية الرؤوس',
      imagePath: 'assets/images/RearArm.jpg',
      page: Chest(),
    ),
  
    ExercisePage(
      name: 'الارداف',
      imagePath: 'assets/images/DownBackPage.jpg',
      page: Chest(),
    ),
    // أضف المزيد من العناصر هنا
  ];