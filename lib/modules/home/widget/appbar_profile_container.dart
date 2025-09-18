import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_screen.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/user_consts.dart';
import '../../../constants/web_image.dart';
import '../../../general_services/localization.service.dart';
import '../../../models/settings/user_settings.model.dart';

class AppbarProfileContainer extends StatelessWidget {
   String? imageUrl;
   String? userName;
   String? userRole;
   AppbarProfileContainer({this.userName, this.imageUrl, this.userRole});

  @override
  Widget build(BuildContext context) {

    String formatName(String fullName) {
      List<String> nameParts = fullName.split(' ');
      if (nameParts.length < 2) {
        return fullName; // Return the full name if no last name is provided.
      }
      String firstName = nameParts[0];
      String lastInitial = nameParts[1][0].toUpperCase();
      return (CacheHelper.getString("lang") == "ar") ?'.$firstName $lastInitial' :'$firstName $lastInitial.';
    }
    var jsonString;
    var us1Cache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      us1Cache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      UserSettingConst.userSettings = UserSettingsModel.fromJson(us1Cache);
    }
    return Column(
      children: [
        if(us1Cache['email_verified_at'] == null || us1Cache['phone_verified_at'] == null) GestureDetector(
          onTap: ()async{
            await context.pushNamed(
                AppRoutes.personalProfile2.name,
                pathParameters: {'lang': context.locale.languageCode});
          },
          child: Container(
            color: Colors.yellow,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: Text(
                    (us1Cache['email_verified_at'] == null && us1Cache['phone_verified_at'] != null)? AppStrings.email_not_verified.tr():
                    (us1Cache['email_verified_at'] != null && us1Cache['phone_verified_at'] == null)? AppStrings.phone_not_verified.tr():
                    (us1Cache['email_verified_at'] == null && us1Cache['phone_verified_at'] == null)? AppStrings.email_phone_not_verified.tr(): "",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Spacer(),
                Text(AppStrings.activeNow.tr(), style: TextStyle(fontSize: 12, color: Colors.green),),
              ],
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
              width: 63,
              height: 63,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(AppColors.primary), Color(AppColors.dark)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipOval( // هنا بدل ClipRRect استخدم ClipOval
                  child:  CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: 59,
                    height: 59,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerAnimatedLoading(
                      width: 63,
                      height: 63,
                      circularRaduis: 63,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported_outlined,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    right: LocalizationService.isArabic(context: context) ? 15 : 0, left: LocalizationService.isArabic(context: context) ? 0 : 15,
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context!).width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 23,
                          child: Text(
                            userName!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Container(
                          height: 15,
                          child: Text(
                            userRole!.toUpperCase(),
                            style: TextStyle(
                                color: Color(0xffFFFFFF).withOpacity(0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    if(kIsWeb) {
                      context.pushNamed(
                        AppRoutes.defaultListPage.name,
                        pathParameters: {
                          "lang": context.locale.languageCode,
                          "type": "rmnotifications"
                        },
                      );
                    }else{
                      context.pushNamed(
                        AppRoutes.defaultPage.name,
                        pathParameters: {
                          "lang": context.locale.languageCode,
                          "type": "rmnotifications"
                        },
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/images/svg/notification.svg",
                    color: Color(0xffFFFFFF),
                    width: AppSizes.s30,
                    height: AppSizes.s30,
                  ),
                )
              ],
            ),
          ),
      ],
    );
    }
  }

