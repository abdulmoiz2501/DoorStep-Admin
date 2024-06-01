import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/progress_dialog.dart';

import '../../components/strings.dart';
import '../../constants.dart';
import '../Dashboard/Dashboard.dart';
import 'package:http/http.dart' as http;

class MakeAnnouncement extends StatefulWidget {
  @override
  _MakeAnnouncementState createState() => _MakeAnnouncementState();
}

class _MakeAnnouncementState extends State<MakeAnnouncement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [


              SizedBox(
                height: size.height*0.08,
              ),

              Text("Make an Announcment",style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),

              SizedBox(
                height: size.height*0.04,
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color:Colors.grey.shade300),
                    color: Colors.grey.shade200,
                  ),
                  height: size.height*0.08,
                  width: size.width*0.9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0,22,10,10),
                    child: TextFormField(
                      maxLength: 25,
                      buildCounter: (
                          BuildContext context, {
                            required int currentLength,
                            required int? maxLength,
                            required bool isFocused,
                          }) {
                        return null;
                      },
                      controller: _title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field is Empty';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontFamily: "Montserrat Regular",
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Enter Title",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),



                  ),

                ),
              ),

              SizedBox(
                height: size.height*0.04,
              ),


              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color:Colors.grey.shade300),
                    color: Colors.grey.shade200,
                  ),
                  height: size.height*0.4,
                  width: size.width*0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 25,
                      controller: _description,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is Empty';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontFamily: "Montserrat Regular",
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Colors.black54,
                      decoration: InputDecoration (
                        hintText: "Enter Description",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),

                  ),

                ),
              ),

              SizedBox(
                height: size.height*0.18,
              ),


              // report button
              SizedBox(
                height: size.height*0.08,
                width: size.width*0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      makeAnnouncment(_title.text, _description.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Montserrat Medium',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  child: Text(
                    'Announce',
                    style: TextStyle(
                      color: Colors.white, // Ensure the text color is white
                    ),
                  ),
                ),


              )

            ],
          ),
        ),

      ),
    );

  }//second




  Future <void> makeAnnouncment(String title , String description )async {

    FirebaseFirestore.instance.collection('userProfile').where('usertype',isEqualTo: 'resident')
        .get()
        .then((QuerySnapshot querySnapshot) {

      for(int i=0 ; i<querySnapshot.docs.length; i++){
        print(querySnapshot.docs[i].get('name'));
        print(querySnapshot.docs[i].get('email'));
        print(querySnapshot.docs[i].get('token'));
        sendNotification(querySnapshot.docs[i].get('token'));
      }

    });


    final CollectionReference announcement = FirebaseFirestore.instance.collection(
        'announcement');

    ProgressDialogWidget.show(context, "Please wait...");


    await announcement.doc().set({
      "title": title,
      "description": description,

    }).whenComplete(() {
    ProgressDialogWidget.hide(context);;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard()),);
      print('posted announcement');
    });
  }

  sendNotification(String token) async{
    String url='https://fcm.googleapis.com/fcm/send';
    Uri myUri = Uri.parse(url);
    await http.post(
      myUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Hey ! There is a new Announcement. Please check the app for more details.',
            'title': 'Announcement Alert!',
            "sound" : "default"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '$token',
        },
      ),
    );

  }


}// final


