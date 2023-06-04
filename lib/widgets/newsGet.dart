import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


launchURLApp(String url) async {
  final finalUrl = Uri.parse(url);
  try{
    await launchUrl(finalUrl,mode: LaunchMode.inAppWebView);
  }catch(e){
    throw 'Couldn\'t load site';
  }
}

Future getResponseData(String stock)async{
  DateTime date = DateTime.now().subtract(const Duration(days: 30));
  String fromDate = date.toString().substring(0, 11);
  final url = Uri.parse('https://newsapi.org/v2/everything?q=$stock&from=$fromDate&domains=investing.com,moneycontrol.com,dsij.in&sources=the-telegraph,google-news,the-times-of-india,the-economic-times,hindustan-times,moneycontrol,livemint,the-indian-express&pageSize=10&language=en&apiKey=ac9bae59739541ada5799b082aee2526');
  final response = await http.get(url);
  final resData = jsonDecode(response.body);
  return resData;
}

Widget getStockNews(context, resData){

  int len = resData['articles'].length < 3 ? resData['articles'].length:3;

  return Column(
      //.sublist(0,3)
      children: resData['articles'].sublist(0,3).map<Widget>((item) =>
          InkWell(
            onTap: (){launchURLApp(item['url']);},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['source']['name'], style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
                const SizedBox(height: 10,),
                Text(item['title'],maxLines: 4, overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
                const SizedBox(height: 15,),
                Text('${DateTime.now().difference(DateTime.parse(item['publishedAt'])).inDays}d ago', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
                const SizedBox(height: 20,)
              ],
            ),
          )
      ).toList());

  return ListView.builder(
    itemCount: resData['totalResults'] < 5 ? resData['totalResults']:5,
    shrinkWrap: true,
    itemBuilder: (context, index){
      return ListTile(
        textColor: Colors.white,
        onTap: (){launchURLApp(resData['articles'][index]['url']);},
        title: Text(resData['articles'][index]['title']),
        subtitle: Text(resData['articles'][index]['source']['name']),
      );
      },
  );
}


//   71bcfe13e327473db97a115020ae56d2      personal id

//  ac9bae59739541ada5799b082aee2526  10 min email1