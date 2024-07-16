import 'package:flutter/material.dart';
import 'package:formafit/classes/HealthyNutritionClasses.dart';

class DetalsFoodScreen extends StatefulWidget {
  final Foods Copyfood;
  const DetalsFoodScreen({Key? key, required this.Copyfood}) : super(key: key);

  @override
  State<DetalsFoodScreen> createState() => _DetalsFoodScreenState();
}

class _DetalsFoodScreenState extends State<DetalsFoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.Copyfood.name), // عنوان الشاشة يكون اسم الطعام
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          MyWidget(values: widget.Copyfood.Kal.toString(), text: "السعرات الحرارية"),
          MyWidget(values: widget.Copyfood.Protein.toString(), text: "البروتين"),
          MyWidget(values: widget.Copyfood.Carbohydrates.toString(), text: "الكربوهيدرات"),
          MyWidget(values: widget.Copyfood.Fats.toString(), text: "الدهون"),
          MyWidget(values: widget.Copyfood.SaturatedFat.toString(), text: "الدهون المشبعة"),
          MyWidget(values: widget.Copyfood.UnSaturatedFat.toString(), text: "الدهون غير المشبعة"),
          MyWidget(values: widget.Copyfood.A.toString(), text: "فيتامين A"),
          MyWidget(values: widget.Copyfood.B12.toString(), text: "فيتامين B12"),
          MyWidget(values: widget.Copyfood.B6.toString(), text: "فيتامين B6"),
          MyWidget(values: widget.Copyfood.B2.toString(), text: "فيتامين B2"),
          MyWidget(values: widget.Copyfood.C.toString(), text: "فيتامين C"),
          MyWidget(values: widget.Copyfood.D.toString(), text: "فيتامين D"),
          MyWidget(values: widget.Copyfood.Fe.toString(), text: "الحديد"),
          MyWidget(values: widget.Copyfood.K.toString(), text: "البوتاسيوم"),
          MyWidget(values: widget.Copyfood.Ca.toString(), text: "الكالسيوم"),
          MyWidget(values: widget.Copyfood.Mg.toString(), text: "المغنيسيوم"),
          MyWidget(values: widget.Copyfood.Kolistol.toString(), text: "الكوليسترول"),
          MyWidget(values: widget.Copyfood.p.toString(), text: "الفسفور"),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final String values;
  final String text;
  const MyWidget({required this.values, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Text(
              values,
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              // تصرف عند النقر على العنصر
            },
          ),
        ),
        Divider(
          color: Color.fromARGB(255, 0, 0, 0), // يمكنك تغيير لون الخط هنا
          thickness: 2, // يمكنك تغيير سمك الخط هنا
          height: 10, // يمكنك تغيير ارتفاع الخط هنا
          indent: 20, // المسافة من اليسار
          endIndent: 20, // المسافة من اليمين
        ),
      ],
    );
  }
}