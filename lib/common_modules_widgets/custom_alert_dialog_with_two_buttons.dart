import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cpanal/constants/app_colors.dart';

import 'button_widget.dart';

Future<void> customAlertDialogWithTwoButtons(
  BuildContext context, {
  String? icon,
  required String title,
  required String content,
  required String actionLeftText,
  required VoidCallback onLeftActionPressed,
  required String actionRightText,
  required  onRightActionPressed,
  Color? actionRightColor,
  Color? actionLeftColor,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Theme.of(context).dialogTheme.barrierColor,
    builder: (BuildContext context) {
      return AlertDialog(
        iconPadding:
            const EdgeInsets.only(right: 24, left: 24, bottom: 32, top: 32),
        titlePadding:
            const EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 24),
        contentPadding: const EdgeInsets.only(bottom: 32, right: 24, left: 24),
        actionsPadding: const EdgeInsets.only(bottom: 18, right: 8, left: 8),
        contentTextStyle: Theme.of(context).dialogTheme.contentTextStyle,
        icon: icon != null ? SvgPicture.asset(icon) : null,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(AppColors.dark),
            fontWeight: FontWeight.w700,
            fontSize: 18
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                //   flex: 2,
                child: ButtonWidget(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  title: actionLeftText,
                  backgroundColor: Color(AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                //   flex: 2,
                child: ButtonWidget(
                  onPressed: ()async{
                   await onRightActionPressed();
                   Navigator.pop(context);
                  },
                  title: actionRightText,
                  backgroundColor: Color(AppColors.primary),
                ),
              ),
            ],
          ),
          // SizedBox(height: 12),
          // Expanded(
          //   child: ButtonWidget(
          //     onPressed: () {},
          //     title: 'CLOSE',
          //   ),
          // ),
        ],
      );
    },
  );
}
