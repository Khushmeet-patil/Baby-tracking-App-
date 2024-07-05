import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossapp/pages/hw.dart';
import 'package:crossapp/model/hw_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Addhw extends StatefulWidget {
  const Addhw({Key? key}) : super(key: key);

  @override
  State<Addhw> createState() => _AddhwState();
}

class _AddhwState extends State<Addhw> {
  //CODE OF TIMEPICKER AND DATEPICKER IS FROM FLUTTER DOCUMENTATION
  var time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController weightcontroller = TextEditingController();
  TextEditingController hightcontroller = TextEditingController();
  TextEditingController time3controller = TextEditingController();
  TextEditingController date3controller = TextEditingController();

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

  int selectedWeight = 5;
  int selectedHeight = 170;

  List<int> weights = List.generate(200, (index) => index + 1);
  List<int> heights = List.generate(200, (index) => index + 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add nappy"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            //CODE OF DROPDOWNBUTTONHIDEUNDERLINE IS TAKEN FROM FLUTTER DOCUMENTATION EXAMPLE

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text("Weight (kg)"),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedWeight,
                    onChanged: (Value) {
                      setState(() {
                        selectedWeight = Value!;
                        weightcontroller.text = '$selectedWeight kg';
                      });
                    },
                    items: weights.map((int weight) {
                      return DropdownMenuItem<int>(
                        value: weight,
                        child: Text(weight.toString()),
                      );
                    }).toList(),
                  ),
                ),
    ),
              ],
            ),

            Column(
              children: [
                Text("Height (cm)"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedHeight,
                      onChanged: (Value) {
                        setState(() {
                          selectedHeight = Value!;
                          hightcontroller.text = '$selectedHeight cm';
                        });
                      },
                      items: heights.map((int height) {
                        return DropdownMenuItem<int>(
                          value: height,
                          child: Text(height.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
            getmyfeild(hinttext: 'weight', textInputType: TextInputType.text, controller: weightcontroller,iconbutton: IconButton(onPressed:null, icon: Icon(Icons.height))),
            getmyfeild(hinttext: 'hight', textInputType: TextInputType.text, controller: hightcontroller,iconbutton:IconButton(onPressed: null, icon: Icon(Icons.monitor_weight)) ),
            getmyfeild(hinttext: 'time', textInputType: TextInputType.text, controller: time3controller,iconbutton: IconButton(onPressed: () async{
              final TimeOfDay? timeofday = await showTimePicker(context: context, initialTime: selectedTime,initialEntryMode: TimePickerEntryMode.dial);
              if(timeofday != null){
                setState(() {
                  selectedTime = timeofday;
                  time3controller.text = '${selectedTime.hour}:${selectedTime.minute}';
                });
              }
            }, icon: Icon(Icons.access_time))),
            getmyfeild(hinttext: 'date', textInputType: TextInputType.text, controller: date3controller,iconbutton:IconButton(onPressed: ()async {
              DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if(pickeddate != null){
                setState(() {
                  date3controller.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                });
              }
            }, icon: Icon(Icons.calendar_month_sharp)) ),

            ElevatedButton(
              onPressed: (){
                HW hw = HW(hight: hightcontroller.text, weight: weightcontroller.text, date: date3controller.text, time: time3controller.text);

                addnappyNavigator(hw,context);
              },
              child: Text("Submit"),
            )

          ],
        ),
      ),
    );
  }
}

void addnappyNavigator(HW hw , BuildContext context) {
  final hwref = FirebaseFirestore.instance.collection('hw').doc();
  // welcome.id = Feedref.id;
  final data = hw.toJson();
  hwref.set(data).whenComplete(() {
    print("user inserted");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HandW()));
  });
}
