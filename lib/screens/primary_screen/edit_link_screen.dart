// ignore_for_file: use_build_context_synchronously

import 'package:biocard/services/links_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:biocard/models/link_model.dart';
import 'package:biocard/screens/primary_screen/add_link_screen.dart';
import 'package:biocard/widgets/preview_emulator_card.dart';

class EditLinkScreen extends StatefulWidget {
  UrlModel url;
  EditLinkScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<EditLinkScreen> createState() => _EditLinkScreenState();
}

class _EditLinkScreenState extends State<EditLinkScreen> {

  bool isLoading = false;
  TextEditingController linkTitleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    linkTitleController.text = widget.url.urlTitle;
    linkController.text = widget.url.url;
    super.initState();
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
          'Edit Link',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              onPressed: ()async{
                await LinksFirestoreService().deleteUrl(widget.url.id);
                Navigator.pop(context);
              }, 
              icon: const Icon(Iconsax.trash, color: Colors.red,), 
              label: Text(
                'Delete Link',
                style: GoogleFonts.inter(
                  color: Colors.red
                ),
              )
            )
          )
        ],
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
                      }else if (!linkController.text.contains('https://')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link must have 'https://' "),backgroundColor: Colors.red,));
                        }
                      else{
                        setState(() {
                          isLoading = true;
                        });
                        await LinksFirestoreService().updateLink(widget.url.id, linkTitleController.text, linkController.text);
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
                      'Edit Link',
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