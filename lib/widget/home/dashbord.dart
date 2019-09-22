import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/chart_data.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/home/item_list.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Dashbord extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DashboardState();

}

class DashboardState extends State<Dashbord>{
  int selectWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100, left: 22, right: 22),
      child: Column(
        children: <Widget>[
          TabDashboard(onSelected: (indexSelected){
            setState(() =>selectWidget = indexSelected);
          }),
          selectWidget == 0 ? DailyWidget() :
          selectWidget == 1 ? WeeklyWidget() :
          WeeklyWidget()
        ],
      ),
    );
  }

}

class TabDashboard extends StatefulWidget{

  final Function onSelected;
  TabDashboard({this.onSelected});

  @override
  State<StatefulWidget> createState() => TabDashboardState();

}

class TabDashboardState extends State<TabDashboard>{
  int selectedId = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: ColorUtils.blue_app, width: 1)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex:1,
            child: GestureDetector(
              onTap: (){
                setState((){
                  selectedId = 0;
                  widget.onSelected(0);
                });
              },
              child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: selectedId == 0 ? ColorUtils.blue_app : Colors.white
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child:Text("Daily", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.font, color: selectedId == 0 ? Colors.white : Colors.black),)
                  )
                )
            )
          ),
          Expanded(
            flex:1,
            child: GestureDetector(
              onTap: (){
                setState((){
                  selectedId = 1;
                  widget.onSelected(1);
                });
              },
              child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: selectedId == 1 ? ColorUtils.blue_app : Colors.white
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child:Text("Weekly", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, color: selectedId == 1 ? Colors.white : Colors.black),)
                    )
                  )
            )
          ),
          Expanded(
            flex:1,
            child: GestureDetector(
              onTap: (){
                setState((){
                  selectedId = 2;
                  widget.onSelected(2);
                });
              },
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: selectedId == 2 ? ColorUtils.blue_app : Colors.white
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child:Text("Year", style: TextStyle(fontFamily: Constants.font, color: selectedId == 2 ? Colors.white : Colors.black),)
                  )
                )
            )
          )
  
         
        ],
      ),
    );
  }
  
}

class DailyWidget extends StatelessWidget{
  final data = [
    CrillModel(crillName: "Breakfast", crilCount: 3),
    CrillModel(crillName: "Do Homework", crilCount: 5),
    CrillModel(crillName: "Jogging", crilCount: 6),
  ];
  final data2 = [
    CrillModel(crillName: "Reading", crilCount: 3),
    CrillModel(crillName: "Cooking", crilCount: 2),
    CrillModel(crillName: "Cycling", crilCount: 4),
  ];
  final data3 = [
    CrillModel(crillName: "Wakeup", crilCount: 3),
    CrillModel(crillName: "Take a rest", crilCount: 2),
    CrillModel(crillName: "Jogging", crilCount: 6),
  ];
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child:ListView(
              children: <Widget>[
                CrillList(listData: data),
                CrillList(listData: data2,),
                CrillList(listData: data3),
              
              ],
      )
    );
          
    
  }

}

class ChartWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 255,
        padding: EdgeInsets.all(16),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child:Text("13-19 May", textAlign: TextAlign.center, style:TextStyle(fontFamily:Constants.font))),
          ChartBar.withSampleData(),
          Padding(padding:EdgeInsets.only(top: 4, bottom: 4),child:Text("Total Crils in this week: 13", style:TextStyle(fontFamily:Constants.font))),
          Text("Total hour in this week: 20", style:TextStyle(fontFamily:Constants.font)),
        ],
      ),
      )
    );
  }

}

class ChartBar extends StatelessWidget{

  final List<charts.Series> seriesList;
  final bool animate;

  ChartBar(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
     return Container(
       height: 170,
       child:
        charts.BarChart(
        seriesList,
        animate: animate,
      )
    );
  }

  factory ChartBar.withSampleData() {
    return ChartBar(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  static List<charts.Series<ChartData, String>> _createSampleData() {
    final data = [
      new ChartData(day: "Mo", value: 3),
      new ChartData(day: "Tu", value: 4),
      new ChartData(day: "We", value: 1),
      new ChartData(day: "Th", value: 0),
      new ChartData(day: "Fr", value: 6),
      new ChartData(day: "Sa", value: 4),
      new ChartData(day: "Su", value: 3),
    ];

    return [
      new charts.Series<ChartData, String>(
        id: 'Crills',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData dataChart, _) => dataChart.day,
        measureFn: (ChartData dataChart, _) => dataChart.value,
        data: data,
      )
    ];
  }

}

class WeeklyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
         Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Card(
              elevation: 1,
              color: Colors.white,
              child: Container(
                height: 50,
                padding:EdgeInsets.all(8),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){},),
                    Text("Weekly"),
                    IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){},),
                  ],
                ),
              )
            ),
          ),
          ChartWidget(),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex:1,
                  child:Card(
                    elevation: 4,
                    child: Container(
                      height: 90,
                      width: (MediaQuery.of(context).size.width * 0.3) ,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                         Text("26", style: TextStyle(fontFamily: Constants.font, fontSize: 24, color: Colors.black),),
                          Padding(padding: EdgeInsets.only(top: 8), child:
                          Text("Crills", style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.black)))
                        ],
                      ),
                    ),
                  )
                ),
                Flexible(
                  flex:1,
                  child:Card(
                    elevation: 4,
                    child: Container(
                      height: 90,
                      width: (MediaQuery.of(context).size.width * 0.3),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("13", style: TextStyle(fontFamily: Constants.font, fontSize: 24, color: Colors.black),),
                          Padding(padding: EdgeInsets.only(top: 8), child:
                          Text("Hours", style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.black)))
                        ],
                      ),
                    ),
                  )
                ),
                Flexible(
                  flex:1,
                  child:Card(
                    elevation: 4,
                    child: Container(
                      height: 90,
                      width: (MediaQuery.of(context).size.width * 0.3),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("%15,5", style: TextStyle(fontFamily: Constants.font, fontSize: 24, color: Colors.black),),
                          Padding(padding: EdgeInsets.only(top: 8), child:
                          Text("Productivity", style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.black)))
                        ],
                      ),
                    ),
                  )
                )

              ],
            ),
          
          )
        ],
    
    );
  }

}