import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/controller/request_controller/request_controller.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/general_services/layout.service.dart';
import 'package:cpanal/general_services/localization.service.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/utils/placeholder_no_existing_screen/no_existing_placeholder_screen.dart';
import 'package:shimmer/shimmer.dart';

class ComplainScreen extends StatefulWidget {
  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final ScrollController _scrollController = ScrollController();
  late RequestController requestController;

  @override
  void initState() {
    super.initState();
    requestController = RequestController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController = Provider.of<RequestController>(context, listen: false);
      // requestController.getRequestMine(context, page: 1,);
      requestController.getRequest(context, page: 1,);
    });
    _scrollController.addListener(() {
      print("Current scroll position: ${_scrollController.position.pixels}");
      print("Max scroll extent: ${_scrollController.position.maxScrollExtent}");

      if ((_scrollController.position.maxScrollExtent - _scrollController.position.pixels).abs() < 10 &&
          !requestController.isGetRequestLoading && requestController.empty == false) {
        print("BOTTOM BOTTOM");
        requestController.getRequest(context, page: requestController.currentPage);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestController>(
      builder: (context, value, child) {
        var jsonString;
        var gCache;
        jsonString = CacheHelper.getString("US1");
        if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
          gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
          UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              AppStrings.ticketSystem.tr().toUpperCase(),
              style: const TextStyle(color: Color(AppColors.dark), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Color(0xffFFFFFF),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
             await context.pushNamed(AppRoutes.newComplainScreen.name,
                  pathParameters: {'lang': context.locale.languageCode,});
             await requestController.getRequest(context, page: requestController.currentPage);
            },
            backgroundColor: const Color(AppColors.primary),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: (value.isGetRequestLoading == true && value.currentPage == 1)
              ? ListView.builder(
            padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse: false,
              itemCount: 7,
              itemBuilder:(context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.s12),
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSizes.s15, vertical: AppSizes.s12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.s15),
                  ),
                  height: 100,
                ),
              ), ):
               SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: (value.requests.isNotEmpty)? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator.adaptive(
                  onRefresh: ()async{
                    await requestController.getRequest(context, page: requestController.currentPage);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      ListView.builder(
                        itemCount: value.requests.length,
                        reverse: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var request = value.requests[index];
                          var statusKey = request['pstatus']['key'];
                          if (statusKey == "hold") {
                            return defaultRequestContainer(
                                context,
                                "mine",
                                id: request['id'],
                                title: request['title'],
                                containerColor: Color(AppColors.primary),
                                date: DateFormat("dd/MM/yyyy", LocalizationService.isArabic(context: context) ? "ar" : "en")
                                    .format(DateTime.parse(request['created_at'].toString()))
                                    .toString(),
                                status: request['pstatus']['key'].toString().tr(),
                                statusColor: Color(0xffFFFFFF)
                            );
                          }else{
                           return defaultRequestContainer(
                                context,
                               "mine",
                                id: request['id'],
                                containerColor: Color(0xffFFFFFF),
                                title: request['title'],
                                date: DateFormat("dd/MM/yyyy", LocalizationService.isArabic(context: context) ? "ar" : "en")
                                    .format(DateTime.parse(request['created_at'].toString()))
                                    .toString(),
                                status: request['pstatus']['key'].toString().tr(),
                                titleColor: Color(AppColors.primary),
                                dateColor: Color(0xff5E5E5E),
                                statusColor: statusKey == "closed"
                                    ? Color(AppColors.red)
                                    : Color(AppColors.primary)
                            );
                          }
                          return SizedBox.shrink();  // Return nothing for non-hold items in this section
                        },
                      ),
                      if(value.isGetRequestLoading == true && value.currentPage != 1)   const SizedBox(height: 15,),
                      if(value.isGetRequestLoading == true && value.currentPage != 1)   const Center( child: CircularProgressIndicator(),),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ) : Center(
                child: NoExistingPlaceholderScreen(
                    height: LayoutService.getHeight(context) * 0.6,
                    title: AppStrings.thereIsNoComplains.tr()),
              ),
            ),
          ),
        );
      } ,
    );
  }

  Widget defaultRequestContainer(BuildContext parentContext,type,{title, containerColor, statusColor, status, date, titleColor, dateColor , id})=>
      GestureDetector(
        onTap: (){
         parentContext.pushNamed(AppRoutes.complainDetails.name,
              pathParameters: {'lang': parentContext.locale.languageCode,
              'id' : "${id}",
              });

        },
        child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 16),

            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: AppSizes.s8,
                  spreadRadius: 1,
                )
              ],
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title".toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor??Color(0xffFFFFFF),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.circle, color: statusColor, size: 10),
              SizedBox(width: 6),
              Text(
                "$status".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: titleColor??Color(0xffFFFFFF),
                ),
              ),
              SizedBox(width: 30,),
              Text(
                "$date".toUpperCase(),
                style: TextStyle(color: dateColor??Color(AppColors.grey50), fontWeight: FontWeight.w500, fontSize: 12),
              ),
            ],
          ),
        ],
            ),
          ),
      );
}
