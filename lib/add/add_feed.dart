import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/pages/feed.dart';
import 'package:crossapp/home.dart';
import 'package:crossapp/model/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Add_feed extends StatefulWidget {
  const Add_feed({Key? key}) : super(key: key);

  @override
  State<Add_feed> createState() => _Add_feedState();
}

class _Add_feedState extends State<Add_feed> {
  //CODE OF TIMEPICKER AND DATEPICKER IS FROM FLUTTER DOCUMENTATION
  //CODE OF STOPWATCH IS TAKEN FROM CHATGPT
  var time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String? side ;
  List<String> _laps = [];

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

  final TextEditingController typecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController durationcontroller = TextEditingController();
  final TextEditingController solidcontroller = TextEditingController();


  Widget getmyfeild({required String hinttext,required TextInputType textInputType ,required TextEditingController controller,required IconButton iconbutton2}){
  return Padding(
    padding: EdgeInsets.all(10.0),
    child:TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: 'Enter $hinttext',
        labelText: hinttext,
          prefixIcon: iconbutton2,

      ),
    ),
  );
  }
  @override
  Widget build(BuildContext context) {
    durationcontroller.text = '${formatTime(_stopwatch.elapsedMilliseconds)}';
    typecontroller.text = '${(side == 'L') ? 'Left':'Right'}';
    // datecontroller.text = '${time.day}-${time.month}-${time.year}';
    return Scaffold(
      appBar: AppBar(
        title: Text("Add feed"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  formatTime(_stopwatch.elapsedMilliseconds),
                  style: TextStyle(fontSize: 48.0),
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          startTimer();
                          side = 'L';
                        });
                      },
                      child: Text("Left"),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: (){

                        setState(() {
                          startTimer();
                          side = 'R';
                        });
                      },
                      child: Text("Right"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: (){
                        lapTimer();
                        stopTimer();
                        // lapTimer();

                      },
                      child: Text('Finish'),
                    ),
                  ),
                ),
              ],
            ),

            

            Divider(),

            getmyfeild(hinttext: "type", textInputType: TextInputType.name,controller: typecontroller,iconbutton2: IconButton(onPressed: null, icon: Icon(Icons.add))),
            getmyfeild(hinttext: "duration", textInputType: TextInputType.name,controller: durationcontroller,iconbutton2:IconButton(onPressed: null, icon: Icon(Icons.timer)) ),
            getmyfeild(hinttext: "time", textInputType: TextInputType.name,controller: timecontroller,iconbutton2:IconButton(onPressed: () async{
              final TimeOfDay? timeofday = await showTimePicker(context: context, initialTime: selectedTime,initialEntryMode: TimePickerEntryMode.dial);
              if(timeofday != null){
                setState(() {
                  selectedTime = timeofday;
                  timecontroller.text = '${selectedTime.hour}:${selectedTime.minute}';
                });
              }
            }, icon: Icon(Icons.access_time_rounded)) ),
            getmyfeild(hinttext: "date", textInputType: TextInputType.number,controller: datecontroller,iconbutton2: IconButton(onPressed: ()async {
              DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if(pickeddate != null){
                setState(() {
                  datecontroller.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                });
              }
            }, icon: Icon(Icons.calendar_month_sharp))),
            getmyfeild(hinttext: "solid", textInputType: TextInputType.name,controller: solidcontroller,iconbutton2:IconButton(onPressed: null, icon: Icon(Icons.book)) ),

            ElevatedButton(
              onPressed: (){
                Welcome welcome = Welcome(
                    type: typecontroller.text,
                    duration: durationcontroller.text,
                    solid: solidcontroller.text,
                    time: timecontroller.text,
                    date: datecontroller.text,
                );

                addFeedNavigator(welcome,context);
                resetTimer();
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  void addFeedNavigator(Welcome welcome, BuildContext context) {
    final Feedref = FirebaseFirestore.instance.collection('feed').doc();
    // welcome.id = Feedref.id;
    final data = welcome.toJson();
    Feedref.set(data).whenComplete(() {
      print("user inserted");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Feed()));
    });
  }
}
