import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common_modules_widgets/custom_elevated_button.widget.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controller/device_sys/device_controller.dart';
import '../../../../general_services/app_config.service.dart';
import '../../../../general_services/layout.service.dart';

class UserDeviceScreen extends StatefulWidget {
  @override
  State<UserDeviceScreen> createState() => _UserDeviceScreenState();
}

class _UserDeviceScreenState extends State<UserDeviceScreen> {
  final ScrollController _scrollController = ScrollController();
  int? selectIndex;
  var appConfigServiceProvider;
  @override
  void initState() {
    super.initState();
    appConfigServiceProvider =
    Provider.of<AppConfigService>(context, listen: false);
    final deviceControllerProvider = Provider.of<DeviceControllerProvider>(context, listen: false);
    deviceControllerProvider.getDevices(context: context); // Load initial notifications
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceControllerProvider>(
      builder: (context, value, child) {
        if(value.isDeleteSuccess == true){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            value.getDevices(context: context);
          });
          value.isDeleteSuccess = false;
        }
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffFFFFFF),
            body: Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: kIsWeb? 900 : double.infinity,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 90,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Color(0xff224982)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              AppStrings.userDevices.tr().toUpperCase(),
                              style: const TextStyle(color: Color(0xff224982), fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.transparent),
                                onPressed: (){}
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.s20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index)=> const SizedBox(height: 18,),
                          shrinkWrap: true,
                          reverse: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:(value.isLoading)? 5 : value.devices.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>
                          (value.isLoading)?
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: AppSizes.s12),
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: AppSizes.s15, vertical: AppSizes.s12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppSizes.s15),
                              ),
                              height: 100,  // Adjust height to match your layout
                            ),
                          ) :
                          InkWell(
                            onTap: () {
                            },
                            child: Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: AppSizes.s15, vertical: AppSizes.s12),
                              decoration: BoxDecoration(
                                color: const Color(AppColors.textC5),
                                borderRadius: BorderRadius.circular(AppSizes.s15),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      spreadRadius: 0,
                                      offset: Offset(0, 1),
                                      blurRadius: 10)
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width : MediaQuery.sizeOf(context).width * 0.5,
                                    child: Text(
                                      "${value.devices[index]['browser'].toString()} (${value.devices[index]['os_version'].toString()})".toUpperCase(),
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff0D3B6F)),
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  if( appConfigServiceProvider.deviceInformation.deviceUniqueId == value.devices[index]['unique_id'].toString())Text(
                                   AppStrings.currentDevice.tr(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                  if( appConfigServiceProvider.deviceInformation.deviceUniqueId != value.devices[index]['unique_id'].toString())const Spacer(),
                                  if( appConfigServiceProvider.deviceInformation.deviceUniqueId != value.devices[index]['unique_id'].toString())GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          selectIndex = index;
                                        });
                                        value.deleteDevices(context: context, deviceId: value.devices[index]['id']);
                                      },
                                      child: (value.isDeleteLoading == true && selectIndex == index) ? const CircularProgressIndicator():const Icon(Icons.logout, color: Colors.red,))
                                ],
                              ),
                            ),
                          )
                          ,
                        ),
                      ),
                      const SizedBox(height: AppSizes.s20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: (value.isDeleteLoading == false) ?CustomElevatedButton(
                            titleSize: AppSizes.s14,
                            width: LayoutService.getWidth(context),
                            radius: AppSizes.s10,
                            backgroundColor: const Color(0xffFF0000),
                            title: AppStrings.logoutFromAllDevices.tr(),
                            onPressed: () async => await value.deleteDevices(context: context, deviceId: null)
                          ) : const CircularProgressIndicator()
                        ),
                      ),
                     ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
