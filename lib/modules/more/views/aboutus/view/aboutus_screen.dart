import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/more/views/aboutus/logic/aboutus_logic.dart';
import 'package:cpanal/modules/more/views/aboutus/view/main_logo_and_title_widget.dart';
import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
import 'package:cpanal/utils/styles.dart';
import 'package:cpanal/utils/tab_bar_widget.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  List<String> taps = [AppStrings.aboutUss.tr(),
    AppStrings.history.tr(),
    //AppStrings.certificates.tr(),
    AppStrings.partners.tr()];
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AboutUsLogicProvider()..getAboutUs(context),
      child: Consumer<AboutUsLogicProvider>(
        builder: (context, value, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/png/contact_back.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      AppStrings.aboutComapny.tr().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  body: Column(
                    children: [
                      const MainLogoAndTitleWidget(),
                      const SizedBox(
                        height: 40,
                      ),
                      if (value.aboutUsModel != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: (selectIndex == 0)
                              ? SizedBox(
                            height: MediaQuery.sizeOf(context)
                                .height *
                                0.45,
                                child: SingleChildScrollView(
                                    child: Html(
                                        shrinkWrap: true,
                                        data: value.aboutUsModel!.page!.content,
                                        style: TextsStyles.htmlStyles),
                                  ),
                              )
                              : (selectIndex == 1)
                                  ? SingleChildScrollView(
                                    child:Html(
                                        data: value.aboutUsModel!.page!.history!,
                                        style: TextsStyles.htmlStyles),
                                  )
                                  // : (selectIndex == 2)
                                  //     ? Container(
                                  //         height: MediaQuery.sizeOf(context)
                                  //                 .height *
                                  //             0.45,
                                  //         child: GridView.builder(
                                  //           gridDelegate:
                                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                                  //             crossAxisCount:
                                  //                 3, // 3 items per row
                                  //             mainAxisSpacing: 16.0,
                                  //             crossAxisSpacing: 16.0,
                                  //             childAspectRatio:
                                  //                 1, // Square aspect ratio
                                  //           ),
                                  //           itemCount: value.aboutUsModel!
                                  //               .page!.certificates!.length,
                                  //           itemBuilder: (context, index) {
                                  //             return Container(
                                  //               decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         12),
                                  //                 boxShadow: [
                                  //                   BoxShadow(
                                  //                     color: Colors.black
                                  //                         .withOpacity(0.1),
                                  //                     blurRadius: 8,
                                  //                     offset:
                                  //                         const Offset(0, 4),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               child: Padding(
                                  //                   padding:
                                  //                       const EdgeInsets.all(
                                  //                           12.0),
                                  //                   child: CachedNetworkImage(
                                  //                     imageUrl: value
                                  //                             .aboutUsModel!
                                  //                             .page!
                                  //                             .certificates![
                                  //                                 index]
                                  //                             .file ??
                                  //                         "",
                                  //                     fit: BoxFit.cover,
                                  //                     placeholder: (context,
                                  //                             url) =>
                                  //                         const ShimmerAnimatedLoading(),
                                  //                     errorWidget: (context,
                                  //                             url, error) =>
                                  //                         const Icon(
                                  //                       Icons
                                  //                           .image_not_supported_outlined,
                                  //                       size: AppSizes.s32,
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                   )),
                                  //             );
                                  //           },
                                  //         ),
                                  //       )
                                      : (selectIndex == 2)
                                          ? Container(
                                              height:
                                                  MediaQuery.sizeOf(context)
                                                          .height *
                                                      0.45,
                                              child: GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      3, // 3 items per row
                                                  mainAxisSpacing: 16.0,
                                                  crossAxisSpacing: 16.0,
                                                  childAspectRatio:
                                                      1, // Square aspect ratio
                                                ),
                                                itemCount: value.aboutUsModel!
                                                    .page!.partners!.length,
                                                itemBuilder:
                                                    (context, index) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.1),
                                                          blurRadius: 8,
                                                          offset:
                                                              const Offset(
                                                                  0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: value
                                                                  .aboutUsModel!
                                                                  .page!
                                                                  .partners![
                                                                      index]
                                                                  .file ??
                                                              "",
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const ShimmerAnimatedLoading(),
                                                          errorWidget:
                                                              (context, url,
                                                                      error) =>
                                                                  const Icon(
                                                            Icons
                                                                .image_not_supported_outlined,
                                                            size:
                                                                AppSizes.s32,
                                                            color:
                                                                Colors.white,
                                                          ),
                                                        )),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
                        )
                    ],
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: defaultTapBarItem(
                      items: taps,
                      tapBarItemsWidth: MediaQuery.sizeOf(context).width * 0.95,
                      selectIndex: selectIndex,
                      onTapItem: (index) {
                        setState(() {
                          selectIndex = index;
                        });
                      },
                    ),
                  ),
                  extendBody: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
