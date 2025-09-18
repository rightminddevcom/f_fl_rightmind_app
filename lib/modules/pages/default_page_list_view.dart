import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';

class DefaultPageListView extends StatelessWidget {
  final List blog;
  final int index;
  var type;
  DefaultPageListView({super.key, required this.blog, required this.index, this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.defaultSinglePage.name,
            pathParameters: {'lang': context.locale.languageCode,
              "id" : "${blog[index]['id']}",
              "type" : type.toString()
            });
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
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3389EE)
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(63),
                  child: CachedNetworkImage(
                      imageUrl: (blog[index]['main_thumbnail'].isNotEmpty)?
                      blog[index]['main_thumbnail'][0]['file'] : "",
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
            gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (blog[index]['created_at'] != null) Text(
                    (blog[index]['created_at'] != null)?  "${blog[index]['created_at']}".toUpperCase() : "0",
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff606060)),
                  ),
                  if (blog[index]['created_at'] != null)  gapH4,
                  Padding(
                      padding: EdgeInsets.zero,
                      child: Text(
                        "${blog[index]['title'].toString()}".toUpperCase(),
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0D3B6F)),
                      )
                    // Html(
                    //     shrinkWrap: true,
                    //     data: "${blog[index]['title']}".toUpperCase(),
                    //     style: {
                    //       "p" : Style(
                    //           fontSize: FontSize(12),maxLines: 2,padding: HtmlPaddings.all(0),margin: Margins.all(0),
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(0xff0D3B6F)),
                    //     }
                    // ),

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
