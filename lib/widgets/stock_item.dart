import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_app/widgets/line_chart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'newsGet.dart';


Future getHistoryData(String stock, String time)async{
  final response = await http.get(
    Uri.parse('http://usualjain.pythonanywhere.com/history?quote=$stock&time=$time'),
  );
  final resData = jsonDecode(response.body);
  return resData;
}

stockItem(BuildContext context, String symbol, String name, Map stockData){
  var color = double.parse(stockData['change']) < 0 ? Colors.red : Colors.green;
  var duration = '1mo';
  return showModalBottomSheet(
      backgroundColor: Colors.black,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      builder: (context){
        return StatefulBuilder(builder: (context,state){
          return SingleChildScrollView(
            padding: EdgeInsets.all(10.h),
            child: SizedBox(
              height: 825.h,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(symbol, style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 32.h),),
                          SizedBox(
                            width: 300.h,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: Colors.grey,
                                fontSize: 17.h,
                                height: 2.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 35.w,),
                      IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.close_sharp,color: Colors.white,)),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4),thickness: 1,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(width:100.w, child: Text(stockData['price'], textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 23.h),)),
                              SizedBox(height: 10.h,),
                              SizedBox(width: 120.w, child: Text('${stockData['exchange']}  ${stockData['currency']}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 17.h),),)
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(width:80.w, child: Text(stockData['volume'], textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: color, fontWeight: FontWeight.bold,fontSize: 21.h),)),
                              SizedBox(height: 10.h,),
                              SizedBox(width: 80.w, child: Text('Vol', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 17.h),),)
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(width:80.w, child: Text(stockData['change'], textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: color, fontWeight: FontWeight.bold,fontSize: 21.h),)),
                              SizedBox(height: 10.h,),
                              SizedBox(width: 80.w, child: Text('Chg', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 17.h),),)
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(width:80.w, child: Text(stockData['percent_change']+'%', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: color, fontWeight: FontWeight.bold,fontSize: 21.h),)),
                              SizedBox(height: 10.h,),
                              SizedBox(width: 80.w, child: Text('% Chg', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 17.h),),)
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.4),thickness: 1,
                      ),
                      SizedBox(
                        height: 30.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: (duration == '1mo') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '1mo';});
                                },
                                autofocus: true,
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('1M', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '3mo') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '3mo';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('3M', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '6mo') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '6mo';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('6M', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '1y') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '1y';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('1Y', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '2y') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '2y';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('2Y', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '5y') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                  state((){duration = '5y';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('5Y', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),
                            Container(
                              decoration: BoxDecoration(
                                color: (duration == '10y') ? Colors.grey.withOpacity(0.4) : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                focusColor: Colors.grey,
                                onTap: (){
                                    state((){duration = '10y';});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  width: 40.w,
                                  child: Text('10Y', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.h),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.4),thickness: 1,
                      ),
                      Container(
                        height: 280.h,
                        width: double.infinity,
                        color: Colors.transparent,
                        child:
                            FutureBuilder<dynamic>(
                              future: getHistoryData(symbol, duration),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return LineChartWidget(
                                    data: snapshot.data,
                                  );
                                }else{
                                  return const Center(child: CircularProgressIndicator(backgroundColor: Colors.white12, color: Colors.white,));
                                }
                              },
                            )
                        // child: const Center(child: Text('Graph', style: TextStyle(color:Colors.white),)),
                      ),
                      SizedBox(
                        height: 120.h,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              width: 160.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Open',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['open'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('High',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['high'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Low',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['low'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.withOpacity(0.6),thickness: 1,
                              indent: 10.h,
                              endIndent: 10.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              width: 160.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Vol',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['volume'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('P/E',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['p/e'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Mkt Cap',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['mcap'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.withOpacity(0.6),thickness: 1,
                              indent: 10.h,
                              endIndent: 10.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              width: 160.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('52W H',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['52weekhi'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('52W L',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['52weeklo'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Avg Vol',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['avgvol'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.withOpacity(0.6),thickness: 1,
                              indent: 10.h,
                              endIndent: 10.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              width: 160.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Yield',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['yield'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text('Beta',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)),
                                      Text(stockData['beta'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('EPS',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontSize: 20.h)), Text(stockData['eps'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18.h)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.withOpacity(0.6),thickness: 1,
                              indent: 10.h,
                              endIndent: 10.h,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.4),thickness: 1,
                      ),
                      Center(child:Text("Yahoo's analyst opinion",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 23.h))),
                      SizedBox(height: 20.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('Technicals',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 21.h)),
                              Text(stockData['recommendationKey'].toUpperCase(),style: Theme.of(context).textTheme.titleMedium!.copyWith(color: stockData['recommendationKey'].endsWith('buy') ? Colors.green : Colors.red,fontSize: 18.h))
                            ],
                          ),
                          Column(
                            children: [
                              Text('Target High',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 21.h),),
                              Text(stockData['targetHighPrice'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.green,fontSize: 20.h)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Target Low',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 21.h),),
                              Text(stockData['targetLowPrice'],style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 20.h) )
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.4),thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: (){
                            var url = 'NSE-';
                            if(symbol.endsWith('.BO')){
                              url = 'BSE-';
                            }
                            late final WebViewController controller = WebViewController();
                            // _loadHtmlString(controller, context);
                            launchURLApp('https://www.tradingview.com/symbols/$url${symbol.substring(0,symbol.length-3)}/');
                            WebViewWidget(
                              controller: controller,
                            );
                          },
                              child: const Text('TradingView', style: TextStyle(color:Colors.blueAccent,fontWeight: FontWeight.bold),)),
                          TextButton(onPressed: (){launchURLApp('https://stockcharts.com/freecharts/pnf.php?c=${symbol.substring(0,symbol.length-3)}.in,P');}, child: const Text('StockCharts', style: TextStyle(color:Colors.blueAccent,fontWeight: FontWeight.bold),),),
                          TextButton(onPressed: (){launchURLApp('https://www.screener.in/company/${symbol.substring(0,symbol.length-3)}/consolidated/');}, child: const Text('StockScreener', style: TextStyle(color:Colors.blueAccent,fontWeight: FontWeight.bold),),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      }
  );
}