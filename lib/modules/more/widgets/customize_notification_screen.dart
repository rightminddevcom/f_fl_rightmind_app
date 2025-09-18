import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/device_sys/device_controller.dart';
class CustomizeNotificationScreen extends StatefulWidget {
  @override
  State<CustomizeNotificationScreen> createState() => _CustomizeNotificationScreenState();
}

class _CustomizeNotificationScreenState extends State<CustomizeNotificationScreen> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceControllerProvider()..getDeviceSysGet(context: context),
      child: Consumer<DeviceControllerProvider>(
        builder: (context, value, child) {
          if(value.isSuccess == true){
            WidgetsBinding.instance.addPostFrameCallback((_) async{
              Navigator.pop(context);
            });
            value.isSuccess = false;
          }
          return (value.isLoading)?
          const SizedBox.shrink() :
          Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: kIsWeb ? 400 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.customizeNotifications.tr().toUpperCase(), style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0D3B6F)
                    ),),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchRow(
                          isLoginPageStyle: true,
                          value: value.notificationStatus,
                          onChanged: (newValue)  {
                            setState(() {
                              value.notificationStatus = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if(value.isLoading2)const Center(child: CircularProgressIndicator(),),
                    if(!value.isLoading2)SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: GestureDetector(
                        onTap: (){
                          value.getDeviceSysSet(
                            context: context,
                            state: value.notificationStatus,
                          );
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff0D3B6F),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/svg/apply_filter.svg"),
                              const SizedBox(width: 15,),
                              Text(
                                AppStrings.saveChanges.tr().toUpperCase(),
                                style:const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFFFFFF)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class SwitchRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? rightText;
  final String? leftText;
  final bool? isLoginPageStyle;

  const SwitchRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.rightText,
    this.leftText,
    this.isLoginPageStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isLoginPageStyle == true
        ? Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(fontSize: AppSizes.s14, fontWeight: FontWeight.w500)
        : Theme.of(context).textTheme.displaySmall;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.deactivate.tr().toUpperCase(),
              style: const TextStyle(
                  fontSize: 11, color: Color(0xff224982), fontWeight: FontWeight.w500)),
          gapW8,
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xff224982),
            inactiveThumbColor: Colors.black,
          ),
          gapW8,
          Text(AppStrings.activation.tr().toUpperCase(),
              style: const TextStyle(
                  fontSize: 11, color: Color(0xff224982), fontWeight: FontWeight.w500)),

        ],
      ),
    );
  }
}

