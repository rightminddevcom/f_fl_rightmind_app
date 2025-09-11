import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/models/all_company_request.model.dart';
import 'package:cpanal/models/myteam_request.model.dart';
import 'package:cpanal/models/other_department_request.model.dart';
import '../../../general_services/app_config.service.dart';
import '../../../general_services/birthday_checker.service.dart';
import '../../../general_services/settings.service.dart';
import '../../../models/notification.model.dart';
import '../../../models/request.model.dart';
import '../../../models/settings/user_settings.model.dart';
import '../../../models/settings/user_settings_2.model.dart';

class HomeViewModel extends ChangeNotifier {
  UserSettingsModel? userSettings;
  UserSettings2Model? userSettings2;
  List<RequestModel>? myRequests;
  List<MyTeamRequestModel>? myTeamRequests;
  List<AllCompanyRequestModel>? allCompanyRequests;
  List<OtherDepartmentRequestModel>? otherDepartmentRequests;
  List<NotificationModel>? notifications;
  final ScrollController homeScrollController = ScrollController();
  bool isLoading = false;
  var errorMessage;
  @override
  void dispose() {
    homeScrollController.dispose();
    super.dispose();
  }

  void updateLoadingStatus({required bool laodingValue}) {
    isLoading = laodingValue;
    notifyListeners();
  }

  Future<void> initializeHomeScreen(BuildContext context, {bool closeDate = false}) async {
    updateLoadingStatus(laodingValue: true);
    final appConfigServiceProvider = Provider.of<AppConfigService>(context, listen: false);
    // if (appConfigServiceProvider.isLogin != true ||
    //     appConfigServiceProvider.token.isEmpty) {
    //   return;
    // }
    // initialize [userSettings] and [userSettings2] after chackings about token
    await AppSettingsService.getUserSettingsAndUpdateTheStoredSettings(
        allData: true, context: context, closeDate: closeDate );
    if (!context.mounted) return;
    userSettings = AppSettingsService.getSettings(
        settingsType: SettingsType.userSettings,
        context: context) as UserSettingsModel;
    userSettings2 = AppSettingsService.getSettings(
        settingsType: SettingsType.user2Settings,
        context: context) as UserSettings2Model;
    // get user requests
  //  await _getUserNotification(context);
  //  await getHome(context);
    // Checking for user BirthDate
    try {
      final userBirthDate = userSettings?.birthDate;
      if (userBirthDate != null) {
        // intialize Birthday Service Checker
        BirthdayChecker.checkBirthday(
            context: context,
            birthDate: ((AppSettingsService.getSettings(
                    settingsType: SettingsType.userSettings,
                    context: context)) as UserSettingsModel)
                .birthDate);
      }
    } catch (err, t) {
      debugPrint("error while checking on user birthday $err at :- $t");
    }
    updateLoadingStatus(laodingValue: false);
  }
}
