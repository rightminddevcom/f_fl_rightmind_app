import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/cpanel/auto_response/auto_response_screen.dart';
import 'package:cpanal/modules/cpanel/dns/dns_screen.dart';
import 'package:cpanal/modules/cpanel/email_account/email_account_screen.dart';
import 'package:cpanal/modules/cpanel/email_filter/email_filter_screen.dart';
import 'package:cpanal/modules/cpanel/email_forward/email_forward_screen.dart';
import 'package:cpanal/modules/cpanel/ftp/ftp_account_screen.dart';
import 'package:cpanal/modules/cpanel/sql/sql_account_screen.dart';
import 'package:cpanal/modules/home/widget/grid_view_model.dart';
import 'package:cpanal/modules/home/widget/home_grid_view_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_router.dart';
import '../../cpanel/ssl/ssl_controller_screen.dart';

class DashboardGridView2 extends StatelessWidget {
  var name;
  var dominId;
  var domin;
  List? userPermissions = [];
  DashboardGridView2({this.name, this.dominId, this.domin, this.userPermissions});

  @override
  Widget build(BuildContext context) {
    List<GrideViewItemModel> grideItems = [
      if(userPermissions!.contains("ftp_controls")) GrideViewItemModel(
          image: "assets/images/svg/ftp.svg",
          title: AppStrings.ftpAccounts.tr(),
          description: "",
          onTap: (){
            context.pushNamed(
              AppRoutes.FTPAccounts.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
            );
          },
          backgroundColor:  Color(AppColors.dark)),
      if(userPermissions!.contains("mysql_controls")) GrideViewItemModel(
          image: "assets/images/svg/sql.svg",
          title: AppStrings.sql.tr(),
          description: "",
          onTap: (){
            context.pushNamed(
              AppRoutes.SqlAccounts.name,
              pathParameters: {
                'lang': context.locale.languageCode,
                'id': dominId.toString(),
                'name': name,
              },
            );
          },
          backgroundColor:  Color(AppColors.dark)),
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
