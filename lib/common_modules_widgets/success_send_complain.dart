import 'package:cpanal/modules/home/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';


class SuccessfulSendCpanalBottomsheet extends StatelessWidget {
String? message;
SuccessfulSendCpanalBottomsheet(this.message);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          SvgPicture.asset("assets/images/svg/success.svg"),
          SizedBox(height: 15,),
          Text(AppStrings.successful.tr().toUpperCase(), style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.w700, color: Color(AppColors.primary))),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff1B1B1B),
                  fontWeight: FontWeight.w500,
                  fontSize: 14
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(), ));
                      },
                      title: AppStrings.goToHome.tr().toUpperCase(),
                      width: null,
                      backgroundColor: const Color(AppColors.dark),
                      isPrimaryBackground: true,
                      isFuture: false),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: CustomElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color(AppColors.dark),
                      title: AppStrings.goToPage.tr().toUpperCase(),
                      width: null,
                      isPrimaryBackground: true,
                      isFuture: false),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
