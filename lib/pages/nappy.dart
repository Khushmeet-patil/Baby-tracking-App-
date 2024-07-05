import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/add/add_nappy.dart';
import 'package:crossapp/model/nappy_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import '../home.dart';

class Nappy extends StatefulWidget {
  const Nappy({Key? key}) : super(key: key);

  @override
  State<Nappy> createState() => _NappyState();
}

class _NappyState extends State<Nappy> {
  //CODE OF STOPWATCH IS TAKEN FROM CHATGPT
  //CODE OF DYNAMIC LIST IS CODED FROM YOUTUBE TUTORIAL
  int count=0;
  var time = DateTime.now();
  late String type ;
  TimeOfDay selectedTime = TimeOfDay.now();

  CollectionReference _documentReference = FirebaseFirestore.instance.collection('nappy');

  final sscontroller = ScreenshotController();

  //

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
          title: Text("Diapers"),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Addnappy()));
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
                  "History of Diaper",
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
              List nappy1 = document.map((e) => Napy(type: e['type'], time: e['time'], date: e['date'])).toList();
                return getdata(nappy1);
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

  getdata(nappy1) {
    return Expanded(
      child: ListView.builder(
        itemCount: nappy1.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text("Excreation - ${nappy1[index].type}"),
            subtitle: Text("${nappy1[index].date}  ${nappy1[index].time} "),
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
