import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/cpanel/auto_response/auto_response_screen.dart';
import 'package:cpanal/modules/cpanel/email_account/email_account_screen.dart';
import 'package:cpanal/modules/cpanel/email_filter/email_filter_screen.dart';
import 'package:cpanal/modules/cpanel/email_forward/email_forward_screen.dart';
import 'package:cpanal/modules/home/widget/grid_view_model.dart';
import 'package:cpanal/modules/home/widget/home_grid_view_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_constants.dart';
import '../../../routing/app_router.dart';

class DashboardGridView extends StatelessWidget {
  var name;
  var dominId;
  var domin;
  List? userPermissions = [];
  DashboardGridView({this.name, this.dominId, this.domin, this.userPermissions});

  @override
  Widget build(BuildContext context) {
    List<GrideViewItemModel> grideItems = [
     if(userPermissions!.contains("emails_controls"))GrideViewItemModel(
          image: "assets/images/svg/email_accounts.svg",
          title: AppStrings.emailAccounts.tr(),
          description: "",
          onTap: (){
            AppConstants.accountsEmailsFilter = [];
            context.pushNamed(
              AppRoutes.EmailAccount.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
              extra: EmailAccountExtra(
                begin: const Offset(1.0, 0.0),
                permissions: userPermissions,
              ),
            );
          },
          backgroundColor:  Color(AppColors.dark)),
      if(userPermissions!.contains("email_forwarders")) GrideViewItemModel(
          image: "assets/images/svg/email_forward.svg",
          title: AppStrings.emailForwarders.tr(),
          description: "",
          onTap: (){
            context.pushNamed(
              AppRoutes.EmailForward.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
            );
          },
          backgroundColor: const Color(AppColors.dark)),
      if(userPermissions!.contains("email_autoresponders")) GrideViewItemModel(
          image: "assets/images/svg/auto_response.svg",
          title: AppStrings.autoresponders.tr(),
          description: "",
          onTap: (){
            context.pushNamed(
              AppRoutes.AutoResponse.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
            );

          },
          backgroundColor: Color(AppColors.dark)),
      if(userPermissions!.contains("email_filters"))GrideViewItemModel(
          image: "assets/images/svg/email_filters.svg",
          title: AppStrings.emailFilters.tr(),
          description: "",
          onTap: (){
            context.pushNamed(
              AppRoutes.EmailFilter.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
            );
          },
          backgroundColor: const Color(AppColors.dark)),
      // GrideViewItemModel(
      //     image: "assets/images/svg/h-cpanal.svg",
      //     title: "Email Accounts",
      //     description: AppStrings.ticketSystemDescripe.tr(),
      //     onTap: (){
      //
      //     },
      //     backgroundColor: const Color(AppColors.dark)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth > 800 ? 1.5 : 0.8;

          return GridView.count(
            crossAxisCount: constraints.maxWidth > 800 ? 4 : 2, // على الويب 4 أعمدة
            mainAxisSpacing: 5,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: aspectRatio,
            children: grideItems
                .map((item) => HomeGridViewItem(itemModel: item))
                .toList(),
          );
        },
      ),
    );

  }

}
