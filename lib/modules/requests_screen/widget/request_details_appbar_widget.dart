import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/models/get_one_request_model.dart';
import 'package:cpanal/general_services/localization.service.dart';

class RequestDetailsAppbarWidget extends StatelessWidget {
  GetOneRequestModel? getOneRequestModel;
  RequestDetailsAppbarWidget({this.getOneRequestModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset("assets/images/png/points_back.png", height: 260, fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Icon(Icons.arrow_back, color: Color(0xffFFFFFF),)),
                    Spacer(),
                    Text(
                      AppStrings.requests.tr().toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Container(width: 20,),
                  ],
                ),
                SizedBox(height: 16,),
                Text(
                  getOneRequestModel!.item!.title!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: Text(
                       DateFormat("dd/MM/yyyy", LocalizationService.isArabic(context: context)? "ar" : "en").format(DateTime.parse(getOneRequestModel!.item!.createdAt.toString())).toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.folder_open_outlined, color: Colors.white,),
                        SizedBox(width: 5,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.25,
                          child: Text(
                              (getOneRequestModel!.item!.pType != null &&getOneRequestModel!.item!.pType!.title != null )?
                              getOneRequestModel!.item!.pType!.title!.toUpperCase() : "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                        ),
                        SizedBox(width: 5,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.25,
                          child: Text(
                            getOneRequestModel!.item!.pstatus!.key!.tr().toUpperCase() ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16,),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
