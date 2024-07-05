import 'package:crossapp/pages/feed.dart';
import 'package:crossapp/pages/hw.dart';
import 'package:crossapp/pages/nappy.dart';
import 'package:crossapp/pages/sleep.dart';
import 'package:crossapp/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? _image;
  var time = DateTime.now();
  String imageurl = "";

  final image_picker = ImagePicker();

  //THIS CODE OF GETIMAGE AND GETPIC IS TAKEN FROM FLUTTER DOCUMENTATION

  Future getImage() async{
    dynamic image = await image_picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }
  Future getPic() async{
    dynamic image = await image_picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           Container(
             width: MediaQuery.of(context).size.width*100,
             color: Colors.grey[800],
             height: MediaQuery.of(context).size.height*0.35,
             child: Stack(
               fit: StackFit.expand,
               children: [
                 _image == null? Center(child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                         "Date : ${time.day} - ${time.month} - ${time.year}",
                       style: TextStyle(
                         fontSize: 30.0
                       ),
                     ),
                     SizedBox(height: 10.0,),
                     Text("ADD IMAGE OF BABY")
                   ],
                 )): Image.file(_image!,fit: BoxFit.cover
                   ,),
               ],
             ),
           ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          )
                      ),
                      onPressed: getImage,
                      child: Icon(Icons.camera_alt),
                    ),
                ),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        )
                    ),
                    onPressed: getPic,
                    child: Icon(Icons.gamepad),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20.0,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Image.asset('images/baby-bottle.png',),
                          Text(
                              "  FEED",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Feed()));
                    },
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Sleep()));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Image.asset('images/sleeping.png',),
                          Text(
                              "  SLEEP",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  InkWell(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Image.asset('images/diaper.png'),
                          Text(
                            "  NAPPY",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Nappy()));
                    },
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HandW()));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Image.asset('images/weight-scale.png'),
                          Text(
                            "  WEIGHT AND HEIGHT",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),


                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Summary()));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Image.asset('images/contract.png'),
                          Text(
                            "  SUMMARY",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
