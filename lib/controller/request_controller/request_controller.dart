import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/dio.dart';
import 'package:cpanal/models/get_one_request_model.dart';
import 'package:cpanal/models/get_request_comment_model.dart';
import 'package:cpanal/modules/requests_screen/widget/successful_send_request_bottomsheet.dart';

class RequestController extends ChangeNotifier {
  bool isGetRequestLoading = false;
  bool isAddCommentLoading = false;
  bool isAddRequestLoading = false;
  bool isGetRequestCommentLoading = false;
  bool isGetRequestTypeLoading = false;
  bool isGetRequestSuccess = false;
  bool isAddCommentSuccess = false;
  bool isAddRequestSuccess = false;
  bool isGetRequestCommentSuccess = false;
  bool isGetRequestTypeSuccess = false;
  GetRequestCommentModel? getRequestCommentModel;
  TextEditingController contentController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  bool hasMoreRequests = true;
  String? selectDepartment;
  String? getRequestErrorMessage;
  String? getRequestCommentErrorMessage;
  String? getRequestTypeErrorMessage;
  String? errorAddCommentMessage;
  String? errorAddRequestMessage;
  GetOneRequestModel? getOneRequestModel;
  final picker = ImagePicker();
  bool hasMore = true;
  final ScrollController controller = ScrollController();
  final int expectedPageSize = 9;
  int pageNumber = 1;
  int count = 0;
  Set<int> commentIds = {};
  XFile? XImageFileAttachmentPersonal;
  File? attachmentPersonalImage;
  List listAttachmentPersonalImage = [];
  List<XFile> listXAttachmentPersonalImage = [];
  List requests = [];
  List requestTypes = [];
  List newComments = [];
  List comments = [];
  List newRequests = [];
  int currentPage = 1;
  final int itemsCount = 9;
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
    await getRequest(page : 1,context);
  }
  Future<void> getRequest(BuildContext context, {int? page}) async {
    if(page != null){currentPage = page;}
    print("currentPage is --> $currentPage}");
    isGetRequestLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/csrequests/entities-operations",
        context: context, // Pass this explicitly only if necessary
        query: {
          "itemsCount": itemsCount,
          "page": page ?? currentPage,
        },
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
        newRequests = response.data['data'] ?? [];
        if (page == 1) {
          requests.clear(); // Clear only when loading the first page
        }
        if (newRequests.isNotEmpty) {
          requests.addAll(newRequests);
          print("LENGTH IS --> ${newRequests.length}");
          if (hasMore) currentPage++;
        } else {
          hasMoreRequests = false; // No more data to fetch
        }

        isGetRequestSuccess = true;
      }
      isGetRequestLoading = false;
      notifyListeners();
    } catch (error) {
      getRequestErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg: getRequestErrorMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isGetRequestLoading = false;
      notifyListeners();
    }
  }
  Future<void> getOneRequest(BuildContext context, id) async {
    isGetRequestLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/csrequests/entities-operations/$id",
        query: {
          "with" : "ptype_id"
        },
        context: context,
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
        getOneRequestModel = GetOneRequestModel.fromJson(response.data);
      }
      isGetRequestLoading = false;
      notifyListeners();
    } catch (error) {
      getRequestErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg: getRequestErrorMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isGetRequestLoading = false;
      notifyListeners();
    }
  }
  Future<void> getRequestType(BuildContext context) async {
    isGetRequestTypeLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/csrequests-type/entities-operations",
        context: context,
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
        isGetRequestTypeSuccess = true;
        requestTypes = response.data['data'];
      }
      isGetRequestTypeLoading = false;
      notifyListeners();
    } catch (error) {
      getRequestTypeErrorMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg: getRequestTypeErrorMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isGetRequestTypeLoading = false;
      notifyListeners();
    }
  }
  Future<void> getRequestComment(BuildContext context, id, {pages, bool? isNewPage,}) async {
    if(pages == null){
      pages = pageNumber;
    }
    if(pageNumber == null){
      pageNumber = pages;
    }
    isGetRequestCommentLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/csrequests/entities-operations/$id/comments",
        context: context,
        query: {
          "page": pages ?? pageNumber,
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
        isGetRequestCommentSuccess = true;
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

          if (hasMore) pageNumber++;
        }
        getRequestCommentModel = GetRequestCommentModel.fromJson(response.data);
        print("COMMENTS --> ${comments.length}");
      }
      isGetRequestCommentLoading = false;
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
      isGetRequestCommentLoading = false;
      notifyListeners();
    }
  }
  Future<void> addComment(BuildContext context, {required String id, List<XFile>? images, String? voicePath}) async {
      if(images == null  && voicePath == null && contentController.text.isEmpty){
        print("NULL COMMENT");
        return;
      }
    isAddCommentLoading = true;
    notifyListeners();

    try {
      var response;
      print("Voice Path: $voicePath");

      // Check if we have either images or a voice file to send
      if (images != null || voicePath != null) {
        print("Uploading media...");

        FormData formData = FormData.fromMap({
          if (contentController.text.isNotEmpty) "content": contentController.text,
          if (images != null && images.isNotEmpty)
            "images[]": await Future.wait(images.map(
                  (file) async => await MultipartFile.fromFile(file.path, filename: file.name),
            ).toList()),
          if (voicePath != null && File(voicePath).existsSync())
            "sounds": await MultipartFile.fromFile(voicePath, filename: "recorded_audio.m4a"),
        });

        response = await DioHelper.postFormData(
          url: "/csrequests/entities-operations/$id/comments",
          context: context,
          formdata: formData,
        );
      } else {
        response = await DioHelper.postData(
          url: "/csrequests/entities-operations/$id/comments",
          context: context,
          data: {
            if (contentController.text.isNotEmpty) "content": contentController.text,
          },
        );
      }

      if (response.data['status'] == false) {
        Fluttertoast.showToast(
          msg: response.data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        isAddCommentSuccess = true;
        Fluttertoast.showToast(
          msg: response.data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        contentController.clear();
        // Refresh comments after successful upload
        getRequestCommentModel = null;
       // getRequestComment(context, id);
      }
    } catch (error) {
      errorAddCommentMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();

      Fluttertoast.showToast(
        msg: errorAddCommentMessage!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isAddCommentLoading = false;
      notifyListeners();
    }
  }
  Future<void> addRequest(BuildContext context, {List<XFile>? images}) async {
  isAddRequestLoading = true;
    notifyListeners();
    var response;
    FormData formData = FormData.fromMap({
      if(subjectController.text != null && subjectController.text.isNotEmpty)"title" : subjectController.text,
      if(detailsController.text != null && detailsController.text.isNotEmpty) "content" : detailsController.text,
      "type_id" : selectDepartment.toString(),
      "main_thumbnail[]": images != null
          ? await Future.wait(
          images.map((file) async => await MultipartFile.fromFile(file.path, filename: file.name))
      )
          : [],
    });
    try {
      if(images != null && images.isNotEmpty){
        response = await DioHelper.postData(
            url: "/rm_postcontrol/v1/add_request",
            context: context,
            data: formData
        );
      }else{
        response = await DioHelper.postData(
            url: "/rm_postcontrol/v1/add_request",
            context: context,
            data: {
              if(subjectController.text != null && subjectController.text.isNotEmpty) "title" : subjectController.text,
              if(detailsController.text != null && detailsController.text.isNotEmpty) "content" : detailsController.text,
              "type_id" : selectDepartment.toString(),
             }
        );
      }
      if(response.data['status']== false){
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
        isAddRequestSuccess = true;
        await getRequest(context, page: 1);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SuccessfulSendRequestBottomsheet();
          },
        );
      }
      isAddRequestLoading = false;
      notifyListeners();
    } catch (error) {
      errorAddRequestMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorAddRequestMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isAddRequestLoading = false;
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
