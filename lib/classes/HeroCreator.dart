import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:cosplay_app/classes/Meetup.dart';
import 'package:cosplay_app/widgets/MyAlertDialogue.dart';

class HeroCreator {
  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView(DocumentReference otherUserDataReference, BuildContext context, FirebaseUser firebaseUser) async {
    // Get latest snapshot of the user from the database
    //  print("getting latest database information?");

    // Get other user data for profile display
    DocumentSnapshot otherUserDataSnapshot = await otherUserDataReference.get().catchError((error) {
      //TODO need to tell user it failed with a widget...
      print("pushProfileIntoView failed to get otherUserDataSnapshot from otherUserDataReference");
    });

    FirestoreReadcheck.heroCreatorReads++;
    FirestoreReadcheck.printHeroCreatorReads();

    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);

    HeroProfileStart heroProfileStart = HeroCreator.createHeroProfileStart(otherUserDataSnapshot, currentLoggedInUser);

    HeroProfileDetails heroProfileDetails =
        await HeroCreator.createHeroProfileDetails(otherUserDataSnapshot, context, currentLoggedInUser, firebaseUser);
    Widget clickedProfile = HeroCreator._wrapInScaffold([heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  static HeroProfileStart createHeroProfileStart(DocumentSnapshot data, LoggedInUser currentLoggedInUser) {
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, data);

    return HeroProfileStart(
      isLoggedInUser: isLookingAtOwnProfile,
      userImages: data[FirestoreManager.keyPhotos],
      name: data[FirestoreManager.keyDisplayName],
      friendliness: data[FirestoreManager.keyFriendliness],
      fame: data[FirestoreManager.keyFame],
      bottomLeftItemPadding: EdgeInsets.only(left: 20, bottom: 25),
    );
  }

  static Future<HeroProfileDetails> createHeroProfileDetails(DocumentSnapshot otherUserDocumentSnapshot, BuildContext context,
      LoggedInUser currentLoggedInUser, FirebaseUser firebaseUser) async {
    // Build a profile with different buttons if they're looking at themselves
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, otherUserDocumentSnapshot);

    bool displayRequestButton = false;
    bool displayAcceptButton = false;
    bool displayFinishButton = false;

    // Get logged in users incoming and outgoing selfie requests (PREV VERSION)
//    List<dynamic> loggedInUserIncomingSelfie = currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];
//    List<dynamic> loggedInUserOutgoingSelfie = currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];
    List<dynamic> loggedInUserIncomingSelfie = List<dynamic>();
    List<dynamic> loggedInUserOutgoingSelfie = List<dynamic>();

    // Need to read private? Yes that's ok they can read their own private database
    await Firestore.instance.collection("private").document(firebaseUser.uid).get().then((snapshot) {
      loggedInUserIncomingSelfie = snapshot.data[FirestoreManager.keyIncomingSelfieRequests];
      loggedInUserOutgoingSelfie = snapshot.data[FirestoreManager.keyOutgoingSelfieRequests];
    });

    //  print("YES");
    // print(loggedInUserOutgoingSelfie);
    // print(loggedInUserIncomingSelfie);

    // If current user sent and recieved a selfie request from other user
    if (loggedInUserIncomingSelfie.contains(otherUserDocumentSnapshot.documentID) &&
        loggedInUserOutgoingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      displayFinishButton = true;
    }

    // Display accept button if the other person exists in logged in user incoming list
    // If current user received a selfie request from other user
    else if (loggedInUserIncomingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      displayAcceptButton = true;
    }
    // If current user didnt recieve or send selfie request to the other user
    else if (!loggedInUserOutgoingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      displayRequestButton = true;
    }

    return HeroProfileDetails(
      onSelfieRequestTap: () {
        _onSelfieRequestTap(otherUserDocumentSnapshot);
      },
      onSelfieAcceptTap: () {
        _onSelfieAcceptTap(otherUserDocumentSnapshot);
      },
      onSelfieFinishTap: (context) {
        _onSelfieFinishTap(otherUserDocumentSnapshot, context);
      },
      displayAcceptButton: displayAcceptButton,
      displayRequestButton: displayRequestButton,
      displayFinishButton: displayFinishButton,
      isLoggedInUser: isLookingAtOwnProfile,
      userCircleImage: otherUserDocumentSnapshot[FirestoreManager.keyPhotos][0],
      rarityBorder: otherUserDocumentSnapshot[FirestoreManager.keyRarityBorder],
      displayName: otherUserDocumentSnapshot[FirestoreManager.keyDisplayName],
      friendliness: otherUserDocumentSnapshot[FirestoreManager.keyFriendliness],
      fame: otherUserDocumentSnapshot[FirestoreManager.keyFame],
    );
  }

  /// HELPERS ----------------------------------
  ///
  ///
  ///
  ///

  static void _onSelfieRequestTap(DocumentSnapshot otherUserData) async {
    // TODO restrict people within distance, if they are out of distance, record malicious attempt
    final response = await Meetup.sendSelfieRequestTo(otherUserData).catchError((error) {
      print(error);
    });
    print(response.data);
  }

  static void _onSelfieAcceptTap(DocumentSnapshot otherUserData) async {
//    final response = await Meetup.sendSelfieRequestTo(otherUserData);
    //  print(response.data);
    final response2 = await Meetup.acceptSelfieFrom(otherUserData);
    print(response2.data);
  }

  static void _onSelfieFinishTap(DocumentSnapshot otherUserData, BuildContext context) async {
    MyAlertDialogue.showDialogue(context, () async {
      final response = await Meetup.finishSelfie(otherUserData);
      print('--------');
      print(response.data);
    }, () async {
      final response = await Meetup.cancelSelfie(otherUserData);
      print('--------');
      print(response.data);
    });
    //final response = await Meetup.finishSelfie(otherUserData);
    //print(response.data);

    // Should send a verification to the other person and if the other person confirms, then approve selfie
    // 1) Send verification to the other person via notifications...
    // 2) Notification puts them into the hero page and they need to click finish selfie...
    // 3) Approve selfie since both ppl confirmed

    // In private database, need to have an array containing who they confirmed selfie with...
    // If they confirmed selfie and the other person also confiemd selfie, then approve with notification fame
    // If they confirmed selfie, but the other person didnt then send notification to other
  }

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }

  static _wrapInScaffold(List<Widget> heros, BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: HeroProfilePage(
          pages: heros,
        ),
      ),
    );
  }
}
