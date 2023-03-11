import 'package:biocard/colors.dart';
import 'package:biocard/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCGA1up-bM2_pRo61eC82WN1mSXRutCQSQ", 
        appId: "1:254527870375:web:a4b8e32e3337e9a8f29282",
        messagingSenderId: "254527870375", 
        projectId: "biocardd",
        storageBucket: "biocardd.appspot.com"
      )
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BioCard',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldColor,
      ),
      routerConfig: AppRouter().router,
    );
  }
}