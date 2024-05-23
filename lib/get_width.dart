import 'package:flutter/material.dart';
import 'package:ulist/widgets/responsive_size/responsive_size.dart';

double getWidth(BuildContext context, double percent) {
  var result = 0.0;

  if (MediaQuery.sizeOf(context).width.floor() > ResponsiveSize.md) {
    result = (MediaQuery.sizeOf(context).width.floor() -70) * percent;
  } else {
    result = MediaQuery.sizeOf(context).width;
  }

  return result;
}
