// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biocard/services/links_firestore_service.dart';
import 'package:biocard/widgets/preview_emulator_card.dart';

class AddLinkScreen extends StatefulWidget {
  User user;
  AddLinkScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {

  bool isLoading = false;
  TextEditingController linkTitleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    linkTitleController.dispose();
    linkController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Add Link',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinkTextField(controller: linkTitleController, hintText: 'Github Page',),
                  const SizedBox(height: 20,),
                  LinkTextField(controller: linkController, hintText: 'https://. . . '),
                  const SizedBox(height: 20,),
                  MaterialButton(
                    onPressed: isLoading ? null : ()async{
                      if (linkTitleController.text == "" || linkController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All fields are required'),backgroundColor: Colors.red,));
                      } else if (!linkController.text.contains('https://')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link must have 'https://' "),backgroundColor: Colors.red,));
                      }
                      else{
                        setState(() {
                          isLoading = true;
                        });
                        await LinksFirestoreService().addLink(linkTitleController.text, linkController.text, widget.user.uid,);
                        setState(() {
                          isLoading = false;
                        });
                        context.pop();
                      }
                    },
                    color: Colors.black87,
                    disabledColor: Colors.grey.withOpacity(.5),
                    disabledTextColor: Colors.black.withOpacity(.5),
                    height: 60,
                    minWidth: double.infinity,
                    elevation: 0,
                    focusElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Add New Link',
                      style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
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

class LinkTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  LinkTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        hoverColor: Colors.white,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}