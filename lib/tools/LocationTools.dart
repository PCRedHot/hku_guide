import 'dart:math';
import 'package:vector_math/vector_math.dart';

double distanceBetweenPositions(double longitude1, double latitude1, double longitude2, double latitude2){
  double lon1 = radians(longitude1);
  double lon2 = radians(longitude2);
  double lat1 = radians(latitude1);
  double lat2 = radians(latitude2);

  double dLon = lon2 - lon1;
  double dLat = lat2 - lat1;
  double a = pow(sin(dLat/2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon/2), 2);
  double c = 2 * asin(sqrt(a));

  int r = 6371;
  return c * r;
}