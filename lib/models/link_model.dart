import 'package:cloud_firestore/cloud_firestore.dart';

class UrlModel {
  String id;
  String urlTitle;
  String url;
  String userId;
  //Timestamp date;
  UrlModel({
    required this.id,
    required this.urlTitle,
    required this.url,
    required this.userId,
    //required this.date,
  });

    factory UrlModel.fromJson(DocumentSnapshot snapshot){
    return UrlModel(
      id: snapshot.id, 
      urlTitle: snapshot['urlTitle'], 
      url:snapshot['url'], 
      //date: snapshot['date'], 
      userId: snapshot['userId']
    );
  }
}