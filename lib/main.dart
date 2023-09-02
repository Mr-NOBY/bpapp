// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influxdb_client/api.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math';

import 'dependency_injection.dart';

Future<void> main() async {
  runApp(const MyApp());
  DependencyInjection.init();
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _hrValue = 0;
  double _sbpValue = 0;
  double _dbpValue = 0;
  double _avgHrValue = 0;
  List<HRData> _hrData = [];

  late InfluxDBClient _influxDBClient;

  @override
  void initState() {
    super.initState();
    _influxDBClient = InfluxDBClient(
      url: 'https://us-east-1-1.aws.cloud2.influxdata.com',
      token:
          '-g6iC2cK-mwZpYCPaiKdDOyyX5P1vkncIDSigkxs_ImaQJUDUm1-87FX4peKEmW4F2DC9CMSqZKVVTLNvXERSg==',
      org: 'test',
      bucket: 'colabtest',
    );
    _getData();
  }

  List<HRData> hrData = [];
  List avgHr = [];

  Future<void> refreshData() async {
    // Close the existing InfluxDB client
    _influxDBClient.close();

    // Create a new InfluxDB client to reestablish the connection
    _influxDBClient = InfluxDBClient(
      url: 'https://us-east-1-1.aws.cloud2.influxdata.com',
      token:
          '-g6iC2cK-mwZpYCPaiKdDOyyX5P1vkncIDSigkxs_ImaQJUDUm1-87FX4peKEmW4F2DC9CMSqZKVVTLNvXERSg==',
      org: 'test',
      bucket: 'colabtest',
    );

    // Refresh data
    _getData();
  }

  void _getData() async {
    var queryApi = _influxDBClient.getQueryService();
    var queryHr = "from(bucket: \"colabtest\") "
        "|> range(start: -72h) "
        "|> filter(fn: (r) => r._measurement == \"acchr\")"
        "|> filter(fn: (r) => r._field == \"acchr\" ) "
        "|> last()";
    var querylast8 = "from(bucket: \"colabtest\") "
        "|> range(start: -72h) "
        "|> filter(fn: (r) => r._measurement == \"acchr\")"
        "|> filter(fn: (r) => r._field == \"acchr\" ) "
        "|> tail(n: 8)"
        "|> sort(columns: [\"_time\"])";
    var resultHr = await queryApi.query(queryHr);
    if (avgHr.length < 8) {
      resultHr = await queryApi.query(querylast8);
    } else {
      resultHr = await queryApi.query(queryHr);
    }
    await for (var record in resultHr) {
      if (record['_field'] == 'acchr') {
        // Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          //_hrValue = (record['_value']).toDouble();
          _hrData = hrData;
          print(_hrValue);
        });
        // });
        hrData.add(HRData(
            record['_value'].toDouble(), DateTime.parse(record['_time'])));
        avgHr.add(_hrValue);
      }

      var queryavgHr = "from(bucket: \"colabtest\") "
          "|> range(start: -72h) "
          "|> filter(fn: (r) => r._measurement == \"acchr\")"
          "|> filter(fn: (r) => r._field == \"avghr\") "
          "|> last()";
      var resultavgHr = await queryApi.query(queryavgHr);
      await for (var record in resultavgHr) {
        if (record['_field'] == 'avghr') {
          Timer.periodic(Duration(seconds: 5), (timer) {
            setState(() {
              _avgHrValue = (record['_value']).toDouble();
            });
          });
        }
      }

      var querySbp = "from(bucket: \"colabtest\") "
          "|> range(start: -72h) "
          "|> filter(fn: (r) => r._measurement == \"acchr\")"
          "|> filter(fn: (r) => r._field == \"sbp\") "
          "|> last()";
      var resultSbp = await queryApi.query(querySbp);
      await for (var record in resultSbp) {
        if (record['_field'] == 'sbp') {
          Timer.periodic(Duration(seconds: 5), (timer) {
            setState(() {
              _sbpValue = (record['_value']).toDouble();
            });
          });
        }

        var queryDbp = "from(bucket: \"colabtest\") "
            "|> range(start: -72h) "
            "|> filter(fn: (r) => r._measurement == \"acchr\")"
            "|> filter(fn: (r) => r._field == \"dbp\" ) "
            "|> last()";
        var resultDbp = await queryApi.query(queryDbp);
        await for (var record in resultDbp) {
          if (record['_field'] == 'dbp') {
            Timer.periodic(Duration(seconds: 5), (timer) {
              setState(() {
                _dbpValue = (record['_value']).toDouble();
              });
            });
          }
        }
      }

      Future.delayed(
        const Duration(seconds: 3),
        () {
          _getData();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double avghr;
    avgHr.remove(0.0);

    if (avgHr.length >= 8) {
      if (avgHr.elementAt(avgHr.length - 1) == avgHr.last) {
        avgHr.removeLast();
      }
      avghr = avgHr.reduce((a, b) => a + b) / avgHr.length;
      print(avghr);
      print(avgHr);
    } else {
      avghr = _hrValue;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 200,
                            radiusFactor: 0.85,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 60,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 60,
                                endValue: 100,
                                color: Colors.orange,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 100,
                                endValue: 160,
                                color: Colors.green,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 160,
                                endValue: 200,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                            ],
                            pointers: <GaugePointer>[
                              MarkerPointer(
                                value: _avgHrValue,
                                animationType: AnimationType.ease,
                                animationDuration: 1000,
                                enableAnimation: true,
                                markerWidth: 20,
                                markerOffset: -10,
                                color: Colors.blueGrey,
                              ),
                              RangePointer(
                                value: _avgHrValue,
                                enableAnimation: true,
                                animationDuration: 1000,
                                animationType: AnimationType.ease,
                                dashArray: const [8, 2],
                                color: Color.fromRGBO(220, 220, 220, 70),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          ((_avgHrValue).round()).toString(),
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "BPM",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.75),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 200,
                            radiusFactor: 0.85,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 90,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 90,
                                endValue: 120,
                                color: Colors.orange,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 120,
                                endValue: 140,
                                color: Colors.green,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 140,
                                endValue: 200,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                            ],
                            pointers: <GaugePointer>[
                              MarkerPointer(
                                value: _sbpValue,
                                animationType: AnimationType.ease,
                                animationDuration: 1000,
                                enableAnimation: true,
                                markerWidth: 20,
                                markerOffset: -10,
                                color: Colors.blueGrey,
                              ),
                              RangePointer(
                                value: _sbpValue,
                                enableAnimation: true,
                                animationDuration: 1000,
                                animationType: AnimationType.ease,
                                dashArray: const [8, 2],
                                color: Color.fromRGBO(220, 220, 220, 70),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          ((_sbpValue).round()).toString(),
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "SBP",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.75),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 200,
                            radiusFactor: 0.85,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 60,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 60,
                                endValue: 80,
                                color: Colors.orange,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 80,
                                endValue: 90,
                                color: Colors.green,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                              GaugeRange(
                                startValue: 90,
                                endValue: 200,
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20,
                              ),
                            ],
                            pointers: <GaugePointer>[
                              MarkerPointer(
                                value: _dbpValue,
                                animationType: AnimationType.ease,
                                animationDuration: 1000,
                                enableAnimation: true,
                                markerWidth: 20,
                                markerOffset: -10,
                                color: Colors.blueGrey,
                              ),
                              RangePointer(
                                value: _dbpValue,
                                enableAnimation: true,
                                animationDuration: 1000,
                                animationType: AnimationType.ease,
                                dashArray: const [8, 2],
                                color: Color.fromRGBO(220, 220, 220, 70),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          ((_dbpValue).round()).toString(),
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "DBP",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.75),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend:
                      Legend(isVisible: true, position: LegendPosition.bottom),
                  primaryYAxis: NumericAxis(
                    associatedAxisName: 'BPM',
                    title: AxisTitle(text: 'BPM'),
                  ),
                  primaryXAxis: DateTimeAxis(
                    associatedAxisName: 'Time',
                    title: AxisTitle(text: 'Time'),
                  ),
                  series: <ChartSeries>[
                    SplineSeries<HRData, DateTime>(
                        name: 'Heart Rate',
                        dataSource: _hrData.sublist(max(0, _hrData.length - 8)),
                        xValueMapper: (HRData data, _) => data.time,
                        xAxisName: 'Time',
                        yValueMapper: (HRData data, _) => data.value,
                        yAxisName: 'BPM')
                  ],
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    enablePinching: true,
                    zoomMode: ZoomMode.xy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HRData {
  final double value;
  final DateTime time;

  HRData(this.value, this.time);
}
