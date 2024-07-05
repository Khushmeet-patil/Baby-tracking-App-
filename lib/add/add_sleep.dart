import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/model/sleep_model.dart';
import 'package:crossapp/pages/sleep.dart';
import 'package:flutter/material.dart';

class AddSleep extends StatefulWidget {
  const AddSleep({Key? key}) : super(key: key);

  @override
  State<AddSleep> createState() => _AddSleepState();
}

class _AddSleepState extends State<AddSleep> {

  //CODE OF TIMEPICKER AND DATEPICKER IS FROM FLUTTER DOCUMENTATION
  var time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();

  TextEditingController initialcontroller = TextEditingController();
  TextEditingController finalcontroller = TextEditingController();
  TextEditingController detailscontroller = TextEditingController();

  Widget getmyfeild({required String hinttext,required TextInputType textInputType ,required TextEditingController controller,required IconButton iconbutton}){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child:TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: 'Enter $hinttext',
          labelText: hinttext,
            prefixIcon: iconbutton
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Sleep"),
      ),
      body: Column(
        children: [
          getmyfeild(hinttext: 'initialtime', textInputType: TextInputType.text, controller: initialcontroller,iconbutton: IconButton(onPressed: () async{
            final TimeOfDay? timeofday = await showTimePicker(context: context, initialTime: selectedTime,initialEntryMode: TimePickerEntryMode.dial);
            if(timeofday != null){
              setState(() {
                selectedTime = timeofday;
                initialcontroller.text = '${selectedTime.hour}:${selectedTime.minute}';
              });
            }
          }, icon: Icon(Icons.timer_outlined))),
          getmyfeild(hinttext: 'finaltime', textInputType: TextInputType.text, controller: finalcontroller,iconbutton:IconButton(onPressed: () async{
            final TimeOfDay? timeofday = await showTimePicker(context: context, initialTime: selectedTime,initialEntryMode: TimePickerEntryMode.dial);
            if(timeofday != null){
              setState(() {
                selectedTime2 = timeofday;
                finalcontroller.text = '${selectedTime2.hour}:${selectedTime2.minute}';
              });
            }
          }, icon: Icon(Icons.timer_sharp)) ),
          getmyfeild(hinttext: 'details', textInputType: TextInputType.text, controller: detailscontroller,iconbutton: IconButton(onPressed: null, icon: Icon(Icons.book))),

          ElevatedButton(
            onPressed: (){
              Slep sleep = Slep(itime: initialcontroller.text, ftime: finalcontroller.text, details: detailscontroller.text);

              addsleepNavigator(sleep,context);
            },
            child: Text("Submit"),
          )

        ],
      ),
    );
  }
}

void addsleepNavigator(Slep sleep , BuildContext context) {
  final sleepref = FirebaseFirestore.instance.collection('sleeps').doc();
  // welcome.id = Feedref.id;
  final data = sleep.toJson();
  sleepref.set(data).whenComplete(() {
    print("user inserted");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sleep()));
  });
}

