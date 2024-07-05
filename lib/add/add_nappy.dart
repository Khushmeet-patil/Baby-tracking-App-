import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/model/nappy_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../pages/nappy.dart';

class Addnappy extends StatefulWidget {
  const Addnappy({Key? key}) : super(key: key);

  @override
  State<Addnappy> createState() => _AddnappyState();
}

class _AddnappyState extends State<Addnappy> {

  //CODE OF TIMEPICKER AND DATEPICKER IS FROM FLUTTER DOCUMENTATION

  var time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController type2controller = TextEditingController();
  TextEditingController time2controller = TextEditingController();
  TextEditingController date2controller = TextEditingController();

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
        title: Text("Add nappy"),
      ),
      body: Column(
        children: [
          getmyfeild(hinttext: 'type', textInputType: TextInputType.text, controller: type2controller,iconbutton: IconButton(onPressed: null, icon: Icon(Icons.add))),
          getmyfeild(hinttext: 'time', textInputType: TextInputType.text, controller: time2controller,iconbutton: IconButton(onPressed: () async{
            final TimeOfDay? timeofday = await showTimePicker(context: context, initialTime: selectedTime,initialEntryMode: TimePickerEntryMode.dial);
            if(timeofday != null){
              setState(() {
                selectedTime = timeofday;
                time2controller.text = '${selectedTime.hour}:${selectedTime.minute}';
              });
            }
          }, icon: Icon(Icons.access_time))),
          getmyfeild(hinttext: 'date', textInputType: TextInputType.text, controller: date2controller,iconbutton: IconButton(onPressed: ()async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if(pickeddate != null){
              setState(() {
                date2controller.text = DateFormat('yyyy-MM-dd').format(pickeddate);
              });
            }
          }, icon: Icon(Icons.date_range))),

          ElevatedButton(
            onPressed: (){
              Napy nappy = Napy(type: type2controller.text, time: time2controller.text, date: date2controller.text);

              addnappyNavigator(nappy,context);
            },
            child: Text("Submit"),
          )

        ],
      ),
    );
  }

  void addnappyNavigator(Napy nappy , BuildContext context) {
    final nappyref = FirebaseFirestore.instance.collection('nappy').doc();
    // welcome.id = Feedref.id;
    final data = nappy.toJson();
    nappyref.set(data).whenComplete(() {
      print("user inserted");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Nappy()));
    });
  }

}
