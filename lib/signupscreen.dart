import 'package:example/functions.dart';
import 'package:example/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/logo (1).png',
                          height: 200,
                          width: 200,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _nameTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    User? user = await FirebaseAuthHelper
                                        .registerUsingEmailPassword(
                                      name: _nameTextController.text,
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text,
                                    );

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    if (user != null) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => Functions(),
                                        ),
                                        ModalRoute.withName('/'),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                  }
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(fontSize: 20),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "Already have an Account?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: "Poppins"),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Or Sign Up with",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    // _googleSignIn.signIn().then((value) {
                                    //   String userName = value!.displayName!;
                                    //   String profilePicture = value.photoUrl!;
                                    //   // Navigate to the main screen after successful sign-in
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Functions()),
                                    //   );
                                    // });
                                    await signInWithGoogle();
                                  },
                                  child:
                                      Image.asset('assets/icons-google.png')),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Image.asset('assets/icons-apple.png'),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    // signInWithFacebook();
                                  },
                                  child:
                                      Image.asset('assets/icons-facebook.png')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  // void signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance
  //         .login(permissions: (['email', 'public_profile']));
  //     final token = result.accessToken!.token;
  //     print(
  //         'Facebook token userID : ${result.accessToken!.grantedPermissions}');
  //     final graphResponse = await http.get(Uri.parse(
  //         'https://graph.facebook.com/'
  //         'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));

  //     final profile = jsonDecode(graphResponse.body);
  //     print("Profile is equal to $profile");
  //     try {
  //       final AuthCredential facebookCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);
  //       final userCredential = await FirebaseAuth.instance
  //           .signInWithCredential(facebookCredential);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const Functions()),
  //       );
  //     } catch (e) {
  //       final snackBar = SnackBar(
  //         margin: const EdgeInsets.all(20),
  //         behavior: SnackBarBehavior.floating,
  //         content: Text(e.toString()),
  //         backgroundColor: (Colors.redAccent),
  //         action: SnackBarAction(
  //           label: 'dismiss',
  //           onPressed: () {},
  //         ),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   } catch (e) {
  //     print("error occurred");
  //     print(e.toString());
  //   }
  // }
}
