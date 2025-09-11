import 'dart:convert';

import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/general_services/app_theme.service.dart';
import 'package:cpanal/modules/points_screen/widgets/select_contact_screen.dart';
import 'package:cpanal/utils/componentes/general_components/all_bottom_sheet.dart';
import 'package:cpanal/utils/componentes/general_components/slider_home_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/home_model/home_model.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/points_screen/widgets/add_friend_bottom_sheet.dart';
import 'package:cpanal/routing/app_router.dart';


class CopounSection extends StatefulWidget {
  CopounSection({super.key});

  @override
  State<CopounSection> createState() => _CopounSectionState();
}

class _CopounSectionState extends State<CopounSection> {
  TextEditingController linkController = TextEditingController();
  TextEditingController friendNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  void copyToClipboard(BuildContext context, {text}) {
    Clipboard.setData(ClipboardData(text: text));
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => HomeViewModel(),
    child: Consumer<HomeViewModel>(
      builder: (context, value, child) {
        final json2String = CacheHelper.getString("US2");
        var us2Cache;
        if (json2String != null && json2String != "") {
          us2Cache = json.decode(json2String) as Map<String, dynamic>;
        }
        final json1String = CacheHelper.getString("US1");
        var us1Cache;
        if (json1String != null && json1String != "") {
          us1Cache = json.decode(json1String) as Map<String, dynamic>;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.aboutPointsProgram.tr().toUpperCase(),
                style:  const TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.oC2Color),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15,),
              Text(
                AppStrings.pointsCondationAbout.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.black),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 30,),
              Text(AppStrings.inviteYourFriend.tr().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, color: Color(AppColors.oC2Color))),
              const SizedBox(height: 15,),
              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: ShapeDecoration(
                  color: AppThemeService.colorPalette.tertiaryColorBackground.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.s10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 10,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        child: Text(us2Cache['referral_form'].toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff5E5E5E)),)),
                  GestureDetector(
                      onTap: (){
                        copyToClipboard(context, text: us2Cache['referral_form']);
                      },
                      child: Text(AppStrings.copy.tr(), style: const TextStyle(fontWeight: FontWeight.w600, color: Color(AppColors.oC2Color), fontSize: 12),))
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Text(AppStrings.referralCode.tr().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, color: Color(AppColors.oC2Color))),
              const SizedBox(height: 15,),
              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: ShapeDecoration(
                  color: AppThemeService.colorPalette.tertiaryColorBackground.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.s10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 10,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        child: Text(us1Cache['referral_code'].toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff5E5E5E)),)),
                  GestureDetector(
                      onTap: (){
                        copyToClipboard(context, text: us1Cache['referral_code']);
                      },
                      child: Text(AppStrings.copy.tr(), style: const TextStyle(fontWeight: FontWeight.w600, color: Color(AppColors.oC2Color), fontSize: 12),))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ) ,
    );
  }
}
