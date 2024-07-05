import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class Nappys extends StatefulWidget {
  const Nappys({Key? key}) : super(key: key);

  @override
  State<Nappys> createState() => _NappysState();
}

class _NappysState extends State<Nappys> {
  //CODE OF DYNAMIC LIST IS CODED FROM YOUTUBE TUTORIAL
  final sscontroller = ScreenshotController();
  deletedata(id)async{
    await FirebaseFirestore.instance.collection('nappy').doc(id).delete();
  }
  final CollectionReference napyy = FirebaseFirestore.instance.collection('nappy');
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  "ALL LOGS OF NAPPY",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 10.0,),

              StreamBuilder<QuerySnapshot>(
                  stream: napyy.snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
                    if(streamSnapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              title: Text('${documentSnapshot['type']}'),
                              subtitle: Text('${documentSnapshot['time']}   ${documentSnapshot['date']} '),
                              trailing: IconButton(
                                onPressed: (){
                                  // sleepp.doc(documentSnapshot[index]).delete();
                                  deletedata(documentSnapshot.id);
                                  setState(() {

                                  });
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );;
  }
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
