import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyThermometer extends StatelessWidget {
  final double value;

  const MyThermometer({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      minimum: 35,
      maximum: 42,
      interval: 1,
      showTicks: true,
      tickPosition: LinearElementPosition.cross,
      majorTickStyle: const LinearTickStyle(
        color: Colors.black87,
        length: 20,
        thickness: 2,
      ),
      minorTickStyle: const LinearTickStyle(
        color: Colors.grey,
        length: 15,
        thickness: 1,
      ),
      minorTicksPerInterval: 9,
      showLabels: true,
      axisLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 17.0,
      ),
      axisTrackStyle: const LinearAxisTrackStyle(
        thickness: 24,
        color: Color.fromRGBO(230, 207, 4, 1),
        borderWidth: 2,
        borderColor: Color.fromRGBO(202, 188, 56, 1),
      ),
      markerPointers: [
        LinearShapePointer(
          value: value,
          shapeType: LinearShapePointerType.invertedTriangle,
          color: Colors.blueGrey,
        ),
      ],
      barPointers: [
        LinearBarPointer(
          value: value,
          thickness: 10,
          color: const Color.fromRGBO(118, 102, 88, 100),
        )
      ],
    );
  }
}
