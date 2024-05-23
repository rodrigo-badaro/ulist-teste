import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/typography/typography.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.leading,
    required this.label,
    this.controller,
    this.focusNode,
    this.validator,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onChanged,
    this.actions = const [],
    this.maxLines = 1,
    this.minLines,
    this.initialValue,
    this.readOnly = false,
    this.alert = false,
    this.keyboardType,
    this.prefixIcon,
    this.fillColor = PaletteColors.white,
    this.minHeight,
  });

  final double? minHeight;
  final Widget? leading;
  final Color fillColor;
  final IconData? prefixIcon;
  final bool alert;
  final String label;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final List<Widget> actions;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    FocusNode focus = focusNode ?? FocusNode();

    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 0.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(
          color: PaletteColors.info.withOpacity(0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListTile(
              enabled: false,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              mouseCursor: MouseCursor.uncontrolled,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: leading,
              title: Row(
                children: alert
                    ? [
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.error,
                            size: 14,
                            color: PaletteColors.danger,
                          ),
                        ),
                        Flexible(
                          child: TableHeader(
                            label,
                            bold: true,
                            color: PaletteColors.danger,
                          ),
                        ),
                      ]
                    : [
                        Flexible(
                          child: TableHeader(
                            label,
                          ),
                        )
                      ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: readOnly
                    ? Paragraph(
                        initialValue ?? '',
                      )
                    : Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            isDense: true,
                            filled: true,
                            hoverColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            iconColor: PaletteColors.menu,
                            prefixIconColor: PaletteColors.menu,
                            floatingLabelStyle: const TextStyle(color: PaletteColors.menu),
                            contentPadding: EdgeInsets.only(
                              top: 4,
                              bottom: minLines != null ? 16 : 4,
                            ),
                            border: InputBorder.none,
                            helperStyle: GoogleFonts.roboto(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: PaletteColors.menu,
                            ),
                          ),
                        ),
                        child: TextFormField(
                          readOnly: readOnly,
                          keyboardType: keyboardType,
                          focusNode: focus,
                          controller: controller,
                          initialValue: initialValue,
                          validator: validator,
                          inputFormatters: inputFormatters,
                          onFieldSubmitted: onFieldSubmitted,
                          onEditingComplete: onEditingComplete,
                          onChanged: onChanged,
                          maxLines: maxLines,
                          minLines: minLines,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontFeatures: const <FontFeature>[
                              FontFeature.enable('kern'),
                            ],
                          ),
                          decoration: prefixIcon == null
                              ? null
                              : InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 16, right: 16),
                                    child: Icon(
                                      prefixIcon,
                                      size: 22,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 54,
            child: Material(
              type: MaterialType.transparency,
              child: Visibility(
                visible: actions.isNotEmpty,
                child: Row(
                  children: [
                    const VerticalDivider(
                      width: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                    ...actions,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
