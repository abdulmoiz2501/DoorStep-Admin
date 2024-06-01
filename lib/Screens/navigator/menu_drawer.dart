//import 'package:DoorStep/Screens/MyAccountSaved/MyAccountSaved.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_admin/Screens/Login/login.dart';
//import 'package:doorstep_guard/Screens/MyAccount/My_Account.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:doorstep_guard/Screens/FAQ/Faq.dart';
//import 'package:doorstep_guard/Screens/Support/Support.dart';
import '../../components/progress_dialog.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Head of Drawer

          // MY ACCOUNT
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                'My Account',
                style:
                    TextStyle(fontSize: 17, fontFamily: 'Montserrat Regular'),
              ),
              //onTap: () => isUserDetailCompleted(),
          ),

          //SETTING
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 17, fontFamily: 'Montserrat Regular'),
            ),
          ),

          //HELP & SUPPORT
/*          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text(
              'Help/Support',
              style: TextStyle(fontSize: 17, fontFamily: 'Montserrat Regular'),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  //builder: (context) => Support(),
                ),
              );
            },
          ),*/
          //LOGOUT
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 17, fontFamily: 'Montserrat Regular'),
            ),
            onTap: signUserOut,
          ),
        ],
      ),
    );
  }
  void signUserOut() async {
    try{
      await FirebaseAuth.instance.signOut();

    }
    catch(err){
      print('Sign out error is: $err');
    }

  }
}
