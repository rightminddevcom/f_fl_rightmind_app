import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_details_screen.dart';
import 'package:cpanal/modules/more/views/notification/view/widget/notification_details_loading_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_images.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/routing/app_router.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';

class PainterNotificationListViewItem extends StatefulWidget {
  final List notifications;
  final int index;
  const PainterNotificationListViewItem({super.key, required this.notifications, required this.index});

  @override
  State<PainterNotificationListViewItem> createState() => _PainterNotificationListViewItemState();
}

class _PainterNotificationListViewItemState extends State<PainterNotificationListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.notifications[widget.index]['seen'] = true;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => SingleListDetailsScreen(
          id: widget.notifications[widget.index]['id'].toString(),
        ),));
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
                      imageUrl: (widget.notifications![widget.index]['main_thumbnail'].isNotEmpty)?
                      widget.notifications[widget.index]['main_thumbnail'][0]['file'] : "",
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
                  Text(
                    DateFormat("yyyy/MM/dd hh:mm a", context.locale.languageCode).format(DateTime.parse(widget.notifications[widget.index]['created_at'])),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff606060)),
                  ),
                  gapH4,
                  Text(widget.notifications[widget.index]['title'],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.notifications[widget.index]['seen'] == true? FontWeight.w300 : FontWeight.w700,
                      color: widget.notifications[widget.index]['seen'] == true? Colors.black.withOpacity(0.5):Color(0xff0D3B6F)),
                  )
                  // Html(
                  //     shrinkWrap: true,
                  //     data: "${notifications[index]['title']}",
                  //     style: {
                  //       "p": Style(
                  //           fontSize: FontSize(12),
                  //           fontWeight: FontWeight.w600,
                  //           color: Color(0xff0D3B6F)),
                  //     }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
