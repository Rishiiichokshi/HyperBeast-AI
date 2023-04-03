import 'package:example/functions.dart';
import 'package:example/resetPassword.dart';
import 'package:example/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo (1).png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 30),
                Container(
                  width: 350,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
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
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
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
                ),
                Padding(
                  padding: EdgeInsets.only(right: 29),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(),
                          ),
                        ),
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => signIn(context),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 20),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  "Don't have an Account?",
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: "Poppins"),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Or Login with",
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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
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
                          child: Image.asset('assets/icons-google.png')),
                      SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                          onTap: () async {
                            // signInWithFacebook();
                          },
                          child: Image.asset('assets/icons-facebook.png')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Future<void> signIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context); // Dismiss the dialog when the sign-in is completed

      // Navigate to a new page after sign-in is successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Functions()),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Navigator.pop(context); // Dismiss the dialog when an error occurs

      // Show an error message to the user using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
