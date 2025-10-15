import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:revbank/UI/LoginScreen.dart';
import 'package:revbank/UI/SignUpScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X/11 Pro size - adjust to your design
      minTextAdapt: true,
      splitScreenMode: true, // This is what was missing!
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RevBank',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
          ),
          home: const RegistrationScreen(),
        );
      },
    );
  }
}