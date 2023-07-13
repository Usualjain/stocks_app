import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/screens/signin.dart';
import 'package:stocks_app/widgets/search_data.dart';
import '../widgets/news_list_item.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../widgets/stock_item.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


class HomeScreen extends StatefulWidget{

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    getStockListData(currentWatchList);
    loadingCsv();
    super.initState();
  }

  void getStockListData(String watchList) async{
    firebaseUser = FirebaseAuth.instance.currentUser!;
    phoneNumber = firebaseUser.phoneNumber!;
    phoneNumber = phoneNumber.substring(3);
    try{
      var db = await FirebaseFirestore.instance.collection('UserData').doc(phoneNumber).get();
      if(db.exists){
          watchListData = db.data()!['WatchLists'];
          stocks = watchListData[watchList];
          stocks.forEach((element) {
            newsStocks.add(element.substring(0, element.length-3));
          });
          fetchStockData();
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
    }
  }

  void loadingCsv() async{
    await loadCSV();
  }
  var phoneNumber="";
  var firebaseUser;
  var watchListData;
  var currentWatchList="My WatchList";
  var _showSheet = true;
  var _showSearchItems = false;

  final TextEditingController _searchTextController = TextEditingController();

  // var watchLists=['My Symbols'];
  // late var currentWatchList = watchLists[0];
  var newsStocks = [];
  var stocks=[];
  var stockProcessData = {};
  var tappedStockData = {};
  final month = {
    1:'Jan', 2:'Feb', 3:'Mar', 4:'Apr', 5:'May', 6:'June', 7:'July', 8:'Aug',
    9:'Sept', 10:'Oct', 11:'Nov', 12:'Dec',
  };
  var stocksList = [];
  var priceVolumeButton = 0;

  Future fetchStockData() async {
    String str = '';
    stocks.forEach((element) {
      str = '$str&query=$element';
    });
    str = str.substring(1);
    final response = await http.get(
      Uri.parse('http://usualjain.pythonanywhere.com/api?$str'),
    );
    final resData = jsonDecode(response.body);
    setState(() {
      stockProcessData = resData;
    });
    return resData;
  }

  Future fetchTappedStockData(String stock)async{
    final response = await http.get(
      Uri.parse('http://usualjain.pythonanywhere.com/detail?quote=$stock'),
    );
    final resData = jsonDecode(response.body);
    setState(() {
      tappedStockData = resData;
    });
    return resData;
  }

  @override
  Widget build(BuildContext context) {
    var x=[];
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: double.infinity.h,
              color: Colors.black,
              child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height*0.16 - MediaQuery.of(context).padding.top,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 11.h, right: 11.h, bottom: 5.h ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Stocks",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                                      Text("${DateTime.now().day} ${month[DateTime.now().month]}",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                                    ],
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle_sharp,color: Colors.grey.shade900.withOpacity(0.8),size: 39.h,),
                                        IconButton(
                                          onPressed: (){
                                            FirebaseAuth.instance.signOut();
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) => const SignInScreen()
                                                ),
                                                    (Route<dynamic> route) => false);
                                          },
                                          icon: const Icon(Icons.more_horiz), color: Colors.blueAccent,iconSize: 33.h,),
                                      ]
                                  )
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 11.h),
                            child: TextField(
                              onTap: ()=>setState(() {
                                _showSheet = false;
                                _showSearchItems = true;
                              }),
                              onChanged: (value){
                                x = search(_searchTextController.text, stocks);
                                // x = await search(_searchTextController.text).whenComplete(() => search);
                                setState(() {
                                  stocksList = x;
                                });
                              },
                              onSubmitted: (event)=>setState(() {
                                fetchStockData();
                                _searchTextController.clear();
                                _showSheet = true;
                                _showSearchItems = false;
                              }),
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                              controller: _searchTextController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 33.h),
                                  labelText:  'Search',
                                  labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.blueGrey.shade400.withOpacity(0.2),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.h)))

                              ),
                            ),
                          ),
                          Visibility(visible: !_showSearchItems, child: TextButton(onPressed: (){}, child: Text('This will have a watchlist section',style: TextStyle(color: Colors.blue.shade500)))),
                          Visibility(
                            visible: !_showSearchItems,
                            child: SizedBox(
                              height: 480.h,
                              child:
                              stocks.isEmpty
                                  ?
                                  Center(child:Text('No stocks added', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)))
                                  :
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                        itemCount: stocks.length,
                                        itemBuilder: (context,index){
                                        if (stockProcessData[stocks[index]].length == 0){
                                          return const ListTile();
                                        }else {
                                          return Dismissible(
                                            key:UniqueKey(),
                                            background: Container(color: Colors.red),
                                            onDismissed: (direction){
                                              var value = stocks[index].substring(0,stocks[index].length-3);
                                              stocks.remove(stocks[index]);
                                              watchListData[currentWatchList] = stocks;
                                              FirebaseFirestore.instance.collection('UserData').doc(phoneNumber).update({'WatchLists': watchListData});
                                              fetchStockData();
                                              setState(() {
                                                newsStocks.remove(value);
                                                stocksList.clear();
                                              });
                                            },
                                            child: InkWell(
                                              onTap: (){
                                                fetchTappedStockData(stocks[index]).whenComplete(() => stockItem(context, stocks[index], stockProcessData[stocks[index]]['name'], tappedStockData));
                                                // stockItem(context, stocks[index], stockProcesData[stocks[index]]);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 11.h,vertical: 5.h),
                                                width: double.infinity,
                                                height: 125.h,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width:180.h,
                                                              child: Text(
                                                                    stocks[index], style: Theme
                                                                      .of(context)
                                                                      .textTheme
                                                                      .headlineSmall!
                                                                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 22.h),),
                                                            ),
                                                            SizedBox(
                                                              width: 250.w,
                                                              child: Text(
                                                                    stockProcessData[stocks[index]]['name'],
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
                                                        SizedBox(width:30.w),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(stockProcessData[stocks[index]]['price'],
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .copyWith(
                                                                    color: Colors.white),
                                                              ),
                                                              SizedBox(
                                                                width: 120.h,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20.h,vertical: 5.h),
                                                                    backgroundColor: double.parse(stockProcessData[stocks[index]]['percent_change']) >= 0
                                                                        ?
                                                                    Colors.green.shade700
                                                                        :
                                                                    Colors.red.shade700,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(9.h),
                                                                    ),
                                                                  ),
                                                                  onPressed: (){
                                                                    setState(() {
                                                                      priceVolumeButton ++;
                                                                    });
                                                                    },
                                                                  child: Text(
                                                                    (priceVolumeButton)%3 == 0
                                                                        ?
                                                                    stockProcessData[stocks[index]]['percent_change']+'%'
                                                                        :
                                                                    (priceVolumeButton)%3 == 1
                                                                        ?
                                                                    stockProcessData[stocks[index]]['volume']
                                                                        :
                                                                    stockProcessData[stocks[index]]['change'],
                                                                    textAlign: TextAlign.end,
                                                                    style: Theme
                                                                        .of(context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold),),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.white.withOpacity(0.6),thickness: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    }),
                            ),
                          ),
                          Visibility(
                            maintainSize: false,
                            visible: _showSearchItems,
                            child: KeyboardVisibilityBuilder(
                              builder: (context, isKeyboardVisible) {
                                final viewInsets = EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio);
                                var h = 695.h - viewInsets.bottom;
                                if (! isKeyboardVisible){
                                  h = 695.h;
                                }
                                return SizedBox(
                                  // height: 695.h,
                                  height: h,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: stocksList.length,
                                      itemBuilder: (context, index) {
                                        return
                                          ListTile(
                                            title: Text(stocksList[index][0],
                                              style: const TextStyle(
                                                  color: Colors.white),),
                                            subtitle: Text(stocksList[index][1],
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                            leading:
                                            stocksList[index][5]
                                                ?
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(Icons.circle_sharp,
                                                  color: Colors.blueGrey
                                                      .withOpacity(0.3),
                                                  size: 30.h,),
                                                IconButton(onPressed: () {
                                                  setState(() {
                                                    stocksList[index][5] =
                                                    false;
                                                    newsStocks.add(
                                                        stocksList[index][0]);
                                                    if (stocksList[index][4] ==
                                                        'NSE') {
                                                      // stocks['${stocksList[index][0]}.NS'] = stocksList[index][1];
                                                      stockProcessData['${stocksList[index][0]}.NS'] =
                                                      {};
                                                      stocks.add(
                                                          '${stocksList[index][0]}.NS');
                                                      watchListData[currentWatchList] =
                                                          stocks;
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                          'UserData').doc(
                                                          phoneNumber).update({
                                                        'WatchLists': watchListData
                                                      });
                                                    } else {
                                                      // stocks['${stocksList[index][0]}.BO'] = stocksList[index][1];
                                                      stockProcessData['${stocksList[index][0]}.BO'] =
                                                      {};
                                                      stocks.add(
                                                          '${stocksList[index][0]}.BO');
                                                      watchListData[currentWatchList] =
                                                          stocks;
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                          'UserData').doc(
                                                          phoneNumber).update({
                                                        'WatchLists': watchListData
                                                      });
                                                    }
                                                  });
                                                },
                                                  icon: Icon(Icons.add,
                                                    color: Colors.blueAccent,
                                                    size: 24.h,),)
                                              ],
                                            )
                                                :
                                            IconButton(onPressed: () {
                                              setState(() {
                                                stocksList[index][5] = true;
                                                newsStocks.remove(
                                                    stocksList[index][0]);
                                                if (stocksList[index][4] ==
                                                    'NSE') {
                                                  stockProcessData.remove(
                                                      '${stocksList[index][0]}.NS');
                                                  stocks.remove(
                                                      '${stocksList[index][0]}.NS');
                                                  watchListData[currentWatchList] =
                                                      stocks;
                                                  FirebaseFirestore.instance
                                                      .collection('UserData')
                                                      .doc(phoneNumber)
                                                      .update({
                                                    'WatchLists': watchListData
                                                  });
                                                } else {
                                                  stockProcessData.remove(
                                                      '${stocksList[index][0]}.BO');
                                                  stocks.remove(
                                                      '${stocksList[index][0]}.BO');
                                                  watchListData[currentWatchList] =
                                                      stocks;
                                                  FirebaseFirestore.instance
                                                      .collection('UserData')
                                                      .doc(phoneNumber)
                                                      .update({
                                                    'WatchLists': watchListData
                                                  });
                                                }
                                              });
                                            },
                                                icon: const Icon(
                                                    Icons.check_circle),
                                                color: Colors.blue.shade500,
                                                iconSize: 25.h),

                                            trailing: Text(stocksList[index][4],
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          );
                                      }),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
            ),
          Visibility(
            visible: (_showSheet),
            child: DraggableScrollableSheet(
                initialChildSize: 0.14,
                maxChildSize: 0.85,
                minChildSize: 0.14,
                snap: true,
                snapSizes: const [0.35, 0.85],
                snapAnimationDuration: const Duration(milliseconds: 200),
                builder: (context, controller)=>ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(13.h), topRight: Radius.circular(13.h)),
                  child: Container(
                    color: Colors.black,
                    child:
                      CustomScrollView(
                        controller: controller,
                        slivers:[
                          SliverAppBar(
                            collapsedHeight: 120.h,
                            backgroundColor: Colors.white10,
                            flexibleSpace:  FlexibleSpaceBar(
                                title:  null,
                                background: Padding(
                                  padding: EdgeInsets.only(left: 11.h, right: 11.h, top: 11.h, bottom: 20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(width: double.infinity.w, alignment: Alignment.center, child: Divider(color: Colors.white,indent: 41.36.w, endIndent: 41.36.w, thickness: 0.45.h,),),
                                      SizedBox(height: 1.35.h,),
                                      Text('Business News', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold, ),textAlign: TextAlign.left),
                                      Text('By Usual Finance', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey), textAlign: TextAlign.left,),
                                    ],
                                  ),
                                ),
                            ),
                          ),
                          (newsStocks.isEmpty)
                          ?
                              SliverFillRemaining(
                                child: Center(
                                  child: Text('No News Article To Show',style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              )
                           :
                            SliverAnimatedList(
                              key: UniqueKey(),
                              initialItemCount: newsStocks.length,
                              itemBuilder: (context, index, animation) {
                                return newsListItem(newsStocks[index], context);
                              }
                          ),
                        ],
                      ),
                  ),
                ),

            ),
          ),
        ],
      ),
    );


  }
}

