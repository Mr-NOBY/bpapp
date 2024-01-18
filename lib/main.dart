// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:bpapp/auth/screens/welcome_screen.dart';
import 'package:bpapp/firebase_options.dart';
import 'package:bpapp/profile/profile_screen.dart';
import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influxdb_client/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math';

import 'dependency_injection.dart';
import 'widgets/gauge.dart';
import 'widgets/thermometer.dart';
import 'helpers/get_data.dart';
import 'helpers/refresh_data.dart';
import 'global/globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthRepo()));
  runApp(const MyApp());
  DependencyInjection.init();
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialColor blackSwatch = MaterialColor(
      Colors.black.value,
      <int, Color>{
        50: Colors.black.withOpacity(0.1),
        100: Colors.black.withOpacity(0.2),
        200: Colors.black.withOpacity(0.3),
        300: Colors.black.withOpacity(0.4),
        400: Colors.black.withOpacity(0.5),
        500: Colors.black.withOpacity(0.6),
        600: Colors.black.withOpacity(0.7),
        700: Colors.black.withOpacity(0.8),
        800: Colors.black.withOpacity(0.9),
        900: Colors.black.withOpacity(1),
      },
    );

    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      title: 'Smart BioChip',
      theme: ThemeData(
        primarySwatch: blackSwatch,
        fontFamily: 'Cairo',
      ),
      //home: MyHomePage(title: 'App Name'),
      home: const CircularProgressIndicator(),
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
  double hrValue = 0.0;
  double sbpValue = 0.0;
  double dbpValue = 0.0;
  double avgHrValue = 0.0;
  List<globals.HRData> hrData = [];

  Future<void> setstate() async {
    setState(() {
      avgHrValue = globals.avgHrValue;
    });
    setState(() {
      sbpValue = globals.sbpValue;
    });
    setState(() {
      dbpValue = globals.dbpValue;
    });
    setState(() {
      hrData = globals.hrrData;
    });
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setstate();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    globals.influxDBClient = InfluxDBClient(
      url: 'https://us-east-1-1.aws.cloud2.influxdata.com',
      token:
          '-g6iC2cK-mwZpYCPaiKdDOyyX5P1vkncIDSigkxs_ImaQJUDUm1-87FX4peKEmW4F2DC9CMSqZKVVTLNvXERSg==',
      org: 'test',
      bucket: 'colabtest',
    );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    setstate();
    double avghr;
    globals.avgHr.remove(0.0);

    if (globals.avgHr.length >= 8) {
      if (globals.avgHr.elementAt(globals.avgHr.length - 1) ==
          globals.avgHr.last) {
        globals.avgHr.removeLast();
      }
      avghr = globals.avgHr.reduce((a, b) => a + b) / globals.avgHr.length;
    } else {
      avghr = globals.hrValue;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]),
            child: IconButton(
                onPressed: () {
                  // AuthRepo.instance.logout();
                  Get.to(ProfileScreen());
                },
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.black,
                )),
          )
        ],
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
                    MyGauge(
                        value: globals.sbpValue,
                        name: 'SBP',
                        redStart: 0,
                        redEnd: 90,
                        orangeStart: 90,
                        orangeEnd: 120,
                        greenStart: 120,
                        greenEnd: 140,
                        secondRedStart: 140,
                        secondRedEnd: 200,
                        minimumValue: 0,
                        maximumValue: 200),
                    MyGauge(
                        value: globals.dbpValue,
                        name: 'DBP',
                        redStart: 0,
                        redEnd: 60,
                        orangeStart: 60,
                        orangeEnd: 80,
                        greenStart: 80,
                        greenEnd: 90,
                        secondRedStart: 90,
                        secondRedEnd: 200,
                        minimumValue: 0,
                        maximumValue: 200),
                  ],
                ),
                Row(
                  children: [
                    MyGauge(
                        value: globals.avgHrValue,
                        name: 'BPM',
                        redStart: 0,
                        redEnd: 60,
                        orangeStart: 60,
                        orangeEnd: 100,
                        greenStart: 100,
                        greenEnd: 160,
                        secondRedStart: 160,
                        secondRedEnd: 200,
                        minimumValue: 0,
                        maximumValue: 200),
                    MyGauge(
                        value: globals.spo2Value,
                        name: 'SpO2',
                        redStart: 0,
                        redEnd: 90,
                        orangeStart: 90,
                        orangeEnd: 95,
                        greenStart: 95,
                        greenEnd: 100,
                        secondRedStart: 100,
                        secondRedEnd: 100,
                        minimumValue: 0,
                        maximumValue: 100),
                  ],
                ),
                MyThermometer(value: globals.tempValue),
                SizedBox(height: 20),
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
                    SplineSeries<globals.HRData, DateTime>(
                        name: 'Heart Rate',
                        dataSource: globals.hrrData
                            .sublist(max(0, globals.hrrData.length - 8)),
                        xValueMapper: (globals.HRData data, _) => data.time,
                        xAxisName: 'Time',
                        yValueMapper: (globals.HRData data, _) => data.value,
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
