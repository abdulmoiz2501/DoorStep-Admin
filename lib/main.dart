
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_admin/Screens/Dashboard/Dashboard.dart';
import 'package:provider/provider.dart';

import 'Screens/Complaints/Complaints.dart';
import 'Screens/Guard Activity/guard_activity_list.dart';
import 'Screens/New Polls/new_polls_provider.dart';
import 'Screens/Splash Screen/splash.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
        providers:
          [
            ChangeNotifierProvider(create: (context) => DbProvider()),
          ],
     child:  MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          '/dashboard': (context) => Dashboard(),
          '/activeList': (context) => GuardActivityPage(),
          '/complaints': (context) => AdminComplaintsPage(),
        }
    );
  }
}
