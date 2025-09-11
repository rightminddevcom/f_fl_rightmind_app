import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/home_model/home_model.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:cpanal/utils/componentes/general_components/all_text_field.dart';


class DropDownAndButtonBottomSheet extends StatefulWidget {
  const DropDownAndButtonBottomSheet({super.key});

  @override
  State<DropDownAndButtonBottomSheet> createState() => _DropDownAndButtonBottomSheetState();
}

class _DropDownAndButtonBottomSheetState extends State<DropDownAndButtonBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create:(context) => PointsProvider()..getPrize(context)),
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
    ],
    child: Consumer<PointsProvider>(
      builder: (context, value, child) {
        return Consumer<HomeViewModel>(
          builder: (context, values, child) {
            return Column(
              children: [
                defaultDropdownField(
                  value: value.selectPrize,
                  title: AppStrings.chooseThePrize.tr(),
                  items: value.prizes.map((e) => DropdownMenuItem(
                    value: e['id'].toString(),
                    child: Text(e['title'].toString(), style: const TextStyle(

                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff464646)
                    ),),
                  ),
                  ).toList(),
                  onChanged: (values) {
                    print(values);
                    setState(() {
                      value.selectPrize = values;
                    });
                  },
                ),
                const SizedBox(height: 30,),
                // if(provider.status == RedeemPrizeStatus.loading)Center(
                //   child: CircularProgressIndicator(),
                // ),
                if(value.isRedeemPrizeLoading == true)Center(child: CircularProgressIndicator(),),
                if(value.isRedeemPrizeLoading == false)GestureDetector(
                  onTap: (){
                    value.redeemPrize(context, id: value.selectPrize.toString());
                  },
                  child: Container(
                    height: 50,
                    width: 224,
                    decoration: BoxDecoration(
                      color: Color(AppColors.primary),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/png/icon.png"),
                        SizedBox(width: 4,),
                        Text(AppStrings.redeemNow.tr().toUpperCase(),style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),)
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    ),
    );
  }
}