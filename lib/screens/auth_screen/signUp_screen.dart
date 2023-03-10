// ignore_for_file: use_build_context_synchronously

import 'package:biocard/colors.dart';
import 'package:biocard/services/auth_service.dart';
import 'package:biocard/services/userInfo_firestore_service.dart';
import 'package:biocard/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController profileTitleController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 550
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an account',
                          style: GoogleFonts.dmSans(
                            fontSize: 27, fontWeight: FontWeight.w800
                          ),
                        ),
                        const Opacity(
                          opacity: .7,
                          child: Text(
                            'Start by creating your account',
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFieldMethod(
                          textController: usernameController, 
                          inputAction: TextInputAction.next, 
                          label: 'Username'
                        ),
                        const SizedBox(height: 15,),
                        TextFieldMethod(
                          textController: profileTitleController, 
                          inputAction: TextInputAction.next, 
                          label: 'Profile Title'
                        ),
                        const SizedBox(height: 15,),
                        TextFieldMethod(
                          textController: bioController, 
                          inputAction: TextInputAction.next, 
                          label: 'Bio', 
                          maxLines: null,
                          maxLength: 80,
                          showMaxLength: true,
                        ),
                        const SizedBox(height: 15,),
                        TextFieldMethod(
                          textController: emailController, 
                          inputAction: TextInputAction.next, 
                          label: 'Email'
                        ),
                        const SizedBox(height: 15,),
                        TextFieldMethod(
                          textController: passwordController, 
                          inputAction: TextInputAction.done,
                          showObscureIcon: true, 
                          label: 'Password'
                        ),
                        const SizedBox(height: 15),
                        MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          elevation: 0,
                          color: primaryColor,
                          disabledColor: Colors.black12,
                          disabledTextColor: Colors.black.withOpacity(.5),
                          onPressed: isLoading ? null : ()async{
                            setState(() {isLoading = true;});
                            User? res = 
                            await AuthService().signUpUser(
                              email: emailController.text,
                              password: passwordController.text,
                              username: usernameController.text,
                              context: context
                            );
                            await UserInfoFirestoreService().userInfo(
                              email: emailController.text,
                              profileTitle: profileTitleController.text,
                              bio: bioController.text,
                              username: usernameController.text
                            );
                            if (res != null) {
                              context.go('/admin');
                            }
                            setState(() {isLoading = false;});
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Already have an account?",
                                    style: TextStyle(color: Colors.black.withOpacity(.5))
                                  ),
                                  const TextSpan(
                                    text: " Log in",
                                    style: TextStyle(fontWeight: FontWeight.w500, color:primaryColor)
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(size >= 600)
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: const Image(image: AssetImage('assets/socials.jpg'),fit: BoxFit.cover,),
            )
          )
        ],
      ),
    );
  }
}