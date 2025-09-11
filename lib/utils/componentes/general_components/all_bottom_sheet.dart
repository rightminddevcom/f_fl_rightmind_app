import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/general_services/app_theme.service.dart';
import 'package:cpanal/modules/authentication/views/widgets/phone_number_field.dart';
import 'package:cpanal/utils/componentes/general_components/all_text_field.dart';

defaultActionBottomSheet(
        {required BuildContext? context,
        required String? title,
        required String? subTitle,
        String? buttonText,
        bool viewCheckIcon = false,
        bool viewPhoneField = false,
        bool viewDropDownButton = false,
        bool viewRefLinkButton = false,
        String? dropDownValue,
        String? refLink,
        String? dropDownTitle,
        String? textFormFieldHint,
        TextEditingController? textFormFieldController,
        bool? view = false,
        bool? widgetTextFormField = false,
        bool? viewHeaderIcon = true,
        Widget? buttonWidget,
        List<DropdownMenuItem<String>>? dropDownItems,
        void Function(String?)? dropDownOnChanged,
        void Function(String?)? textFieldOnChanged,
        Widget? headerIcon,
        double? bottomSheetHeight,
        countryCodeController,
        phoneController,
        void Function()? onTapButton}) =>
    showModalBottomSheet(
      context: context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
              color: Color(0xffFFFFFF)),
          width: double.infinity,
          height: (bottomSheetHeight != null)
              ? bottomSheetHeight
              : (viewDropDownButton == false)
                  ? MediaQuery.sizeOf(context).height * 0.5
                  : MediaQuery.sizeOf(context).height * 0.56,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  height: 5,
                  width: 63,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xffB9C0C9)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (viewHeaderIcon == true)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE93F81).withOpacity(0.05),
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE93F81),
                                ),
                                child: headerIcon),
                          ),
                          if (viewCheckIcon == true)
                            const Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: const Color(0xff38CF71),
                                child: Icon(
                                  Icons.check,
                                  color: const Color(0xffFFFFFF),
                                  size: 12,
                                ),
                              ),
                            )
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text(
                      title!.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(AppColors.dark),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      subTitle!,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(AppColors.black),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    if (viewDropDownButton == true)
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.5),
                            child: Container(
                              height: 49,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE93F81),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          defaultDropdownField(
                              items: dropDownItems,
                              title: dropDownTitle,
                              value: dropDownValue,
                              onChanged: dropDownOnChanged),
                        ],
                      ),
                    if (widgetTextFormField == true)
                      defaultTextFormField(
                          context: context,
                          onChanged: textFieldOnChanged,
                          hintText: textFormFieldHint,
                          controller: textFormFieldController),
                    if (viewRefLinkButton == true)
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        decoration: ShapeDecoration(
                          color: AppThemeService.colorPalette.tertiaryColorBackground.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.s10),
                            side: BorderSide(
                              color: const Color(0xffE3E5E5),
                              width: 1.0,
                            ),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 10,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Text(refLink!, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff5E5E5E)),),
                      ),
                    if (viewPhoneField == true)
                      PhoneNumberField(
                        controller: phoneController,
                        countryCodeController: countryCodeController,
                      ),
                    const SizedBox(height: 30),
                    if (view == true)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (view == false)
                      GestureDetector(
                        onTap: onTapButton,
                        child: Container(
                          height: 50,
                          width: 225,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(AppColors.primary)),
                          child: (buttonWidget != null)
                              ? buttonWidget
                              : Text(
                                  buttonText!.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffFFFFFF),
                                      ),
                                ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
