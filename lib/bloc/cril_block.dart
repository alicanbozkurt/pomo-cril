import 'package:bloc/bloc.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/db_helper.dart';

enum CrilEvent{
  getCrillToday,
  emptyCrill
}

class CrillBlock extends Bloc<CrilEvent, List<CrillModel>>{
  final DBHelper dbHelper;
  CrillBlock({this.dbHelper});
  @override
  List<CrillModel> get initialState => List();


  @override
  Stream<List<CrillModel>> mapEventToState(CrilEvent event) async*{
    switch (event) {
      
      case CrilEvent.getCrillToday:
      final list = await dbHelper.getCrillsToday();
      if(list.isEmpty){
        dispatch(CrilEvent.emptyCrill);
      }else{
        yield list;
      }
      break;

      case CrilEvent.emptyCrill:
        yield List();
      break;

    }
  }
  
}