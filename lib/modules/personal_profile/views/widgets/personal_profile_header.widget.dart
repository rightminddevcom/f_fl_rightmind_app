import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/check_values.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/general_services/layout.service.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/personal_profile/viewmodels/personal_profile.viewmodel.dart';
import '../../../../../constants/app_sizes.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/web_image.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/custom_shimmer_loading/shimmer_animated_loading.dart';

class PersonalProfileHeaderWidget extends StatelessWidget {
  final PersonalProfileViewModel viewModel;
  final String headerImage;
  final double notchedContainerHeight;
  final double backgroundHeight;
  final double notchRadius;
  final double notchPadding;
  final String notchImage;
  final String title;
  final String subtitle;
  final double circleBorderWidth;
  const PersonalProfileHeaderWidget(
      {super.key,
        required this.viewModel,
        required this.notchImage,
        required this.notchPadding,
        required this.headerImage,
        required this.notchedContainerHeight,
        required this.backgroundHeight,
        required this.notchRadius,
        required this.title,
        required this.subtitle,
        required this.circleBorderWidth});

  @override
  Widget build(BuildContext context) {
    var jsonString;
    var us1Cache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      us1Cache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
    }
    return SizedBox(
      width: LayoutService.getWidth(context),
      height: backgroundHeight +
          (notchedContainerHeight *
              0.35), // background image height + half of notched container height
      child: Stack(
        children: [
          PersonalProfileHeaderBackgroundWidget(
              headerImage: headerImage, backgroundHeight: backgroundHeight),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CompanyInfoNotchedContainer(
              viewModel:viewModel ,
              notchedContainerHeight: notchedContainerHeight,
              notchRadius: notchRadius,
              notchPadding: notchPadding,
              notchImage: notchImage,
              title: title,
              subtitle: subtitle,
              circleBorderWidth: circleBorderWidth,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSizes.s12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
              width: LayoutService.getWidth(context),
              child: Column(
                children: [
                  if(us1Cache['email_verified_at'] == null || us1Cache['phone_verified_at'] == null) Container(
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
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const Spacer(),
                        Text(AppStrings.activeNow.tr(), style: const TextStyle(fontSize: 12, color: Colors.green),),
                      ],
                    ),
                  ),
                  if(us1Cache['email_verified_at'] == null || us1Cache['phone_verified_at'] == null)const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA3A3A3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.s15),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: AppSizes.s18,
                              ),
                            ),
                          )),
                       Text(
                        AppStrings.accountAndSettings.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppSizes.s14,
                          letterSpacing: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA3A3A3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.s15),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () async =>
                                  await viewModel.logout(context: context),
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: Colors.red,
                                size: AppSizes.s18,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalProfileHeaderBackgroundWidget extends StatelessWidget {
  final String headerImage;
  final double? backgroundHeight;
  const PersonalProfileHeaderBackgroundWidget(
      {super.key, required this.headerImage, required this.backgroundHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: backgroundHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(headerImage), fit: BoxFit.fill)),
        child: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Container(
                  height: backgroundHeight != null
                      ? backgroundHeight! / 2
                      : double.infinity,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Theme.of(context).colorScheme.primary,
                    //     Colors.transparent,
                    //   ],
                    //   stops: const [0.0, 0.5],
                    // ),
                  ),
                ),
                Container(
                    height: backgroundHeight != null
                        ? backgroundHeight! / 2
                        : double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    )),
              ],
            ))
          ],
        ));
  }
}

class CompanyInfoNotchedContainer extends StatelessWidget {
  final double notchedContainerHeight;
  final double notchRadius;
  final double notchPadding;
  final String notchImage;
  final String title;
  var viewModel;
  final String subtitle;
  final double circleBorderWidth;
  CompanyInfoNotchedContainer(
      {super.key,
        required this.notchImage,
        required this.viewModel,
        required this.notchPadding,
        required this.notchRadius,
        required this.notchedContainerHeight,
        required this.title,
        required this.circleBorderWidth,
        required this.subtitle});

  @override
  Widget build(BuildContext context) {
    var jsonString;
    var gCache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
    }
    return SizedBox(
      height: notchedContainerHeight,
      width: LayoutService.getWidth(context),
      child: Stack(
        children: [
          Positioned(
              top: AppSizes.s6,
              left: 0,
              right: 0,
              child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: (notchRadius - notchPadding) * 2.2,
                        height: (notchRadius - notchPadding) * 2.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color(AppColors.dark),
                              width: AppSizes.s2),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: viewModel
                                .listProfileImage
                                .isNotEmpty
                                ? Image(
                              image: CheckValuesFromApi.safeArray(viewModel.listProfileImage).isNotEmpty &&
                                  CheckValuesFromApi.safeArray(viewModel.listProfileImage)[0]['compressed'] != null
                                  ? FileImage(CheckValuesFromApi.safeArray(viewModel.listProfileImage)[0]['compressed'] as File)
                                  : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                              fit: BoxFit.cover,
                            )
                                : UserSettingConst.userSettings
                                ?.photo ==
                                null
                                ? Image.asset(
                              AppImages.logo,
                              fit: BoxFit.cover,
                            )
                                : !kIsWeb ? CachedNetworkImage(
                                imageUrl: UserSettingConst.userSettings
                                    ?.photo ??
                                    '',
                                fit: BoxFit.cover,
                                placeholder: (context,
                                    url) =>
                                const ShimmerAnimatedLoading(
                                  circularRaduis:
                                  AppSizes
                                      .s50,
                                ),
                                errorWidget:
                                    (context, url,
                                    error) =>
                                const Icon(
                                  Icons
                                      .image_not_supported_outlined,
                                  size: AppSizes
                                      .s60,
                                )) : ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 250, // أو أي رقم مناسب بدل Infinity
                              ),
                              child: CustomImage(
                                UserSettingConst.userSettings
                                    ?.photo?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              shape: BoxShape.circle
                          ),
                          child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Color(AppColors.dark),
                                size: AppSizes.s20,
                              ),
                              onPressed: () async {
                                await viewModel.getImage(context,
                                    image1: viewModel
                                        .profileImage,
                                    image2: viewModel
                                        .XImageFileProfile,
                                    list2: viewModel
                                        .listXProfileImage,
                                    list: viewModel
                                        .listProfileImage);
                                viewModel.updateProfileMainInfoImage(context: context);
                              }),
                        ),
                      ),
                    ],
                  ))),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: PersonalProfileCustomNotchClipper(
                  notchSize: (notchRadius * 2) + (notchPadding * 2)),
              child: Container(
                padding: EdgeInsets.only(
                    top: notchRadius / 2,
                    left: AppSizes.s8,
                    right: AppSizes.s8),
                height: notchedContainerHeight - (notchRadius + notchPadding),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.s32),
                    topRight: Radius.circular(AppSizes.s32),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    gapH12,
                    AutoSizeText(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalProfileCustomNotchClipper extends CustomClipper<Path> {
  final double notchSize;

  PersonalProfileCustomNotchClipper({required this.notchSize});

  @override
  Path getClip(Size size) {
    final double radius = notchSize / 2;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo((size.width - notchSize) / 2, 0)
      ..arcToPoint(
        Offset((size.width + notchSize) / 2, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
