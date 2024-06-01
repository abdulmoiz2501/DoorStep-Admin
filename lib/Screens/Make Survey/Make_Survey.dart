import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_admin/Screens/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import '../../components/progress_dialog.dart';

import '../../constants.dart';

class MakeSurvey extends StatefulWidget {
  @override
  _MakeSurveyState createState() => _MakeSurveyState();
}

class _MakeSurveyState extends State<MakeSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _link = TextEditingController();

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

              Text("Publish a Survey",style: TextStyle(
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
                  height: size.height*0.25,
                  width: size.width*0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 25,
                      controller: _subtitle,
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
                  height: size.height*0.18,
                  width: size.width*0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 25,
                      controller: _link,
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
                        hintText: "Enter Link",
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
                height: size.height*0.15,
              ),


              // report button
              SizedBox(
                height: size.height*0.08,
                width: size.width*0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      makeSurvey(_title.text, _subtitle.text, _link.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(
                    'Publish',
                    style: TextStyle(
                      fontFamily: 'Montserrat Medium',
                      fontSize: 20,
                      color: Colors.white,
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

  Future <void> makeSurvey(String title , String subtitle , String link )async {
    final CollectionReference survey = FirebaseFirestore.instance.collection(
        'survey');

    ProgressDialogWidget.show(context, "Please wait...");


    await survey.doc().set({
      "title": title,
      "subtitle": subtitle,
      "link" : link

    }).whenComplete(() {
    ProgressDialogWidget.hide(context);;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard()),);
    });
  }

}// final


