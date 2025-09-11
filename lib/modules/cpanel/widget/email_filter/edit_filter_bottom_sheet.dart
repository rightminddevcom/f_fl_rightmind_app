import 'dart:math';

import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/modules/cpanel/logic/auto_response_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_account_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_filter_provider.dart';
import 'package:cpanal/modules/cpanel/logic/email_forward_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/componentes/general_components/all_text_field.dart';

class EditEmailBottomSheet extends StatefulWidget {
  var dominId;
  var dominName;
  var email;
  var object;
  EditEmailBottomSheet({this.dominId,this.object,this.dominName,this.email});

  @override
  State<EditEmailBottomSheet> createState() => _EditEmailBottomSheetState();
}

class _EditEmailBottomSheetState extends State<EditEmailBottomSheet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rulesTitleController = TextEditingController();
  TextEditingController actionTitleController = TextEditingController();
  bool isContainsHtml = true;
  List<RuleItem> rules = [];
  List<ActionItem> actions = [];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.object['filtername'];
    if (widget.object['rules'] != null) {
      for (var rule in widget.object['rules']) {
        rules.add(RuleItem()
          ..selectedFrom = rule['part']
          ..selectedContain = rule['match']
          ..selectedAnd = rule['opt']
          ..controller.text = rule['val'] ?? ""
        );
      }
    }
    if (widget.object['actions'] != null) {
      for (var action in widget.object['actions']) {
        List actionList2 = [
          {
            "key" : AppStrings.inbox.tr(),
            "value" : "INBOX"
          },    {
            "key" : AppStrings.drafts.tr(),
            "value" : "/.Drafts"
          },    {
            "key" : AppStrings.junk.tr(),
            "value" : "/.Junk"
          },    {
            "key" : AppStrings.sent.tr(),
            "value" : "/.Sent"
          },    {
            "key" : AppStrings.spam.tr(),
            "value" : "/.spam"
          },    {
            "key" : AppStrings.trash.tr(),
            "value" : "/.Trash"
          },

        ];

        String dest = action['dest'] ?? "";
        int lastSlashIndex = dest.lastIndexOf('/');

        String lastPart = lastSlashIndex != -1 ? dest.substring(lastSlashIndex) : dest;

        var item = ActionItem()
          ..selectedAction = action['dest'] == "/dev/null" ? "save \"/dev/null\"" :action['action'];

        if(action['dest'] != "/dev/null" && action['dest'] != "finish"){
          if (actionList2.any((e) => e['value'] == lastPart)) {
            item.selectedAction2 = lastPart;
          } else {
            item.controller.text = dest;
          }
        }

        actions.add(item);
      }

    }
  }

  String generateRandomPassword({int length = 12}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{};:,.<>?/|';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailFilterProvider>(
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        AppStrings.updateFilters.tr().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(AppColors.primary),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Center(
                      child: Text(
                        AppStrings.autoResponseMessage.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(AppColors.dark),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildInputWithSuffix(AppStrings.filterName.tr().toUpperCase(), "${widget.dominName}", 120.0, controller: nameController),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Text(AppStrings.rules.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                            color: Color(0xff1B1B1B)),),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              rules.add(RuleItem());
                            });
                          },
                          child:  Container(
                            height: 26,
                            width: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                border: Border.all(color: const Color(AppColors.primary))
                            ),
                            child: const Icon(Icons.add,color: Color(AppColors.primary),),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (rules.isNotEmpty) {
                                rules.removeLast();
                              }
                            });
                          },
                          child:  Container(
                              height: 26,
                              width: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                  border: Border.all(color: const Color(0xff122730))
                              ),
                              child: const Text("-", style: TextStyle(color: Color(0xff122730), fontSize: 20),)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                Column(
                  children: [
                    for (int i = 0; i < rules.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: defaultDropdownField(
                                    value: rules[i].selectedFrom,
                                    title: rules[i].selectedFrom ?? AppStrings.selectOptian.tr(),
                                    items: value.fromList
                                        .map(
                                          (e) => DropdownMenuItem(
                                        value: e['value'].toString(),
                                        child: Text(
                                          e['key'].toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        rules[i].selectedFrom = newVal;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: defaultDropdownField(
                                    value: rules[i].selectedContain,
                                    title:
                                    rules[i].selectedContain ?? AppStrings.selectOptian.tr(),
                                    items: value.containList
                                        .map(
                                          (e) => DropdownMenuItem(
                                        value: e['value'].toString(),
                                        child: Text(
                                          e['key'].toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        rules[i].selectedContain = newVal;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              keyboardType: rules[i].selectedContain == "is above" ||  rules[i].selectedContain == "is not above"
                                  || rules[i].selectedContain == "is below"|| rules[i].selectedContain == "is not below" ? TextInputType.number : TextInputType.text,
                              controller: rules[i].controller,
                              decoration: InputDecoration(
                                hintText: AppStrings.rulesTitle.tr().toUpperCase(),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            if (rules.length > 1 && i != rules.length - 1)
                            defaultDropdownField(
                              value: rules[i].selectedAnd,
                              title: rules[i].selectedAnd ??
                                  AppStrings.selectOptian.tr(),
                              items: value.andList
                                  .map((e) => DropdownMenuItem(
                                value: e['value'].toString(),
                                child: Text(
                                  e['key'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ))
                                  .toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  rules[i].selectedAnd = newVal;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (i != rules.length - 1) const Divider(),
                    ],
                  ],
                ),
                const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(AppStrings.actions.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                            color: Color(0xff1B1B1B)),),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              actions.add(ActionItem());
                            });
                          },

                          child: Container(
                            height: 26,
                            width: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                border: Border.all(color: const Color(AppColors.primary))
                            ),
                            child: const Icon(Icons.add,color: Color(AppColors.primary),),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (actions.isNotEmpty) {
                                actions.removeLast();
                              }
                            });
                          },
                          child: Container(
                              height: 26,
                              width: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                  border: Border.all(color: const Color(0xff122730))
                              ),
                              child: const Text("-", style: TextStyle(color: Color(0xff122730), fontSize: 20),)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                Column(
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          children: [
                            defaultDropdownField(
                              value: actions[i].selectedAction,
                              title: actions[i].selectedAction ??
                                  AppStrings.selectOptian.tr(),
                              items: value.actionList
                                  .map(
                                    (e) => DropdownMenuItem(
                                  value: e['value'].toString(),
                                  child: Text(
                                    e['key'].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  actions[i].selectedAction = val;
                                  actions[i].controller.clear();
                                });
                              },
                            ),

                            if (actions[i].selectedAction != "save \"/dev/null\"" &&
                                actions[i].selectedAction != "finish" &&
                                actions[i].selectedAction != "save")
                              const SizedBox(height: 10),
                            if (actions[i].selectedAction != "save \"/dev/null\"" &&
                                actions[i].selectedAction != "finish" &&
                                actions[i].selectedAction != "save")
                              TextFormField(
                                controller: actions[i].controller,
                                decoration: InputDecoration(
                                  hintText: AppStrings.actionTitle.tr().toUpperCase(),
                                ),
                              ),

                            if (actions[i].selectedAction == "save")
                              const SizedBox(height: 10),
                            if (actions[i].selectedAction == "save")
                              defaultDropdownField(
                                value: actions[i].selectedAction2,
                                title: actions[i].selectedAction2 ??
                                    AppStrings.discardMassage.tr(),
                                items: value.actionList2
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e['value'].toString(),
                                    child: Text(
                                      e['key'].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    actions[i].selectedAction2 = val;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      if (i != actions.length - 1) const Divider(),
                    ],
                  ],
                ),
                const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomElevatedButton(
                            width: null,
                            backgroundColor: const Color(0xffD10A11),
                            title: AppStrings.cancel.tr().toUpperCase(),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            isPrimaryBackground: false,
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          flex: 1,
                            child: CustomElevatedButton(
                              width: null,
                              backgroundColor: const Color(AppColors.dark),
                              title: AppStrings.update.tr().toUpperCase(),
                              onPressed: () async {
                                List<List<String>> fromResult = rules.map((r) => [
                                  r.selectedFrom ?? '',
                                  r.selectedContain ?? '',
                                  r.controller.text,
                                  r.selectedAnd ?? '',
                                ]).toList();
                                List<List<String>> actionsResult = actions.map((a) => [
                                  a.selectedAction ?? '',
                                  a.controller.text.isNotEmpty ? a.controller.text : a.selectedAction2 ?? ""
                                ]).toList();
                                print(fromResult);
                                print(actionsResult);
                                value.addEmailFilter(context,
                                    domainId: widget.dominId.toString(),
                                    email: widget.email,
                                    filtername: nameController.text,
                                    actions: actionsResult,
                                    match: fromResult
                                );
                              },
                              isPrimaryBackground: false,
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputWithSuffix(String label, String suffixText, width, {controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: label,
        // suffixIcon: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     width: width,
        //     alignment: Alignment.center,
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: Color(0xffDFDFDF),
        //       borderRadius: BorderRadius.circular(6),
        //     ),
        //     child: Text(
        //       suffixText,
        //       style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(AppColors.dark)),
        //     ),
        //   ),
        // ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

}
class RuleItem {
  String? selectedFrom;
  String? selectedContain;
  String? selectedAnd;
  TextEditingController controller = TextEditingController();
}
class ActionItem {
  String? selectedAction;
  String? selectedAction2;
  TextEditingController controller = TextEditingController();
}
