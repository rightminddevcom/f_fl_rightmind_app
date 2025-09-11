import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/alert_service/alerts.service.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/dio.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/get_one_notification_model.dart';
import 'package:cpanal/models/get_request_comment_model.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';

class NotificationProviderModel extends ChangeNotifier {
  bool isLoading = false;
  bool isGetNotificationLoading = false;
  bool isGetNotificationSuccess = false;
  bool isGetNotificationCommentLoading = false;
  bool isGetNotificationCommentSuccess = false;
  bool hasMoreNotifications = true; // Track if there are more notifications to load
  bool allowComment = true; // Track if there are more notifications to load
  String? getNotificationErrorMessage;
  String? getRequestCommentErrorMessage;
  String? errorAddNotificationMessage;
  String? errorMessage;
  GetRequestCommentModel? getRequestCommentModel;
  NotificationSingleModel? notificationModel;
  List comments = [];
  Set<int> commentIds = {};
  List notifications = [];
  List newNotifications = [];
  List listIds = [];
  List listIdsDepartment = [];
  int currentPage = 1;
  final int itemsCount = 9;
  bool hasMore = true;
  final int expectedPageSize = 9;
  final picker = ImagePicker();
  XFile? XImageFileAttachmentPersonal;
  File? attachmentPersonalImage;
  List listAttachmentPersonalImage = [];
  List<XFile> listXAttachmentPersonalImage = [];
  FilePickerResult? attachedFile;
  Map<String, dynamic>? selectedEmployee;
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> departments = [];
  TextEditingController titleArController = TextEditingController();
  TextEditingController contentArController = TextEditingController();
  TextEditingController titleEnController = TextEditingController();
  TextEditingController contentEnController = TextEditingController();
  String? selectNotificationType;
  void initializeAddTaskScreen({required BuildContext context}) {
    getEmployees(context: context);
    getDepartment(context: context);
    _resetValues();
    notifyListeners();
  }
  void _resetValues() {
    // selectedType = null;
    // selectedDatecontroller = TextEditingController();
     contentArController = TextEditingController();
     titleArController = TextEditingController();
     contentEnController = TextEditingController();
     titleEnController = TextEditingController();
     selectNotificationType = null;
     listXAttachmentPersonalImage = [];
     listAttachmentPersonalImage = [];
     listIds = [];
     listIdsDepartment = [];
  }
  bool hasMoreData(int length) {
    if (length < expectedPageSize) {
      return false;
    } else {
      currentPage += 1;
      return true;
    }
  }
  Future<void> refreshPaints(context) async{
    currentPage = 1;
    hasMore = true;
    await getNotification(page : 1,context);
  }
  void getEmployees({required BuildContext context}) {
    var jsonString;
    var gCache;
    jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty && jsonString != "") {
      gCache = json.decode(jsonString) as Map<String, dynamic>; // Convert String back to JSON
      UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
    }
    isLoading = true;
    notifyListeners();
    DioHelper.getData(
      url: "/emp_requests/v1/employees",
      query: {
        "under_my_management" : true
      },
      context: context,
    ).then((value){
      isLoading = false;
      employees = [];
      value.data['employees'].forEach((e){
        employees.add(Map<String, dynamic>.from(e));
      });
      notifyListeners();
    }).catchError((error){
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    });
  }
  void getDepartment({required BuildContext context}) {
    isLoading = true;
    notifyListeners();
    DioHelper.getData(
      url: "/departments/entities-operations",
      query: {
        "under_my_management" : true
      },
      context: context,
    ).then((value){
      isLoading = false;
      departments = List<Map<String, dynamic>>.from(value.data['data']);
      notifyListeners();
    }).catchError((error){
      isLoading = false;
      notifyListeners();
      if (error is DioError) {
        errorMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage = error.toString();
      }
    });
  }
  Future<void> getNotification(BuildContext context, {int? page, forWho}) async {
    if(page != null){currentPage = page;}
    print("currentPage is --> $currentPage}");
    isGetNotificationLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/emp_requests/v1/notifications/list",
        context: context, // Pass this explicitly only if necessary
        query: {
          "itemsCount": itemsCount,
          "page": page ?? currentPage,
          "for" : forWho
        },
      );

       newNotifications = response.data['notifications'] ?? [];
      if (page == 1) {
        notifications.clear(); // Clear only when loading the first page
      }
      if (newNotifications.isNotEmpty) {
        notifications.addAll(newNotifications);
        print("LENGTH IS --> ${newNotifications.length}");
        if (hasMore) currentPage++;
      } else {
        hasMoreNotifications = false; // No more data to fetch
      }

      isGetNotificationSuccess = true;
    } catch (error) {
      getNotificationErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
    } finally {
      isGetNotificationLoading = false;
      notifyListeners();
    }
  }
  Future<void> getNotificationSingle(BuildContext context, id) async {
    isGetNotificationLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/rmnotifications/entities-operations/$id",
        context: context, // Pass this explicitly only if necessary
      );
      if(response.data["status"] == true){
        notificationModel = NotificationSingleModel.fromJson(response.data['item']);
        isGetNotificationSuccess = true;
        isGetNotificationLoading = false;
        notifyListeners();
      }
    } catch (error) {
      getNotificationErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
    } finally {
      isGetNotificationLoading = false;
      notifyListeners();
    }
  }
  Future<void> getNotificationComment(BuildContext context, id, {pages, bool? isNewPage,}) async {
    pages ??= currentPage;
    if(currentPage == null){
      currentPage = pages;
    }
    isGetNotificationCommentLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
          url: "/rmnotifications/entities-operations/$id/comments",
          context: context,
          query: {
            "page": pages ?? currentPage,
            "order_dir" : "desc"
          }
      );
      if(response.data['status'] == false){
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        isGetNotificationCommentSuccess = true;
        comments = response.data['comments'];
        if (response.data['products'] != null && response.data['products'].isNotEmpty) {
          List newComments = response.data['products'];

          // Remove duplicates based on ID
          List uniqueComments = newComments.where((p) => !commentIds.contains(p['id'])).toList();

          if (isNewPage == true) {
            comments.addAll(uniqueComments);
          } else {
            comments = uniqueComments;
            print("PRODUCTS SUCCESS");
          }

          // Update product ID tracker
          commentIds.addAll(uniqueComments.map((p) => p['id']));

          if (hasMore) currentPage++;
        }
        getRequestCommentModel = GetRequestCommentModel.fromJson(response.data);
        print("COMMENTS --> ${comments.length}");
      }
      isGetNotificationCommentLoading = false;
      notifyListeners();
    } catch (error) {
      getRequestCommentErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg: getRequestCommentErrorMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isGetNotificationCommentLoading = false;
      notifyListeners();
    }
  }
  addNotification(BuildContext context, {empIds, depIds})async {
    isLoading = true;
    notifyListeners();
    print("empIds is --> ${empIds}");
    FormData formData = FormData.fromMap({
      "titles[en]" : titleEnController.text,
      "titles[ar]" : titleArController.text,
      "contents[en]" : contentEnController.text,
      "contents[ar]" : contentArController.text,
      "allow_comments" : allowComment == true ? "enable" : "disable",
      "type" : selectNotificationType.toString(),
      "image": listXAttachmentPersonalImage != null
          ? await Future.wait(
          listXAttachmentPersonalImage.map((file) async => await MultipartFile.fromFile(file.path, filename: file.name))
      )
          : [],
      if(empIds != null && empIds.isNotEmpty)"employee_ids[]" : empIds,
      if(depIds != null && depIds.isNotEmpty)"department_ids[]" : depIds
    });
    var response;
    try{
      if(listXAttachmentPersonalImage == null || listXAttachmentPersonalImage.isEmpty){
        response = await DioHelper.postFormData(
            url: "/emp_requests/v1/notifications/create",
            context: context,
            formdata: formData
        );
      }else{
        response = await DioHelper.postFormData(
            url: "/emp_requests/v1/notifications/create",
            context: context,
            formdata: formData
        );
      }
      if(response.data['status'] == true){
        titleEnController.clear();
        titleArController.clear();
        contentEnController.clear();
        contentArController.clear();
        AlertsService.success(
            context: context,
            message: response.data['message'],
            title: AppStrings.success.tr());
      }else{
        AlertsService.error(
            context: context,
            message: response.data['message'],
            title: AppStrings.failed.tr());
      }
    }catch (error) {
      errorAddNotificationMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorAddNotificationMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProfileImageByCam(
      {image1, image2, list, list2, one}) async {
    XFile? imageFileProfile =
    await picker.pickImage(source: ImageSource.camera);
    if (imageFileProfile == null) return;
    image1 = File(imageFileProfile.path);
    image2 = imageFileProfile;
    if(one == false)list.add({"image": image2, "view": image1});
    if(one == false)list2.add(image2);
    notifyListeners();
    print(image1);
  }
  Future<void> getProfileImageByGallery(
      {image1, image2, list, list2, one}) async {
    XFile? imageFileProfile =
    await picker.pickImage(source: ImageSource.gallery);
    if (imageFileProfile == null) return null;
    image1 = File(imageFileProfile.path);
    image2 = imageFileProfile;
    if(one == false) list.add({"image": image2, "view": image1});
    if(one == false)list2.add(image2);
    print("LISTS IS --> ${list}");
    notifyListeners();
  }
  Future<void> getImage( context, {image1, image2, list, bool one = true, list2}) =>
      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Select Photo",
                      style: TextStyle(
                          fontSize: 20, color: Color(0xFF011A51)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () async {
                                await getProfileImageByGallery(
                                    image1: image1,
                                    image2: image2,
                                    list: list,
                                    list2: list2,
                                    one: one
                                );
                                await image2 == null
                                    ? null
                                    : Image.asset(
                                    "assets/images/profileImage.png");
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.image,
                                  color: Color(0xFF011A51),
                                ),
                              ),
                            ),
                            Text("Gallery",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFF011A51)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await getProfileImageByCam(
                                    image1: image1,
                                    image2: image2,
                                    list: list,
                                    list2: list2,
                                    one: one
                                );
                                print(image1);
                                print(image2);
                                await image2 == null
                                    ? null
                                    : Image.asset(
                                    "assets/images/profileImage.png");
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera,
                                  color: Color(0xFF011A51),
                                ),
                              ),
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 18, color: Color(0xFF011A51)),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });

}
