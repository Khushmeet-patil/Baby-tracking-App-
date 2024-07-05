import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/add/add_hw.dart';
import 'package:crossapp/model/hw_model.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import '../home.dart';

class HandW extends StatefulWidget {
  const HandW({Key? key}) : super(key: key);

  @override
  State<HandW> createState() => _HandWState();
}

class _HandWState extends State<HandW> {
  //CODE OF STOPWATCH IS TAKEN FROM CHATGPT
  //CODE OF DYNAMIC LIST IS CODED FROM YOUTUBE TUTORIAL
  int count=0;
  var time = DateTime.now();
  late String type ;
  TimeOfDay selectedTime = TimeOfDay.now();

  final sscontroller = ScreenshotController();

  CollectionReference _documentReference = FirebaseFirestore.instance.collection('hw');

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: sscontroller,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: ()async{
              final image = await sscontroller.capture();
              if(image ==null) return;
              await saveImage(image);
              saveAndShare(image);
            },
            child: Icon(Icons.share),
          ),
          appBar: AppBar(
            title: Text("Height and Weight"),
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Addhw()));
                },
                icon: Icon(Icons.add),
              )
            ],
            leading: BackButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              },
            ),
          ),
          body: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "History of Weight and Hight",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),

              Divider(),

              //THIS CODE IS TAKEN FROM GITHUB

              FutureBuilder<QuerySnapshot>(
                future: _documentReference.get(),
                builder: (context,snapshot){
                  if(snapshot.hasError){
                    return const Center(child: Text("Somtthing went wrong"),);
                  }
                  if(snapshot.hasData){
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> document = querySnapshot.docs;
                    List hw1 = document.map((e) => HW(hight: e['hight'], weight: e['weight'], date: e['date'], time: e['time'])).toList();
                    return getdata(hw1);
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          )
      ),
    );
  }
  getdata(hw1) {
    return Expanded(
      child: ListView.builder(
        itemCount: hw1.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text("Height : ${hw1[index].hight} , Weight : ${hw1[index].weight} "),
            subtitle: Text("${hw1[index].date}  ${hw1[index].time} "),
          );
        },
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


