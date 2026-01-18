import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OfflineViewModel with ChangeNotifier {
  final List<String> _usersFingerprints = [];

  List<String> get usersFingerprints => _usersFingerprints;

//   void initialize({required BuildContext ctx}) async {
//     final appConfigServiceProvider =
//     Provider.of<AppConfigService>(ctx, listen: false);
//
//     final settings =
//     appConfigServiceProvider.getSettings(type: SettingsType.userSettings);
//
//     final fingerprints = settings?.toJson()['av_fingerprint'];
//
//     if (fingerprints != null && fingerprints is Map) {
//       fingerprints.forEach((key, value) {
//         if (value == 'active_all' || value == 'active_some') {
//           _usersFingerprints.add(key);
//           print("_usersFingerprints --> $_usersFingerprints");
//         }
//       });
//     } else {
//       print("⚠️ fingerprints is null or not a Map");
//     }
//
//
// }
}