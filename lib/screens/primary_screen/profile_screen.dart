// ignore_for_file: use_build_context_synchronously

import 'package:biocard/colors.dart';
import 'package:biocard/services/auth_service.dart';
import 'package:biocard/services/userInfo_firestore_service.dart';
import 'package:biocard/widgets/preview_emulator_card.dart';
import 'package:biocard/widgets/settings_tiles.dart';
import 'package:biocard/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController titleController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  

  String email = '';
  String username = '';
  String profileTitle = '';
  String bio = '';
  String emoji = defaultPic;
  String facebook = '';
  String twitter = '';
  String instagram = '';
  String linkedin = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo()async{
    final userRef = FirebaseFirestore.instance.collection('usersInfo').doc(user!.uid);
    final userData = await userRef.get();
    setState(() {
      email = userData.data()!['email'];
      username = userData.data()!['username'];
      emoji = userData.data()!['profilePic'];
      profileTitle = userData.data()!['profileTitle'];
      bio = userData.data()!['bio'];
    });
    titleController.text = profileTitle;
    bioController.text = bio;
  }


  @override
  Widget build(BuildContext context) {
    final customUrl = 'biocardd.web.app/$username';
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Profile',
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
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: Image(image: NetworkImage(emoji),),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: TextButton(
                          onPressed: (){
                            context.pushNamed('emoji');
                          }, 
                          child: Text(
                            'Change Picture',
                            style: GoogleFonts.inter(
                              color: Colors.blue.shade600, fontWeight: FontWeight.w600
                            ),
                          )
                        )
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Transform.rotate(
                                      angle: 135 * (3.14159265358979323846 / 180),
                                      child: const Icon(Icons.link, color: Colors.grey,),
                                    ),
                                    const SizedBox(width: 2,),
                                    Expanded(
                                      child: Text(
                                        customUrl,//'biocardd.web.app/$username',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 15, fontWeight: FontWeight.w500
                                        ),
                                      )
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Clipboard.setData(ClipboardData(text: customUrl)).then((value) => 
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            snackBar('Url is copied to the clipboard', context, Colors.green)
                                          )
                                        );
                                      }, 
                                      child: Text(
                                        'Copy',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,color: Colors.blue.shade600
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25,),
                              textFieldTitle('Profile Title'),
                              const SizedBox(height: 5,),
                              MyTextField(
                                textController: titleController, 
                                hintText: 'Software Dev.',
                                onChanged: (value) {
                                  UserInfoFirestoreService().updateProfileTitle(titleController.text);
                                },
                              ),
                              const SizedBox(height: 15,),
                              textFieldTitle('Bio'),
                              const SizedBox(height: 5,),
                              MyTextField(
                                textController: bioController, 
                                hintText: 'Hello, I am . . .',
                                maxLines: 4,
                                maxLength: 80,
                                showMaxLength: true,
                                onChanged: (value) {
                                  UserInfoFirestoreService().updateBio(bioController.text);
                                },
                              ),
                              const SizedBox(height: 20,),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("usersInfo").doc(user?.uid).get().then((snapshot)async{
                                  if (snapshot.exists) {
                                    setState(() {
                                      facebook = snapshot.data()!['facebook'];
                                      twitter = snapshot.data()!['twitter'];
                                      instagram = snapshot.data()!['instagram'];
                                      linkedin = snapshot.data()!['linkedin'];
                                    });
                                  }
                                }).asStream(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  return ExpansionTile(
                                    title: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade100.withOpacity(.7),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Social Icons',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600, color: Colors.deepPurple
                                          ),
                                        ),
                                      ),
                                    ),
                                    children: [
                                      SocialIconTile(
                                        textController: emailController,
                                        title: 'Email',
                                        subTitle: email,
                                        svg: 'assets/mail2.svg', 
                                        hintText: 'example@gmail.com', 
                                        linkTitle: 'Email Address',
                                        showTrailing: false,
                                      ),
                                      SocialIconTile(
                                        textController: facebookController,
                                        onTap: (){
                                          if (!facebookController.text.contains('https://')) {
                                            UserInfoFirestoreService().updateFacebookLink('https://${facebookController.text}');
                                          }else{
                                            UserInfoFirestoreService().updateFacebookLink(facebookController.text);
                                          }
                                          Navigator.pop(context);
                                        },
                                        title: 'Facebook', 
                                        subTitle: facebook, 
                                        svg: 'assets/facebook2.svg', 
                                        hintText: 'https://facebook. . .', 
                                        linkTitle: 'Facebook',
                                      ),
                                      SocialIconTile(
                                        textController: instagramController,
                                        onTap: (){
                                          if (!facebookController.text.contains('https://')) {
                                            UserInfoFirestoreService().updateInstagramLink('https://${instagramController.text}');
                                          }else{
                                            UserInfoFirestoreService().updateInstagramLink(instagramController.text);
                                          }
                                          Navigator.pop(context);
                                        },
                                        title: 'Instagram', 
                                        subTitle: instagram, 
                                        svg: 'assets/instagram2.svg', 
                                        hintText: 'https://instagram. . .', 
                                        linkTitle: 'Instagram',
                                      ),
                                      SocialIconTile(
                                        textController: twitterController,
                                        onTap: (){
                                          if (!facebookController.text.contains('https://')) {
                                            UserInfoFirestoreService().updateTwitterLink('https://${twitterController.text}');
                                          }else{
                                            UserInfoFirestoreService().updateTwitterLink(twitterController.text);
                                          }
                                          Navigator.pop(context);
                                        },
                                        title: 'Twitter', 
                                        subTitle: twitter, 
                                        svg: 'assets/twitter2.svg',
                                        hintText: 'https://twitter. . .',
                                        linkTitle: 'Twitter',
                                      ),
                                      SocialIconTile(
                                        textController: linkedinController,
                                        onTap: (){
                                          if (!facebookController.text.contains('https://')) {
                                            UserInfoFirestoreService().updateLinkedInLink('https://${linkedinController.text}');
                                          }else{
                                            UserInfoFirestoreService().updateLinkedInLink(linkedinController.text);
                                          }
                                          Navigator.pop(context);
                                        },
                                        title: 'LinkedIn', 
                                        subTitle: linkedin, 
                                        svg: 'assets/linkedin2.svg',
                                        hintText: 'https://linkedIn. . .',
                                        linkTitle: 'LinkedIn',
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20,),
                              SettingsActionTile(
                                onTap: (){
                                  context.pushNamed('forgotpassword');
                                }, 
                                title: 'Reset Password', 
                                icon: const Icon(Iconsax.key, color: Colors.black87,size: 22,), 
                                subTitle: 'Forgot your password? Reset.',
                              ),
                              SettingsActionTile(
                                onTap: ()async{
                                  await AuthService().signout();
                                  context.go('/');
                                }, 
                                title: 'Log out', 
                                icon: Icon(Iconsax.logout, color: Colors.red.shade500,size: 22,),
                                colorr: Colors.red.shade500,
                                subTitle: '',
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
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

  Text textFieldTitle(title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w500
      ),
    );
  }
}