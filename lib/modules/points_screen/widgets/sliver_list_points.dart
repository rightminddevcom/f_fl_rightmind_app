import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/points_screen/widgets/condition_section.dart';
import 'package:cpanal/modules/points_screen/widgets/copoun_section.dart';
import 'package:cpanal/modules/points_screen/widgets/history_item.dart';
import 'package:cpanal/utils/componentes/general_components/general_components.dart';

class SliverListPoints extends StatefulWidget {
  const SliverListPoints({super.key});

  @override
  State<SliverListPoints> createState() => _SliverListPointsState();
}

class _SliverListPointsState extends State<SliverListPoints> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: !kIsWeb?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22,),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: defaultTapBarItem(items:
                    [AppStrings.recommend.tr(), AppStrings.conditions.tr(), AppStrings.history.tr()],
                    selectIndex: selectIndex,
                      onTapItem: (index){
                      setState(() {
                        selectIndex = index;
                      });
                      }
                    ),
                  ),
                  const SizedBox(height: 29,),
                  selectIndex == 0 ?
                  CopounSection() :
                  selectIndex == 1?ConditionSection()
                      :HistoryItem()
                ],
              ):Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: !kIsWeb? double.infinity : 300,
                      alignment: Alignment.center,
                      child: defaultTapBarItem(items:
                      [AppStrings.recommend.tr(), AppStrings.conditions.tr(), AppStrings.history.tr()],
                      selectIndex: selectIndex,
                        onTapItem: (index){
                        setState(() {
                          selectIndex = index;
                        });
                        }
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Container(
                      width: 800,
                      child: selectIndex == 0 ?
                      CopounSection() :
                      selectIndex == 1?ConditionSection()
                          :HistoryItem(),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        childCount: 1,
      ),
    );
  }
}
