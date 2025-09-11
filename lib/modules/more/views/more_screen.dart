import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpanal/modules/more/views/aboutus/view/aboutus_screen.dart';
import 'package:cpanal/modules/more/views/blog/view/blog_screen.dart';
import 'package:cpanal/modules/more/views/company_structure/company_structure_screen.dart';
import 'package:cpanal/modules/more/views/contactus/view/contact_screen.dart';
import 'package:cpanal/modules/more/views/faq/view/faq_screen.dart';
import 'package:cpanal/modules/more/views/lang_setting/lang_setting_screen.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_screen.dart';
import 'package:cpanal/modules/more/views/update_password/update_password_screen.dart';
import 'package:cpanal/modules/personal_profile/views/personal_profile_screen.dart';
import 'package:cpanal/modules/requests_screen/requests_screen.dart';
import 'package:cpanal/modules/splash_and_onboarding/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/more/widgets/customize_notification_screen.dart';
import 'package:cpanal/services/requests.services.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../general_services/settings.service.dart';
import '../../../models/settings/user_settings.model.dart';

import '../../../common_modules_widgets/cached_network_image_widget.dart';
import '../../../general_services/app_config.service.dart';
import '../../../routing/app_router.dart';
import '../../home/view_models/home.viewmodel.dart';
import '../../personal_profile/viewmodels/personal_profile.viewmodel.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final ValueNotifier<bool?> isLogout = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
    isLogout.addListener(() {
      if (isLogout.value == false) {
        context.pop();
      } else if (isLogout.value == true) {
        context.pop();

        PersonalProfileViewModel().logout(context: context);
      }
    });
  }

  @override
  void dispose() {
    isLogout.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var jsonString;
    var gCache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
    }

    return Consumer<HomeViewModel>(
      builder: (context, value, child) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topCenter,
                  color: Color(AppColors.dark),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.25,
                    child: Image.asset(
                      "assets/images/png/more_back.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  top: MediaQuery.sizeOf(context).height * 0.25,
                  child: Container(
                    // height: MediaQuery.sizeOf(context).height * 0.66,
                    decoration: const ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, 0),
                        end: Alignment(1, 0),
                        colors: [Colors.white, Color(AppColors.bgC4)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.15,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView(
                              children: [
                                Text(AppStrings.more.tr().toUpperCase(),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(AppColors.primary))
                                ),
                                const SizedBox(height : 15),
                                DefaultListTile(
                                  title: AppStrings.ticketSystem.tr(),
                                  src: "assets/images/svg/mts.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RequestsScreen(),));
                                  },
                                ),
          
                                DefaultListTile(
                                  title: AppStrings.companyStructure.tr(),
                                  src:  "assets/images/svg/mcs.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewStack(),));
                                  },
                                ),DefaultListTile(
                                  title: AppStrings.notifications.tr(),
                                  src:  "assets/images/svg/notification.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(true),));
                                  },
                                ),
                                DefaultListTile(
                                  title: AppStrings.articlesNew.tr(),
                                  src:  "assets/images/svg/man.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlogScreen(),));
          
                                  },
                                ),
                                DefaultListTile(
                                  title: AppStrings.aboutComapny.tr(),
                                  src: "assets/images/svg/map.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen(),));
          
                                  },
                                ),
                                DefaultListTile(
                                  title: AppStrings.contactUs.tr(),
                                  src: "assets/images/svg/s8.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen(),));
          
                                  },
                                ), DefaultListTile(
                                  title: AppStrings.faqs.tr(),
                                  src: "assets/images/svg/faqqs.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen(),));
          
                                  },
                                ),
                                const SizedBox(height : 15),
                                Text(AppStrings.myAccount.tr().toUpperCase(),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(AppColors.primary))
                                ),
                                const SizedBox(height : 15),
                                DefaultListTile(
                                  title:AppStrings.customizeNotifications.tr(),
                                  src: "assets/images/svg/mcn.svg",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomizeNotificationScreen();
                                        });
                                  },
                                ),DefaultListTile(
                                  title:AppStrings.languageSettings.tr(),
                                  src: "assets/images/svg/mls.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LangSettingScreens(),));
          
                                  },
                                ),DefaultListTile(
                                  title:AppStrings.updatePassword.tr(),
                                  src: "assets/images/svg/mup.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordScreen(),));
          
                                  },
                                ),
                                DefaultListTile(
                                  title: AppStrings.personalInfo.tr(),
                                  src: "assets/images/svg/mpi.svg",
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalProfileScreen(),));
                                  },
                                ),
                                DefaultListTile(
                                  title: AppStrings.logout.tr(),
                                  src: "assets/images/svg/mlo.svg",
                                  onTap: ()async{
                                    final appConfigService =
                                    Provider.of<AppConfigService>(context, listen: false);
                                    appConfigService.logout().then((v){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen(),));
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.15,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(124),
                        child: GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalProfileScreen(),));
          
                          },
                          child: CachedNetworkImage(
                              imageUrl:(gCache != null)? gCache['photo'] : "https://th.bing.com/th/id/OIP.NV-x3Km5_nHK2ZcRuqV5OgHaHa?rs=1&pid=ImgDetMain",
                              fit: BoxFit.cover,
                              height: 124,
                              width: 124,
                              placeholder: (context, url) => const ShimmerAnimatedLoading(
                                width: 63.0,
                                height: 63,
                                circularRaduis: 63,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported_outlined,
                              )),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        width: MediaQuery.sizeOf(context).width * 1,
                        child: Text(
                          (gCache != null ?gCache['name'] ?? '' : "").toUpperCase(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            // fontSize: 16,
          
                            // fontWeight: FontWeight.w700,
                            // height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        gCache != null ?gCache['job_title'] ?? "" : "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: Color(0xff4F4F4F),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          // height: 0,
                        ),
          
                        //      TextStyle(
                        // color: Color(0xFF4F4F4F),
                        // fontSize: 10,
                        //   fontFamily: 'Bai Jamjuree',
                        //   fontWeight: FontWeight.w500,
                        //   height: 0,
                        // ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class DefaultListTile extends StatelessWidget {
  final String src;
  final String title;
  final VoidCallback? onTap;

  const DefaultListTile({
    super.key,
    required this.src,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 8),
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: SvgPicture.asset(
          src,
          color: const Color(AppColors.primary),
          fit: BoxFit.contain,
        ),
        title: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        // trailing: Icon(
        //   Icons.arrow_forward_ios,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        onTap: onTap ?? () {}, // Add your onTap functionality here
      ),
    );
  }
}
