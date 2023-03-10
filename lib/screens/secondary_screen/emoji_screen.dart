// ignore_for_file: use_build_context_synchronously

import 'package:biocard/models/emoji_model.dart';
import 'package:biocard/services/userInfo_firestore_service.dart';
import 'package:biocard/widgets/preview_emulator_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EmojiScreen extends StatefulWidget {
  const EmojiScreen({super.key});

  @override
  State<EmojiScreen> createState() => _EmojiScreenState();
}

class _EmojiScreenState extends State<EmojiScreen> {
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Emoji',
          style: GoogleFonts.inter(
            fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black
          ),
        ),
        leading: IconButton(
          onPressed: (){
            context.pop();
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87,)
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('userEmoji').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    EmojiModel emoji = EmojiModel.fromJson(snapshot.data.docs[index]);
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Save Emoji'),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text('Cancel')
                                ),
                                TextButton(
                                  onPressed: ()async{
                                    Navigator.pop(context);
                                    await UserInfoFirestoreService().updateProfilePic(emoji.emoji);
                                  }, 
                                  child: const Text('Save')
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        height: 100,
                        width: 100,
                        imageUrl: emoji.emoji,
                        placeholder: (context, url) {
                          return Container(
                            color: Colors.grey.withOpacity(.3)
                          );
                        },
                        placeholderFadeInDuration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }else{
                return const Center(child: CircularProgressIndicator(),);
              }
                },
              ),
            )
          ),
          if(size >= 600)
          const VerticalDivider(),
          if(size >= 600)
          const PreviewEmulator()
        ],
      ),
    );
  }
}