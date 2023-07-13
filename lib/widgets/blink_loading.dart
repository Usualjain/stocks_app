import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// loaderOn(BuildContext context) {
//   showDialog(context: context,
//       builder: (BuildContext dialogContext) {
//       return Container(
//         height: 6,
//         width: 6,
//         alignment: Alignment.center,
//         child:
//             Icon(Icons.currency_rupee_sharp, color: Colors.green.shade400,)
//             Icon(Icons.currency_rupee_sharp, color: Colors.transparent,)
//             // Image.asset('./assets/gif/loader.gif', fit: BoxFit.fill,),
//       );
//   });
// }


class BlinkLoading extends StatefulWidget{
  const BlinkLoading({super.key});

  @override
  _BlinkLoadingState createState() => _BlinkLoadingState();
}
class _BlinkLoadingState extends State<BlinkLoading> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    super.initState();
    _navigatewait();
  }

  _navigatewait()async{
    await Future.delayed(const Duration(seconds: 6),(){});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          height: double.infinity.h,
          alignment: Alignment.center,
          color: Colors.black,
          child: FadeTransition(
            opacity: _animationController,
            child: Icon(Icons.currency_rupee_sharp, color: Colors.green.shade800,size: 60.h,)
      ),
        )
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
