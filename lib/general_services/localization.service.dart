import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import '../modules/splash_and_onboarding/views/splash_screen.dart';
import '../routing/app_router.dart';

abstract class LocalizationService {
  static void setLocaleAndUpdateUrl(
      {required BuildContext context, required String newLangCode}) {
    // Set the locale
    print("i will put lang");
    final locale = Locale(newLangCode);
    CacheHelper.setString(key: "lang", value: newLangCode);
    context.setLocale(locale);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()));    // // Update the URL
    // final uri = GoRouterState.of(context).uri;
    // // Create a new URI with the updated language parameter
    // final updatedUri = uri.replace(queryParameters: {
    //   ...uri.queryParameters,
    //   'lang': newLangCode,
    // });

    // // Navigate to the updated URL
    // context.go(updatedUri.toString());
  }

  static bool isArabic({required BuildContext context}) =>
      context.locale.languageCode == 'ar';
}
