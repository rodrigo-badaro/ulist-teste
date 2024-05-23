import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key, required this.isSearching, required this.searchFunction, required this.search, required this.searchFocus});

  final ValueNotifier<bool> isSearching;
  final Function(String search) searchFunction;
  final TextEditingController search;
  final FocusNode searchFocus;

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, scaffoldConstraints) {
      return ListenableBuilder(
        listenable: widget.isSearching,
        builder: (context, snapshot) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 246),
            curve: Curves.easeOut,
            width: scaffoldConstraints.maxWidth,
            height: widget.isSearching.value ? 70 : 0,
            color: Colors.white,
            child: Visibility(
              visible: widget.isSearching.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: IconButton(
                        onPressed: (() {
                          widget.isSearching.value = false;
                        }),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey[400],
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.search,
                      focusNode: widget.searchFocus,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => widget.searchFunction(value),
                      decoration: InputDecoration(
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
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isSearching.value = false;
                            if (widget.search.text.isNotEmpty) {
                              widget.search.clear();
                              widget.searchFunction('');
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
