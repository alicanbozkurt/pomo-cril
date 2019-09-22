class CrillModel{

  final String crillName;
  final int crilCount;
  final int date;

  CrillModel({this.crillName, this.crilCount, this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': crillName,
      'count': crilCount,
      'date': date,
    };
  }

}