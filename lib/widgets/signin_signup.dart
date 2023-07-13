import 'package:flutter/material.dart';
import 'package:stocks_app/screens/phone_verify.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextField textFieldWidget(context, String text, IconData icon, bool isOtpType, bool isPhoneNum, TextEditingController controller,{bool isVerified=false, bool isSignUp = false}) {
  return TextField(controller: controller,
    maxLength: isPhoneNum ? 10 : isOtpType ? 6 : TextField.noMaxLength,
    obscureText: isOtpType,
    enableSuggestions: !isOtpType,
    autocorrect: !isOtpType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20.sp),
    decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white,),
        prefixText: isPhoneNum ? '+91 ' : '',
        suffix: (isVerified) ?
          const Icon(Icons.verified, color: Colors.green,) :
          (isSignUp) ?
            TextButton(onPressed: ()async{
              isVerified = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    PhoneVerifyScreen(phoneNumber: controller.text)
                ),
              );
              if(isVerified){
                textFieldWidget(context, text, icon, isOtpType, isPhoneNum, controller,isVerified: true);
              }
            },
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(right: 100.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.square(2.h),) ,
              child: const Text('Verify', style: TextStyle(color:Colors.white),),)
              :
          const Text(''),
        prefixStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.sp),
        labelText: text,
        labelStyle: TextStyle(
            color: Colors.white60.withOpacity(0.9), fontSize: 20.sp),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(33.h),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))
    ),
    keyboardType: (!isPhoneNum || !isOtpType)  ? TextInputType.text : TextInputType.number,
  );
}

  Container signInSignUpButton(String label, VoidCallback onTap,{bool isProcessing = false}){
    return Container(
      height:56.h,
      width: 350.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.h)),
      child: ElevatedButton(
        onPressed: () {
          // isProcessing = true;
          onTap();
          // isProcessing = false;
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states){
            if(states.contains(MaterialState.pressed)){
              return Colors.black26;
            }else{
              return Colors.white;
            }
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(33.h))
          ),
        ),
        child:
          isProcessing?
            const CircularProgressIndicator(color: Colors.black,)
              :
              Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
      ),
    );
  }