import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: PaletteColors.background,
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3.0),
      side: const BorderSide(
        color: Color.fromRGBO(15, 23, 42, 0.2),
        width: 1,
      ),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) => 0),
      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
        (Set<MaterialState> states) => GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      backgroundColor: const MaterialStatePropertyAll(PaletteColors.menu),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey[300],
    thickness: 1,
  ),
  chipTheme: const ChipThemeData(
    selectedColor: PaletteColors.primary,
    backgroundColor: PaletteColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
    side: BorderSide(color: Color.fromRGBO(59, 71, 82, 0.2), width: 1.0),
  ),
  checkboxTheme: CheckboxThemeData(
    side: const BorderSide(color: Color.fromRGBO(15, 23, 42, 0.3), width: 1.0),
    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return PaletteColors.primary;
      }
      return PaletteColors.background;
    }),
  ),
  switchTheme: SwitchThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    trackOutlineWidth: const MaterialStatePropertyAll(0),
    thumbIcon: MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return const Icon(
          Icons.remove,
        );
      }
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.check,
          color: PaletteColors.primary,
        );
      }
      return const Icon(
        Icons.close,
        color: PaletteColors.primary,
      );
    }),
    thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey;
      }

      if (states.contains(MaterialState.selected)) {
        return PaletteColors.primary;
      }

      return const Color.fromRGBO(82, 73, 227, 0.5);
    }),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF5249E3),
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(fontWeight: FontWeight.w400), //<-- SEE HERE
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(primary: PaletteColors.primary).copyWith(
        background: PaletteColors.background,
      ),
);
