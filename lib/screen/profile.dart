import 'package:flutter/material.dart';
import 'package:formafit/Notification/MealNotification.dart';
import 'package:formafit/authentication/Onboarding/activity.dart';
import 'package:formafit/authentication/Onboarding/age.dart';
import 'package:formafit/authentication/Onboarding/gender.dart';
import 'package:formafit/authentication/Onboarding/gools.dart';
import 'package:formafit/authentication/Onboarding/height.dart';
import 'package:formafit/authentication/Onboarding/weight.dart';
import 'package:formafit/imgProfile/imgFunction.dart';
import 'package:formafit/profile_setting/change_password.dart';
import 'package:formafit/profile_setting/update_profile.dart';
import 'package:formafit/provider/userProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // تستخدم لتحديت الص
  //فحة عندما نقوم بالعودة الى هدة الصفحة من صفحة التعديل
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // هذه الميزة تستمع للإشارات القادمة من الصفحات الأخرى عند العودة إليها
    final bool? shouldRefresh =
        ModalRoute.of(context)?.settings.arguments as bool?;
    if (shouldRefresh == true) {
      fetchProfileData(); // إعادة جلب البيانات عند العودة للصفحة
    }
  }

  void ShowButtomSheet(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final NameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
                // تدريج الوان
                ),
            width: double.infinity,
            height: 440,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'تعديل الاسم',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: NameController,
                        decoration: InputDecoration(labelText: 'الاسم'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال الاسم';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'الرجاء ادخال اسم صالح';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            Provider.of<UserProvider>(context, listen: false)
                                .updateFullName(NameController.text);

                            await EditUserName();
                            Navigator.pop(
                                context); // إغلاق الحوار بعد حفظ التغييرات
                          }
                        },
                        child: Text('حفظ'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    fetchProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("الملف الشخصي"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealReminderScreen()));
            },
            icon: Icon(Icons.notifications_active),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("حدث خطأ في جلب البيانات"),
            );
          } else {
            return ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(125, 78, 91, 110),
                                ),
                                child: Stack(
                                  children: [
                                    ProvideimgName == null
                                        ? CircleAvatar(
                                            backgroundColor: Color.fromARGB(
                                                255, 225, 225, 225),
                                            radius: 55,
                                            backgroundImage: AssetImage(
                                                "assets/images/gym2.jpg"),
                                          )
                                        : CircleAvatar(
                                            radius: 55,
                                            backgroundImage:
                                                NetworkImage(ProvideimgName),
                                          ),
                                    Positioned(
                                      right: -15,
                                      bottom: -15,
                                      child: IconButton(
                                        onPressed: () async {
                                          print(ProvideimgName);
                                          print('hhhhhhhhhhhhhhhhhhhhhhh');
                                          await showmodel();
                                          if (imgPath != null &&
                                              imgName != null) {
                                            // عرض نافذة التأكيد
                                            bool confirm = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('تأكيد'),
                                                  content: Text(
                                                      'هل أنت متأكد من تحميل الصورة؟'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text('إلغاء'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: Text('تأكيد'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // إذا وافق المستخدم، تابع تنفيذ بقية العمليات
                                            if (confirm) {
                                              if (ProvideimgName != null) {
                                                // حذف الصورة القديمة من Firebase Storage
                                                  print('hhhhhhhhhhhhhhhhhhhhhhh');
                                                print(ProvideimgName);
                                                await deleteOldImage(
                                                    ProvideimgName);
                                              }
                                              String imgUrl = await getImgURL(
                                                imgName: imgName!,
                                                imgPath: imgPath!,
                                              );
                                              await updateImageData(imgUrl);
                                              await EditUserImg();
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.add_a_photo),
                                        color:
                                            Color.fromARGB(255, 208, 218, 224),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                fullName ?? '',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("" // userProvider.user.email!,
                                  ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${weight ?? ''} kg",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.monitor_weight),
                                          Text("weight"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${height ?? ''} cm",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.height),
                                          Text("height"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "1450",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.fire_extinguisher),
                                          Text("cal"),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "General :",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              title: Text(
                                "الاسم: ${fullName ?? 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.person),
                              trailing: IconButton(
                                  onPressed: () {
                                    ShowButtomSheet(context);
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "الجنس: ${gender ?? 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.person),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GenderSelectionPage(
                                          onNext: () {},
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "العمر: ${age ?? 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.cake),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AgeSelectionPage(
                                          onNext: () {},
                                          onPrevious: SaveUserData,
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "الطول: ${height != null ? '${height} سم' : 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.height),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HeightSelectionPage(
                                          onNext: () {},
                                          onPrevious: () {},
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "الوزن: ${weight != null ? '${weight} كجم' : 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.monitor_weight),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WeightSelectionPage(
                                          onNext: () {},
                                          onPrevious: () {},
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "مستوى النشاط: ${activityLevel ?? 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.fitness_center),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActivityLevelPage(
                                          onNext: () {},
                                          onPrevious: () {},
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ListTile(
                              title: Text(
                                "الأهداف: ${goalList != null ? goalList!.join(', ') : 'غير محدد'}",
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: Icon(Icons.flag),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GoalSelectionPage(
                                          onFinish: () {},
                                          onPrevious: () {},
                                          isSaveOrNext: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                            ExpansionTile(
                              leading: Icon(Icons.local_activity),
                              title: Text('Activity '),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Challenges activity'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Exercise activity'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                      ListTile(
                                        title: Text('nutrition'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(Icons.calculate),
                              title: Text('Calculator'),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Calc calories'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Calc body mass index'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Calc the ideal weidht'),
                                        onTap: () {
                                          // تعامل مع هذا العنصر هنا
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(Icons.settings),
                              title: Text('Profile Setting'),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Change Password'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePassword(),
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Update profile'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Update_Profile(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
