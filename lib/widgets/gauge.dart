import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyGauge extends StatelessWidget {
  final double value;
  final String name;
  final double redStart;
  final double redEnd;
  final double orangeStart;
  final double orangeEnd;
  final double greenStart;
  final double greenEnd;
  final double secondRedStart;
  final double secondRedEnd;
  final double minimumValue;
  final double maximumValue;

  const MyGauge({
    Key? key,
    required this.value,
    required this.name,
    required this.redStart,
    required this.redEnd,
    required this.orangeStart,
    required this.orangeEnd,
    required this.greenStart,
    required this.greenEnd,
    required this.secondRedStart,
    required this.secondRedEnd,
    required this.minimumValue,
    required this.maximumValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.33,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
              minimum: minimumValue, // Use the minimumValue parameter here
              maximum: maximumValue, // Use the maximumValue parameter here
              radiusFactor: 0.85,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: redStart, // Use the redStart parameter here
                  endValue: redEnd, // Use the redEnd parameter here
                  color: Colors.red,
                  startWidth: 20,
                  endWidth: 20,
                ),
                GaugeRange(
                  startValue: orangeStart, // Use the orangeStart parameter here
                  endValue: orangeEnd, // Use the orangeEnd parameter here
                  color: Colors.orange,
                  startWidth: 20,
                  endWidth: 20,
                ),
                GaugeRange(
                  startValue: greenStart, // Use the greenStart parameter here
                  endValue: greenEnd, // Use the greenEnd parameter here
                  color: Colors.green,
                  startWidth: 20,
                  endWidth: 20,
                ),
                GaugeRange(
                  startValue:
                      secondRedStart, // Use the secondRedStart parameter here
                  endValue: secondRedEnd, // Use the secondRedEnd parameter here
                  color: Colors.red,
                  startWidth: 20,
                  endWidth: 20,
                ),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: value, // Use the value parameter here
                  animationType: AnimationType.ease,
                  animationDuration: 1000,
                  enableAnimation: true,
                  markerWidth: 20,
                  markerOffset: -10,
                  color: Colors.blueGrey,
                ),
                RangePointer(
                  value: value, // Use the value parameter here
                  enableAnimation: true,
                  animationDuration: 1000,
                  animationType: AnimationType.ease,
                  dashArray: const [8, 2],
                  color: const Color.fromRGBO(220, 220, 220, 70),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ((value).round())
                              .toString(), // Use the value parameter here
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          name, // Use the name parameter here
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 52, 52, 52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.75,
                )
              ]),
        ],
      ),
    );
  }
}
