import 'dart:convert';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/widget/email_filter/create_filter_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_filter/delete_filter_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_filter/edit_filter_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common_modules_widgets/template_page.widget.dart';
import '../../../../constants/app_sizes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../choose_domain/choose_domin_screen.dart';
import '../../more/views/more_screen.dart';

class FilterEmailScreen extends StatefulWidget {
  final String? name;
  final String? dominId;
  final String? email;
  FilterEmailScreen({this.name, this.dominId, this.email});

  @override
  State<FilterEmailScreen> createState() => _FilterEmailScreenState();
}

class _FilterEmailScreenState extends State<FilterEmailScreen> {
  List<Email> emails = [];
  List<Email> selectedEmails = [];
  bool isSelectionMode = false;
  late ScrollController _scrollController;
  late final EmailFilterProvider emailProvider;
  List<String> get selectedAccountsDeleted =>
      selectedEmails.map((e) => e.address).toList();
  var accountsPayload;
  void printSelectedAccounts() {
    accountsPayload = {
      "accounts": selectedEmails.map((e) => e.address).toList(),
    };
    print(jsonEncode(accountsPayload));
  }
  void onLongPress(int index) {
    setState(() {
      isSelectionMode = true;
      emails[index].isSelected = true;
      selectedEmails.add(emails[index]);
      printSelectedAccounts(); // ✅ هنا
    });
  }

  void onTap(int index) {
    if (isSelectionMode) {
      setState(() {
        emails[index].isSelected = !emails[index].isSelected;
        if (emails[index].isSelected) {
          selectedEmails.add(emails[index]);
        } else {
          selectedEmails.removeWhere((element) => element.address == emails[index].address);
        }
        if (!emails.any((e) => e.isSelected)) {
          isSelectionMode = false;
        }
        printSelectedAccounts();
      });
    }
  }
  emailcickle()async{
    await emailProvider.getEmailFilter(actionType: "email_account",
      context,
      username: widget.email,
      domainId: widget.dominId,
    );
  }
  @override
  void initState() {
    super.initState();
    emailProvider = EmailFilterProvider();
    _scrollController = ScrollController();
    emailcickle();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent == 0) return;

    final isCloseToBottom = position.pixels >= position.maxScrollExtent - 200;
    if (isCloseToBottom &&
        !emailProvider.isLoading &&
        emailProvider.hasMore &&
        emailProvider.emailFilter.isNotEmpty) {
      emailProvider.getEmailFilter(actionType: "email_account",
        username: widget.email,
        context,
        domainId: widget.dominId,
        isNewPage: true,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var jsonString = CacheHelper.getString("US1");
    if (jsonString != null && jsonString.isNotEmpty) {
      var gCache = json.decode(jsonString);
      UserSettingConst.userSettings = UserSettingsModel.fromJson(gCache);
    }

    return ChangeNotifierProvider<EmailFilterProvider>.value(
      value: emailProvider,
      child: Consumer<EmailFilterProvider>(
        builder: (context, value, child) {
          return TemplatePage(
            pageContext: context,
            title: AppStrings.emailFilters.tr().toUpperCase(),
            onRefresh: () async {
              emailProvider.pageNumber = 1;
              emailProvider.emailFilter.clear();
              await emailProvider.getEmailFilter(actionType: "email_account",context,  domainId: widget.dominId, username: widget.email);
            },
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 82,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffC9CFD2).withOpacity(0.5),
                    blurRadius: AppSizes.s5,
                    spreadRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(35),
              ),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        },
                      child: Text(widget.name!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark))),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        },
                      child: SvgPicture.asset("assets/images/svg/cpanal_bottom_nav_icon.svg")),
                  const Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MoreScreen(),));
                    },
                    child: const Icon(Icons.menu, color: Color(AppColors.primary)),
                  )
                ],
              ),
            ),
            body: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSizes.s12),
                children: [
                   Text(
                    AppStrings.email_filters_description.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                  ),
                  const SizedBox(height: 15),
                  ListView.separated(
                    itemCount: value.isLoading && value.pageNumber == 1 ? 3 : value.emailFilter.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final safeContext = context;
                      if (value.isLoading && value.pageNumber == 1) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(height: 100, width: double.infinity, color: Colors.white),
                        );
                      }
                      final email = value.emailFilter[index];
                      return GestureDetector(
                        // onLongPress: () => onLongPress(index),
                        // onTap: () => onTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 1))],
                          ),
                          child: Slidable(
                            key: ValueKey(value.emailFilter[index]['dest']),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.6,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) async{
                                    await showModalBottomSheet(
                                      context: safeContext,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                        child: EditEmailBottomSheet(dominId: widget.dominId.toString(), object: value.emailFilter[index],dominName: widget.name.toString(), email: widget.email,),
                                      ),
                                    );
                                    await emailcickle();
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA372FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset("assets/images/svg/swip_edit.svg", fit: BoxFit.scaleDown),
                                  ),
                                ),
                                CustomSlidableAction(
                                  onPressed: (_)async {
                                   await showModalBottomSheet(
                                      context: safeContext,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                        child: DeleteAccountBottomSheet(
                                          email: widget.email,
                                            dominId: widget.dominId,dest: value.emailFilter[index]['filtername'],
                                            actionType: "email_account"
                                        ),
                                      ),
                                    );
                                   await emailcickle();
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE93F81),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset("assets/images/svg/menu_delete.svg", fit: BoxFit.scaleDown, color: Colors.white,),
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: ()async{
                                await showModalBottomSheet(
                                  context: safeContext,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                    child: EditEmailBottomSheet(dominId: widget.dominId.toString(), object: value.emailFilter[index],dominName: widget.name.toString(), email: widget.email,),
                                  ),
                                );
                                await emailcickle();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 1))],
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.emailFilter[index]['filtername'],
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  if (value.isLoading && value.pageNumber != 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: ()async {
                   await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: CreateEmailBottomSheet(dominId: widget.dominId,dominName: widget.name, email: widget.email),
                      ),
                    );
                   await emailcickle();
                  },
                  backgroundColor: Colors.pink,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Email {
  final String address;
  final String status;
  final String usage;
  bool isSelected;
  Email(this.address, this.status, this.usage, {this.isSelected = false});
}
