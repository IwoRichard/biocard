import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinksFirestoreService{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  Future addLink(String title, url, userId)async{
    try {
      await firebaseFirestore.collection('userUrls').add({
        "urlTitle": title,
        "url": url,
        "date": DateTime.now(),
        "userId": userId
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future updateLink(String docId,title,url)async{
    try {
      await firebaseFirestore.collection('userUrls').doc(docId).update({
        "urlTitle": title,
        "url": url,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future deleteUrl(String docId)async{
    try {
      await firebaseFirestore.collection('userUrls').doc(docId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}