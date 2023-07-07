import 'package:collection/collection.dart';

class ChartPoints{
  double x;
  double y;
  ChartPoints({required this.x, required this.y});

}

List<ChartPoints> get chartPointsData{

  final data = <double>[1,2,2,4,3];
  return data.mapIndexed(
      ((index, element) => ChartPoints(x: index.toDouble(), y: element)))
      .toList();
}
