import 'package:flutter/material.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/typography/typography.dart';

class MenuTileItem extends StatelessWidget {
  final IconData icon;
  final String title;

  final bool active;
  final Function() function;

  const MenuTileItem({
    required this.icon,
    required this.title,
    required this.active,
    required this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> mouseHover = ValueNotifier(false);

    return RepaintBoundary(
      child: SelectionContainer.disabled(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: active ? PaletteColors.primary : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          child: MouseRegion(
            onHover: (event) => mouseHover.value = true,
            onExit: (event) => mouseHover.value = false,
            child: ListenableBuilder(
              listenable: mouseHover,
              builder: (context, child) {
                return ListTile(
                  selected: active,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                  selectedTileColor: PaletteColors.primary,
                  onTap: function,
                  leading: Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(
                      icon,
                      color: active || mouseHover.value ? Colors.white : Colors.grey[400],
                      size: 22,
                    ),
                  ),
                  hoverColor: active ? Colors.transparent : Colors.white.withOpacity(0.15),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Paragraph(
                      title,
                      maxLines: 1,
                      color: active || mouseHover.value ? Colors.white : Colors.grey[350],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
