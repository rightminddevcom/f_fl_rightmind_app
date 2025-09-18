import 'package:cpanal/controller/device_sys/device_controller.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:cpanal/modules/cpanel/logic/auto_response_provider.dart';
import 'package:cpanal/modules/cpanel/logic/dns_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_forward_provider.dart';
import 'package:cpanal/modules/cpanel/logic/ftp_provider.dart';
import 'package:cpanal/modules/cpanel/logic/sql_provider.dart';
import 'package:cpanal/platform/platform_is.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/general_services/connections.service.dart';
import 'package:cpanal/modules/more/views/blog/controller/blog_controller.dart';
import 'package:cpanal/modules/more/views/notification/logic/notification_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app.dart';
import 'controller/request_controller/request_controller.dart';
import 'firebase_options.dart';
import 'general_services/app_config.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'general_services/conditional_imports/change_url_strategy.service.dart';
import 'general_services/internet_check.dart';
import 'modules/home/view_models/home.viewmodel.dart';
import 'modules/main_screen/view_models/main_viewmodel.dart';
GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Background handler for Firebase messages
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔹 Background Notification: ${message.notification?.title}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  //await ConnectionsService.init();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  if (await Permission.notification.isPermanentlyDenied) {
    openAppSettings();
  } else {
    try {
      if (PlatformIs.android || PlatformIs.iOS) {
        try {
          const platform = MethodChannel('notification_settings_channel');
          await platform.invokeMethod('openNotificationSettings');
        } catch (e) {
          print("Error opening notification settings: $e");
        }
      }

    } catch (e) {
      print("Error opening notification settings: $e");
    }
  }
  // Request notification permissions
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  // Initialize local notifications
  var androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSSettings = DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iOSSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    // onDidReceiveNotificationResponse: (NotificationResponse response) {
    //   if (response.payload != null) {
    //     final data = jsonDecode(response.payload!);
    //     final type = data['type'];
    //     final id = data['id'];
    //     GeneralListener.linksAction(popup: data);
    //   }
    //
    // },
  );

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// Retrieve and print the FCM Token
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
  // if (!PlatformIs.android && !PlatformIs.iOS) {
  //   changeUrlStrategyService();
  // }
  GoRouter.optionURLReflectsImperativeAPIs = true;
  try {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  } catch (ex, t) {
    debugPrint('Failed to initialize Hive Database $ex $t');
  }
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/json/lang',
      fallbackLocale: const Locale('en'),
      // Enable saving the selected locale in local storage
      saveLocale: true,
      child: MultiProvider(
        // inject all providers to make it accessable intire all application via context.
        providers: [
          ChangeNotifierProvider<AppConfigService>(
            create: (_) => AppConfigService(),
          ),
          ChangeNotifierProvider<MainScreenViewModel>(
            create: (_) => MainScreenViewModel(),
          ),
          ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(),
          ),
          ChangeNotifierProvider<EmailAccountProvider>(
            create: (_) => EmailAccountProvider(),
          ),
          ChangeNotifierProvider<AutoResponseProvider>(
            create: (_) => AutoResponseProvider(),
          ),
          ChangeNotifierProvider(create: (context) => RequestController()),
          ChangeNotifierProvider(create: (context) => BlogProviderModel()),
          ChangeNotifierProvider(create: (context) => EmailForwardProvider()),
          ChangeNotifierProvider(create: (context) => FtpProvider()),
          ChangeNotifierProvider(create: (context) => ConnectionService()),
          ChangeNotifierProvider(create: (context) => EmailFilterProvider()),
          ChangeNotifierProvider(create: (context) => SqlProvider()),
          ChangeNotifierProvider(create: (context) => DNSProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProviderModel()),
          ChangeNotifierProvider(create: (context) => PointsProvider()),
          ChangeNotifierProvider(create: (context) => DeviceControllerProvider()),
        ],
        child: MyApp(),
      )));
}
