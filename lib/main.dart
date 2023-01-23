import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/pages/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.white),
    home: const LoginScreen(),),);
}
//
// class Statistics extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<Users>.value(
//       value: AuthService().currentUser,
//       child: MaterialApp(theme: ThemeData(primaryColor: Colors.amberAccent), home: LandingPage(),),
//     )
//   }
// }
