// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:biocard/models/link_model.dart';
import 'package:biocard/screens/auth_screen/forgot_password_screen.dart';
import 'package:biocard/screens/auth_screen/login_screen.dart';
import 'package:biocard/screens/auth_screen/signUp_screen.dart';
import 'package:biocard/screens/primary_screen/add_link_screen.dart';
import 'package:biocard/screens/primary_screen/edit_link_screen.dart';
import 'package:biocard/screens/primary_screen/home_screen.dart';
import 'package:biocard/screens/primary_screen/preview_screen.dart';
import 'package:biocard/screens/primary_screen/profile_screen.dart';
import 'package:biocard/screens/secondary_screen/details_screen.dart';
import 'package:biocard/screens/secondary_screen/emoji_screen.dart';
import 'package:biocard/screens/secondary_screen/error_screen.dart';
import 'package:biocard/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


authr(){
  StreamBuilder(
    stream: AuthService().firebaseAuth.authStateChanges(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return HomeScreen(user: snapshot.data);
      }
      return const LoginScreen();
    },
  );
}

class AppRouter{
  GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) {
          final User? res = FirebaseAuth.instance.currentUser;
          return HomeScreen(user: res!);
        },
        routes: [
          GoRoute(
            path: 'addlink',
            name: 'addlink',
            builder: (context, state) {
              final User? res = FirebaseAuth.instance.currentUser;
              return AddLinkScreen(user: res!);
            },
          ),
          GoRoute(
            path: 'editlink/:id/:urlTitle/:url/:userId',
            name: 'editlink',
            builder: (context, state) {
              UrlModel url = UrlModel(
                id: state.params['id']!, 
                urlTitle: state.params['urlTitle']!, 
                url: state.params['url']!, 
                userId: state.params['userId']!,
              );
              return EditLinkScreen(url: url);
            },
          ),
          GoRoute(
            path: 'preview',
            name: 'preview',
            builder: (context, state) {
              return const PreviewScreen();
            },
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: 'emoji',
            name: 'emoji',
            builder: (context, state) {
              return const EmojiScreen();
            },
          ),
        ]
      ),
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: '/forgotpassword',
        name: 'forgotpassword',
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: '/:username',
        name: 'details',
        builder: (context, state) {
          return DetailsScreen(
            username: state.params['username']!
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorScreen());
    },
    redirect: (context, state) {
      if (state.path == '/:username') {
        return '/:username';
      }else{
        return authr();
      }
    },
  );
}
