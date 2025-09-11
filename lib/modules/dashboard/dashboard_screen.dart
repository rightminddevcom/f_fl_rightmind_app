import 'dart:convert';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/dashboard/widget/dashboard_grid_view.dart';
import 'package:cpanal/modules/dashboard/widget/dashboard_grid_view2.dart';
import 'package:cpanal/modules/dashboard/widget/dashboard_grid_view3.dart';
import 'package:cpanal/modules/more/views/more_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common_modules_widgets/template_page.widget.dart';
import '../../../constants/app_sizes.dart';

class DashboardScreen extends StatefulWidget {
  var name;
  var dominId;
  List? userPermissions = [];
  DashboardScreen({this.name, this.dominId, this.userPermissions});
  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    var jsonString;
    var gCache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
    }
    return TemplatePage(
        pageContext: context,
        title: AppStrings.dashboard.tr().toUpperCase(),
        onRefresh: () async {},
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.s12, horizontal: AppSizes.s25),
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.emails.tr().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(AppColors.primary)),
                  ),
                  const SizedBox(height: 20,),
                  DashboardGridView(
                    name: widget.name,
                    dominId: widget.dominId,
                    userPermissions: widget.userPermissions,
                  ),
                  const SizedBox(height: 30,),
                  Text(AppStrings.website.tr().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(AppColors.primary)),
                  ),
                  const SizedBox(height: 20,),
                  DashboardGridView2(
                    name: widget.name,
                    dominId: widget.dominId,
                    userPermissions: widget.userPermissions,
                  ),
                  const SizedBox(height: 30,),
                  Text(AppStrings.more.tr().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(AppColors.primary)),
                  ),
                  const SizedBox(height: 20,),
                  DashboardGridView3(
                    name: widget.name,
                    dominId: widget.dominId,
                    userPermissions: widget.userPermissions,
                  ),
                ],
              )
          ),
        ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xffC9CFD2).withOpacity(0.5),
              blurRadius: AppSizes.s5,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(35),
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
              child: Text(widget.name!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark))),
            ),
            const SizedBox(width: 5),
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/images/svg/cpanal_bottom_nav_icon.svg")),
            const Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MoreScreen(),));
              },
              child: const Icon(Icons.menu, color: Color(AppColors.primary)),
            )
          ],
        ),
      ),
    );
  }
}
