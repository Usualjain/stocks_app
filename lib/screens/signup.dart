import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/screens/phone_verify.dart';
import 'package:stocks_app/widgets/signin_signup.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key,});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _phoneNumberTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _experienceTextController = TextEditingController();

  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {

    Widget pno = TextField(
      onChanged: (text){
        if(_isVerified){
          setState(() {
            _isVerified = false;
          });
        }
      },

      controller: _phoneNumberTextController,
      maxLength: 10,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20.sp),
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone , color: Colors.white,),
          prefixText: '+91 ' ,
          suffix: (_isVerified) ?
          const Icon(Icons.verified, color: Colors.green,) :
          TextButton(onPressed: ()async{
          if(_phoneNumberTextController.text.length == 10){
              _isVerified = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
              PhoneVerifyScreen(phoneNumber: _phoneNumberTextController.text)
              ),
              );
          }else{
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a valid phone number')));
          }
            if(_isVerified){
              setState(() {
                _isVerified;
              });
            }
          },
            style: TextButton.styleFrom(
              padding: EdgeInsets.only(right: 11.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.square(2.h),) ,
            child: const Text('Verify', style: TextStyle(color:Colors.white),),
          ),
          prefixStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.sp),
          labelText: 'Phone Number',
          labelStyle: TextStyle(
              color: Colors.white60.withOpacity(0.9), fontSize: 20.sp),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(33.h),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))
      ),
      keyboardType:TextInputType.number,
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(fontSize: 22.sp)),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height:100.h, width: double.infinity.w,),
              SizedBox(width:360.w, child: textFieldWidget(context, 'First Name', Icons.person, false, false,_firstNameTextController)),
              SizedBox(height:22.h),
              SizedBox(width:360.w, child: textFieldWidget(context, 'Last Name', Icons.person, false, false, _lastNameTextController)),
              SizedBox(height:22.h),
              SizedBox(width:360.w, child: pno),
              SizedBox(height:22.h),
              SizedBox(width:360.w, child: textFieldWidget(context, 'Email Id', Icons.email, false, false, _emailTextController)),
              SizedBox(height:22.h),
              SizedBox(width:360.w, child: textFieldWidget(context, 'Market Exp In Yrs', Icons.eject_rounded, false, false, _experienceTextController)),
              SizedBox(height:56.h),
              SizedBox(
                width: 375.w,
                child: signInSignUpButton('SIGN UP', () {
                  String text="";
                  if(_firstNameTextController.text == ''){
                    text = "First Name can't be empty";
                  }else if(_lastNameTextController.text == ''){
                    text = "Last Name can't be empty";
                  }else if(_isVerified == false){
                    text = "Phone number must be verified";
                  }else if(_emailTextController.text == ''){
                    text = "Email can't be empty";
                  }else if(_experienceTextController.text ==''){
                    text = "Experience can't be empty";
                  }else{
                    FirebaseFirestore.instance.collection('UserData').
                      doc(_phoneNumberTextController.text).set({
                        "firstName":_firstNameTextController.text,
                        "lastName":_lastNameTextController.text,
                        "email":_emailTextController.text,
                        "Market Experience":_experienceTextController.text,
                        "WatchLists": <String, List> {'My WatchList': []},
                    }).then((value) => Navigator.of(context).pop());
                    // FirebaseAuth.instance.signOut();
                    // Navigator.of(context).pop();
                  }
                  if(text.isNotEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}