import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:shimmer/shimmer.dart';

class ConditionSection extends StatefulWidget {
  const ConditionSection({super.key});

  @override
  State<ConditionSection> createState() => _ConditionSectionState();
}

class _ConditionSectionState extends State<ConditionSection> {
  late PointsProvider pointsProvider;

  @override
  void initState() {
    super.initState();
    pointsProvider = PointsProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pointsProvider = Provider.of<PointsProvider>(context, listen: false);
      pointsProvider.getCondition(context);
    });
  }
  @override
  Widget build(BuildContext context) {
     return Consumer<PointsProvider>(
       builder: (context, value, child) {
         return Padding(
           padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 16),
           child: (pointsProvider.pointsTermsAndConditionsModel != null)?HtmlWidget(
             '''
                  ${pointsProvider.pointsTermsAndConditionsModel!.page!.content}
             ''',
             renderMode: RenderMode.column,
             textStyle: const TextStyle(fontSize: 14, color: Color(0xff464646), fontWeight: FontWeight.w400),
           ): Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               shimmerContainer(width: double.infinity, height: 12),
               SizedBox(height: 4),
               shimmerContainer(width: double.infinity, height: 12),
               SizedBox(height: 4),
               shimmerContainer(width: double.infinity, height: 12),
               SizedBox(height: 4),
               shimmerContainer(width: 200, height: 12), // Shorter line
               SizedBox(height: 8),
               // Bullet points shimmer
               shimmerContainer(width: 10, height: 10, shape: BoxShape.circle),
               SizedBox(height: 4),
               shimmerContainer(width: double.infinity, height: 12),
               SizedBox(height: 4),
               shimmerContainer(width: 250, height: 12),
             ],
           ),
         );
       },
     );
  }
  Widget shimmerContainer({
    required double width,
    required double height,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(4) : null,
        ),
      ),
    );
  }
}
