import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/utils/db_helper.dart';
import 'package:pomodoro_apps/widget/home/dashbord.dart';
import 'package:pomodoro_apps/widget/home/fill_crill.dart';
import 'package:pomodoro_apps/widget/pomo/Pomo.dart';
import 'package:pomodoro_apps/widget/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<Home>{

  bool isHome = true;
  List<CrillModel> listData = List();

  @override
  void initState() {
    initialData();
    getData();
    super.initState();
  }

  initialData() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((prefData){
      DataApp.isEmpty = prefData.getBool('isEmpty') == null ? true : prefData.getBool('isEmpty');
    });
    
  }

  getData(){
    final getCrills = DBHelper().getCrillsToday();
    getCrills.then((crills){
      setState(() => listData = crills);
      DataApp.isEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          child: Stack(
            children: <Widget>[
              titleWidget(),
              isHome ? 
                FillCrill(isEmpty: DataApp.isEmpty, listData: listData)
              : 
                Dashbord()
            ],
          )
          
          ,
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtils.blue_app,
      child: Image.asset(DataApp.isEmpty ? "assets/img/icon_home_empty.png" : "assets/img/icon_home.png"), onPressed: () {
           Navigator.push(context, SlideTopRoute(page: Pomo(homeState: this)));
      }),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4,
        elevation: 8,
        shape: CircularNotchedRectangle(),
        color: ColorUtils.blue_app,
        child: Container(
          height: 60,
         child:Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(icon: Image.asset( isHome ? "assets/img/home_select_icon.png" : "assets/img/home_unselect_icon.png", width: 26,), onPressed: () {
            setState(() {
              isHome = true;
            });
          },),
          Padding(padding:EdgeInsets.only(top: 24),child:Text("Start a Cril", style:TextStyle(color:Colors.white,fontSize: 16,fontFamily: Constants.font))),
          IconButton(icon: Image.asset( isHome ? "assets/img/pie_unselected_icon.png" : "assets/img/pie_select_icon.png"  , width: 26,), onPressed: () {
            setState(()=> isHome = false);
          },),
        ],
      ),
        )
      ),
    );
  }

  

  Widget titleWidget(){
    return Container(
      color: ColorUtils.bg_home,
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
             Image.asset("assets/img/crillo.png", width: 43, height: 19,),
              IconButton(icon: Image.asset("assets/img/icon_gear.png", width: 29,), onPressed: (){ 
                 Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => Setting())
                            );
                          
              },)
            ],
          )
    );
  }

}