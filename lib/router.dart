import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ulist/get_it.dart';
import 'package:ulist/screens/principal/principal.dart';
import 'package:ulist/widgets/modal/modal_listener.dart';

int currentIndex = 0;
int initialPage = 0;

final ModalListener modal = getIt<ModalListener>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late PageController pageController;
final PageController pageControllerCalendario = PageController(initialPage: 0);
final PageController pageControllerListas = PageController(initialPage: 0);

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/listas',
  redirect: (context, state) async {
    while (modal.state > 0) {
      modal.isOpen(instances: modal.state - 1);
      navigatorKey.currentState?.pop();
    }
    if (modal.state < 0) {
      modal.isOpen(instances: 0);
    }

    if (state.fullPath != null) {
      if (state.fullPath!.startsWith('/listas')) initialPage = 0;

      pageController = PageController(initialPage: initialPage);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.animateToPage(
            initialPage,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutQuint,
          );
        }

        if (initialPage == 0 && pageControllerListas.hasClients) {
          pageControllerListas.animateToPage(
            state.fullPath == '/listas' ? 0 : 1,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutQuint,
          );
        }
      });
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CupertinoPage(child: Principal(pageController: pageController, pageControllerListas: pageControllerListas), name: '/listas'),
    ),
    GoRoute(
      path: '/listas',
      pageBuilder: (context, state) => CupertinoPage(child: Principal(pageController: pageController, pageControllerListas: pageControllerListas), name: '/listas'),
    ),
    GoRoute(
      path: '/listas/:id',
      pageBuilder: (context, state) => CupertinoPage(child: Principal(pageController: pageController, pageControllerListas: pageControllerListas, ref: state.pathParameters['id']), name: '/listas/:id'),
    ),
  ],
);
