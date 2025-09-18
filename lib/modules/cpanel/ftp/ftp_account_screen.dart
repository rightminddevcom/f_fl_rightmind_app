import 'dart:convert';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/constants/user_consts.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/models/settings/user_settings.model.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:cpanal/modules/cpanel/logic/ftp_provider.dart';
import 'package:cpanal/modules/cpanel/logic/ftp_provider.dart';
import 'package:cpanal/modules/cpanel/logic/ftp_provider.dart';
import 'package:cpanal/modules/cpanel/logic/ftp_provider.dart';
import 'package:cpanal/modules/cpanel/widget/ftp/create_ftp_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/ftp/delete_ftp_bottom_sheet.dart';
import 'package:cpanal/modules/cpanel/widget/ftp/edit_ftp_bottom_sheet.dart';
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

class FTPAccountsScreen extends StatefulWidget {
  final String? name;
  final String? dominId;
  FTPAccountsScreen({this.name, this.dominId});

  @override
  State<FTPAccountsScreen> createState() => _FTPAccountsScreenState();
}

class _FTPAccountsScreenState extends State<FTPAccountsScreen> {
  List<Email> emails = [];
  List<Email> selectedEmails = [];
  bool isSelectionMode = false;
  late ScrollController _scrollController;
  late final FtpProvider emailProvider;
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
    await emailProvider.getFtpEmails(
      context,

      domainId: widget.dominId,
    );
  }
  @override
  void initState() {
    super.initState();
    emailProvider = FtpProvider();
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
        emailProvider.ftps.isNotEmpty) {
      emailProvider.getFtpEmails(
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

    return ChangeNotifierProvider<FtpProvider>.value(
      value: emailProvider,
      child: Consumer<FtpProvider>(
        builder: (context, value, child) {
          return TemplatePage(
            pageContext: context,
            title: AppStrings.ftpAccounts.tr().toUpperCase(),
            onRefresh: () async {
              emailProvider.pageNumber = 1;
              emailProvider.ftps.clear();
              await emailProvider.getFtpEmails(context,  domainId: widget.dominId);
              await emailcickle();
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
                     AppStrings.ftp_accounts_description.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                  ),
                  const SizedBox(height: 15),
                  ListView.separated(
                    itemCount: value.isLoading && value.pageNumber == 1 ? 3 : value.ftps.length,
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
                      return GestureDetector(
                        // onLongPress: () => onLongPress(index),
                        // onTap: () => onTap(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 1))],
                          ),
                          child: Slidable(
                            key: ValueKey(value.ftps[index]['login']),
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
                                        child: EditEmailBottomSheet(
                                          dominId: widget.dominId,
                                          email: value.ftps[index]['login'],
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
                                  onPressed: (_) async{
                                   await showModalBottomSheet(
                                      context: safeContext,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(safeContext).viewInsets.bottom),
                                        child: DeleteAccountBottomSheet(
                                          multi: false,
                                            domainId: widget.dominId,email: value.ftps[index]['login'],
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
                                    child: EditEmailBottomSheet(
                                      dominId: widget.dominId,
                                      email: value.ftps[index]['login'],
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
                                          value.ftps[index]['login'],
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(AppColors.dark)),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset("assets/images/svg/message.svg"),
                                            const SizedBox(width: 5),
                                            Text(
                                              value.ftps[index]['dir'],
                                              style: const TextStyle(color: Color(AppColors.c4), fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedEmails.any((e) => e.address == value.ftps[index]['email']))
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
            floatingActionButton: isSelectionMode
                ? null
                : Column(
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
                        child: CreateEmailBottomSheet(dominId: widget.dominId,dominName: widget.name,),
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
