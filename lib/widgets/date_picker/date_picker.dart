import 'package:flutter/material.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    this.initialValue,
    required this.onChange,
    this.color = PaletteColors.background,
    this.bordered = true,
  });

  final Color color;
  final bool bordered;
  final DateTime? initialValue;
  final void Function(DateTime dateTime) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: bordered
            ? Border.all(
                width: 1,
                color: const Color(0xFFCBD5E1),
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: const DatePickerThemeData(
            dayStyle: TextStyle(fontSize: 13),
            weekdayStyle: TextStyle(fontSize: 13),
            yearStyle: TextStyle(fontSize: 13),
          ),
        ),
        child: SelectionContainer.disabled(
          child: CalendarDatePicker(
            initialDate: initialValue ?? DateTime.now(),
            firstDate: DateTime.parse('1900-11-30'),
            lastDate: DateTime.parse('2099-12-31'),
            onDateChanged: (val) {
              var date = DateTime(val.year, val.month, val.day, 0, 00);
              onChange.call(date);
            },
          ),
        ),
      ),
    );
  }
}
