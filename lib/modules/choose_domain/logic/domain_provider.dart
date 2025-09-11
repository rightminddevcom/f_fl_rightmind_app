import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/dio.dart';

class DomainProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;
  List domains = [];
  getUserDomains(context) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await DioHelper.getData(
        url: "/rm_cpanel/v1/user_domains",
        context: context,
      );
      isLoading = false;
      domains = response.data['domains'];
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

}
