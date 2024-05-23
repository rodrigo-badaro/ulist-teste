import 'package:flutter/material.dart';
import 'package:ulist/screens/listas/listas.dart';

class Principal extends StatefulWidget {
  final PageController pageController;
  final PageController? pageControllerCalendario;
  final PageController? pageControllerListas;
  final dynamic ref;

  const Principal({
    super.key,
    required this.pageController,
    this.pageControllerCalendario,
    this.pageControllerListas,
    this.ref,
  });

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> sizeAnimation;
  final ValueNotifier<bool> hoverMenu = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

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

    hoverMenu.addListener(() {
      if (hoverMenu.value) {
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
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        Listas(
          pageControllerListas: widget.pageControllerListas,
          ref: widget.ref,
        ),
      ],
    );
  }
}

