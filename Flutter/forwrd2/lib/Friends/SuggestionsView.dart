import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePhoneNumberService.dart';
import 'package:forwrd/Friends/SuggestionsTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionsView extends StatefulWidget {
  SuggestionsView({super.key});

  // bool to keep track of if we have already initilsed the loading of contacts
  bool loadedContacts = false;
  List<Widget> suggestedTiles = [];
  List<String> suggestFriendUID = [];

  @override
  State<SuggestionsView> createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView>
    with AutomaticKeepAliveClientMixin {
  // this is a list of all the persons contacts that are on the app
  List<List<String>> contactsOnApp = [];

  @override
  Future<List<Contact>> contactsList =
      ContactsService.getContacts(withThumbnails: false);

  Future<void> processNumbers() async {
    contactsOnApp = [];

    // initialising the shared preferences thing
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // get the list of the contacts first
    List<Contact> contactsDataList =
        await ContactsService.getContacts(withThumbnails: false);

    // process the list of contacts to the format we want [phoneNumber, display name]
    List<List<String>> formattedContactsList = [];
    contactsDataList.forEach((element) {
      String displayName = element.displayName ?? "";
      element.phones?.forEach((phoneNum) {
        formattedContactsList.add([phoneNum.value ?? "", displayName]);
      });
    });

    String selfUID = FFirebaseAuthService().getCurrentUID();
    // run through each record, check if they are on the app
    formattedContactsList.forEach((element) async {
      String? friendUID =
          await FFirebasePhoneNumberService().isUser(phoneNumber: element[0]);

      if (friendUID != null) {
        // person is a user, adding em to friendsOnApp
        print("We got a FRIEND!!! $element");
        contactsOnApp.add([friendUID, element[1]]);
        setState(() {});
      }
      // first we check if we have already uploaded that hash
      final bool? hashAlreadyUploaded = prefs.getBool(element[0]);

      // if we havent uploaded that hash
      if (hashAlreadyUploaded != true) {
        // upload that hash to the database
        FFirebasePhoneNumberService()
            .uploadUserHash(phoneNumber: element[0], selfUID: selfUID);
        prefs.setBool(element[0], true);
        print("uploaded ${element[0]}");
      } else {
        print(
            "Skipped uploading ${element[0]} as we have already done so before");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loadedContacts == false) {
      widget.loadedContacts = true;
      processNumbers();
    }

    //List<Widget> suggestedTiles = [];
    contactsOnApp.forEach((element) {
      widget.suggestedTiles
          .add(SuggestionsTile(uid: element[0], displayName: element[1]));
    });

    // if we have suggested tiles then adding the text telling us they are from your contacts
    if (widget.suggestedTiles.isNotEmpty) {
      widget.suggestedTiles.insert(
        0,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
          child: Text(
            'Your Contacts',
            style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(137, 137, 137, 1),
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    // Get all contacts without thumbnail (faster)
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ListView(children: widget.suggestedTiles)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
