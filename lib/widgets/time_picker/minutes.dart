import 'package:flutter/material.dart';

class Minutes extends StatelessWidget {
  final int mins;
  final Color color;
  final bool bold;

  const Minutes({
    super.key,
    required this.mins,
    required this.bold,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        mins < 10 ? '0$mins' : mins.toString(),
        style: TextStyle(
          fontSize: bold ? 28 : 20,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
