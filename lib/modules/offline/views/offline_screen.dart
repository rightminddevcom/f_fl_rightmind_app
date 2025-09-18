import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/restart_app.dart';
import '../../../constants/app_sizes.dart';
import '../view_models/offline_viewmodel.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => OfflineViewModel()),
        ],
      child: Scaffold(
        body: Consumer<OfflineViewModel>(
          builder: (context, viewModel, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 1,
                ),
                Stack(
                  children: [
                    // Background image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.s32),
                          bottomRight: Radius.circular(AppSizes.s32)),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppSizes.s32),
                              bottomRight: Radius.circular(AppSizes.s32)),
                        ),
                        child: Image.asset(
                          "assets/images/png/home_back.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        ),
                      ),
                    ),

                    // Linear gradient overlay
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(AppColors.dark)
                                .withOpacity(0.9), // Top - darker
                            Color(AppColors.dark)
                                .withOpacity(0.0), // Bottom - transparent
                          ],
                        ),
                      ),
                    ),

                    // Your content goes here, if any
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/svg/wifi.svg",),
                        const SizedBox(height: 25,),
                        Text(AppStrings.youAreOffline.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),),
                        const SizedBox(height: 15,),
                        Text(AppStrings.pleaseConnectToTheInternetAndTryAgain.tr(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(AppColors.black)),),
                        const SizedBox(height: 25,),
                        CustomElevatedButton(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            titleSize: AppSizes.s12,
                            title: AppStrings.retry.tr().toUpperCase(),
                            onPressed: () async{
                              RestartWidget.restartApp(context);
                            }
                        ),

                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _widget(
          {required IconData icon,
          Function()? onPress,
          required String hero}) =>
      Padding(
        padding: const EdgeInsets.all(AppSizes.s0),
        child: Row(
          children: [
            FloatingActionButton(
              heroTag: hero,
              onPressed: onPress,
              backgroundColor: Color(AppColors.primary),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}
