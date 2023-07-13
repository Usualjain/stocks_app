import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:stocks_app/widgets/auth_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => const MaterialApp(
        home: AuthPage(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(420, 933),

      minTextAdapt: true,
      splitScreenMode: true,
    );
    // return Sizer(builder: (context, orientation, deviceType)
    // {
    //   return  const MaterialApp(
    //     home:  AuthPage(),
    //   );
    // });
  }
}

