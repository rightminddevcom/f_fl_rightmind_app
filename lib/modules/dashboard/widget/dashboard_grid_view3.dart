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

import '../../cpanel/ssl/ssl_controller_screen.dart';

class DashboardGridView3 extends StatelessWidget {
  var name;
  var dominId;
  var domin;
  List? userPermissions = [];
  DashboardGridView3({this.name, this.dominId, this.domin, this.userPermissions});

  @override
  Widget build(BuildContext context) {
    List<GrideViewItemModel> grideItems = [
      if(userPermissions!.contains("dns_controls")) GrideViewItemModel(
          image: "assets/images/svg/dns.svg",
          title: AppStrings.dnsControl.tr(),
          description: "",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DNSScreen(
              dominId: dominId.toString(),
              name: name,
            ),));
          },
          backgroundColor:  Color(AppColors.dark)),
      if(userPermissions!.contains("ssl_controls"))GrideViewItemModel(
          image: "assets/images/svg/ssl.svg",
          title: AppStrings.sslControl.tr(),
          description: "",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SSLControllerScreen(
              dominId: dominId.toString(),
              name: name,
            ),));
          },
          backgroundColor:  Color(AppColors.dark)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s20),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Important if inside ScrollView
        childAspectRatio: 0.8,
        children: grideItems.map((item) => HomeGridViewItem(itemModel: item)).toList(),
      ),
    );
  }

}
