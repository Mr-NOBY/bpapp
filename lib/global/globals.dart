library my_project.globals;

import 'package:influxdb_client/api.dart';

double hrValue = 0;
double sbpValue = 0;
double dbpValue = 0;
double avgHrValue = 0;
List<HRData> hrData = [];

late InfluxDBClient influxDBClient;

List<HRData> hrrData = [];
List avgHr = [];

class HRData {
  final double value;
  final DateTime time;

  HRData(this.value, this.time);
}
