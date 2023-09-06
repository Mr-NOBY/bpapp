import 'dart:async';

import '../global/globals.dart' as globals;

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
      globals.hrValue = (record['_value']).toDouble();
      globals.hrrData = globals.hrData;
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
        globals.avgHrValue = (record['_value']).toDouble();
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
        globals.sbpValue = (record['_value']).toDouble();
      }

      var queryDbp = "from(bucket: \"colabtest\") "
          "|> range(start: -72h) "
          "|> filter(fn: (r) => r._measurement == \"acchr\")"
          "|> filter(fn: (r) => r._field == \"dbp\" ) "
          "|> last()";
      var resultDbp = await queryApi.query(queryDbp);
      await for (var record in resultDbp) {
        if (record['_field'] == 'dbp') {
          globals.dbpValue = (record['_value']).toDouble();
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
