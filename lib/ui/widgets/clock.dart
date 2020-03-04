import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnalogClock(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0, // has the effect of softening the shadow
                spreadRadius: 0.1, // has the effect of extending the shadow
                offset: Offset(
                  5.0, // horizontal, move right 10
                  10.0, // vertical, move down 10
                ),
              )
            ],
          ),
          isLive: true,
          showAllNumbers: true,
          tickColor: Colors.green[600],
          secondHandColor: Colors.green[600],
          numberColor: Colors.green[600],
          width: 150.0,
          height: 150.0,
          showNumbers: false,
          showDigitalClock: false,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            DateFormat('dd - MMM - yyyy').format(DateTime.now()),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 20,
              color: Colors.green[600],
              shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
            ),
          ),
        )
      ],
    );
  }
}
