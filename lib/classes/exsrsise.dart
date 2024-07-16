import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formafit/classes/gym_exercises.dart';
import 'package:formafit/provider/providerfile2.dart';
import 'package:formafit/screen/plan.dart';

class exsrsis extends StatefulWidget {
  final List<exsrsis_item> myList;

  final List<int> selectindex;
  exsrsis({required this.myList, required this.selectindex});
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<exsrsis> {
  @override
  Widget build(BuildContext context) {
    int rating = 1;

    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 0.98,
        child: Column(
          children: [
            if (!isFirstTap)
              Container(
                color: Color.fromARGB(207, 142, 143, 155),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.selectindex.clear();
                            isFirstTap = true;
                            selectedexsrsis_to_list.clear();
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          size: 33,
                          color: Colors.red,
                        )),
                    SizedBox(
                      width: 55,
                    ),
                    Text(
                      " تم تحديد ${selectedexsrsis_to_list.length} من العناصر",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.playlist_add_check, size: 20),
                    SizedBox(width: 55),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlanScreen()),
                        ); // إجراء عند الضغط على الزر
                      },
                      // child: Text("اضافة",style: TextStyle(
                      //   fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white
                      // ),),

                      child: Icon(
                        Icons.add_box,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: ListView.builder(
                  itemCount: widget.myList.length,
                  itemBuilder: (context, index) {
                    bool isSelected = widget.selectindex
                        .contains(index); // تحقق مما إذا كان العنصر محددًا
                    // تحقق مما إذا كان العنصر محددًا
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          if (isFirstTap) {
                            // هذه هي الضغطة الأولى
                            isFirstTap = false;
                            if (isSelected) {
                              widget.selectindex.remove(
                                  index); // إزالة العنصر المحدد إذا كان محددًا بالفعل
                              selectedexsrsis_to_list
                                  .remove(widget.myList[index]);
                            } else {
                              widget.selectindex
                                  .add(index); // إضافة العنصر إذا لم يكن محددًا
                              selectedexsrsis_to_list.add(widget.myList[index]);
                            }
                          }
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (!isFirstTap) {
                            // إذا كانت هذه ليست الضغطة الأولى
                            print("onTap");
                            if (isSelected) {
                              widget.selectindex.remove(
                                  index); // إزالة العنصر المحدد إذا كان محددًا بالفعل
                              selectedexsrsis_to_list
                                  .remove(widget.myList[index]);
                            } else {
                              widget.selectindex
                                  .add(index); // إضافة العنصر إذا لم يكن محددًا
                              selectedexsrsis_to_list.add(widget.myList[index]);
                            }
                            // هنا يمكنك إضافة السلوك المراد للضغطات التالية بعد الضغطة الأولى
                          }
                        });

                        if (isFirstTap) ShowButtomSheet(widget.myList[index]);
                      },
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: StretchMotion(), children: [
                          SlidableAction(
                            // flex: 1,
                            padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                            borderRadius: BorderRadius.circular(15),
                            label: 'add',
                            icon: Icons.add,

                            backgroundColor: Colors.green,
                            onPressed: (context) => {
                              selectedexsrsis_to_list.add(widget.myList[index]),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlanScreen()),
                              )
                            },
                          ),
                        ]),
                        startActionPane:
                            ActionPane(motion: BehindMotion(), children: [
                          SlidableAction(
                            icon: Icons.favorite,
                            foregroundColor: Colors.white,
                            label: "Favorite",
                            backgroundColor: Colors.blue,
                            onPressed: (context) => {},
                          )
                        ]),
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          color: widget.selectindex.contains(index)
                              ? Color.fromARGB(26, 0, 106, 255)
                              : Color.fromARGB(255, 255, 251, 251),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Image(
                                          width: 100,
                                          height: 130,
                                          image: AssetImage(widget
                                              .myList[index].main_image))),
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
                                              onPressed: () {},
                                              child: Text(
                                                widget.myList[index].name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'font_1'),
                                                ),
                                              ],
                                            )
                                          ])),
                          
                                  if (!isFirstTap)
                                    Icon(
                                      widget.selectindex.contains(index)
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: Colors.red,
                                      size: 30,
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void ShowButtomSheet(exsrsis_item item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                //  تدريج الوان
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(240, 56, 57, 60),
                  Color.fromRGBO(50, 58, 90, 0.2)
                ])),
            width: double.infinity,
            height: double.infinity,
            child: ListView(children: [
            
              Image(
                  width: 400, height: 400, image: AssetImage(item.main_image)),
          
              Column(
                children: [

                  Row(
                    children: [
                       Text(
                    "فوائد التمرين",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),),
                      SizedBox(
                        width: 70,
                      ),
                      Icon(
                        Icons.star,
                        size: 40,
                  
                        color: Colors.amber, // اختيار لون النجمة
                      ),
                      Icon(
                        Icons.star,
                        size: 40,
                        color: item.rating >= 2
                            ? Colors.amber
                            : Colors.black, // اختيار لون النجمة
                      ),
                      Icon(
                        Icons.star,
                        size: 40,
                        color: item.rating >= 3
                            ? Colors.amber
                            : Colors.black, // اختيار لون النجمة
                      ),
                      Icon(
                        Icons.star,
                        size: 40,
                        color: item.rating >= 3
                            ? Colors.amber
                            : Colors.black, // اختيار لون النجمة
                      ),
                      Icon(
                        Icons.star,
                        size: 40,
                        color: item.rating >= 3
                            ? Colors.amber
                            : Colors.black, // اختيار لون النجمة
                      ),
                    ],
                  ),
            
            SizedBox(
              height: 15,
            ),
            Row(
  children: [
    Text(
      "التكرارات",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    ),
      SizedBox(
                        width: 100,
                      ),
    Container(
      height: 20,
     width: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: item.round.length,
        itemBuilder: (context, idx) {
          Round round = item.round[idx];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Text(
                  '${round.count}',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ],
),
   SizedBox(
              height: 15,
            ),
    
                  Row(
                    children: [
                       Text(
                    "زمن التمرين",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),),
                      SizedBox(
                        width: 90,
                      ),
                     Text(
                  '${item.ExrsisTime.inMinutes}',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                 Text(
                  ':min',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                    ],
                  ),
            
            
                ],
              ),
  SizedBox(
              height: 15,
            ),
              // ودجت تقوم بعمل خط بشكل افقي
              Divider(
                color: Color.fromARGB(
                    255, 255, 255, 255), // يمكنك تغيير لون الخط هنا
                thickness: 2, // يمكنك تغيير سمك الخط هنا
                height: 10, // يمكنك تغيير ارتفاع الخط هنا
                indent: 20, // المسافة من اليسار
                endIndent: 20, // المسافة من اليمين
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "التعليمات",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: item.explane.length,
                      itemBuilder: (context, idx) {
                        String explaneText = item.explane[idx];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '  ${idx + 1}.  ${explaneText} .',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            textScaleFactor: 0.9,
                            
                            style: TextStyle(
                              
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                          
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          
              SizedBox(
                height: 5,
              ),

              Divider(
                color: Color.fromARGB(
                    255, 255, 255, 255), // يمكنك تغيير لون الخط هنا
                thickness: 2, // يمكنك تغيير سمك الخط هنا
                height: 10, // يمكنك تغيير ارتفاع الخط هنا
                indent: 20, // المسافة من اليسار
                endIndent: 20, // المسافة من اليمين
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "فوائد التمرين",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    height: 130,
                    child: ListView.builder(
                      itemCount: item.ExsrsisGoal.length,
                      itemBuilder: (context, idx) {
                        String explaneText = item.ExsrsisGoal[idx];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '  ${idx + 1}.  ${explaneText} .',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            textScaleFactor: 0.9,
                            
                            style: TextStyle(
                              
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                          
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          
              SizedBox(
                height: 5,
              ),

              Divider(
                color: Color.fromARGB(
                    255, 255, 255, 255), // يمكنك تغيير لون الخط هنا
                thickness: 2, // يمكنك تغيير سمك الخط هنا
                height: 10, // يمكنك تغيير ارتفاع الخط هنا
                indent: 20, // المسافة من اليسار
                endIndent: 20, // المسافة من اليمين
              ),
              SizedBox(
                height: 5,
              ),

              Text(
                "ابرز العضلات",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'font_1',
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              SizedBox(
                height: 30,
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                        height: 250,
                        width: 250,
                        image: AssetImage(item.image1)),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                        height: 200,
                        width: 250,
                        image: AssetImage(item.image2)),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              )
            ]),
          );
        },
        isScrollControlled: true);
  }
}
