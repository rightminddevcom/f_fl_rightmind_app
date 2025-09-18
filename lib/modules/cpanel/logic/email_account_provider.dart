import 'package:cpanal/common_modules_widgets/success_send_complain.dart';
import 'package:cpanal/constants/app_constants.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/general_services/alert_service/alerts.service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:typed_data';
import 'package:media_store_plus/media_store_plus.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';

class EmailAccountProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isWebLoading = false;
  bool isSuccess = false;
  String? errorMessage;
  String? webViewUrl;
  bool hasMore = true;
  int pageNumber = 1;
  final int expectedPageSize = 9;
  List accountsEmails = [];
  List accountsMulti = [];
  List resErrors = [];
  bool hasMoreData(int length) {
    if (length < expectedPageSize) {
      return false; // No more data available if we received less than expected
    } else {
      pageNumber += 1; // Increment for the next page
      return true; // More data available
    }
  }
  Future<void> getEmails(context, {required dynamic domainId, required String actionType, bool isNewPage = false,}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/actions",
        data: {
          'page': pageNumber,
          "domain_id": domainId,
          "action_type": actionType,
          "action": "get",
        },
        context: context,
      );

      if (response.data['status'] == true) {
        List newEmails = response.data['res'];

        if (isNewPage) {
          accountsEmails.addAll(newEmails);
          AppConstants.accountsEmailsFilter!.addAll(newEmails);
        } else {
          accountsEmails = newEmails;
          AppConstants.accountsEmailsFilter = newEmails;
        }

        hasMore = newEmails.length == expectedPageSize;
        if (hasMore) pageNumber++;

        isLoading = false;
        notifyListeners();
      }else{
        isLoading = false;
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
        notifyListeners();
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      errorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
    }
  }
  Future<void> getWebview(context, {required dynamic domainId, required String username}) async {
    if (isLoading) return;
    isWebLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/create_web_mail_session_for_mail_user",
        data: {
          "domain_id": domainId,
          "username": username,
        },
        context: context,
      );

      if (response.data['status'] == true) {
        webViewUrl = response.data['url'];
        var uri = Uri.parse(webViewUrl!);
        if(await canLaunchUrl(uri)){
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }else{
          throw 'Could not launch $webViewUrl';
        }
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      isWebLoading = false;
      notifyListeners();
    } catch (error) {
      isWebLoading = false;
      notifyListeners();
      errorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
    }
  }
  addEmails(context, {username, domainId, actionType, password, quota, domain}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/actions",
        data: {
          "action" : "add",
          "domain_id" : domainId,
          "action_type" : actionType,
          "username" : username,
          "password" : password,
          "quota" : quota,
          "send_welcome_email" : 1
        },
        context: context,
      );
      if(response.data['status'] == true){
        isSuccess = true;
        Navigator.pop(context);
         showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }
  addMultiEmails(context, {accounts, domainId,}) async {
    print("TAPED ${accounts}");
    isLoading = true;
    notifyListeners();
    print("TAPED");
    try {
      final response = await DioHelper.postData(
        context: context,
        url: "/rm_cpanel/v1/emails/add_multi",
        data: {
          "domain_id" : domainId,
          "accounts" :accounts,
        },
      );
      print("TAPED");
      if(response.data['status'] == true){
        if(response.data['res'] != null){
          resErrors = response.data['res'];
        }
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        if(response.data['res'] != null){
          resErrors = response.data['res'];
          final successUsernames = resErrors
              .where((e) => e["status"] == true)
              .map((e) => e["username"])
              .toSet();
          accountsMulti.removeWhere(
                (account) => successUsernames.contains(account["username"]),
          );
          print("ACCOUNTS MULTI IS --> ${accountsMulti}");
          await showErrorsSequentially(context, resErrors);
        }else{
          AlertsService.error(
              context: context,
              message: "${response.data['message']}",
              title: AppStrings.failed.tr());
        }

      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }
  Future<void> showErrorsSequentially(
      BuildContext context, List? resErrors) async {
    for (var e in resErrors!) {
      if (e['status'] == true) {
        await AlertsService.success(
          context: context,
          message: "${e['message']}",
          title: AppStrings.success.tr(),
        );
      } else {
        await AlertsService.error(
          context: context,
          message: "${e['message']}",
          title: AppStrings.failed.tr(),
        );
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  updateEmail(context, {account, domainId, password, quota, suspend}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/actions",
        data: {
          "action" : "update",
          "domain_id" : domainId,
          "action_type" : "email_account",
          "username" : account,
          if(password != null && password.toString().isNotEmpty)"password" : password,
          if(quota != null && quota.toString().isNotEmpty)"quota" : quota,
          "suspend" : suspend == AppStrings.blockAccount.tr() ? "suspend_login" : "unsuspend_login",
          "send_welcome_email" : 1
        },
        context: context,
      );
      if(response.data['status'] == true){
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }
  updateEmailMulti(context, {accounts, domainId, password, quota, suspend}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/emails/update_multi",
        data: {
          ...accounts,
          "action" : "update",
          "domain_id" : domainId,
          if(password != null && password.toString().isNotEmpty)"password" : password,
          if(quota != null && quota.toString().isNotEmpty)"quota" : quota,
          if(suspend != null)"suspend" : suspend == AppStrings.blockAccount.tr() ?  "suspend_login" : "unsuspend_login"
        },
        context: context,
      );
      if(response.data['status'] == true){
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }
  deleteEmail(context, {account, domainId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/actions",
        data: {
          "action" : "delete",
          "domain_id" : domainId,
          "action_type" : "email_account",
          "username" : account,
        },
        context: context,
      );
      if(response.data['status'] == true){
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }
  deleteMutiEmail(context, {accounts, domainId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_cpanel/v1/emails/delete_multi",
        data: {
          "domain_id" : domainId,
          ...accounts,
        },
        context: context,
      );
      if(response.data['status'] == true){
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendCpanalBottomsheet(response.data['message']);
          },
        );
      }else{
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    }
  }

  Future<void> downloadExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      TextCellValue("username"),
      TextCellValue("password"),
      TextCellValue("quota"),
    ]);

    List<int>? fileBytes = excel.encode();
    if (fileBytes == null) return;

    try {
      if (Platform.isAndroid) {
        // 1. create temporary file
        final tempDir = await getApplicationDocumentsDirectory();
        final tempPath = "${tempDir.path}/accounts.xlsx";
        await File(tempPath).writeAsBytes(fileBytes);

        // 2. initialize and set app folder first
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "MyApp"; // <-- must set a folder name

        // 3. save file into Downloads/MyApp
        await MediaStore().saveFile(
          tempFilePath: tempPath,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File saved in Downloads/MyApp")),
        );

        await OpenFilex.open(tempPath);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final path = "${dir.path}/accounts.xlsx";
        await File(path).writeAsBytes(fileBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saved at: $path")),
        );

        await OpenFilex.open(path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save error: $e")),
      );
    }
  }
  Future<void> uploadExcel(List? accountsMulti) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      final bytes = File(result.files.single.path!).readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(bytes);

      for (var table in decoder.tables.keys) {
        for (var row in decoder.tables[table]!.rows.skip(1)) {
          accountsMulti!.add({
            "username": row[0]?.toString() ?? "",
            "password": row[1]?.toString() ?? "",
            "quota": row[2]?.toString() ?? "",
          });
        }
      }
      notifyListeners();
      print("ACCOUNTS IS --> $accountsMulti");
    }
  }}
