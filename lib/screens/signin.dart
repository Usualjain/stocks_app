import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_app/screens/home.dart';
import 'package:stocks_app/widgets/blink_loading.dart';
import 'package:stocks_app/widgets/signin_signup.dart';
import 'package:stocks_app/screens/signup.dart';


class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});
  static String verify="";
  @override
    _SignInScreenState createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _phoneNumTextController = TextEditingController();
  
  Image signInImageWidget(String imageName){
    return  Image.asset(
        width: double.infinity.w,
        height: 360.h,
        scale:0.5,
        imageName,
        fit: BoxFit.fill,
    );
  }

  otpSendingMethod(){
    auth.verifyPhoneNumber(
      phoneNumber: '+91 ${_phoneNumTextController.text}',
      verificationCompleted: (PhoneAuthCredential credential){
        auth.signInWithCredential(credential).then((value) => Navigator.of(context).pop(true));
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        SignInScreen.verify = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  var finalCode="";
  var isVerified = false;
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body: Container(
              height: double.infinity.h,
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(top: 45.h),
                      child: signInImageWidget(
                          './assets/images/signin_screen_image.png'),
                    ),
                    SizedBox(height: 60.h,),
                    SizedBox(
                      width: 360.w,
                      child: TextField(
                        controller: _phoneNumTextController,
                        maxLength: 10,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 22.sp),
                        decoration: InputDecoration(
                          prefixIcon: const Icon( Icons.verified_user, color: Colors.white,),
                          prefixText: '+91 ',

                          suffix: TextButton(
                              onPressed: ()async{
                                if(_phoneNumTextController.text != ''){
                                  try{
                                    var db = await FirebaseFirestore.instance
                                        .collection(
                                        'UserData').
                                    doc(_phoneNumTextController.text).get();
                                    if(db.exists){
                                      otpSendingMethod();
                                      setState(() {
                                        isVerified = true;
                                      });
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please SignUp Before Logging'),));
                                    }
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(right: 10.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.square(2.h),) ,
                            child: const Text('Send Otp', style: TextStyle(color:Colors.white),),),
                            prefixStyle: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.sp),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                color: Colors.white60.withOpacity(0.9), fontSize: 20.sp),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(38.h),
                                borderSide: const BorderSide(width: 0, style: BorderStyle.none))
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                        // child: textFieldWidget(
                        //     context, "Phone Number", Icons.verified_user, false,
                        //     true, _phoneNumTextController)),
                    SizedBox(height: 22.h,),
                    SizedBox(
                        width: 360.w,
                        child: textFieldWidget(
                            context, "OTP", Icons.lock, true, false,
                            _passwordTextController)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: () {},
                            child: const Text(
                              'Issue in logging in?', style: TextStyle(
                                color: Colors.white60),)),
                        TextButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUpScreen()
                          ));
                          _passwordTextController.clear();
                          _phoneNumTextController.clear();
                        },
                            child: const Text(
                                "Don't have an account?", style: TextStyle(
                                color: Colors.white60))),
                      ],
                    ),
                    SizedBox(height: 33.h),
                    SizedBox(
                        width: 375.w,
                        child: signInSignUpButton('LOG IN', (){
                          finalCode = _passwordTextController.text;
                          (_passwordTextController.text == "" ||
                              _phoneNumTextController.text == "")
                              ?
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Text Fields can't be empty")))
                              :
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const BlinkLoading()));
                          try {
                            // doc(_phoneNumTextController.text).get().timeout(const Duration(seconds: 5));
                            if (!isVerified) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const SignInScreen()
                                  ),
                                      (Route<dynamic> route) => false);
                              _passwordTextController.clear();
                              _phoneNumTextController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please Generate Otp First')));
                            }
                            else {
                              try {
                                PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                  verificationId: SignInScreen.verify,
                                  smsCode: finalCode,
                                );
                                auth.signInWithCredential(credential).then((value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => const HomeScreen()
                                        ),
                                            (Route<dynamic> route) => false)
                                );
                                _passwordTextController.clear();
                                _phoneNumTextController.clear();
                              }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                builder: (context) => const SignInScreen()
                                ),
                                (Route<dynamic> route) => false);
                                _passwordTextController.clear();
                                _phoneNumTextController.clear();
                              }
                            }
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Check your internet connection and try again')));
                          }
                        })
                    ),


                  ],
                ),
              ),
            ),
          );
  }
}