import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';

class H1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H1(this.text,
      {super.key,
      this.color = const Color(0xFF4B4B4B),
      this.maxLines,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.inter(
        fontSize: 36,
        letterSpacing: 36 * -0.0141279,
        fontWeight: FontWeight.w900,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class H2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H2(this.text,
      {super.key,
      this.maxLines,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.inter(
        fontSize: 30,
        letterSpacing: 30 * -0.021,
        fontWeight: FontWeight.w900,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class H3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H3(this.text,
      {super.key,
      this.maxLines,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        fontSize: 27,
        letterSpacing: 27 * -0.0114923,
        fontWeight: FontWeight.w700,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class H4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H4(this.text,
      {super.key,
      this.maxLines,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        fontSize: 22,
        letterSpacing: 22 * -0.00865734,
        fontWeight: FontWeight.w500,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
      // style: GoogleFonts.roboto(
      //   fontSize: 22,
      //   letterSpacing: -0.00865734,
      //   color: color,
      // ),
    );
  }
}

class H5 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H5(this.text,
      {super.key,
      this.maxLines,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        fontSize: 18,
        letterSpacing: 18 * -0.00630069,
        fontWeight: FontWeight.w400,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
      // style: GoogleFonts.roboto(
      //   fontSize: 18,
      //   fontWeight: FontWeight.w400,
      //   color: color,
      // ),
    );
  }
}

class Paragraph extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool bold;
  const Paragraph(this.text,
      {super.key,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start,
      this.maxLines,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: bold ? FontWeight.w600 : null,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class Overline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const Overline(this.text,
      {super.key,
      this.color = const Color(0xFF4B4B4B),
      this.maxLines,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        height: 21 / 11,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 11 * 0.006,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const SmallText(this.text,
      {super.key,
      this.color = const Color(0xFF4B4B4B),
      this.textAlign = TextAlign.start,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        height: 21 / 12,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 12 * 0.00849077,
        color: color,
        fontFeatures: const <FontFeature>[
          FontFeature.enable('kern'),
        ],
      ),
    );
  }
}

class H6 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H6(this.text,
      {super.key,
      this.color = PaletteColors.info,
      this.textAlign = TextAlign.start,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        fontSize: 16,
        letterSpacing: -0.00630069,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool bold;
  const Label(this.text,
      {super.key,
      this.color = PaletteColors.info,
      this.textAlign = TextAlign.start,
      this.maxLines,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: color,
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool upperCase;
  final bool bold;
  const TableHeader(
    this.text, {
    super.key,
    this.color = PaletteColors.info,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.upperCase = true,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      upperCase ? text.toUpperCase() : text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.montserrat(
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        fontSize: 11.0,
        letterSpacing: 0.06,
        color: color,
      ),
    );
  }
}

class ChipText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const ChipText(this.text,
      {super.key,
      this.color = PaletteColors.info,
      this.textAlign = TextAlign.start,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class H1Small extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  const H1Small(this.text,
      {super.key,
      this.color = PaletteColors.info,
      this.textAlign = TextAlign.start,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.inter(
        fontSize: 20,
        letterSpacing: -0.0141279,
        fontWeight: FontWeight.w900,
        color: color,
      ),
    );
  }
}
