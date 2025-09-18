import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_constants.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/cpanel/email_account/create_multi_accounts_screen.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAccountBottomSheet extends StatefulWidget {
  final Function(String?)? onSearch;
  String? title;
  SearchAccountBottomSheet({this.onSearch, super.key, this.title});
  @override
  State<SearchAccountBottomSheet> createState() =>
      _SearchAccountBottomSheetState();
}

class _SearchAccountBottomSheetState extends State<SearchAccountBottomSheet> {
  TextEditingController searchController = TextEditingController();

  var query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.45,
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
                widget.title ?? AppStrings.emailSearch.tr().toUpperCase(),
                style: const TextStyle(
                  color: Color(AppColors.primary),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                AppStrings.createEmailMessage.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: AppStrings.search.tr().toUpperCase(),
              ),
              onChanged: (String? value) {
                setState(() {
                  query = value;
                });
              },
            ),
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
                      Navigator.pop(context);
                    },
                    isPrimaryBackground: false,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child:  CustomElevatedButton(
                    width: null,
                    backgroundColor: const Color(AppColors.dark),
                    title: AppStrings.search.tr().toUpperCase(),
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.onSearch?.call(query);
                    },
                    isPrimaryBackground: false,
                  )

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
