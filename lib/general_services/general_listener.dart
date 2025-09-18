import 'dart:convert';

import 'package:cpanal/general_services/webview_offers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../general_services/localization.service.dart';
import '../main.dart';
import '../routing/app_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralListener {
  void startAll(
      BuildContext context, String? currentRoute, List? popups) async {
    checkAndShowPopup(context, currentRoute, popups);
    // listenToNotifications(context);
  }


  Future<void> checkAndShowPopup(BuildContext context, String? currentRoute, List? popups) async {
    if (currentRoute == null || popups == null || !context.mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final relatedPopups = popups.where((popup) {
      return popup['screens'].contains(currentRoute);
    }).toList();

    for (var popup in relatedPopups) {
      String type = popup['repeat_every_type'];
      int count = popup['repeat_every_count'];

      Duration interval;
      switch (type) {
        case "mins":
          interval = Duration(minutes: count);
          break;
        case "hours":
          interval = Duration(hours: count);
          break;
        case "days":
          interval = Duration(days: count);
          break;
        default:
          interval = Duration(minutes: 5);
      }

      String key = 'last_seen_${popup['title']['en']}';
      int? lastSeenMillis = prefs.getInt(key);
      DateTime now = DateTime.now();

      if (lastSeenMillis == null ||
          now.difference(DateTime.fromMillisecondsSinceEpoch(lastSeenMillis)) >=
              interval) {
        if (!context.mounted) return;
        await _showPopup(popup); // 👈 مش محتاج context من widget
        prefs.setInt(key, now.millisecondsSinceEpoch);
      }
    }
  }

  Future<void> _showPopup(Map popup) {
    final safeContext = rootNavigatorKey.currentContext!;
    return showDialog(
      context: safeContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        titlePadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding: const EdgeInsets.all(16),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kIsWeb ? 400 : double.infinity,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (popup['images'] != null && popup['images'].isNotEmpty)
                GestureDetector(
                  onTap: () async {
                    await linksAction(popup: popup['go_to']);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      popup['images'][0]['file'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              if (popup['title']['ar'] != null ||
                  popup['title']['en'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    LocalizationService.isArabic(
                        context: safeContext) // 👈 استخدم safeContext
                        ? popup['title']['ar']
                        : popup['title']['en'] ?? "",
                    style: const TextStyle(
                      color: Color(AppColors.dark),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (popup['content']['ar'] != null ||
                  popup['content']['en'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    LocalizationService.isArabic(context: safeContext)
                        ? popup['content']['ar']
                        : popup['content']['en'] ?? "",
                    style: const TextStyle(color: Color(AppColors.dark)),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if ((popup['go_to'] != null &&
              popup['go_to'].toString().isNotEmpty))
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await linksAction(popup: popup['go_to']);
              },
              child: Text(AppStrings.go.tr()),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.cancel.tr()),
          ),
        ],
      ),
    );
  }

  // void listenToNotifications(BuildContext context) async {
  //   final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  //   await _analytics.logEvent(
  //     name: 'open_home_screen',
  //     parameters: {'timestamp': DateTime.now().toIso8601String()},
  //   );
  // }

  static linksAction({popup}) async {
    if (popup.startsWith("rm_browser:")) {
      final String link = popup.replaceFirst("rm_browser:", "");
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw '${AppStrings.failed.tr()}: $link';
      }
    } else if (popup.startsWith("rm_webview:")) {
      Navigator.push(
          rootNavigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebViewStackOffers(
                popup.replaceFirst("rm_webview:", "").toString()),
          ));
    } else {
      var result = await routeCompile(popup);
      if (result != null) {
        var route = result['key'];
        var params = result['values'];

        // استبدل الـ placeholders بالقيم
        params.forEach((key, value) {
          route = route.replaceFirst('{$key}', value);
        });

        // push بالمسار النهائي
        GoRouter.of(rootNavigatorKey.currentContext!).push(
          '/${CacheHelper.getString("lang")}/$route',
        );
      }
    }
  }

  static routeCompile(urls) async {
    print("PLAY IS IN PROCESS");
    print(urls);
    final url = urls;
    final result = await analyzeRoute(url);
    if (result != null) {
      print("Route Key: ${result['key']}");
      print("Parameters: ${result['values']}");
      return result;
    } else {
      print("No matching route found.");
    }
  }

  static Future<List<dynamic>> loadJson() async {
    const filepath = 'assets/json/routes.json';
    final content = await rootBundle.loadString(filepath);
    return jsonDecode(content);
  }

  static Future<Map<String, dynamic>?> analyzeRoute(String url) async {
    // Decode JSON into an array
    final allRoute = await loadJson();

    // Parse URL and extract path and query parameters
    final uri = Uri.parse(url);
    final path = uri.path
        .trim()
        .replaceAll(RegExp(r'^/|/$'), ''); // Trim leading/trailing slashes
    final queryParams = uri.queryParameters;

    // Iterate through routes to find a match
    for (final route in allRoute) {
      final routePattern = route['backendRoute'];

      // Extract placeholder names (e.g., {id})
      final keys = RegExp(r'\{([^\}]+)\}')
          .allMatches(routePattern)
          .map((match) => match.group(1)!)
          .toList();

      // Convert route pattern to regex
      final pattern = '^' +
          routePattern
              .replaceAll(RegExp(r'\{[^\}]+\}'), '([^/]+)')
              .replaceAll('/', r'\/') +
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
          'key': route['frontendRoute'],
          'values': params,
        };
      }
    }
    // Return null if no match is found
    return null;
  }
}

