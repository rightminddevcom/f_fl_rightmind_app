import 'package:cpanal/modules/requests_screen/new_request_screen.dart';
import 'package:cpanal/modules/requests_screen/request_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/request_controller/request_controller.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cpanal/general_services/localization.service.dart';

class RequestsScreen extends StatefulWidget {
  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final ScrollController _scrollController = ScrollController();
  late RequestController requestController;

  @override
  void initState() {
    super.initState();
    requestController = RequestController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController = Provider.of<RequestController>(context, listen: false);
      requestController.getRequest(context, page: 1);
    });
    _scrollController.addListener(() {
      print("Current scroll position: ${_scrollController.position.pixels}");
      print("Max scroll extent: ${_scrollController.position.maxScrollExtent}");

      if ((_scrollController.position.maxScrollExtent - _scrollController.position.pixels).abs() < 10 &&
          !requestController.isGetRequestLoading &&
          requestController.hasMoreRequests) {
        print("BOTTOM BOTTOM");
        requestController.getRequest(context, page: requestController.currentPage);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestController>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              AppStrings.requests.tr().toUpperCase(),
              style: TextStyle(color: Color(AppColors.dark), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Color(0xffFFFFFF),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewRequestScreen("no", "no", "no"),));
            },
            backgroundColor: Color(0xFFE93F81),
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: (value.isGetRequestLoading == true && value.currentPage == 1)
              ? ListView.builder(
            padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
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
              ), ): SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // List for "hold" status requests
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
                              id: request['id'],
                              title: request['title'],
                              containerColor: Color(AppColors.primary),
                              date: DateFormat("dd/MM/yyyy", LocalizationService.isArabic(context: context) ? "ar" : "en")
                                  .format(DateTime.parse(request['created_at'].toString()))
                                  .toString(),
                              status: request['pstatus']['key'].toString().tr(),
                              statusColor: Color(0xffFFFFFF)
                          );
                        }
                        return SizedBox.shrink();  // Return nothing for non-hold items in this section
                      },
                    ),

                    // "Other Requests" Text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        AppStrings.otherRequests.tr().toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(AppColors.dark),
                        ),
                      ),
                    ),

                    // List for non-"hold" status requests
                    ListView.builder(
                      itemCount: value.requests.length,
                      reverse: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        var request = value.requests[index];
                        var statusKey = request['pstatus']['key'];

                        if (statusKey != "hold") {
                          return defaultRequestContainer(
                              context,
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
                        return SizedBox.shrink();  // Return nothing for hold items in this section
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } ,
    );
  }

  Widget defaultRequestContainer(BuildContext parentContext,{title, containerColor, statusColor, status, date, titleColor, dateColor , id})=>
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetailsScreen(id: id),));
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
