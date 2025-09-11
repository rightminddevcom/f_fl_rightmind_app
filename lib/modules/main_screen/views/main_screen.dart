import 'package:cpanal/modules/home/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../routing/app_router.dart';
import '../view_models/main_viewmodel.dart';

class BottomNavigationBarModel {
  final String icon;
  final String title;

  BottomNavigationBarModel({required this.icon, required this.title});
}

final bottomNavigationBarItems = [
  BottomNavigationBarModel(
    icon: AppImages.homeBottomBarIcon,
    title: AppStrings.home,
  ),
  BottomNavigationBarModel(
    icon: AppImages.requestsBottomBarIcon,
    title: AppStrings.requests,
  ),
  BottomNavigationBarModel(
    icon: AppImages.fingerprintBottomBarIcon,
    title: AppStrings.fingerprint,
  ),
  BottomNavigationBarModel(
    icon: AppImages.notificationBottomBarIcon,
    title: AppStrings.notifications,
  ),
  BottomNavigationBarModel(
    icon: AppImages.moreBottomBarIcon,
    title: AppStrings.more,
  ),
];

class MainScreen extends StatelessWidget {
  final Widget child;
  final NavbarPages currentNavPage;
  const MainScreen(
      {super.key, required this.child, required this.currentNavPage});

  @override
  Widget build(BuildContext context) {
    // ConnectionsService.init();
    final viewModel = Provider.of<MainScreenViewModel>(context);
    viewModel.currentPage = currentNavPage;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // floatingActionButton: const MainAppFabWidget(),
      body: SafeArea(child: HomeScreen()),
    );
  }
}
