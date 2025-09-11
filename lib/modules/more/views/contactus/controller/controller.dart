import 'package:flutter/material.dart';
import 'package:cpanal/general_services/url_launcher.service.dart';

class ContactUsController extends ChangeNotifier{
 bool isLoading = false;
 bool isSuccess = false;
 String? errorMessage;


 Future<void> sendMailToCompany(
     {required BuildContext context,
       required String email,
       required String? subject,
       required String? body}) async {
   if (email.isEmpty) return;
   final Uri params = Uri(
     scheme: 'mailto',
     path: email,
     query: 'subject=${subject ?? 'Contact From Application'}&body=${body ?? 'Hello'}',
   );
   var url = params.toString();
   await UrlLauncherServiceEx.launch(context: context, url: url);
 }
}

