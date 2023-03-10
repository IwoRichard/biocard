// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:biocard/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoFirestoreService{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future userInfo({
    required String email, 
    required String username, 
    required String bio, 
    required String profileTitle
    })async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).set({
        'email': email,
        'username': username,
        'profileTitle': profileTitle,
        'profilePic': defaultPic,
        'bio': bio,
        'userId': _uid,
        'date': DateTime.now(),
        'facebook': '',
        'instagram': '',
        'twitter': '',
        'linkedin': '',
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

    Future updateProfilePic(String profilePic)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "profilePic": profilePic,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateProfileTitle(String profileTitle)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "profileTitle": profileTitle,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateBio(String bio)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "bio": bio,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateFacebookLink(String facebookk)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "facebook": facebookk,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future updateInstagramLink(String instagram)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "instagram": instagram,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateTwitterLink(String twitter)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "twitter": twitter,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateLinkedInLink(String linkedin)async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final _uid = user!.uid;
      await firebaseFirestore.collection('usersInfo').doc(_uid).update({
        "linkedin": linkedin,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}