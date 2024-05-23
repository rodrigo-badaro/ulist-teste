import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/responsive_size/responsive_size.dart';
import 'package:ulist/widgets/typography/typography.dart';

class AppBarCustom extends StatefulWidget {
  final Widget? more;

  final ValueNotifier<bool>? isSearching;
  final Function(String search)? searchFunction;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController? search;
  final FocusNode? searchFocus;

  const AppBarCustom({
    super.key,
    this.more,
    this.isSearching,
    this.searchFunction,
    required this.scaffoldKey,
    this.search,
    this.searchFocus,
  });

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      leading: const Icon(Icons.menu),
      // leading: MenuButton(
      //   scaffoldKey: widget.scaffoldKey,
      //   color: widget.transparentBackground ? PaletteColors.white : PaletteColors.menu,
      // ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: 55),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Visibility(
                visible: widget.searchFunction != null,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: H1Small('uList'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: VerticalDivider(
                        width: 1,
                        thickness: 0.5,
                        endIndent: 24,
                        indent: 24,
                        color: PaletteColors.info,
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.searchFunction?.call(widget.search?.text ?? ''),
                      icon: const Icon(
                        Icons.search,
                        color: PaletteColors.info,
                        size: 22,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextFormField(
                          controller: widget.search,
                          keyboardType: TextInputType.text,
                          onChanged: (value) => widget.searchFunction == null ? null : widget.searchFunction!(value),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: false,
                            hintText: 'Pesquisar...',
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: PaletteColors.info,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: widget.isSearching ?? ValueNotifier(false),
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: widget.isSearching?.value ?? false || hasTextFieldNotEmpty(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: IconButton(
                              onPressed: () {
                                if (widget.search != null) {
                                  setState(() {
                                    if (widget.search!.text.isNotEmpty) {
                                      widget.search!.clear();
                                      widget.searchFunction ?? ('');
                                    }
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: PaletteColors.danger,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: MediaQuery.sizeOf(context).width > ResponsiveSize.sm,
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Label('Rodrigo Badaró'),
                    Paragraph('rodrigo.badaro.p@gmail.com'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: widget.more != null ? 4 : 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(130),
                      color: PaletteColors.info,
                    ),
                  ),
                  const Icon(
                    Icons.account_circle,
                    size: 24,
                    color: PaletteColors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: widget.more,
            ),
          ],
        ),
      ),
    );
  }

  bool hasTextFieldNotEmpty() {
    if (widget.search != null) {
      if (widget.search!.text.isNotEmpty) return true;
    }

    return false;
  }
}
