import 'dart:math';

import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/cpanel/email_account/create_multi_accounts_screen.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEmailBottomSheet extends StatefulWidget {
  var emails;
  var domainId;
  var email;
  bool? multi = false;
  EditEmailBottomSheet({this.emails,this.domainId,this.email,this.multi});

  @override
  State<EditEmailBottomSheet> createState() => _EditEmailBottomSheetState();
}

class _EditEmailBottomSheetState extends State<EditEmailBottomSheet> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController qoutaController = TextEditingController();
  bool isSusbend = true;
  String generateRandomPassword({int length = 12}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{};:,.<>?/|';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailAccountProvider>(
      builder: (context, value, child) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.6,
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
                  AppStrings.editEmail.tr().toUpperCase(),
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
              if(widget.multi == false)SizedBox(
                width: double.infinity,child: Center(child:
              Text(
               widget.email,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(AppColors.dark),
                ),
              ),
                ),
              ),
              if(widget.multi == true)GridView.count(
                crossAxisCount: 2, // عمودين
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                reverse: false,
                padding: EdgeInsets.zero,
                childAspectRatio: 4.5, // عرض العنصر نسبةً لطوله
                children: (widget.emails['accounts'] as List<dynamic>).map((email) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Text(
                      email,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(AppColors.dark),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              _buildPasswordField(passwordController),
              const SizedBox(height: 15),
              _buildInputWithSuffix(AppStrings.storage.tr().toUpperCase(), AppStrings.gp.tr().toUpperCase(), 50.0, qoutaController, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.unBlockAccount.tr().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1B1B1B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSusbend = !isSusbend;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 60,
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSusbend ? Color(0xFFE91E63) : Colors.grey[400],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: AnimatedAlign(
                          duration: Duration(milliseconds: 200),
                          alignment: isSusbend ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.blockAccount.tr().toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1B1B1B),
                      ),
                    ),
                  ],
                ),
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
                  const SizedBox(width: 20,),
                  Expanded(
                    child:value.isLoading == false? CustomElevatedButton(
                      width: null,
                      backgroundColor: const Color(AppColors.dark),
                      title: AppStrings.update.tr().toUpperCase(),
                      onPressed: () async {
                        if(widget.multi == false) {
                          value.updateEmail(context,
                            account: widget.email,
                            domainId: widget.domainId,
                            password: passwordController.text,
                            quota: qoutaController.text,
                            suspend: isSusbend
                          );
                        }else{
                          value.updateEmailMulti(context,
                            accounts: widget.emails,
                            domainId: widget.domainId,
                            password: passwordController.text,
                            quota: qoutaController.text,
                            suspend: isSusbend
                          );
                        }
                      },
                      isPrimaryBackground: false,
                    ) : Container(
                      width: 50, height: 50,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: AppStrings.password.tr().toUpperCase(),
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
            onPressed: () {
              setState(() {
                controller.text = generateRandomPassword();
              });
            },
            child: Text(
              AppStrings.generate.tr().toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInputWithSuffix(String label, String suffixText, width, controller, {keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType?? TextInputType.text,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: label,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xffDFDFDF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              suffixText,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(AppColors.dark)),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
