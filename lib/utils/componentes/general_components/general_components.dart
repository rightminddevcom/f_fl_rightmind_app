import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/general_services/localization.service.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
import 'package:provider/provider.dart';

  Widget defaultTapBarItem(
      {required List<String>? items,
      final Function? onTapItem,
        bool? sectInt = false,
        int? selectIndex = 0,
        String? selectName,
        bool enableScroll = false,
      double? tapBarItemsWidth}) {

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        double itemWidth =
            (tapBarItemsWidth ?? MediaQuery.sizeOf(context).width * 0.95) /
                items!.length;
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7.5),
            height: 45.0,
            alignment: Alignment.center,
            width: tapBarItemsWidth ?? MediaQuery.sizeOf(context).width * 0.95,
            decoration: BoxDecoration(
                color: Color(AppColors.dark),
                borderRadius: BorderRadius.circular(25)),
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              scrollDirection: Axis.horizontal,
              physics: enableScroll == false? const NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectIndex = index;
                      selectName = items[index];
                      if (onTapItem != null) {
                        onTapItem!(index);
                      }
                    });
                  },
                  child: Container(
                    height: 32,
                    width: itemWidth - 8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: (selectIndex == index || selectName == items[index])
                          ? const Color(AppColors.primary)
                          : Colors.transparent,
                    ),
                    child: Text(
                      items![index].toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.w900,
                          ),
                    ),
                  )),
              itemCount: items!.length,
            ));
      },
    );
  }
Widget defaultBottomNavigationBar(
    {required List<String>? items,
      final Function? onTapItem,
      double? tapBarItemsWidth,
      int? selectIndex = 0,
    }) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      double containerWidth = tapBarItemsWidth ?? MediaQuery.sizeOf(context).width;
      double itemWidth =(items!.length > 4)? containerWidth / items!.length * 0.9 :containerWidth / items!.length * 0.95;
      double itemHeight = itemWidth * 1;
      double itemRadius = (items.length > 4)?itemWidth / 2 : itemHeight;
      print("SELECTED => ${selectIndex}");
      return Center(
        child: Container(
          alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
            height:(items.length > 4)? itemHeight + 15 : itemHeight,
            width: containerWidth,
            decoration: BoxDecoration(
                color: const Color(0xff15223D),
                borderRadius: BorderRadius.circular(50)),
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectIndex = index;
                      if (onTapItem != null) {
                        onTapItem!(index);
                      }
                    });
                  },
                  child: Container(
                      width: (items.length > 4)? itemWidth:itemWidth - 12,
                      height: itemHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: (selectIndex == index)
                              ? const Color(0xffFFFFFF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(itemRadius)),
                      child: SvgPicture.asset(
                        items[index],
                        color: (selectIndex == index)
                            ? const Color(0xFFE93F81)
                            : const Color(0xffFFFFFF),
                      ))),
              itemCount: items.length,
            )),
      );
    },
  );
}
// Widget defaultBottomNavigationBar(
//     {required List<String>? items,
//       void Function(int? index)? onTap,
//     double? tapBarItemsWidth,
//     int? selectIndex,
//       BuildContext? context
//     }) {
//   double containerWidth = tapBarItemsWidth ?? MediaQuery.sizeOf(context!).width;
//   double itemWidth = containerWidth / items!.length * 0.9;
//   double itemHeight = itemWidth * 1;
//   double itemRadius = itemWidth / 2;
//   int? selectIndex;
//   return StatefulBuilder(
//       builder: (context),
//   )
// }

Widget defaultProductContainer(
    {Color? containerColor,
    Color? bookmarkColor,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    required String? title,
    required String? price,
     String? unit,
    String? discountPrice,
    required BuildContext? context,
    required bool? showBookMark,
    bool showUnit = true,
      max,
    required bool? showDiscountPrice,
    double? containerWidth,
    final void Function()? onPressedBookMark,
    required String? imageUrl}) {
  return Container(
    width: containerWidth ?? MediaQuery.sizeOf(context!).width * 1,
    padding: EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: containerColor ?? const Color(0xffFFFFFF),
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      boxShadow: boxShadow,
    ),
    child: Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            height: 104.0,
            width: 100,
            placeholder: (context, url) => const ShimmerAnimatedLoading(
                  width: 100.0,
                  height: 104.0,
                  circularRaduis: 10,
                ),
            errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported_outlined,
                )),
      ),
      SizedBox(
        width: 16,
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context!).width * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: const TextStyle(
                    color: Color(0xFFE93F81),
                    
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
              Row(
                children: [
                  Text(
                    price!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xff1B1B1B),
                        
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                  SizedBox(
                    width: 17,
                  ),
                  if (showDiscountPrice == true)
                    Text(
                      discountPrice!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey,
                        decorationThickness: 2,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showUnit == true)
                    Text(
                      unit!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xff15223D),
                          
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  const Spacer(),
                  if (showBookMark == true)
                    GestureDetector(
                        onTap: onPressedBookMark,
                        child: Icon(
                          Icons.bookmark,
                          color: bookmarkColor ?? const Color(0xFFE93F81),
                        ))
                ],
              ),
            ],
          ),
        ),
      )
    ]),
  );
}

Widget defaultProfileContainer({
  required String? imageUrl,
  required String? userName,
  required String? userRole,
  required BuildContext? context,
}) {
  String formatName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length < 2) {
      return fullName; // Return the full name if no last name is provided.
    }
    String firstName = nameParts[0];
    String lastInitial = nameParts[1][0].toUpperCase();
    return (CacheHelper.getString("lang") == "ar") ?'.$firstName $lastInitial' :'$firstName $lastInitial.';
  }
  return Container(
    color: Colors.transparent,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 63,
          height: 63,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE93F81), Color(0xff15223D)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(63),
              child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
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
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.sizeOf(context!).width * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      ),
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
                      ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

