import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_admin/components/my_list_tile.dart';
import 'package:project_admin/constants.dart';

class MyDrawer extends StatefulWidget {

  final void Function()? onHomeTap;
  final void Function()? onProfileTap;
  final void Function()? onSettingTap;
  final void Function()? onLogoutTap;
  final void Function()? onComplaintTap;


  const MyDrawer({Key? key, required this.onProfileTap, required this.onSettingTap, required this.onLogoutTap, required this.onHomeTap, this.onComplaintTap}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: kAccentColor,
      child: Column(
        children: [
         SizedBox(height: 50,),


         ///home list tile
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: widget.onHomeTap,
          ),
          ///profile list tile
          /*MyListTile(
              icon: Icons.person,
              text: 'P R O F I L E' ,
              onTap: widget.onProfileTap
          ),*/

          ///settings list tile
          MyListTile(
              icon: Icons.settings,
              text: 'A C T I V I T Y' ,
              onTap: widget.onSettingTap,
          ),
          MyListTile(
            icon: Icons.settings,
            text: 'C O M P L A I N T S' ,
            onTap: widget.onComplaintTap,
          ),

          ///logout list tile
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            onTap: widget.onLogoutTap,
          ),
        ],
      ),
    );
  }
}
