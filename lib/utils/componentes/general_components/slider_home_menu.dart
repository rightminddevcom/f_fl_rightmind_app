import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cpanal/constants/app_colors.dart';

class SliderHomeMenu extends StatelessWidget {
  var title;
  var description;
  var onTap;
  var src;
  SliderHomeMenu({this.description, this.title, this.onTap, this.src});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding:EdgeInsets.symmetric(vertical: 25),
          width: 150,
          height: 170,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: const Color(AppColors.textC5),
                borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsetsDirectional.only(
              bottom: 30,
              start: 2,
              end: 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff15223D)),
                ),
                SizedBox(height: 4,),
                Text(
                  description.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff231F20)),
                ),
              ],
            ),
          ),
        ),
        Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xFFE93F81),
                borderRadius: BorderRadius.circular(15)),
            child: SvgPicture.asset(src ??"assets/images/svg/ref_link.svg")
        ),
      ],
    );
  }
}
