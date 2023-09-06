import 'package:influxdb_client/api.dart';
import './get_data.dart';

import '../global/globals.dart' as global;

Future<void> refreshData() async {
  // var myWidget = MyWidgetState();
  // Close the existing InfluxDB client
  global.influxDBClient.close();

  // Create a new InfluxDB client to reestablish the connection
  global.influxDBClient = InfluxDBClient(
    url: 'https://us-east-1-1.aws.cloud2.influxdata.com',
    token:
        '-g6iC2cK-mwZpYCPaiKdDOyyX5P1vkncIDSigkxs_ImaQJUDUm1-87FX4peKEmW4F2DC9CMSqZKVVTLNvXERSg==',
    org: 'test',
    bucket: 'colabtest',
  );
  getData();
  // Refresh data
  // myWidget.getData();
}
