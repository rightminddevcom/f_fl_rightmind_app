import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:cpanal/common_modules_widgets/custom_elevated_button.widget.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/home_model/home_model.dart';
import 'package:cpanal/controller/points_controller/points_controller.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ContactSelectionScreen extends StatefulWidget {
  @override
  _ContactSelectionScreenState createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Map<String, dynamic> _selectedContacts = {
    "items": []
  };
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
      });
    }
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts
          .where((contact) => contact.displayName.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSelection(Contact contact) async {
    if (contact.phones.isEmpty) return;

    String rawPhoneNumber = contact.phones.first.number.replaceAll(RegExp(r'\D'), ''); // Normalize number
    String countryCode = await getCountryCode(rawPhoneNumber);

    setState(() {
      List items = _selectedContacts["items"];
      int existingIndex = items.indexWhere((item) =>
          (item["phonesNumbers"] as List).contains(rawPhoneNumber)
      );

      if (existingIndex != -1) {
        items.removeAt(existingIndex);
      } else {
        items.add({
          "name": contact.displayName.toString(),
          "country_code": countryCode.toString(),
          "phonesNumbers": [rawPhoneNumber.toString()],
        });
      }
    });
    print("_selectedContacts is --> ${_selectedContacts}");
    print("_selectedContacts is --> ${_selectedContacts.length}");
  }
  Future<String> getCountryCode(String phoneNumber) async {
    try {
      final parsed = PhoneNumber.parse(phoneNumber, callerCountry: IsoCode.EG); // Use IsoCode.EG instead of "EG"
      return "+${parsed.countryCode}"; // Returns country code with "+"
    } catch (e) {
      print("Error extracting country code: $e");
      return ""; // Return empty if parsing fails
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => PointsProvider(),),
      ChangeNotifierProvider(create: (context) => HomeViewModel(),),
    ],
    child: Consumer<HomeViewModel>(
      builder: (context, values, child) {
        return Consumer<PointsProvider>(
          builder: (context, value, child) {
            if(value.isAddFriendContactSuccess == true){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedContacts['items'].clear();
                });
                values.initializeHomeScreen(context);
              });
              value.isAddFriendContactSuccess = false;
            }
            return Scaffold(
              backgroundColor: Color(0xffFFFFFF),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(AppColors.dark
                    ),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  AppStrings.recommendFriends.tr().toUpperCase(),
                  style: const TextStyle(
                    color: Color(AppColors.dark
                    ),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${_selectedContacts['items'].length} ${AppStrings.selected.tr()}",
                            style: TextStyle(color: Color(0xff5E5E5E), fontSize: 12 ,fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          if(value.isAddFriendLoading == true)Container(
                            width: 90,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                          if(value.isAddFriendLoading == false)SizedBox(
                            height: 30,
                            child: CustomElevatedButton(
                                width: 90,
                                onPressed: () async {
                                  value.addFriendContact(context,contact: _selectedContacts);
                                },
                                title: AppStrings.add.tr().toUpperCase(),
                                isPrimaryBackground: true,
                                isFuture: false),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 45,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    labelText: AppStrings.search.tr(),
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: GestureDetector(
                                        onTap: (){
                                          _searchController.clear();
                                        },
                                        child: Icon(Icons.close)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                              onTap: (){
                                _searchController.clear();
                              },
                              child: Text(AppStrings.cancel.tr().toUpperCase(),style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(AppColors.black)),))
                        ],
                      ),
                    ),
                    if(_filteredContacts.isEmpty)Container(
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      alignment: Alignment.center,
                      child: Center(child: Text("${AppStrings.searchingInContacts.tr()} ...", style: TextStyle(color: Colors.black, fontSize: 18),),),
                    ),
                    if(_filteredContacts.isNotEmpty)Container(
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      child: ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = _filteredContacts[index];

                          // Ensure the contact has at least one phone number
                          String contactNumber = contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : "No number";

                          bool isSelected = _selectedContacts["items"].any((item) {
                            var phoneNumbers = item["phonesNumbers"] as List;
                            return contact.phones.isNotEmpty && phoneNumbers.contains(
                                contact.phones.first.number.replaceAll(RegExp(r'\D'), '')
                            );
                          });

                          return ListTile(
                            leading: (contact.photo != null)
                                ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                                : CircleAvatar(child: Text(contact.displayName.isNotEmpty ? contact.displayName[0] : '?')),
                            title: Text(contact.displayName.isNotEmpty ? contact.displayName : "Unknown"),
                            subtitle: Text(contactNumber),
                            trailing: isSelected ? Icon(Icons.check_circle, color: Color(0xFFE93F81)) : null,
                            onTap: () => _toggleSelection(contact),
                          );
                        },
                      ),
                    ),


                  ],
                ),
              ),
            );
          },
        );
      },
    ),
    );
  }
}
