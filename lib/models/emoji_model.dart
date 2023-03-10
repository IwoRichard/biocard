import 'package:cloud_firestore/cloud_firestore.dart';

class EmojiModel {
  String id;
  String emoji;
  EmojiModel({
    required this.id,
    required this.emoji,
  });

  factory EmojiModel.fromJson(DocumentSnapshot snapshot){
    return EmojiModel(
      id: snapshot.id, 
      emoji: snapshot['emoji']
    );
  }
}