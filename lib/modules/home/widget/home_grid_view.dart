import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/home/widget/grid_view_model.dart';
import 'package:cpanal/modules/home/widget/home_grid_view_item.dart';
import 'package:cpanal/modules/more/views/contactus/controller/controller.dart';
import 'package:cpanal/modules/more/views/contactus/view/contact_screen.dart';
import 'package:cpanal/modules/more/views/more_screen.dart';
import 'package:cpanal/modules/points_screen/points_screen.dart';
import 'package:cpanal/modules/requests_screen/requests_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_router.dart';

class HomeGridView extends StatelessWidget {
  const HomeGridView({super.key});

  @override
  Widget build(BuildContext context) {
    List<GrideViewItemModel> grideItems = [
      GrideViewItemModel(
          image: "assets/images/svg/h-cpanal.svg",
          title: AppStrings.cpanal.tr().toUpperCase(),
          description: AppStrings.cpanalDescripe.tr(),
          onTap: (){
            context.pushNamed(
                AppRoutes.chooseDomain.name,
                pathParameters: {
                  'lang': context.locale.languageCode,
                });
           // Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseDomainScreen(),));
          },
          backgroundColor:  Color(AppColors.dark)),
      GrideViewItemModel(
          image: "assets/images/svg/h-points.svg",
          title: AppStrings.myPoints.tr().toUpperCase(),
          description: AppStrings.pointsDescripe.tr(),
          onTap: (){
                 context.pushNamed(
                    AppRoutes.pointsScreen.name,
                    pathParameters: {
                      'lang':
                      context.locale.languageCode
                    });
           // Navigator.push(context, MaterialPageRoute(builder: (context) => PointsScreen(),));
          },
          backgroundColor: const Color(AppColors.primary)),
      GrideViewItemModel(
          image: "assets/images/svg/h-contact.svg",
          title: AppStrings.contactUs.tr().toUpperCase(),
          description: AppStrings.contactUsDescripe.tr(),
          onTap: (){
            context.pushNamed(
                AppRoutes.contactUs.name,
                pathParameters: {
                  'lang':
                  context.locale.languageCode
                });
           // Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen(),));
          },
          backgroundColor: Color(AppColors.primary)),
      GrideViewItemModel(
          image: "assets/images/svg/h-ticket.svg",
          title: AppStrings.ticketSystem.tr(),
          description: AppStrings.ticketSystemDescripe.tr(),
          onTap: (){
            context.pushNamed(
                AppRoutes.requests.name,
                pathParameters: {
                  'lang':
                  context.locale.languageCode
                });
            //Navigator.push(context, MaterialPageRoute(builder: (context) => RequestsScreen(),));
          },
          backgroundColor: const Color(AppColors.dark)),
      GrideViewItemModel(
          image: "assets/images/svg/menu.svg",
          title: AppStrings.more.tr(),
          description: AppStrings.moreDescripe.tr(),
          onTap: (){
            context.pushNamed(
                AppRoutes.more
                    .name,
                pathParameters: {
                  'lang':
                  context.locale.languageCode
                });
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const MoreScreen(),));
          },
          backgroundColor: const Color(AppColors.dark)),
    ];
    return SliverPadding(
      padding: const EdgeInsetsDirectional.only(
          top: AppSizes.s90),
      sliver: SliverGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: [
            ...grideItems.map((item) {
              return HomeGridViewItem(
                itemModel: item,
              );
            })
          ]),
    );
  }

}
