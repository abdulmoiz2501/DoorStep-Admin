import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_admin/constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import '../../components/progress_dialog.dart';
import '../../components/signInButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_admin/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginPage extends StatefulWidget {
  final Function()? onSignUpClicked;
  LoginPage({Key? key, required this.onSignUpClicked}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  /*tokenUpdate(String userId){

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic('user');
    _firebaseMessaging.getToken().then((value) {

      FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.get('token')}');

          if(documentSnapshot.get('token').toString() != value.toString())
          {
            CollectionReference tokening = FirebaseFirestore.instance.collection('customer');

            tokening
                .doc(userId)
                .update({
              'token': value.toString()
            }).then((value) => print("User Updated"))
                .catchError((error) => print("Failed to update user: $error"));
          }
        } else {
          print('Document does not exist on the database');
        }
      });


    }).onError((error, stackTrace)
    {

    });
  }*/

  tokenSetNew(String userId){

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic('user');
    _firebaseMessaging.getToken().then((value) {

      CollectionReference users = FirebaseFirestore.instance.collection('userProfile');

      users
          .doc(userId)
          .update({
        'token': value.toString()
      }).then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));


    }).onError((error, stackTrace)
    {
      print(error);
      /// add snackbar
      //CustomAlertDialogs.showFailuresDailog(context,error.toString());

    });
  }


  void signUserIn() async{

    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    ///Loading
    // Show the progress dialog before performing the task.
    ProgressDialogWidget.show(context, "Please wait...");


    ///Sign user in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),

      );
      /*DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        print('Document data: ${userDoc.data()}');

        String userType = userDoc.get('usertype');
        print('User type being retireved: $userType');


        if (userType == "admin") {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          print('correct pass but wrong usertype');
          final snackBar = SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'On Snap!',
              message:
              'The email you entered is not registered',

              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }*/

     /// tokenUpdate(FirebaseAuth.instance.currentUser!.uid.toString());
      // Task completed. Hide the progress dialog.
      tokenSetNew(FirebaseAuth.instance.currentUser!.uid.toString());
      ProgressDialogWidget.hide(context);
      print('logged in');
      Navigator.pushReplacementNamed(context, '/dashboard');
    }on FirebaseAuthException catch (e){
      // Task completed. Hide the progress dialog.
      ProgressDialogWidget.hide(context);
      print('login exception');

      ///Wrong email
      if(e.code == 'user-not-found'){
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message:
            'The email you entered is not registered',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      ///Wrong password
      else if(e.code == 'wrong-password'){
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message:
            'The password you entered is incorrect',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      ///No internet
      else if(e.code == 'network-request-failed') {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message:
            'Please check your internet connection and try again',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.warning,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  //logo
                  Icon(
                    Icons.lock,
                    size: 50,
                    color: kAccentColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  //welcomeback
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.029,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065),
                    child: TextFormField(
                      obscureText: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        fillColor: kTextBoxColor,
                        filled: true,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color:kHintTextColor,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }

                        if (!EmailValidator.validate(value)) {
                          return 'Enter a valid email';
                        }

                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //password
                  // MyTextField(
                  //   controlller: passwordController,
                  //   hintText: 'Password',
                  //   obscureText: true,
                  //   emailValidate: false,
                  //   passValidate: true,
                  //   confirmPassValidate: false,
                  // ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        fillColor: kTextBoxColor,
                        filled: true,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color:kHintTextColor,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.length < 6) {
                          return 'Enter 6 characters (minimum)';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.019,
                  ),

                  //forgot pass
                  /*Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.065),
                    child: Row(
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: kTextColor),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),*/

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.024,
                  ),
                  //signin
                  SignInButton(
                    text: 'Sign In',
                    onTap: signUserIn,
                  ),
                  //continue with

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.044,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.2,
                            color: Colors.grey[400],
                          ),
                        ),
                        /*Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.025),
                          child: Text(
                            'Or continue with ',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.019,
                              color: kTextColor,
                            ),
                          ),
                        ),*/
                        Expanded(
                          child: Divider(
                            thickness: 0.2,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.024,
                  ),

                  //google signin
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        imagePath: 'lib/assets/images/google.png',
                        onTap: () => AuthService().signInWithGoogle(),
                      ),
                    ],
                  ),*/
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  //not a user?
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a user?",

                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.020,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.015,
                      ),
                      GestureDetector(
                        onTap: widget.onSignUpClicked,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.022,
                            color: kAccentColor,
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
