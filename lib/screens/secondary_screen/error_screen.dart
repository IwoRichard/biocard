import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500
            ),
            child: Image.asset('assets/Error.png')
          ),
          Text(
            'PAGE NOT FOUND',
            style: GoogleFonts.inter(
              fontSize: 30,fontWeight: FontWeight.w700
            ),
          ),
          const Spacer(),
          SizedBox(
            child: Center(
              child: InkWell(
                onTap: (){},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.5),
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
            ),
          ),
          const SizedBox(height: 40,)
        ],
      ),
    );
  }
}