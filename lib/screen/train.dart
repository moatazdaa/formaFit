

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:formafit/exercises/back.dart';
import 'package:formafit/exercises/buttocks.dart';
import 'package:formafit/exercises/cardio.dart';
import 'package:formafit/exercises/chest.dart';
import 'package:formafit/exercises/handCranks.dart';
import 'package:formafit/exercises/hard.dart';
import 'package:formafit/exercises/legs.dart';
import 'package:formafit/exercises/power.dart';
import 'package:formafit/exercises/shoulder.dart';
import 'package:formafit/exercises/stomach.dart';
import 'package:formafit/exercises/triceps.dart';
import 'package:formafit/screen/challenge.dart';
import 'package:formafit/screen/favorit.dart';


// صفحة خاصة بي التمارين 



//List of Cards with size 
List<StaggeredTile>  _cardTile = <StaggeredTile> [ 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
  StaggeredTile.count(2, 2), 
  StaggeredTile.count(2, 3), 
];

//List of Cards with color and icon 
List<Widget> _listTile(BuildContext context) { // تحديث التوقيع هنا
  return <Widget>[
    InkWell(
   
    child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/gym3.1.jpg'),
        exerciseDescription: 'الصدر ',
        //iconData: Icons.home,
          targetPage: Chest(),

      ),),

    InkWell( 
      child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/gym4.jpg'),
        exerciseDescription: 'الظهر',
      //  iconData: Icons.home,
                  targetPage: Backk(),

      ),),

      InkWell(
     
    child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/gym5.1.jpg'),
        exerciseDescription: 'الأرجل',
        //iconData: Icons.home,
                  targetPage: Legs(),

      ),    ),
    InkWell(
    
    child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall2.jpg'),
        exerciseDescription: 'الأرداف',
        //iconData: Icons.home,
                  targetPage: Buttocks(),

      ),    ),
      InkWell(
   
       child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/gym3.1.jpg'),
        exerciseDescription: 'المعدة',
      //  iconData: Icons.home,
                  targetPage: Stomach(),

      ),
    ),
    InkWell(
   
       child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/gym3.2.jpg'),
        exerciseDescription: 'السواعد',
      //  iconData: Icons.home,
                  targetPage: HandCranks(),

      ),
    ),
      InkWell(
      
      child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall4.jpg'),
        exerciseDescription: 'الأكتاف',
       // iconData: Icons.home,
                  targetPage: Shoulder(),

      ),
    ),
    InkWell(
  
      child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall3.jpg'),
        exerciseDescription: 'تراي سيبس',
     //   iconData: Icons.home,
                  targetPage: Triceps(),

      ),
    ),
      InkWell(
     
         child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall2.jpg'),
        exerciseDescription: 'ذات الرأسين',
      //  iconData: Icons.home,
                  targetPage: ChallengeScreen(),

      ),
    ),
    InkWell(
   
        child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall1.jpg'),
        exerciseDescription: 'ثلاتية رؤو',
       // iconData: Icons.home,
                  targetPage: FavoritScreen(),

      ),
    ),
     InkWell(
   
        child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall1.jpg'),
        exerciseDescription: 'الكارديو',
       // iconData: Icons.home,
                  targetPage: Cardio(),

      ),
    ),
     InkWell(
   
        child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall1.jpg'),
        exerciseDescription: 'القوة',
       // iconData: Icons.home,
                  targetPage: Power(),

      ),
    ),
     InkWell(
   
        child: BackgroundTile(
        backgroundImage: AssetImage('assets/images/chall1.jpg'),
        exerciseDescription: 'القلب',
       // iconData: Icons.home,
                  targetPage: Hard(),

      ),
    ),

  ];
}


class TrainScreen extends StatelessWidget {
  final String? exerciseDescription;

  TrainScreen({Key? key, this.exerciseDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title: Text("التمارين "), 
      ), 
      body: Container( 
  
        // Staggered Grid View starts here 
        child: StaggeredGridView.count( 
            crossAxisCount: 4, 
          staggeredTiles: _cardTile, 
          children: _listTile(context), 
           mainAxisSpacing: 4.0, 
          crossAxisSpacing: 4.0, 
  
      ), 
      ), 
    ); 
  } 
} 
 
 
 class BackgroundTile extends StatelessWidget {
 final ImageProvider backgroundImage;
  final String exerciseDescription;
  //final IconData iconData;
  final Widget targetPage;

  BackgroundTile({
    required this.backgroundImage,
    required this.exerciseDescription,
   // required this.iconData,
    required this.targetPage,
  });
   @override
  Widget build(BuildContext context) {
    return Card(
   child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => targetPage,
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: backgroundImage, fit: BoxFit.cover),
            Center(
              
            ),
            Positioned(
              bottom: 8,
              right: 8,
child: Text(
                exerciseDescription,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
             // child: Icon(iconData, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


