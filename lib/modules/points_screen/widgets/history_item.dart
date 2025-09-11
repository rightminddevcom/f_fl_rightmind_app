import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:cpanal/general_services/localization.service.dart';
import 'package:shimmer/shimmer.dart';

class HistoryItem extends StatefulWidget {
  HistoryItem({super.key});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  late PointsProvider pointsProvider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    pointsProvider = PointsProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pointsProvider = Provider.of<PointsProvider>(context, listen: false);
      pointsProvider.getHistory(context, page: 1);
    });
    _scrollController.addListener(() {
      print("Current scroll position: ${_scrollController.position.pixels}");
      print("Max scroll extent: ${_scrollController.position.maxScrollExtent}");

      if ((_scrollController.position.maxScrollExtent - _scrollController.position.pixels).abs() < 10 &&
          !pointsProvider.isHistoryLoading &&
          pointsProvider.hasMoreHistory) {
        print("BOTTOM BOTTOM");
        pointsProvider.getHistory(context, page: pointsProvider.currentPageHistory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: (context, value, child) {
        print("value.currentPageHistory --> ${value.currentPageHistory}");
        return (value.isHistoryLoading && value.currentPageHistory == 1)
            ?ListView.builder(
          shrinkWrap: true,
          reverse: false,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 6,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: AppSizes.s12),
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSizes.s15, vertical: AppSizes.s12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.s15),
              ),
              height: 100,
            ),
          ),
        ): Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      child: ListView.builder(
                        controller: _scrollController,
                          padding: EdgeInsets.zero,
                          physics:  ClampingScrollPhysics(),
                          reverse: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var e = value.history[index];
                            String apiDate = e['created_at'];
                            DateTime parsedDate = DateTime.parse(apiDate);
                            String formattedDate = DateFormat(
                                    'MMM d, yyyy',
                                    LocalizationService.isArabic(context: context)
                                        ? "ar"
                                        : "en")
                                .format(parsedDate);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                height: 90,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 0,
                                        offset: Offset(0, 1),
                                        blurRadius: 10)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/png/gift.png'),
                                        height: 40,
                                        width: 40,
                                        color: Color(AppColors.primary),
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              e['title'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff464646),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              e['operation'] == "deposit"
                                                  ? "+${e['points']} ${AppStrings.points.tr()}"
                                                  : "-${e['points']} ${AppStrings.points.tr()}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: e['operation'] == "deposit"
                                                    ? Colors.green
                                                    : const Color(0xffFF0004),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: value.history.length),
                    ),
                    if(value.isHistoryLoading && value.currentPageHistory != 1) SizedBox(height: 15,),
                    if(value.isHistoryLoading && value.currentPageHistory != 1) Center(child: CircularProgressIndicator(),),
                  ],
                ),
              );
      },
    );
  }
}
