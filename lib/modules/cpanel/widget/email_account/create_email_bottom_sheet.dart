import 'dart:math';

import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEmailBottomSheet extends StatefulWidget {
  var dominId;
  var dominName;
  var multiEmails;
  bool? multi = false;
  CreateEmailBottomSheet({this.dominId,this.dominName,this.multi,this.multiEmails});

  @override
  State<CreateEmailBottomSheet> createState() => _CreateEmailBottomSheetState();
}

class _CreateEmailBottomSheetState extends State<CreateEmailBottomSheet> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController qoutaController = TextEditingController();

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
          return DraggableScrollableSheet(
            initialChildSize: 0.65,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (_, controller) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: controller,
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
                        AppStrings.createEmails.tr().toUpperCase(),
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
                    _buildInputWithSuffix(AppStrings.email.tr().toUpperCase(), "${widget.dominName}", 120.0, controller: emailController),
                    const SizedBox(height: 15),
                    _buildPasswordField(passwordController),
                    const SizedBox(height: 15),
                    _buildInputWithSuffix(AppStrings.storage.tr().toUpperCase(), AppStrings.mp.tr().toUpperCase(), 50.0,keyboardType: TextInputType.number,
                     controller: qoutaController),
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
                          child: CustomElevatedButton(
                            width: null,
                            backgroundColor: const Color(AppColors.dark),
                            title: AppStrings.addEmail.tr().toUpperCase(),
                            onPressed: () async {
                              if(widget.multi == false){
                                value.addEmails(context,
                                    domainId: widget.dominId.toString(),
                                    actionType: "email_account",
                                    domain: widget.dominName.toString(),
                                    quota: qoutaController.text,
                                    password: passwordController.text,
                                    username: emailController.text
                                );
                              }else{
                                widget.multiEmails.add({
                                  "username" : emailController.text,
                                  "password" : passwordController.text,
                                  "quota" : qoutaController.text
                                });
                                Navigator.pop(context);
                              }
                            },
                            isPrimaryBackground: false,
                          )
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
    );
  }

  Widget _buildInputWithSuffix(String label, String suffixText, width, {controller, keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
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

  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        hintText: AppStrings.password.tr().toUpperCase(),
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
                passwordController.text = generateRandomPassword();
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
}
