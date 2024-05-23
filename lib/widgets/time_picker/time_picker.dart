import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/time_picker/hours.dart';
import 'package:ulist/widgets/time_picker/minutes.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.initialValue,
    required this.onChange,
    this.color = PaletteColors.background,
    this.bordered = true,
  });

  final Color color;
  final bool bordered;
  final DateTime? initialValue;
  final Function(DateTime dateTime) onChange;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final FixedExtentScrollController hController = FixedExtentScrollController();
  final FixedExtentScrollController mController = FixedExtentScrollController();

  int hour = 0;
  int minutes = 0;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) dateTime = widget.initialValue!;

    if (dateTime != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        var minIndex = (dateTime!.minute / 5).round().toString();

        hController.animateToItem(dateTime!.hour, duration: const Duration(milliseconds: 300), curve: Curves.linear);
        mController.animateToItem(int.parse(minIndex), duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }

  @override
  void dispose() {
    hController.dispose();
    mController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        border: widget.bordered
            ? Border.all(
                width: 1,
                color: const Color(0xFFCBD5E1),
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              color: Colors.white.withOpacity(0.8),
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: ListWheelScrollView.useDelegate(
                        controller: hController,
                        squeeze: 2,
                        itemExtent: 100,
                        perspective: 0.0001,
                        diameterRatio: 10,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (value) {
                          setState(() {
                            hour = value;
                            dateTime = DateTime(1970, 0, 0, hour, minutes);

                            widget.onChange(dateTime!);
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List<Widget>.generate(
                            24,
                            (index) => Hours(
                              hours: index,
                              bold: (index == hour),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              hController.animateToItem(
                                hController.selectedItem - 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            },
                            child: const Icon(
                              Icons.expand_less,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              hController.animateToItem(
                                hController.selectedItem + 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            },
                            child: const Icon(
                              Icons.expand_more,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ':',
                      style: TextStyle(fontSize: 28, color: Colors.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: ListWheelScrollView.useDelegate(
                        controller: mController,
                        squeeze: 2,
                        itemExtent: 100,
                        perspective: 0.0001,
                        diameterRatio: 10,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (value) {
                          setState(() {
                            minutes = value * 5;
                            dateTime = DateTime(1970, 0, 0, hour, minutes);

                            widget.onChange(dateTime!);
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List<Widget>.generate(
                            12,
                            (index) => Minutes(
                              mins: index * 5,
                              bold: (index * 5 == minutes),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              mController.animateToItem(
                                mController.selectedItem - 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            },
                            child: const Icon(
                              Icons.expand_less,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              mController.animateToItem(
                                mController.selectedItem + 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            },
                            child: const Icon(
                              Icons.expand_more,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IgnorePointer(
              child: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      height: 50,
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
