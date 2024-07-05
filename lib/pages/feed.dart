

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/add/add_feed.dart';
import 'package:crossapp/home.dart';
import 'package:crossapp/model/feed_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';


import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';


class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  //CODE OF STOPWATCH IS TAKEN FROM CHATGPT
  //CODE OF DYNAMIC LIST IS CODED FROM YOUTUBE TUTORIAL

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String? side ;
  List<String> _laps = [];
  var time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
    _stopwatch.start();
  }

  void stopTimer() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  void resetTimer() {
    _stopwatch.reset();
    // setState(() {
    //   _laps.clear();
    // });
  }

  void lapTimer() {
    setState(() {
      _laps.insert(0, formatTime(_stopwatch.elapsedMilliseconds));
    });
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  CollectionReference _documentReference = FirebaseFirestore.instance.collection('feed');

  // List<Welcome> feed = [
  //   // Welcome(type: "left", duration: "00:23", solid: "nothing", time: "2:23", date: "2-3-2023"),
  //   // Welcome(type: "right", duration: "00:43", solid: "nothing", time: "2:24", date: "2-3-2023"),
  //   // Welcome(type: "left", duration: "00:33", solid: "nothing", time: "2:25", date: "2-3-2023"),
  // ];
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
            await saveImage(image);
            saveAndShare(image);
          },
          child: Icon(Icons.share),
        ),
        appBar: AppBar(
          title: Text('Breast Feeding'),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_feed()));
              },
              icon: Icon(Icons.add),
            ),
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
                      "History of Sleep cycle",
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
                        List welcome1 = document.map((e) => Welcome(type: e['type'], duration: e['duration'], solid: e['solid'], time: e['time'], date: e['date'])).toList();
                        return getdata(welcome1);
                      }
                      else{
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
        ),
      ),
    );
  }

  getdata(welcome1) {
    return Expanded(
      child: ListView.builder(
        itemCount: welcome1.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text("Duration - ${welcome1[index].duration}"),
            subtitle: Text("${welcome1[index].date}  ${welcome1[index].time}  ${welcome1[index].solid} "),
            trailing: CircleAvatar(
              child: (welcome1[index].type =='left') ? Text('L'):Text('R'),
              radius: 20,
            ),
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


