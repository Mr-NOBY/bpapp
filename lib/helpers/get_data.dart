import 'dart:async';
import 'package:flutter/material.dart';

import '../global/globals.dart' as globals;

// class MyWidget extends StatefulWidget {
//   @override
//   MyWidgetState createState() => MyWidgetState();
// }

// class MyWidgetState extends State<MyWidget> {
void getData() async {
  var queryApi = globals.influxDBClient.getQueryService();
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
  if (globals.avgHr.length < 8) {
    resultHr = await queryApi.query(querylast8);
  } else {
    resultHr = await queryApi.query(queryHr);
  }
  await for (var record in resultHr) {
    if (record['_field'] == 'acchr') {
      // Timer.periodic(Duration(seconds: 3), (timer) {
      // setState(() {
      //_hrValue = (record['_value']).toDouble();
      globals.hrrData = globals.hrData;
      // });
      // });
      globals.hrData.add(globals.HRData(
          record['_value'].toDouble(), DateTime.parse(record['_time'])));
      globals.avgHr.add(globals.hrValue);
    }

    var queryavgHr = "from(bucket: \"colabtest\") "
        "|> range(start: -72h) "
        "|> filter(fn: (r) => r._measurement == \"acchr\")"
        "|> filter(fn: (r) => r._field == \"avghr\") "
        "|> last()";
    var resultavgHr = await queryApi.query(queryavgHr);
    await for (var record in resultavgHr) {
      if (record['_field'] == 'avghr') {
        Timer.periodic(const Duration(seconds: 5), (timer) {
          // setState(() {
          globals.avgHrValue = (record['_value']).toDouble();
          // });
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
        Timer.periodic(const Duration(seconds: 5), (timer) {
          // setState(() {
          globals.sbpValue = (record['_value']).toDouble();
          // });
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
          Timer.periodic(const Duration(seconds: 5), (timer) {
            // setState(() {
            globals.dbpValue = (record['_value']).toDouble();
            // print('dpb');
            // print((record['_value']).toDouble());
            // print(globals.dbpValue);
          });
          // });
        }
      }
    }

    Future.delayed(
      const Duration(seconds: 3),
      () {
        getData();
      },
    );
  }
}

@override
Widget build(BuildContext context) {
  // You can call the getData function here or anywhere else in this class
  // getData();

  // Return your widget here
  return Container();
}
// }
