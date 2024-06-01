import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_admin/Screens/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import '../../components/progress_dialog.dart';
import '../../components/upload_image.dart';
import '../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewService extends StatefulWidget {
  @override
  _NewServiceState createState() => _NewServiceState();
}

class _NewServiceState extends State<NewService> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _serviceNumber = TextEditingController();
  final TextEditingController _providerName = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  File? _image;

  // Dropdown related variables
  String? _selectedServiceType;
  List<String> _serviceTypes = [
    "electricians",
    "gardeners",
    "plumbers",
    "painters",
    "car_mechanics",
    "house_helps",
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Service'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedServiceType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedServiceType = newValue;
                    });
                  },
                  hint: Text('Select Service Type'),
                  items: _serviceTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                  value == null ? 'Please select a service type' : null,
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              _buildTextField(
                controller: _serviceName,
                hintText: "Enter Service Name",
                size: size,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              _buildTextField(
                controller: _serviceNumber,
                hintText: "Enter Service Number",
                size: size,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              _buildTextField(
                controller: _providerName,
                hintText: "Enter Provider Name",
                size: size,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              _buildTextField(
                controller: _rate,
                hintText: "Enter Rate",
                size: size,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (_image != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(_image!),
                  ),
                ),
              SizedBox(
                height: size.height * 0.04,
              ),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      addService(
                        _selectedServiceType!,
                        _serviceName.text,
                        _serviceNumber.text,
                        _providerName.text,
                        _rate.text,
                        _image,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Montserrat Medium',
                      fontSize: 20,
                    ),
                  ),
                  child: Text(
                    'Add Service',
                    style: TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Size size,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade200,
        ),
        height: size.height * 0.08,
        width: size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field is Empty';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontFamily: "Montserrat Regular",
              fontWeight: FontWeight.bold,
            ),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addService(
      String serviceType,
      String serviceName,
      String serviceNumber,
      String providerName,
      String rate,
      File? image,
      ) async {
    String imageUrl = "";

    ProgressDialogWidget.show(context, "Please wait...");
    if (image != null) {
      imageUrl = await uploadProfileImageToStorage(providerName, image);
    }

    final CollectionReference service =
    FirebaseFirestore.instance.collection(serviceType);



    await service.doc().set({
      "Service Name": serviceName,
      "number": serviceNumber,
      "Provider Name": providerName,
      "rate": rate,
      "img": imageUrl,
      "averageRating" : "0.0",
      "numberOfRatings" : "0.0",
      "rating" : "0.0",
    }).whenComplete(() {
      ProgressDialogWidget.hide(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }
}
