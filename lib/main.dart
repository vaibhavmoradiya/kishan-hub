
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kishan_hub/auth/auth.dart';
import 'package:kishan_hub/login/root_page.dart';

void main() {
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Kishan Hub',
    
    theme: ThemeData(
      primaryColor: Colors.greenAccent[700],
      textTheme:GoogleFonts.latoTextTheme(
      Theme.of(context).textTheme,
    ), 
    ),
    home: RootPage(auth: Auth(),),
  );
  }
  
}