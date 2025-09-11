import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:cpanal/modules/points_screen/widgets/sliver_app_bar_points.dart';
import 'package:cpanal/modules/points_screen/widgets/sliver_list_points.dart';

class PointsScreen extends StatefulWidget {

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverAppBarPoints(arrow: false,),
              SliverListPoints(),
            ],
          ),
        );
      },
    );
  }
}
