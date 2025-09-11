import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_screen.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';

class AppbarProfileContainer extends StatelessWidget {
   String? imageUrl;
   String? userName;
   String? userRole;
   AppbarProfileContainer({this.userName, this.imageUrl, this.userRole});

  @override
  Widget build(BuildContext context) {

    String formatName(String fullName) {
      List<String> nameParts = fullName.split(' ');
      if (nameParts.length < 2) {
        return fullName; // Return the full name if no last name is provided.
      }
      String firstName = nameParts[0];
      String lastInitial = nameParts[1][0].toUpperCase();
      return (CacheHelper.getString("lang") == "ar") ?'.$firstName $lastInitial' :'$firstName $lastInitial.';
    }
    return Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(AppColors.primary), Color(AppColors.dark)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(63),
                  child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                      placeholder: (context, url) => const ShimmerAnimatedLoading(
                        width: 63.0,
                        height: 63,
                        circularRaduis: 63,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported_outlined,
                      )),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: MediaQuery.sizeOf(context!).width * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 23,
                    child: Text(
                      userName!.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins"),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                    height: 15,
                    child: Text(
                      userRole!.toUpperCase(),
                      style: TextStyle(
                          color: Color(0xffFFFFFF).withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins"),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(true),));
              },
              child: SvgPicture.asset(
                "assets/images/svg/notification.svg",
                color: Color(0xffFFFFFF),
                width: AppSizes.s30,
                height: AppSizes.s30,
              ),
            )
          ],
        ),
      );
    }
  }

