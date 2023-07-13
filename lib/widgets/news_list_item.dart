import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'newsGet.dart';

var newsData = {};

Widget newsListItem(String stockName, context){
  dynamic response;
  if(newsData.containsKey(stockName)){
    response = newsData[stockName];
  }else{
    try {
      response = getResponseData(stockName);
    }catch(e){
      return  ListTile(
        title: Column(
          children: [
            SizedBox(height: 22.5.h,),
            ListTile(title: Text(stockName.toUpperCase(),textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold)),),
            SizedBox(height: 22.5.h,),
            Text('No Popular Article Found', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
            // SizedBox(height: 11.2.h,),
            Divider(color: Colors.white.withOpacity(0.6),thickness: 2,)
          ],
        ),
      );
    }
    newsData[stockName] = response;
  }

  return ListTile(
    title: FutureBuilder(
      future: response,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData && snapshot.data['articles'].length!=0){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.5.h,),
                ListTile(title: Text(stockName.toUpperCase(),textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,)),),
                SizedBox(height: 22.5.h,),
                getStockNews(context, snapshot.data),
                Divider(color: Colors.white.withOpacity(0.6),thickness: 2,)
              ]
          );
        }else{
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.5.h,),
                ListTile(title: Text(stockName.toUpperCase(),textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold)),),
                SizedBox(height: 22.5.h,),
                ListTile(title: Text('No Popular Article Found', textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey))),
                // SizedBox(height: 11.2.h,),
                Divider(color: Colors.white.withOpacity(0.6),thickness: 2,)
              ],
          );
        }
      },
    ),

  );


}