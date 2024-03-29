import 'package:ai_music/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),



      
    );
  }
}