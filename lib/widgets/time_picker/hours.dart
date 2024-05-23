import 'package:flutter/material.dart';

class Hours extends StatelessWidget {
  final int hours;
  final Color color;
  final bool bold;

  const Hours({
    super.key,
    required this.hours,
    required this.bold,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hours < 10 ? '0$hours' : hours.toString(),
        style: TextStyle(
          fontSize: bold ? 28 : 20,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
