import 'package:project_admin/Screens/Login/login.dart';
import 'package:project_admin/Screens/Make%20Announcment/Make_Announcment.dart';
import 'package:project_admin/Screens/Make%20Survey/Make_Survey.dart';
import 'package:project_admin/Screens/New%20Service/New_Service.dart';
import 'package:project_admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/drawer.dart';
import '../New Polls/new_polls_page.dart';
import '../SOS List/sos_list.dart';
import '../chat/AllChat.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signOut() async {
    try {
      return await _auth.signOut().then((value) =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage(onSignUpClicked: () {  },))));
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(
        onHomeTap: () {
          Navigator.pop(context);
          //Navigator.pushNamed(context, '/home');
        },
        onProfileTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile');
        },
        onComplaintTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/complaints');
        },
          onSettingTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/activeList');
          },
        onLogoutTap: signOut,

      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
        centerTitle: false,
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat Regular",
                    ),
                  ),
                  SizedBox(
                    width: 8.0, // Adjust the spacing between text and icon
                  ),
                  Icon(
                    Icons.logout,
                    size: 26.0,
                    color: Colors.white, // Ensure the icon color matches the text
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    ),

      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [

            SizedBox(
              height: size.height*0.05,
            ),

            //title
            Text("Dashboard Admin",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),

            SizedBox(
              height: size.height*0.02,
            ),

            // main image
            Container(
              height: size.height*0.2,
                child: Image.asset("assets/images/support.png",)
            ),
            SizedBox(
              height: size.height*0.05,
            ),

            // Announcement
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 22.0, // Spacing between rows
                    childAspectRatio: 3 / 2, // Aspect ratio of each item
                  ),
                  itemCount: 6, // Number of containers
                  itemBuilder: (BuildContext context, int index) {
                    String title;
                    IconData icon;
                    Widget targetPage;

                    switch (index) {
                      case 0:
                        title = "Announcement";
                        icon = Icons.announcement;
                        targetPage = MakeAnnouncement();
                        break;
                      case 1:
                        title = "Survey";
                        icon = Icons.forum;
                        targetPage = MakeSurvey();
                        break;
                      case 2:
                        title = "Services";
                        icon = Icons.home_repair_service_outlined;
                        targetPage = NewService();
                        break;
                      case 3:
                        title = "Polls";
                        icon = Icons.how_to_vote; // Use a relevant icon
                        targetPage = AddPollPage(); // Replace with actual target page
                        break;
                      case 4:
                        title = "SOS";
                        icon = Icons.sos; // Use a relevant icon
                        targetPage = SosListPage(); // Replace with actual target page
                        break;
                      case 5:
                        title = "Chat";
                        icon = Icons.chat_outlined; // Use a relevant icon
                        targetPage = MyChats(); // Replace with actual target page
                        break;
                      default:
                        title = "Default";
                        icon = Icons.info;
                        targetPage = Placeholder();
                        break;
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => targetPage,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kPrimaryColor),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14, // Adjust the font size here
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              icon,
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),



          ],
        ),
      ),

    );
  }
}
