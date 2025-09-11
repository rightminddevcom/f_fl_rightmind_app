import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/home_model/home_model.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/points_screen/widgets/drop_down_and_button_bottom_sheet.dart';
import 'package:cpanal/modules/points_screen/widgets/redeem_now_button.dart';


class SliverAppBarPoints extends StatefulWidget {
  bool arrow = true;
  SliverAppBarPoints({required this.arrow});

  @override
  State<SliverAppBarPoints> createState() => _SliverAppBarPointsState();
}

class _SliverAppBarPointsState extends State<SliverAppBarPoints> {
  late HomeViewModel homeViewModel;
  @override
  void initState() {
    super.initState();
    homeViewModel = HomeViewModel();
    homeViewModel.initializeHomeScreen(context);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, value, child) {
          var balancePoints = 0;
          var availablePoints = 0;
          final json2String = CacheHelper.getString("US2");
          var us2Cache;
          if (json2String != null && json2String != "") {
            us2Cache = json.decode(json2String) as Map<String, dynamic>;// Convert String back to JSON
            print("Available IS --> ${us2Cache['points']['available']}");
            print("Total IS --> ${us2Cache['points']['total']}");
          }
          balancePoints = us2Cache['points']['total'];
          availablePoints = us2Cache['points']['available'];
          return SliverAppBar(
            elevation: 0,
            pinned: true,
            title:  Text(
              AppStrings.myPoints.tr().toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: 275,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/png/points_back.png", height: 400, fit: BoxFit.cover,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.myPointsEarned.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8,),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.question_mark_sharp,
                                color: Colors.black,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16,),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: availablePoints.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "\t ${AppStrings.points.tr().toUpperCase()}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ])),
                        Text(
                          "${AppStrings.from.tr()} ${balancePoints.toString()} ${AppStrings.myPoints.tr().toUpperCase()}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              builder: (context) {
                                return StatefulBuilder(builder: (context, setState) {
                                  return  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5,),
                                          Container(
                                            height: 5,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                                          ),
                                          const SizedBox(height: 15,),
                                          Text(AppStrings.redeemNow.tr().toUpperCase(),style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(AppColors.primary),
                                          )),
                                          const SizedBox(height: 25,),
                                          const DropDownAndButtonBottomSheet()
                                        ],
                                      ),
                                    ),
                                  );
                                },);
                              },
                            );
                          },
                          child: const RedeemNowButton(),
                        ),
                        const Spacer(flex: 1,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
