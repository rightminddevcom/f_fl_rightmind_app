import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';


class RedeemNowButton extends StatelessWidget {
  const RedeemNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 150,
      decoration: BoxDecoration(
        color: Color(AppColors.primary),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/png/icon.png"),
          SizedBox(width: 4),
          Text(AppStrings.redeemNow.tr().toUpperCase(),style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),)
        ],
      ),
    );
  }
}
