// ignore_for_file: deprecated_member_use

import 'package:biocard/colors.dart';
import 'package:biocard/models/link_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final String username;
  const DetailsScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  String? userId;
  String email = '';
  String profileTitle = '';
  String bio = '';
  String? emoji;
  String facebook = '';
  String twitter = '';
  String instagram = '';
  String linkedin = '';

  getUserId()async{
    await FirebaseFirestore.instance
    .collection('usersInfo')
    .where('username', isEqualTo: widget.username)
    .get().then((value){
      setState(() {
        userId = value.docs.first.data()['userId'];
      });
      debugPrint(userId);
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(55, 55, 55, 1),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("usersInfo").doc(userId).get().then((snapshot)async{
          if (snapshot.exists) {
            setState(() {
              email = snapshot.data()!['email'];
              profileTitle = snapshot.data()!['profileTitle'];
              bio = snapshot.data()!['bio'];
              emoji = snapshot.data()!['profilePic'];
              facebook = snapshot.data()!['facebook'];
              twitter = snapshot.data()!['twitter'];
              instagram = snapshot.data()!['instagram'];
              linkedin = snapshot.data()!['linkedin'];
            });
          }
        }).asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40,),
                        CircleAvatar(
                          radius: 30,
                          foregroundColor: Colors.grey[700],
                          child: Image.network(emoji??defaultPic),
                        ),
                        const SizedBox(height: 15,),
                        Text(
                          profileTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          bio,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: Colors.white,fontSize: 16,),
                        ),
                        const SizedBox(height: 17,),
                        ConstrainedBox(
                          constraints:const BoxConstraints(
                            maxWidth: 300
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if(twitter != '')
                              sociallogo('assets/twitter2.svg', twitter),
                              if(email != '')
                              emaillogo('assets/mail2.svg', email),
                              if(facebook != '')
                              sociallogo('assets/facebook2.svg', facebook),
                              if(instagram != '')
                              sociallogo('assets/instagram2.svg', instagram),
                              if(linkedin != '')
                              sociallogo('assets/linkedin2.svg', linkedin),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17,),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('userUrls').where('userId', isEqualTo: userId).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length > 0) {
                                return ListView.separated(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index){
                                    UrlModel url = UrlModel.fromJson(snapshot.data.docs[index]);
                                    return InkWell(
                                      onTap: () async{
                                        final link = Uri.parse(url.url);
                                        if (await canLaunchUrl(link)) {
                                          //await launchUrl(link);
                                          launch(
                                            url.url,
                                            forceSafariVC: true
                                          );
                                        }else{
                                          throw Exception('Could not launch $link');
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            url.urlTitle,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const SizedBox(height: 15,),
                                );
                              }else{
                                return const Center(
                                  child: Text(
                                    'no links',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            }
                            return const Center(child: CircularProgressIndicator(color: Colors.white,),);
                          },
                        ),
                        const SizedBox(height: 40,),
                        InkWell(
                          onTap: (){},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'BIO.\nCARD',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }

  InkWell sociallogo(svg, url) {
    return InkWell(
      onTap: () async{
        final link = Uri.parse(url);
        if (await canLaunchUrl(link)) {
          launch(
            url,
            forceSafariVC: true
          );
        }else{
          throw Exception('Could not launch $link');
        }
      },
      child: SvgPicture.asset(
        svg,
        height: 30,
        color: Colors.white,
      ),
    );
  }

    InkWell emaillogo(svg, path) {
    return InkWell(
      onTap: () async{
        String? encodeQueryParameters(Map<String, String> params) {
          return params.entries
              .map((MapEntry<String, String> e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
        }

        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: path,
          query: encodeQueryParameters(<String, String>{
            'subject': 'Example Subject & Symbols are allowed!',
          }),
        );

        if (await canLaunchUrl(emailLaunchUri)) {
          launch(emailLaunchUri.toString());
        }else{
          throw Exception('Not supported');
        }
      
      },
      child: SvgPicture.asset(
        svg,
        height: 30,
        color: Colors.white,
      ),
    );
  }
}