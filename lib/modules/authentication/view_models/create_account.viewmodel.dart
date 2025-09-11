import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import '../../../constants/app_strings.dart';
import '../../../general_services/alert_service/alerts.service.dart';
import '../../../general_services/app_config.service.dart';
import '../auth_services/authentication.service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isEmailRegister = false;
  bool isRegisterSuccess = false;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }

  Future<void> createAccount({required BuildContext context, cityId, countryId, stateId, Function? making}) async {
    // await getDeviceSysSet(context: context);
    try {
      if (phoneController.text.isEmpty) {
        AlertsService.warning(
            context: context,
            message: AppStrings.phoneNumberIsRequired.tr(),
            title: AppStrings.phoneNumber.tr());
        return;
      }
      if (formKey.currentState?.validate() == true) {
        if(CacheHelper.getString("role") != "merchant"){ await _createNewAccount(
            phone: phoneController.text,
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
            mak: making,
            countryKey: countryCodeController.text.isEmpty
                ? '+20'
                : countryCodeController.text + phoneController.text,
            context: context,
            departmentId: 1);}
        else{
          await _createNewAccount(
              phone: phoneController.text,
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
              countryKey: countryCodeController.text.isEmpty
                  ? '+20'
                  : countryCodeController.text + phoneController.text,
              context: context,
              departmentId: 1);

        }
      } else {
        AlertsService.warning(
            context: context,
            message: AppStrings.formIsInvalid.tr(),
            title: AppStrings.formValidation.tr());
      }
      return;
    } catch (err, t) {
      debugPrint('Error :- $err in :- $t');
      AlertsService.warning(
          context: context,
          message: AppStrings.failedRegisterationPleaseTryAgain.tr(),
          title: AppStrings.failed.tr());

      return;
    }
  }

  Future<void> _createNewAccount(
      {required String name,
        required String phone,
        required String countryKey,
        required String password,
        required String email,
        required int departmentId,
        var mak,
        required BuildContext context}) async {
    final appConfigServiceProvider =
    Provider.of<AppConfigService>(context, listen: false);
    final result = await AuthenticationService.createAccount(
        context: context,
        name: name,
        phone: phone,
        countryKey: countryKey,
        password: password,
        email: email,
        departmentId: departmentId,
        deviceInformation: appConfigServiceProvider.deviceInformation.toMap());
    if (result.success) {
      Fluttertoast.showToast(
          msg: result.message!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      if(mak == null) Navigator.pop(context, result);
      if(mak != null){mak();}
      isRegisterSuccess = true;
    } else {
      AlertsService.error(
          title: AppStrings.failed.tr(),
          context: context,
          message: result.message ??
              AppStrings.failedRegisterationPleaseTryAgain.tr());

      return;
    }
  }
}
