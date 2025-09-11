import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/home_model/home_model.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:cpanal/modules/authentication/views/widgets/phone_number_field.dart';
import 'package:cpanal/utils/componentes/general_components/all_text_field.dart';

class AddFriendBottomSheet extends StatelessWidget {
  const AddFriendBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PointsProvider(),
      child: ChangeNotifierProvider(create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, values, child) {
          return Consumer<PointsProvider>(
            builder: (context, value, child) {
              if(value.isAddFriendSuccess == true){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  values.initializeHomeScreen(context);
                });
                value.isAddFriendSuccess = false;
              }
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // Moves it above the keyboard
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
                      color: Color(0xffFFFFFF)),
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.62,
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
                            const SizedBox(height: 20),
                            Text(
                              AppStrings.registerYourFriendData.tr().toUpperCase(),
                              style: const TextStyle(

                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color(AppColors.dark),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.pointsCondationAbout.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(AppColors.black),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            defaultTextFormField(
                                context: context,
                                hintText: AppStrings.friendName.tr().toUpperCase(),
                                controller: value.friendNameController
                            ),
                            PhoneNumberField(
                              controller: value.phoneController,
                              countryCodeController: value.countryCodeController,
                            ),
                            const SizedBox(height: 20),
                            if(value.isAddFriendLoading)Center(child: CircularProgressIndicator(),),
                            if(!value.isAddFriendLoading)GestureDetector(
                              onTap: (){
                                value.addFriend(context);
                              },
                              child: Container(
                                height: 50,
                                width: 225,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(AppColors.primary)),
                                child: Text(
                                  AppStrings.invitation.tr().toUpperCase(),
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
                ),
              );
            },
          );
        },
      ),
      )
    );
  }
}
