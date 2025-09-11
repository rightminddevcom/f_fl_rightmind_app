import 'package:cpanal/modules/home/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_screen.dart';
import '../../../routing/app_router.dart';
import '../../more/views/more_screen.dart';

class MainScreenViewModel extends ChangeNotifier {
  NavbarPages currentPage = NavbarPages.home;
  int get pageIndex => NavbarPages.values.indexOf(currentPage);

  void initializeMainScreen({
    required BuildContext context,
    required Type currentScreen,
  }) {
    switch (currentScreen) {
      case HomeScreen _:
        currentPage = NavbarPages.home;
        return;
      case NotificationScreen _:
        currentPage = NavbarPages.requests;
        return;
      case NotificationScreen _:
        currentPage = NavbarPages.fingerprint;
        return;
      case NotificationScreen _:
        CacheHelper.deleteData(key: "value");
        currentPage = NavbarPages.notifications;
        return;
      case MoreScreen _:
        currentPage = NavbarPages.notifications;
        return;
      default:
        currentPage = NavbarPages.home;
        return;
    }
  }

  Widget getCurrentMainPage(NavbarPages currPage) {
    switch (currPage) {
      case NavbarPages.home:
        return HomeScreen();
      case NavbarPages.fingerprint:
        return NotificationScreen(false);
      case NavbarPages.requests:
        return NotificationScreen(false);
      case NavbarPages.notifications:
        CacheHelper.deleteData(key: "value");
        return NotificationScreen(false);
      case NavbarPages.more:
        return const MoreScreen();
    }
  }

  void onItemTapped(
      {required BuildContext context, required NavbarPages page}) {
    if (page == currentPage) return;
    int oldIndex = pageIndex;
    int newIndex = NavbarPages.values.indexOf(page);
    currentPage = page;
    Offset begin = (newIndex > oldIndex)
        ? const Offset(1.0, 0.0)
        : const Offset(-1.0, 0.0);
    notifyListeners();
    _pushNamedToPage(context: context, page: page, begin: begin);
    return;
  }

  void _pushNamedToPage({
    required BuildContext context,
    required NavbarPages page,
    required Offset begin,
  }) {
    switch (page) {
      case NavbarPages.home:
        context.goNamed(AppRoutes.home.name,
            extra: begin,
            pathParameters: {'lang': context.locale.languageCode});
        return;
      case NavbarPages.fingerprint:
        context.goNamed(AppRoutes.notifications.name,
            extra: {'offset': begin},
            pathParameters: {'lang': context.locale.languageCode,
            });
        return;
      case NavbarPages.requests:
        context.goNamed(AppRoutes.notifications.name, extra: begin, pathParameters: {
          'type': 'mine',
          'lang': context.locale.languageCode
        });
        return;
      case NavbarPages.notifications:
        context.goNamed(AppRoutes.notifications.name,
            extra: begin,
            pathParameters: {'lang': context.locale.languageCode});
        return;
      case NavbarPages.more:
        context.goNamed(AppRoutes.more.name,
            extra: begin,
            pathParameters: {'lang': context.locale.languageCode});
        return;
    }
  }
}
