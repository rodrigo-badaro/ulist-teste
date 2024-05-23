import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ulist/router.dart';
import 'package:ulist/widgets/menu/menu_tile_item.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';

class Menu extends StatefulWidget {
  final ValueNotifier<bool>? hoverMenu;

  const Menu({super.key, this.hoverMenu});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> sizeAnimation;
  late final Animation<double> textAnimation;

  String? currentPath;

  @override
  void initState() {
    super.initState();
    navigatorKey.currentState?.popUntil(
      (route) {
        currentPath = route.settings.name;
        return true;
      },
    );

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    sizeAnimation = Tween<double>(
      begin: 70,
      end: 270,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutQuint,
        reverseCurve: Curves.easeInOutQuint,
      ),
    );

    textAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.8, 1.0),
      ),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    widget.hoverMenu?.addListener(() {
      if (widget.hoverMenu?.value == true) {
        controller.forward();
      } else {
        try {
          controller.reverse();
        } catch (e) {
          null;
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant Menu oldWidget) {
    super.didUpdateWidget(oldWidget);
    navigatorKey.currentState?.popUntil(
      (route) {
        currentPath = route.settings.name;
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: ((event) {
        widget.hoverMenu?.value = true;
      }),
      onExit: ((event) {
        widget.hoverMenu?.value = false;
      }),
      child: AnimatedContainer(
        alignment: Alignment.topLeft,
        height: double.maxFinite,
        width: sizeAnimation.value,
        duration: const Duration(milliseconds: 246),
        curve: Curves.easeOutQuint,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: PaletteColors.menu,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE2E8F0).withOpacity(0.2),
              spreadRadius: 1,
              offset: const Offset(1, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuTileItem(
                  function: () => context.go('/listas'),
                  icon: Icons.list,
                  title: 'Listas',
                  active: currentPath?.startsWith('/listas') ?? false,
                ),
                MenuTileItem(
                  function: () => context.go('/calendario'),
                  icon: Icons.calendar_month,
                  title: 'Calendario',
                  active: currentPath?.startsWith('/calendario') ?? false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
