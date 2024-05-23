import 'dart:async';
import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:ulist/widgets/modal/modal_body.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/responsive_size/responsive_size.dart';

class Modal {
  const Modal._();

  static Future<void> right({required BuildContext context, required double width, required Widget body, Function(dynamic)? onClose, Color? barrierColor}) {
    return SideSheet.right(
      barrierColor: barrierColor ?? PaletteColors.black.withOpacity(0.4),
      sheetColor: PaletteColors.background,
      context: context,
      width: width,
      transitionDuration: Duration(milliseconds: MediaQuery.sizeOf(context).width < ResponsiveSize.sm ? 150 : 300),
      body: ModalBody(child: body),
    ).then((value) {
      if (onClose != null) {
        onClose(value);
      }
    });
  }

  static Future<void> left({required BuildContext context, required double width, required Widget body, Function(dynamic)? onClose, Color? barrierColor}) {
    return SideSheet.left(
      barrierColor: barrierColor ?? PaletteColors.black.withOpacity(0.4),
      sheetColor: PaletteColors.background,
      context: context,
      width: width,
      transitionDuration: Duration(milliseconds: MediaQuery.sizeOf(context).width < ResponsiveSize.sm ? 150 : 300),
      body: ModalBody(child: body),
    ).then((value) {
      if (onClose != null) {
        onClose(value);
      }
    });
  }
}
