import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/summary/feed_summary.dart';
import 'package:crossapp/summary/hw_summary.dart';
import 'package:crossapp/summary/nappy_summary.dart';
import 'package:crossapp/summary/sleep_summary.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import '../home.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {

  final CollectionReference feedd = FirebaseFirestore.instance.collection('feed');
  final CollectionReference sleepp = FirebaseFirestore.instance.collection('sleep');
  final CollectionReference napyy = FirebaseFirestore.instance.collection('nappy');


  final sscontroller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: sscontroller,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            final image = await sscontroller.capture();
            if(image ==null) return;
            // await saveImage(image)
            saveAndShare(image);
          },
          child: Icon(Icons.share),
        ),
        appBar: AppBar(
          title: Text('summary'),
          leading: BackButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
                children: [

                  SizedBox(height: 30.0,),

                  Container(
                    width: double.infinity,
                    height: 70.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                        )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Feeds()));
                      },
                      child: Text(
                        "FEED SUMMARY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                        ),),
                    ),
                  ),

                  SizedBox(height: 30.0,),

                  Container(
                    height: 70.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Nappys()));
                      },
                      child: Text(
                        "NAPPY SUMMARY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                        ),),
                    ),
                  ),

                  SizedBox(height: 30.0,),

                  Container(
                    height: 70.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Sleeps()));
                      },
                      child: Text(
                          "SLEEP SUMMARY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0,),

                  Container(
                    height: 70.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HWs()));
                      },
                      child: Text(
                        "MEASUREMENT SUMMARY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                        ),),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  //SAVEANDASHARE AND SAVEIMAGE CODE IS TAKEN FROM GITHUB

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}
