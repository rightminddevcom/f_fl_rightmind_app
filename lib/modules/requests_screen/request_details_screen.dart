  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:easy_localization/easy_localization.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
  import 'package:provider/provider.dart';
  import 'package:cpanal/constants/app_colors.dart';
  import 'package:cpanal/constants/app_sizes.dart';
  import 'package:cpanal/constants/app_strings.dart';
  import 'package:cpanal/controller/request_controller/request_controller.dart';
  import 'package:cpanal/modules/requests_screen/widget/request_audio_widget.dart';
  import 'package:cpanal/modules/requests_screen/widget/request_details_appbar_widget.dart';
  import 'package:cpanal/modules/requests_screen/widget/request_details_loading_screen.dart';
  import 'package:cpanal/modules/requests_screen/widget/request_details_send_comment.dart';
import 'package:cpanal/utils/componentes/general_components/view_image_gallery.dart';
  import 'package:cpanal/utils/custom_shimmer_loading/shimmer_animated_loading.dart';
  import 'package:cpanal/general_services/localization.service.dart';
import 'package:cpanal/utils/styles.dart';

  class RequestDetailsScreen extends StatefulWidget {
    var id;
    RequestDetailsScreen({required this.id});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  late RequestController requestController;
  late ScrollController _scrollController;
  Set<int> _loadedPages = {}; // Keep track of loaded pages
  final PageController _controller = PageController();
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      int newIndex = _controller.page?.round() ?? 0;
      if (_currentIndex != newIndex) {
        setState(() => _currentIndex = newIndex);
      }
    });
    requestController = RequestController();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        int nextPage = requestController.pageNumber; // Get the next page number

        if (!_loadedPages.contains(nextPage)) { // Check if the page was already loaded
          _loadedPages.add(nextPage); // Mark this page as loaded

          requestController.getRequestComment(
              context,
              widget.id,
              isNewPage: true
          );
        } else {
          print("Page $nextPage is already loaded. Skipping request.");
        }
      }
    });

  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller
    _controller.dispose();
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(create: (context) => RequestController()..getOneRequest(context, widget.id)..getRequestComment(context, widget.id),
      child: Consumer<RequestController>(
        builder: (context, value, child) {
          if(value.isAddCommentSuccess){
            print("ADDED SUCCESS");
          }
          return Scaffold(
            backgroundColor: Color(0xffFFFFFF),
            body: (value.getOneRequestModel != null && value.isGetRequestCommentLoading != true
                &&!value.isGetRequestCommentLoading)?SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RequestDetailsAppbarWidget(
                    getOneRequestModel: value.getOneRequestModel,
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Html(
                            shrinkWrap: true,
                            data: value.getOneRequestModel!.item!.content,
                            style: {
                              "h1":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(26),
                                fontWeight: FontWeight.w500,
                              ),"h2":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.w500,
                              ),"h3":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(22),
                                fontWeight: FontWeight.w500,
                              ),"h4":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.w500,
                              ),"h5":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(18),
                                fontWeight: FontWeight.w500,
                              ),"h6":Style(
                                color: const Color(AppColors.oC2Color),
                                fontSize: FontSize(16),
                                fontWeight: FontWeight.w500,
                              ),
                              "p": Style(
                                color: Color(0xff525252),
                                lineHeight: LineHeight(1.5),
                                fontSize: FontSize(12), // Adjust font size for better visibility
                                fontWeight: FontWeight.w400,
                              ), "ul": Style(
                                color: Color(0xff333333),
                                lineHeight: LineHeight(1.5),
                                fontSize: FontSize(18), // Adjust font size for better visibility
                                fontWeight: FontWeight.w500,
                              ),"li": Style(
                                color: Color(0xff333333),
                                lineHeight: LineHeight(1.5),
                                fontSize: FontSize(18), // Adjust font size for better visibility
                                fontWeight: FontWeight.w500,
                              ),"ol": Style(
                                color: Color(0xff333333),
                                lineHeight: LineHeight(1.5),
                                fontSize: FontSize(18), // Adjust font size for better visibility
                                fontWeight: FontWeight.w500,
                              ),"*": Style(
                                color: Color(0xff333333),
                                lineHeight: LineHeight(1.5),
                                fontSize: FontSize(14), // Adjust font size for better visibility
                                fontWeight: FontWeight.w500,
                              ),
                            }),
                        SizedBox(height: 10,),
                        if(value.getOneRequestModel!.item!.mainThum != null &&value.getOneRequestModel!.item!.mainThum!.isNotEmpty)Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                           if(value.getOneRequestModel!.item!.mainThum!.length > 1) Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: PageView.builder(
                                    controller: _controller,
                                    itemCount: value.getOneRequestModel!.item!.mainThum!.length,
                                    itemBuilder: (context, index) {
                                      return  GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FullScreenImageViewer(
                                                  imageUrls: value.getOneRequestModel!.item!.mainThum!,
                                                  file: true,
                                                  initialIndex: index,
                                                  url: true,
                                                  thum: false,
                                                ),
                                              )
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.contain,
                                          imageUrl: value.getOneRequestModel!.item!.mainThum![index].file ?? "",
                                          placeholder: (context, url) =>
                                          const ShimmerAnimatedLoading(),
                                          errorWidget: (context, url, error) => const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: AppSizes.s32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 25, right: 40, left: 40),
                                    child: SizedBox(
                                      height: 20,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          reverse: false,
                                          physics: ClampingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) => AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            margin: EdgeInsets.symmetric(horizontal: 4),
                                            width: _currentIndex == index ? 12 : 8,
                                            height: _currentIndex == index ? 12 : 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentIndex == index ? Color(0xffFFFFFF) : Colors.grey,
                                            ),
                                          ), separatorBuilder: (context, index) => SizedBox(width: 5,),
                                          itemCount: value.getOneRequestModel!.item!.mainThum!.length),
                                    )
                                )
                              ],
                            ),
                            if(value.getOneRequestModel!.item!.mainThum!.length == 1) GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImageViewer(
                                        imageUrls: [""],
                                        one:  true,
                                        image: value.getOneRequestModel!.item!.mainThum![0].file, initialIndex: 1, url: false,
                                        
                                      ),
                                    )
                                );
                              },
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: value.getOneRequestModel!.item!.mainThum![0].file ?? "",
                                placeholder: (context, url) =>
                                const ShimmerAnimatedLoading(),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: AppSizes.s32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(strokeAlign: 1, color: Color(0xffDFDFDF))
                                  ),
                                ),
                              ),
                            ),
                            Text(AppStrings.lastedComments.tr().toUpperCase(), style: TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w500, color: Color(AppColors.dark))),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(strokeAlign: 1, color: Color(0xffDFDFDF))
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: MediaQuery.sizeOf(context).height * 0.42,
                          child: Column(
                            children: [
                               if(value.comments.isNotEmpty)SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.3,
                                child: ListView.separated(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics: ClampingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index){
                                      DateTime utcDateTime = DateTime.parse("${value.comments[index]['created_at']}");
                                      DateTime egyptDateTime = utcDateTime.add(Duration(hours: 2)); // Convert to Egypt time
                                      String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss", context.locale.languageCode).format(egyptDateTime);
                                      print("formattedDate is --> ${formattedDate}"); // This will display the time in 24-hour format

                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0C000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 1),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(63),
                                              child:  CachedNetworkImage(
                                                width: 63,
                                                height: 63,
                                                fit: BoxFit.cover,
                                                imageUrl: value.comments[index]['user']['avatar'] ?? "",
                                                placeholder: (context, url) =>
                                                const ShimmerAnimatedLoading(),
                                                errorWidget: (context, url, error) => const Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: AppSizes.s32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                                    child: Text(
                                                       "$formattedDate", maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500, fontSize: 12,color: Color(0xff5E5E5E)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  if(value.comments[index]['content'] != null)Text(
                                                    value.comments[index]['content'] ?? "",
                                                    style: TextStyle(color: Color(AppColors.black), fontSize: 12, fontWeight: FontWeight.w500),
                                                  ),
                                                  if(value.comments[index]['images'].isNotEmpty)Container(
                                                      width: 94,
                                                      height: 94,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Color(AppColors.primary),
                                                            width: 2
                                                        ),
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => FullScreenImageViewer(
                                                                initialIndex: 0,
                                                                imageUrls: [""],
                                                                one: true,
                                                                url: false,
                                                                image: value.comments[index]['images'][0]['file'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: CachedNetworkImage(
                                                          imageUrl: value.comments[index]['images'][0]['file'],
                                                          fit: BoxFit.cover,
                                                          width: 94,
                                                          height: 94,
                                                          placeholder: (context, url) =>
                                                          const ShimmerAnimatedLoading(),
                                                          errorWidget: (context, url, error) => const Icon(
                                                            Icons.image_not_supported_outlined,
                                                            size: AppSizes.s32,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  if(value.comments[index]['sounds'].isNotEmpty)VoiceMessageWidget(
                                                    audioUrl: value.comments[index]['sounds'][0]['file'] ,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(height: 5,),
                                    itemCount: value.comments.length
                                ),
                              ),
                              if(value.comments.isEmpty)Container(
                                alignment: Alignment.center,
                                height: MediaQuery.sizeOf(context).height * 0.3,
                                child: Center(
                                  child: Text(AppStrings.noCommentsFound.tr().toUpperCase(), style: TextStyle(fontSize: 18, color: Colors.black),),
                                ),
                              ),
                              if(value.isGetRequestCommentLoading == true && value.pageNumber != 1)Center(child: CircularProgressIndicator(),),
                              Spacer(),
                              SizedBox(height: 15),
                              if(value.getOneRequestModel!.item!.commentStatus!.key == "enable")RequestDetailsSendComment(widget.id),
                              if(value.getOneRequestModel!.item!.commentStatus!.key != "enable")Text(AppStrings.theCommentOnThisRequestHasBeenClosedByTheAdmin.tr(),
                              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  )
                ],
              ),
            ): RequestDetailsLoadingScreen(),
          );
        },
      ),
      );
    }
}
