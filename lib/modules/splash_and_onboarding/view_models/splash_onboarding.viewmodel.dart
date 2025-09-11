import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/home/view_models/home.viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_images.dart';
import '../../../constants/settings/default_general_settings.dart';
import '../../../general_services/app_config.service.dart';
import '../../../general_services/app_info.service.dart';
import '../../../general_services/backend_services/get_endpoint.service.dart';
import '../../../general_services/connections.service.dart';
import '../../../general_services/device_info.service.dart';
import '../../../general_services/notification_service/notification.service.dart';
import '../../../models/endpoint.model.dart';
import '../../../models/settings/general_settings.model.dart';
import '../../../routing/app_router.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  final PageController pageController2 = PageController();
  int _currentIndex = 0;

  set currentIndex(int newIndex) => _currentIndex = newIndex;
  @override
  void dispose() {
    pageController.dispose();
    pageController2.dispose();
    super.dispose();
  }
  DateTime? safeParseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final hasArabicNumerals = RegExp(r'[٠-٩]').hasMatch(dateString);
      final normalized = hasArabicNumerals
          ? dateString.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
        const arabicNumbers = {
          '٠': '0',
          '١': '1',
          '٢': '2',
          '٣': '3',
          '٤': '4',
          '٥': '5',
          '٦': '6',
          '٧': '7',
          '٨': '8',
          '٩': '9',
        };
        return arabicNumbers[match.group(0)]!;
      })
          : dateString;

      return DateTime.parse(normalized);
    } catch (e) {
      debugPrint('Invalid date format: $dateString');
      return null;
    }
  }

  List<FeatureItems>? getAllOnboardingData({required BuildContext context}) {
    final jsonString = CacheHelper.getString("USG");
    if (jsonString != null && jsonString.isNotEmpty) {
      print("jsonString is --> $jsonString");
      final gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      print("S2 IS --> $gCache");

      if (gCache['features'] != null && gCache['features']['items'].isNotEmpty) {
        // Convert the List<dynamic> to List<FeatureItems>
        defaultGeneralSettings.features!.items = (gCache['features']['items'] as List<dynamic>)
            .map((item) => FeatureItems.fromJson(item))
            .toList();
      }else{
        print("YES IT IS EMPTY");
        try{
          defaultGeneralSettings.features!.items = (defaultGeneralSettingsMap['features']['items'] as List<dynamic>)
              .map((item) => FeatureItems.fromJson(item))
              .toList();
          print("done");
        }catch(e){
          print(e.toString());
        }

      }
    }else{
      try{
        defaultGeneralSettings.features!.items = (defaultGeneralSettingsMap['features']['items'] as List<dynamic>)
            .map((item) => FeatureItems.fromJson(item))
            .toList();
        print("done");
      }catch(e){
        print(e.toString());
      }
    }
    return defaultGeneralSettings.features!.items;
  }

  FeatureItems? getOnboardingDataWithIndex(int index, BuildContext context) {
    final items = getAllOnboardingData(context: context);
    if (items != null && index >= 0 && index < items.length) {
      return items[index];
    }
    return null;
  }

  // var userSettings;
  Future<void> _initializeAppServices(
      BuildContext context, AppConfigService appConfigService) async {
    try {
      // Precache logo image
      await precacheImage(const AssetImage(AppImages.logo), context);

      // Initialize application services
      await appConfigService.init();

      // Initialize and set device information in local storage
      DeviceInformationService.initializeAndSetDeviceInfo(context: context);

      // Set base API URL
      appConfigService.apiURL = AppConstants.baseUrl;

      // Optional: Enable or disable checking for token expiration
      appConfigService.checkOnTokenExpiration = false;

      // Optional: Set refresh token API URL
      appConfigService.refreshTokenApiUrl = AppConstants.refreshTokenBaseUrl;

      // Optional: Set application name
      appConfigService.appName =
      await ApplicationInformationService.getAppName();

      // Optional: Set application version
      appConfigService.appVersion =
      await ApplicationInformationService.getAppVersion();

      // Optional: Set application build number
      appConfigService.buildNumber =
      await ApplicationInformationService.getAppBuildNumber();

      // Optional: Set application package name
      appConfigService.packageName =
      await ApplicationInformationService.getAppPackageName();

      await ConnectionsService.init();
    } catch (e) {
      debugPrint('Error initializing app services: $e');
    }
  }
  Future<List<dynamic>> loadJson() async {
    const filepath = 'assets/json/routes.json';
    final content = await rootBundle.loadString(filepath);
    return jsonDecode(content);
  }
  Future<Map<String, dynamic>?> analyzeRoute(String url) async {
    // Decode JSON into an array
    final allRoute = await loadJson();

    // Parse URL and extract path and query parameters
    final uri = Uri.parse(url);
    final path = uri.path.trim().replaceAll(RegExp(r'^/|/$'), ''); // Trim leading/trailing slashes
    final queryParams = uri.queryParameters;

    // Iterate through routes to find a match
    for (final route in allRoute) {
      final routePattern = route['route'];

      // Extract placeholder names (e.g., {id})
      final keys = RegExp(r'\{([^\}]+)\}')
          .allMatches(routePattern)
          .map((match) => match.group(1)!)
          .toList();

      // Convert route pattern to regex
      final pattern = '^' +
          routePattern.replaceAll(RegExp(r'\{[^\}]+\}'), '([^/]+)').replaceAll('/', r'\/') +
          r'$';

      // Check if the path matches the pattern
      final matches = RegExp(pattern).allMatches(path);
      if (matches.isNotEmpty) {
        final match = matches.first;
        final params = <String, String>{};

        for (var i = 0; i < keys.length; i++) {
          params[keys[i]] = match.group(i + 1)!;
        }

        // Add query parameters to the values
        params.addAll(queryParams);

        // Return the matching route key and parameters
        return {
          'key': route['key'],
          'values': params,
        };
      }
    }
    // Return null if no match is found
    return null;
  }
  Future<void> initializeSplashScreen(
      {required BuildContext context, role}) async {
    final appConfigService =
    Provider.of<AppConfigService>(context, listen: false);
    late final HomeViewModel homeViewModel;
    homeViewModel = HomeViewModel();
    try {
      if (await ConnectionsService.isOnline()) {
        await _initializeAppServices(context, appConfigService);
        if (appConfigService.isLogin && appConfigService.token.isNotEmpty) {
          try {
            await PushNotificationService.init(
              context: context,
              apiUrlThatReciveUserToken:
              EndpointServices.getApiEndpoint(EndpointsNames.deviceSys).url,
            );
          } catch (ex) {
            debugPrint(
                'Failed to send notification device token to server $ex');
          }
          final features = getAllOnboardingData(context: context);
          final jsonString = CacheHelper.getString("USG");
          var gCache;
          if (jsonString != null && jsonString != "") {
            gCache = json.decode(jsonString) as Map<String, dynamic>;
          }
          var dateToCheck = safeParseDateTime(CacheHelper.getString("dateWatchScreen"));
          final referenceDate = safeParseDateTime(gCache['features']['date']);
          print("dateWatchScreen is ${CacheHelper.getString("dateWatchScreen")}");
          if (CacheHelper.getString("dateWatchScreen") == null ||gCache['features']['date'] == null|| referenceDate!.isAfter(dateToCheck!)) {
            await _precacheImages(context, features!);
            context.goNamed(AppRoutes.onboarding.name,
                pathParameters: {'lang': context.locale.languageCode});
          } else {
            context.goNamed(
              AppRoutes.home.name,
              pathParameters: {'lang': context.locale.languageCode},
            );
          }
          return;
        } else {
          final features = getAllOnboardingData(context: context);
          final jsonString = CacheHelper.getString("USG");
          var gCache;
          var dateToCheck ;
          var referenceDate ;
          if (jsonString != null && jsonString != "") {
            gCache = json.decode(jsonString) as Map<String, dynamic>;// Convert String back to JSON
            print("S2 IS --> $gCache");
            referenceDate = safeParseDateTime(gCache['features']['date']);
            print("Date IS --> $referenceDate");
          }
          if(CacheHelper.getString("dateWatchScreen") != null && CacheHelper.getString("dateWatchScreen") != ""){
            dateToCheck = safeParseDateTime(CacheHelper.getString("dateWatchScreen"));
          }else{
            context.goNamed(
              AppRoutes.login.name,
              pathParameters: {'lang': context.locale.languageCode},
            );
          }
          if (features == null || features.isEmpty) {
            print("login2");
            context.goNamed(
              AppRoutes.login.name,
              pathParameters: {'lang': context.locale.languageCode,
              },
            );
            return;
          } else {
            if (CacheHelper.getString("dateWatchScreen") == null ||CacheHelper.getString("dateWatchScreen") == "" ||
                gCache == null || gCache['features']['date'] == ""||dateToCheck.isAfter(referenceDate) == false ) {
              await _precacheImages(context, features);
              context.goNamed(AppRoutes.onboarding.name,
                  pathParameters: {'lang': context.locale.languageCode});
            } else {
              print("login3");
              context.goNamed(
                AppRoutes.login.name,
                pathParameters: {'lang': context.locale.languageCode},
              );
            }
          }
          return context.goNamed(
            AppRoutes.login.name,
            pathParameters: {'lang': context.locale.languageCode},
          );
        }
      } else {
        context.goNamed(AppRoutes.offlineScreen.name,
            pathParameters: {'lang': context.locale.languageCode});
      }
    } catch (err, t) {
      return context.goNamed(
        AppRoutes.login.name,
        pathParameters: {'lang': context.locale.languageCode},
      );
    }
  }

  Future<void> _precacheImages(
      BuildContext context, List<FeatureItems> features) async {
    for (var item in features) {
      final image = item.image![0].file;
      if (image != null) {
        try {
          if (image.startsWith('http') || image.startsWith('https')) {
            // Network image
            await precacheImage(CachedNetworkImageProvider(image), context);
          } else {
            // Asset image
            await precacheImage(AssetImage(image), context);
          }
        } catch (e) {
          debugPrint('Error precaching image ($image): $e');
        }
      }
    }
  }

  void goNext(BuildContext context) {
    const int duration = 500;
    final items = getAllOnboardingData(context: context);

    if (items != null && _currentIndex < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: duration),
        curve: Curves.easeInOut,
      );
      pageController2.nextPage(
        duration: const Duration(milliseconds: duration),
        curve: Curves.easeInOut,
      );
      currentIndex = _currentIndex + 1;
    } else {
      final appConfigService =
      Provider.of<AppConfigService>(context, listen: false);
      final jsonString = CacheHelper.getString("US1");
      var us1Cache;
      var role;
      if (jsonString != "") {
        us1Cache = json.decode(jsonString) as Map<String, dynamic>;// Convert String back to JSON
        print("S2 IS --> $us1Cache");
        role = us1Cache['role'];
      }
      if (appConfigService.isLogin && appConfigService.token.isNotEmpty){
        context.goNamed(
          AppRoutes.home.name,
          pathParameters: {'lang': context.locale.languageCode,},
        );
      }else{
        context.goNamed(
          AppRoutes.login.name,
          pathParameters: {'lang': context.locale.languageCode,},
        );
      }
    }
  }

  void skip(BuildContext context) {
    final appConfigService =
    Provider.of<AppConfigService>(context, listen: false);
    if (appConfigService.isLogin && appConfigService.token.isNotEmpty){
      context.goNamed(
        AppRoutes.home.name,
        pathParameters: {'lang': context.locale.languageCode,},
      );
    }else{
      context.goNamed(
        AppRoutes.login.name,
        pathParameters: {'lang': context.locale.languageCode,
        },
      );}
  }

// void skip(BuildContext context) => context.goNamed(AppRoutes.stores.name,
//     pathParameters: {'lang': context.locale.languageCode});
}
