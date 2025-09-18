import 'dart:convert';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_constants.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/cpanel/email_account/create_multi_accounts_screen.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:cpanal/modules/cpanel/widget/auto_res/create_auto_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_account/create_email_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_account/create_multi_email_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_account/delete_account_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_account/edit_email_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_account/search_account_bottomsheet.dart';
import 'package:cpanal/modules/cpanel/widget/email_forward/create_forward_bottom_sheet.dart';
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

class EmailAccountScreen extends StatefulWidget {
  List? permissions = [];
  final String? name;
  final String? dominId;
  EmailAccountScreen({this.name, this.dominId, this.permissions});

  @override
  State<EmailAccountScreen> createState() => _EmailAccountScreenState();
}

class _EmailAccountScreenState extends State<EmailAccountScreen> {
  List<Email> emails = [];
  bool isSearch = false;
  List<Email> selectedEmails = [];
  TextEditingController searchController = TextEditingController();
  bool isSelectionMode = false;
  late ScrollController _scrollController;
  late final EmailAccountProvider emailProvider;
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
    await emailProvider.getEmails(
      context,
      actionType: "email_account",
      domainId: widget.dominId,
    ).then((_) {
      setState(() {
        emails = AppConstants.accountsEmailsFilter!
            .map((e) => Email(e['email'], "Unrestricted", "${e['humandiskquota']} / ${e['humandiskused']}"))
            .toList();
      });
    });
  }
  @override
  void initState() {
    super.initState();
    emailProvider = EmailAccountProvider();
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
        AppConstants.accountsEmailsFilter!.isNotEmpty) {
      emailProvider.getEmails(
        context,
        actionType: "email_account",
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

    return ChangeNotifierProvider<EmailAccountProvider>.value(
      value: emailProvider,
      child: Consumer<EmailAccountProvider>(
        builder: (context, value, child) {
          if(value.isSuccess == true){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              value.getEmails(context, actionType: "email_account",
                domainId: widget.dominId,
              );
            });
          }
          return TemplatePage(
            pageContext: context,
            title: AppStrings.emailAccounts.tr().toUpperCase(),
            onRefresh: () async {
              emailProvider.pageNumber = 1;
              AppConstants.accountsEmailsFilter!.clear();
              await emailProvider.getEmails(context, actionType: "email_account", domainId: widget.dominId);
              await emailcickle();
            },
            actions: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.s10),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SearchAccountBottomSheet(
                        onSearch: (query) {
                          
                          final allEmails = emailProvider.accountsEmails;

                          if (query == null || query.trim().isEmpty) {
                            AppConstants.accountsEmailsFilter = allEmails;
                          } else {
                            AppConstants.accountsEmailsFilter = allEmails.where((item) {
                              final email = item['email']?.toString().toLowerCase() ?? '';
                              return email.contains(query.toLowerCase());
                            }).toList();
                          }

                          setState(() {
                            emails = AppConstants.accountsEmailsFilter!
                                .map((e) => Email(e['email'], "Unrestricted", "${e['humandiskquota']} / ${e['humandiskused']}"))
                                .toList();
                          });
                        },
                      ),
                    );
                  },

                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffB289FF)),
                    child: const Icon(Icons.search, color: Colors.white, size: AppSizes.s18),
                  ),
                ),
              )
            ],
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
                        Navigator.pop(context);                      },
                      child: Text(widget.name!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark))),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);                      },
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
                    AppStrings.email_accounts_description.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                  ),
                  const SizedBox(height: 15),
                  if (selectedEmails.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            "${AppStrings.select.tr().toUpperCase()} ${selectedEmails.length} ${AppStrings.email.tr().toUpperCase()}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: ()async{
                              selectedEmails.clear();
                             await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: EditEmailBottomSheet(emails:  accountsPayload, domainId: widget.dominId.toString(), multi: true,),
                                ),
                              );
                             await emailcickle();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: SvgPicture.asset("assets/images/svg/edit.svg"),
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: ()async{
                              selectedEmails.clear();
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: DeleteAccountBottomSheet(emails:  accountsPayload, domainId: widget.dominId.toString(),
                                  multi: true,
                                  ),
                                ),
                              );
                              await emailcickle();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child:   SvgPicture.asset("assets/images/svg/delete.svg") ,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  ListView.separated(
                    itemCount: value.isLoading && value.pageNumber == 1 ? 3 : AppConstants.accountsEmailsFilter!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final safeContext = context; // ✅ هذا هو الـ context الآمن

                      if (value.isLoading && value.pageNumber == 1) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(height: 100, width: double.infinity, color: Colors.white),
                        );
                      }

                      final email = emails[index];
                      return GestureDetector(
                        onLongPress: () => onLongPress(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 1))],
                          ),
                          child: Slidable(
                            key: ValueKey(AppConstants.accountsEmailsFilter![index]['email']),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.6,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) async{
                                    selectedEmails.clear();
                                   await showModalBottomSheet(
                                      context: safeContext,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                        child: EditEmailBottomSheet(
                                          domainId: widget.dominId,
                                          multi: false,
                                          email: AppConstants.accountsEmailsFilter![index]['email'],
                                        ),
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
                                  onPressed: (_) {
                                    value.getWebview(context, domainId: widget.dominId, username: AppConstants.accountsEmailsFilter![index]['email']);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xffE93F81),
                                      shape: BoxShape.circle,
                                    ),
                                    child: value.isWebLoading == false ?SvgPicture.asset("assets/images/svg/swip_view.svg", fit: BoxFit.scaleDown) : CircularProgressIndicator(),
                                  ),
                                ),
                                CustomSlidableAction(
                                  onPressed: (actionContext) async {
                                    // ✅ هنا لازم نستعمل safeContext الآمن
                                    final RenderBox button = actionContext.findRenderObject() as RenderBox;
                                    final RenderBox overlay = Overlay.of(safeContext).context.findRenderObject() as RenderBox;
                                    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);

                                    final selected = await showMenu<int>(
                                      context: safeContext,
                                      position: RelativeRect.fromLTRB(
                                        offset.dx,
                                        offset.dy,
                                        overlay.size.width - offset.dx - 40,
                                        overlay.size.height - offset.dy,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      items: [
                                       if(widget.permissions!.contains("email_autoresponders")) PopupMenuItem(
                                          value: 0,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/images/svg/menu_edit.svg", fit: BoxFit.scaleDown),
                                              SizedBox(width: 10),
                                              Text(AppStrings.autoresponders.tr(),
                                                style: const TextStyle(
                                                  color: Color(AppColors.dark),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(widget.permissions!.contains("email_forwarders"))PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/images/svg/menu_forward.svg", fit: BoxFit.scaleDown),
                                              SizedBox(width: 10),
                                              Text(AppStrings.forwardEmail.tr(),
                                                style: TextStyle(
                                                  color: Color(AppColors.dark),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Container(
                                            color: Colors.pink.withOpacity(0.1),
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset("assets/images/svg/menu_delete.svg", fit: BoxFit.scaleDown),
                                                SizedBox(width: 10),
                                                Text(AppStrings.deleteEmail.tr(),
                                                  style: TextStyle(
                                                    color: Color(AppColors.dark),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );

                                    if (selected == null || !safeContext.mounted) return;

                                    if (selected == 0) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: CreateAutoBottomSheet(dominId: widget.dominId,dominName: widget.name, email: AppConstants.accountsEmailsFilter![index]['email'],),
                                        ),
                                      );
                                    } else if (selected == 1) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: CreateEmailFowardBottomSheet(
                                            dominId: widget.dominId,
                                            domain: false,
                                            email: AppConstants.accountsEmailsFilter![index]['email'],
                                            dominName: widget.name, actionType: "emails",),
                                        ),
                                      );
                                    } else if (selected == 2) {
                                      selectedEmails.clear();
                                     await showModalBottomSheet(
                                        context: safeContext,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                          child: DeleteAccountBottomSheet(
                                            domainId: widget.dominId,
                                            multi: false,
                                            email: AppConstants.accountsEmailsFilter![index]['email'],
                                          ),
                                        ),
                                      );
                                     await emailcickle();
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(AppColors.dark),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset("assets/images/svg/swip_more.svg", fit: BoxFit.scaleDown),
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: ()async{
                                selectedEmails.clear();
                                await showModalBottomSheet(
                                  context: safeContext,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                    child: EditEmailBottomSheet(
                                      domainId: widget.dominId,
                                      multi: false,
                                      email: AppConstants.accountsEmailsFilter![index]['email'],
                                    ),
                                  ),
                                );
                                await emailcickle();
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppConstants.accountsEmailsFilter![index]['email'],
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset("assets/images/svg/lock.svg", color: AppConstants.accountsEmailsFilter![index]['suspended_login'] == 0 || AppConstants.accountsEmailsFilter![index]['suspended_login'] == null? Colors.green : Color(0xffEB4335)),
                                            const SizedBox(width: 5),
                                            Text(
                                              AppConstants.accountsEmailsFilter![index]['suspended_login'] == 0 || AppConstants.accountsEmailsFilter![index]['suspended_login'] == null ? AppStrings.unrestricted.tr() : AppStrings.restricted.tr(),
                                              style: TextStyle(color: AppConstants.accountsEmailsFilter![index]['suspended_login'] == 0 || AppConstants.accountsEmailsFilter![index]['suspended_login'] == null? Colors.green : Color(0xffEB4335), fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            SvgPicture.asset("assets/images/svg/speed.svg"),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${AppConstants.accountsEmailsFilter![index]['humandiskused']} / ${AppConstants.accountsEmailsFilter![index]['humandiskquota']}",
                                              style: const TextStyle(color: Color(AppColors.primary), fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedEmails.any((e) => e.address == AppConstants.accountsEmailsFilter![index]['email']))
                                    const Icon(Icons.check_circle, color: Colors.green),
                                ],
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
                  onPressed: () async{
                   await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: CreateEmailBottomSheet(dominId: widget.dominId,dominName: widget.name,multi: false,),
                      ),
                    );
                    await emailcickle();
                  },
                  backgroundColor: Colors.pink,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () async{
                    value.accountsMulti.clear();
                    setState(() {});
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMultiAccountsScreen(
                      dominId: widget.dominId,
                      name: widget.name,
                    ),));
                    await emailcickle();
                   // await showModalBottomSheet(
                   //    context: context,
                   //    isScrollControlled: true,
                   //    backgroundColor: Colors.transparent,
                   //    builder: (_) => Padding(
                   //      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                   //      child: CreateMultiEmailBottomSheet(dominId: widget.dominId, dominName: widget.name,),
                   //    ),
                   //  );
                   // await emailcickle();
                  },
                  backgroundColor: Colors.pink,
                  child: const Column(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
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
class EmailAccountExtra {
  final Offset? begin;
  final List? permissions;

  EmailAccountExtra({this.begin, this.permissions});
}
