import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formafit/classes/gym_exercises.dart';
import 'package:flutter/widgets.dart';
import 'package:formafit/provider/providerfile2.dart';



class exsrsis_in_plan extends StatefulWidget {
  final List<exsrsis_item> myList;
final List<int>selectindex;

  exsrsis_in_plan({Key? key, required this.myList,required this.selectindex}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

 
    // استخدم myList هنا في بناء الواجهة
class _MyStatefulWidgetState extends State<exsrsis_in_plan> {
  @override
  Widget build(BuildContext context) {
    int rating = 1;
    // استخدم myList هنا في بناء الواجهة
    return Scaffold(
      backgroundColor: Color.fromARGB(60, 106, 67, 16),
      body: ListView.builder(
          itemCount: widget.myList.length,
          itemBuilder: (context, index) {
            bool isSelected =
               widget.  selectindex.contains(index); // تحقق مما إذا كان العنصر محددًا

            //تسنخدم هدة الاداة لعرض قائمة جانبية من جهه اليمين او اليسار
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  if (isFirstTap) {
                    // هذه هي الضغطة الأولى

                    isFirstTap = false;
                    print("onLongPress");
                    if (isSelected) {
                       widget.selectindex.remove(
                          index); // إزالة العنصر المحدد إذا كان محددًا بالفعل
                      selectedexsrsis_to_list.remove(widget.myList[index]);
                    } else {
                      widget. selectindex.add(index); // إضافة العنصر إذا لم يكن محددًا
                      selectedexsrsis_to_list.add(widget.myList[index]);
                    }
                  }
                });
              },
              onTap: () {
                setState(() {
                  if ( widget.selectindex.isEmpty) {
                 isFirstTap=true;
                  }
                  if (!isFirstTap) {
                    // إذا كانت هذه ليست الضغطة الأولى
                    print("onTap");
                    if (isSelected) {
                      widget. selectindex.remove(
                          index); // إزالة العنصر المحدد إذا كان محددًا بالفعل
                      selectedexsrsis_to_list.remove(widget.myList[index]);
                    } else {
                      widget. selectindex.add(index); // إضافة العنصر إذا لم يكن محددًا
                      selectedexsrsis_to_list.add(widget.myList[index]);
                    }
                    // هنا يمكنك إضافة السلوك المراد للضغطات التالية بعد الضغطة الأولى
                  }
                });
              },
              child: Slidable(
          
          
                endActionPane: ActionPane(motion: StretchMotion(), children: [
        
                  SlidableAction(
                    
                    // flex: 1,
                 autoClose: true,
                    spacing: 7,
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    borderRadius: BorderRadius.circular(15),
                    label: 'delet',
                    icon: Icons.remove,
          
                    backgroundColor: Colors.red,
                    // مزال لين تخدم البروفايد لان تبي تمرير المتغير الى داله من صفحة الى اخرى
                    onPressed: (context) => {
                SelectExsrsisId=widget.myList[index].id,
                      removeExerciseFromDay(dayDocId,SelectExsrsisId)
                      
                    },
                  ),
                  
                ]),
                startActionPane:
                    ActionPane(motion: const BehindMotion(), children: [
                  SlidableAction(
                    icon: Icons.favorite,
                    foregroundColor: Colors.white,
                    label: "Favorite",
                    backgroundColor: Colors.blue,
                    onPressed: (context) => {},
                  )
                ]),
                child: FractionallySizedBox(
                  // خاصية للودجت تجعله يشغل مساحة لهاتف بنسبة مئوية
                  widthFactor: 0.99,
                  child: Container(
                    width: double.infinity,
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.all(5),
                    // ignore: prefer_const_constructors
                    // color: Color.fromARGB(255, 255, 251, 251),
                    color: widget. selectindex.contains(index)
                        ? Color.fromARGB(26, 0, 106, 255)
                        : 
                        Color.fromARGB(255, 255, 251, 251),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Image(
                                    width: 100,
                                    height: 130,
                                    image: AssetImage(
                                        widget.myList[index].main_image))),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      //  تدريج الوان
                                                      gradient: LinearGradient(
                                                          begin:
                                                              Alignment.center,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        Color.fromARGB(
                                                            240, 56, 57, 60),
                                                        Color.fromRGBO(
                                                            50, 58, 90, 0.2)
                                                      ])),
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: ListView(children: [
                                                    Image(
                                                        width: 400,
                                                        height: 400,
                                                        image: AssetImage(widget
                                                            .myList[index]
                                                            .main_image)),

                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          size: 40,

                                                          color: Colors
                                                              .amber, // اختيار لون النجمة
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          size: 40,
                                                          color: rating >= 2
                                                              ? Colors.amber
                                                              : Colors
                                                                  .black, // اختيار لون النجمة
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          size: 40,
                                                          color: rating >= 3
                                                              ? Colors.amber
                                                              : Colors
                                                                  .black, // اختيار لون النجمة
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          size: 40,
                                                          color: rating >= 3
                                                              ? Colors.amber
                                                              : Colors
                                                                  .black, // اختيار لون النجمة
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          size: 40,
                                                          color: rating >= 3
                                                              ? Colors.amber
                                                              : Colors
                                                                  .black, // اختيار لون النجمة
                                                        ),
                                                      ],
                                                    ),

                                                    // ودجت تقوم بعمل خط بشكل افقي
                                                    Divider(
                                                      color: Color.fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // يمكنك تغيير لون الخط هنا
                                                      thickness:
                                                          2, // يمكنك تغيير سمك الخط هنا
                                                      height:
                                                          10, // يمكنك تغيير ارتفاع الخط هنا
                                                      indent:
                                                          20, // المسافة من اليسار
                                                      endIndent:
                                                          20, // المسافة من اليمين
                                                    ),

                                                    Text(
                                                      " التعليمات",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'font_1',
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 255, 255)),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 7),
                                                      child: Text(
                                                        // خاصية للنص تجعل الكتابة من اليمين لليسار
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        widget.myList[index].explane.join('\n'), // دمج السلاسل النصية
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'font_1',
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 255, 255)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),

                                                    Divider(
                                                      color: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // يمكنك تغيير لون الخط هنا
                                                      thickness:
                                                          2, // يمكنك تغيير سمك الخط هنا
                                                      height:
                                                          10, // يمكنك تغيير ارتفاع الخط هنا
                                                      indent:
                                                          20, // المسافة من اليسار
                                                      endIndent:
                                                          20, // المسافة من اليمين
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Main Muscles ",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'font_1',
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 255, 255)),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),

                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Image(
                                                              height: 250,
                                                              width: 250,
                                                              image: AssetImage(
                                                                  widget
                                                                      .myList[
                                                                          index]
                                                                      .image1)),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image(
                                                              height: 200,
                                                              width: 250,
                                                              image: AssetImage(
                                                                  widget
                                                                      .myList[
                                                                          index]
                                                                      .image2)),
                                                        ],
                                                      ),
                                                    ),

                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                          Color>(
                                                                      Color.fromARGB(
                                                                          255,
                                                                          49,
                                                                          111,
                                                                          212))),
                                                              onPressed: () {
                                                                //تستخدم لاغلاق الshow mode bottm sheet
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Exit",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'font_1'),
                                                              )),
                                                          ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                          Color>(
                                                                      Color.fromARGB(
                                                                          255,
                                                                          49,
                                                                          111,
                                                                          212))),
                                                              onPressed: () {},
                                                              child: Text(
                                                                "START ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'font_1'),
                                                              )),
                                                        ]),
                                                    SizedBox(
                                                      height: 40,
                                                    )
                                                  ]),
                                                );
                                              },
                                              isScrollControlled: true);
                                        },
                                        child: Text(
                                          widget.myList[index].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "20min",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'font_1'),
                                          ),
                                        ],
                                      )
                                    ])),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 30,

                                          color:
                                              Colors.amber, // اختيار لون النجمة
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 30,
                                          color: rating >= 2
                                              ? Colors.amber
                                              : Colors
                                                  .black, // اختيار لون النجمة
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 30,
                                          color: rating >= 3
                                              ? Colors.amber
                                              : Colors
                                                  .black, // اختيار لون النجمة
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "مبتدي",
                                      style: TextStyle(
                                          fontSize: 18, fontFamily: 'font_1'),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

