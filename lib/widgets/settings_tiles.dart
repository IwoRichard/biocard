// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SettingsActionTile extends StatelessWidget {
  Function() onTap;
  String title;
  String subTitle;
  Icon icon;
  Color colorr;
  SettingsActionTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.colorr = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: colorr,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subTitle
      ),
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}

class SocialIconTile extends StatelessWidget {
  TextEditingController textController;
  Function()? onTap;
  String title;
  String linkTitle;
  String hintText;
  String svg;
  String subTitle;
  bool showTrailing;
  SocialIconTile({
    Key? key,
    required this.textController,
    this.onTap,
    required this.title,
    required this.linkTitle,
    required this.hintText,
    required this.svg,
    required this.subTitle,
    this.showTrailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text(linkTitle),
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hintText
                ),
              ),
              actions: [
                TextButton(
                  onPressed: onTap, 
                  child: const Text('SUBMIT')
                )
              ],
            );
          }
        );
      },
      contentPadding: const EdgeInsets.all(0),
      horizontalTitleGap: 0,
      leading: SvgPicture.asset(
        svg,
        height: 30,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(),
      ),
      subtitle: Text(
        subTitle,
        style: GoogleFonts.inter(),
      ),
      trailing: showTrailing == true ? const Icon(Iconsax.edit, size: 18,) : null,
    );
  }
}