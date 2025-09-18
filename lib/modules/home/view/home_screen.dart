import 'dart:convert';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/home/widget/appbar_profile_container.dart';
import 'package:cpanal/modules/home/widget/home_grid_view.dart';
import 'package:cpanal/modules/personal_profile/views/personal_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../general_services/general_listener.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final generalListener = GeneralListener();
  @override
  void initState() {
    var jsonString;
    var gCache;
    jsonString = CacheHelper.getString("USG");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
    }
    final popups = gCache?['popups'];
    if (popups != null && popups.isNotEmpty) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (context.mounted) {
      //     generalListener.startAll(context, "home", popups);
      //   }
      // });
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final json2String = CacheHelper.getString("US2");
    var us2Cache;
    if (json2String != null && json2String != "") {
      us2Cache = json.decode(json2String) as Map<String, dynamic>;// Convert String back to JSON
    }
    final json1String = CacheHelper.getString("US1");
    var us1Cache;
    if (json1String != null && json1String != "") {
      us1Cache = json.decode(json1String) as Map<String, dynamic>;// Convert String back to JSON

      UserSettingConst.userSettings = UserSettingsModel.fromJson(us1Cache);
    }
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
        },
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: height * 0.2,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      var top = constraints.biggest.height;
                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.only(
                                right: AppSizes.s24,
                                left: AppSizes.s24,
                              ),
                              decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/images/home_images/appbar_images/home_top_background.png",
                                    ),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalProfileScreen(),));
                                         },
                                      child: AppbarProfileContainer(
                                          imageUrl:(us1Cache != null && us1Cache['photo'] != null)?
                                          "${us1Cache['photo']}" : '',
                                          userName:(us1Cache != null && us1Cache['name'] != null)?
                                          "${us1Cache['name']}" : "",
                                          userRole:(us1Cache != null && us1Cache['role'] != null)?(us1Cache['role'].isNotEmpty)?
                                          "${us1Cache['role'][0]}".tr() : "" : "",
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const HomeGridView(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
