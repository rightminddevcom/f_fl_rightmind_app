import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_sizes.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/modules/more/views/blog/controller/blog_controller.dart';
import 'package:cpanal/modules/more/views/blog/widget/blog_list_view_item.dart';
import 'package:shimmer/shimmer.dart';

class BlogScreen extends StatefulWidget {
  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final notificationProvider = Provider.of<BlogProviderModel>(context, listen: false);
    notificationProvider.getBlog(context, page: 1); // Load initial notifications
    _scrollController.addListener(() {
      print("Current scroll position: ${_scrollController.position.pixels}");
      print("Max scroll extent: ${_scrollController.position.maxScrollExtent}");

      if ((_scrollController.position.maxScrollExtent - _scrollController.position.pixels).abs() < 10 &&
          !notificationProvider.isGetBlogLoading &&
          notificationProvider.hasMoreBlogs) {
        print("BOTTOM BOTTOM");
        notificationProvider.getBlog(context, page: notificationProvider.currentPage);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BlogProviderModel>(
      builder: (context, notificationProviderModel, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffFFFFFF),
            body: SingleChildScrollView(
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
                          AppStrings.blogCenter.tr().toUpperCase(),
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
                      itemCount:(notificationProviderModel.isGetBlogLoading && notificationProviderModel.currentPage ==1 )? 5 : notificationProviderModel.blogs.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) =>
                      (notificationProviderModel.isGetBlogLoading&& notificationProviderModel.currentPage ==1)?
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
                      )
                          :
                      BlogListViewItem(
                        blog: notificationProviderModel.blogs,
                        index: index ,)
                      ,
                    ),
                  ),
                  if(notificationProviderModel.isGetBlogLoading&& notificationProviderModel.currentPage !=1)const SizedBox(height: 10,),
                  if(notificationProviderModel.isGetBlogLoading&& notificationProviderModel.currentPage !=1) const Center(child: CircularProgressIndicator(),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
