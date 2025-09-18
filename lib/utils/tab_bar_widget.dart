import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_colors.dart';

Widget defaultTapBarItem({
  required List<String>? items,
  final Function? onTapItem,
  bool? sectInt = false,
  int? selectIndex = 0,
  String? selectName,
  bool enableScroll = false,
  double? tapBarItemsWidth,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      bool isWeb = MediaQuery.of(context).size.width > 600; // 判定 Web أو Mobile

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7.5),
        alignment: Alignment.center,
        height: !isWeb ? 40 : null,

        width: isWeb
            ? 200 // العرض ثابت للقائمة الجانبية
            : (tapBarItemsWidth ?? MediaQuery.sizeOf(context).width * 0.95),
        decoration: BoxDecoration(
          color: const Color(AppColors.dark),
          borderRadius: BorderRadius.circular(25),
        ),
        child: SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            reverse: false,
            scrollDirection: isWeb ? Axis.vertical : Axis.horizontal,
            physics: enableScroll == false
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: items!.length,
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
                margin: EdgeInsets.symmetric(
                  horizontal: isWeb ? 0 : 4,
                  vertical: isWeb ? 6 : 0,
                ),
                height: isWeb ? 40 : 32,
                width: isWeb ? double.infinity : 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (selectIndex == index || selectName == items[index])
                      ? const Color(AppColors.primary)
                      : Colors.transparent,
                ),
                child: Text(
                  items[index].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
