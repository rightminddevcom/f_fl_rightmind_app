import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/dio.dart';
import 'package:cpanal/models/points_condations_model.dart';
import 'package:cpanal/models/points_history_model.dart';

class PointsProvider with ChangeNotifier {
  PointsTermsAndConditionsModel? pointsTermsAndConditionsModel;
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController friendNameController = TextEditingController();
  bool isConditionLoading = false;
  bool isHistoryLoading = false;
  bool isRedeemPrizeLoading = false;
  bool isPrizeLoading = false;
  bool isAddFriendLoading = false;
  bool isHistorySuccess = false;
  bool isRedeemPrizeSuccess = false;
  bool isGetPrizeLoading = false;
  bool isAddFriendSuccess = false;
  bool isAddFriendContactSuccess = false;
  var selectPrize;
  String? errorConditionMessage;
  String? errorHistoryMessage;
  String? errorRedeemPrizeMessage;
  String? errorAddFriendMessage;
  String? errorPrizeMessage;
  HistoryModel? historyModel;
  bool hasMoreHistory = true;
  List history = [];
  List prizes = [];
  List newHistory = [];
  int currentPage = 1;
  int currentPageHistory = 1;
  final int itemsCount = 9;
  bool hasMore = true;
  final int expectedPageSize = 9;
  bool hasMoreData(int length) {
    if (length < expectedPageSize) {
      return false;
    } else {
      currentPage += 1;
      currentPageHistory += 1;
      return true;
    }
  }
  Future<void> getCondition(context) async {
    isConditionLoading = true;
    errorConditionMessage = null;
    notifyListeners();
    DioHelper.getData(
        url: "/rm_page/v1/show?slug=points-terms-and-conditions",
        context: context
    ).then((v){
      isConditionLoading = false;
      if(v.data['status'] == false){
        Fluttertoast.showToast(
            msg: v.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        pointsTermsAndConditionsModel = PointsTermsAndConditionsModel.fromJson(v.data);
      }
      notifyListeners();
    }).catchError((error){
      isConditionLoading = false;
      if (error is DioError) {
        errorConditionMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorConditionMessage = error.toString();
      }
      notifyListeners();
      Fluttertoast.showToast(
          msg: errorConditionMessage.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
  Future<void> getPrize(context) async {
    isGetPrizeLoading = true;
    errorPrizeMessage = null;
    notifyListeners();
    DioHelper.getData(
        url: "/prizes/entities-operations",
        context: context
    ).then((v){
      isGetPrizeLoading = false;
      if(v.data['status'] == false){
        Fluttertoast.showToast(
            msg: v.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        prizes = v.data['data'];
      }
      notifyListeners();
    }).catchError((error){
      isGetPrizeLoading = false;
      if (error is DioError) {
        errorPrizeMessage = error.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorPrizeMessage = error.toString();
      }
      notifyListeners();
      Fluttertoast.showToast(
          msg: errorPrizeMessage.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
  Future<void> getHistory(BuildContext context, {int? page}) async {
    if(page != null){currentPageHistory = page;}
    print("currentPage is --> $currentPageHistory}");
    isHistoryLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/rm_pointsys/v1/history",
        context: context,
        query: {
          "itemsCount": itemsCount,
          "page": page ?? currentPageHistory,
        },
      );
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
        newHistory = response.data['history'] ?? [];
        if (page == 1) {
          history.clear(); // Clear only when loading the first page
        }
        if (newHistory.isNotEmpty) {
          history.addAll(newHistory);
          print("LENGTH IS --> ${newHistory.length}");
          if (hasMore) currentPageHistory++;
        } else {
          hasMoreHistory = false; // No more data to fetch
        }
        isHistorySuccess = true;
      }
      notifyListeners();
    } catch (error) {
      errorHistoryMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorHistoryMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isHistoryLoading = false;
      notifyListeners();

    }
  }
  Future<void> addFriend(BuildContext context) async {
    isAddFriendLoading = true;
    if(countryCodeController.text.isEmpty){
      countryCodeController.text = "+20";
    }
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_pointsys/v1/add_new",
        context: context,
        data: {
          "items":[{
            "name":friendNameController.text,
            "country_code": countryCodeController.text,
            "phonesNumbers":[phoneController.text],
          }
          ]
        }
      );
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
        isAddFriendSuccess = true;
        countryCodeController.clear();
        phoneController.clear();
        friendNameController.clear();
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      isAddFriendLoading = false;
      notifyListeners();
    } catch (error) {
      errorHistoryMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorHistoryMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isAddFriendLoading = false;
      notifyListeners();

    }
  }
  Future<void> addFriendContact(BuildContext context, {contact}) async {
    isAddFriendLoading = true;
    if(countryCodeController.text.isEmpty){
      countryCodeController.text = "+20";
    }
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_pointsys/v1/add_new",
        context: context,
        data: contact
      );
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
        isAddFriendContactSuccess = true;
        countryCodeController.clear();
        phoneController.clear();
        friendNameController.clear();
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      isAddFriendLoading = false;
      notifyListeners();
    } catch (error) {
      errorHistoryMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorHistoryMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isAddFriendLoading = false;
      notifyListeners();

    }
  }
  Future<void> redeemPrize(BuildContext context, {id}) async {
    isRedeemPrizeLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.postData(
        url: "/rm_pointsys/v1/prizes",
        context: context,
        data: {
          "prize_id" : id
        });
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
        isRedeemPrizeSuccess = true;
        Fluttertoast.showToast(
            msg: response.data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      isRedeemPrizeLoading = false;
      notifyListeners();
    } catch (error) {
      errorRedeemPrizeMessage = error is DioError
          ? error.response?.data['message'] ?? 'Something went wrong'
          : error.toString();
      Fluttertoast.showToast(
          msg:errorRedeemPrizeMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isRedeemPrizeLoading = false;
      notifyListeners();

    }
  }
}
