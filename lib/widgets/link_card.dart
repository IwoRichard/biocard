import 'package:biocard/models/link_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.urll,
  });

  final UrlModel urll;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        context.pushNamed('editlink',params: {
          'id': urll.id,
          'urlTitle': urll.urlTitle,
          'url': urll.url,
          'userId': urll.userId
        });
      },
      contentPadding: const EdgeInsets.all(10),
      horizontalTitleGap: 0,
      tileColor: Colors.white,
      leading: const Icon(
        Icons.more_vert
      ),
      title: Text(
        urll.urlTitle,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        urll.url,
        style: GoogleFonts.inter(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
    );
  }
}