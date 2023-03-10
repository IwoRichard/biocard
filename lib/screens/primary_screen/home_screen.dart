import 'package:biocard/models/link_model.dart';
import 'package:biocard/widgets/link_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biocard/colors.dart';
import 'package:biocard/screens/primary_screen/preview_screen.dart';
import 'package:biocard/widgets/preview_emulator_card.dart';

class HomeScreen extends StatefulWidget {
  User user;
  HomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final User? user = FirebaseAuth.instance.currentUser;
  String emoji = defaultPic;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Links',
          style: GoogleFonts.inter(
            fontSize: 23, fontWeight: FontWeight.w700, color: Colors.black
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                context.pushNamed('profile');
              },
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('usersInfo').doc(user?.uid).get().then((snapshot) async {
                    if (snapshot.exists) {
                      setState(() {
                        emoji = snapshot.data()!['profilePic'];
                      });
                    }
                  }).asStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(emoji),
                  );
                },
              ),
            ),
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
                  MaterialButton(
                    onPressed: (){
                      context.pushNamed('addlink');
                    },
                    color: primaryColor,
                    height: 60,
                    minWidth: double.infinity,
                    elevation: 0,
                    focusElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      'Add New Link',
                      style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("userUrls").where(
                        "userId", isEqualTo: widget.user.uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length > 0) {
                            return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 18,);
                              },
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index){
                                UrlModel urll = UrlModel.fromJson(snapshot.data.docs[index]);
                                return LinkCard(urll: urll);
                              }
                            );
                          } else{
                            return const Center(
                              child: Text('No Links'),
                            );
                          }
                        }
                        return const Center(child: CircularProgressIndicator(),);
                      },
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
      floatingActionButton: size < 600 ?
      FloatingActionButton.extended(
        backgroundColor: Colors.grey.withOpacity(.6),
        elevation: 0,
        onPressed: (){
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) => const PreviewScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            )
          );
        }, 
        label: const Text(
          'Preview',
        ),
        icon: const Icon(Icons.remove_red_eye_outlined),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}