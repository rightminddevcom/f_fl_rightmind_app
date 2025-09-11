import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoadFromFilesBottomSheet extends StatelessWidget {
  const LoadFromFilesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              AppStrings.loadFromFile.tr().toUpperCase(),
              style: const TextStyle(
                color: Color(AppColors.primary),
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              AppStrings.createEmailMessage.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          const SizedBox(height: 25),
          _buildFilesField(),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  width: null,
                  backgroundColor: const Color(0xffD10A11),
                  title: AppStrings.cancel.tr().toUpperCase(),
                  onPressed: () async {
                  },
                  isPrimaryBackground: false,
                ),
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: CustomElevatedButton(
                  width: null,
                  backgroundColor: const Color(AppColors.dark),
                  title: AppStrings.addEmail.tr().toUpperCase(),
                  onPressed: () async {
                  },
                  isPrimaryBackground: false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilesField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: AppStrings.emailsFile.tr().toUpperCase(),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2C154D),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Text(
              AppStrings.uploadFile.tr().toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
