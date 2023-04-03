import 'package:example/codescreen.dart';
import 'package:example/firebase_auth.dart';
import 'package:example/imageScreen.dart';
import 'package:example/loginscreen.dart';
import 'package:example/signupscreen.dart';
import 'package:example/text_summarization_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Functions extends StatefulWidget {
  const Functions({super.key});

  @override
  State<Functions> createState() => _FunctionsState();
}

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

class _FunctionsState extends State<Functions> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "HyperBeast.AI",
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 24.0, color: Colors.black),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                navigateToScreen(context, const CodeScreen());
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "Generate Code",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 23),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                navigateToScreen(context, const ImageScreen());
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "Generate Images By AI",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                navigateToScreen(context, const TextSummarizationScreen());
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "Text Summerization",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await FirebaseAuthHelper.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
