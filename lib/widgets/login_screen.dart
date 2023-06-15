// The basic skeleton structure of the widget

import 'package:app4hr/utils/firestore.dart';
import 'package:app4hr/widgets/popups.dart';
import 'package:flutter/material.dart';

import '../utils/authentication.dart';
import '../utils/navigation_functions.dart';
import 'googleSignInButton.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;
  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false, _isRegistering = false;

  late String loginStatus;
  late Color loginStringColor;

  FirestoreService fireStoreService = FirestoreService();

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerEmail.text = '';
    textFocusNodeEmail = FocusNode();

    textControllerPassword = TextEditingController();
    textControllerPassword.text = '';
    textFocusNodePassword = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), // ...
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text('Email address'),
                      const SizedBox(
                        height: 4,
                      ),
                      buildEmailTextField,
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Password'),
                      const SizedBox(
                        height: 4,
                      ),
                      buildPasswordTextField,
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          signUpButton,
                          SizedBox(
                            width: 5,
                          ),
                          signInButton
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisSize: MainAxisSize.max,
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Flexible(
                      //       flex: 1,
                      //       child: SizedBox(
                      //         width: double.maxFinite,
                      //         child: TextButton(
                      //           onPressed: () {},
                      //           child: const Text(
                      //             'Log in',
                      //             style: TextStyle(fontSize: 14, color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Flexible(
                      //       flex: 1,
                      //       child: SizedBox(
                      //         width: double.maxFinite,
                      //         child: TextButton(
                      //           onPressed: () {},
                      //           child: const Text(
                      //             'Sign up',
                      //             style: TextStyle(fontSize: 14, color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const Center(child: GoogleButton()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField get buildEmailTextField => TextField(
        focusNode: textFocusNodeEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: textControllerEmail,
        autofocus: false,
        onChanged: (value) {
          setState(() {
            _isEditingEmail = true;
          });
        },
        onSubmitted: (value) {
          textFocusNodeEmail.unfocus();
          FocusScope.of(context).requestFocus(textFocusNodeEmail);
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.blueGrey[800]!,
              width: 3,
            ),
          ),
          filled: true,
          hintStyle: TextStyle(
            color: Colors.blueGrey[300],
          ),
          hintText: "Email",
          fillColor: Colors.white,
          errorText:
              _isEditingEmail ? _validateEmail(textControllerEmail.text) : null,
          errorStyle: const TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      );

  TextField get buildPasswordTextField => TextField(
        focusNode: textFocusNodePassword,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: textControllerPassword,
        autofocus: false,
        onChanged: (value) {
          setState(() {
            _isEditingPassword = true;
          });
        },
        onSubmitted: (value) {
          textFocusNodePassword.unfocus();
          FocusScope.of(context).requestFocus(textFocusNodePassword);
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.blueGrey[800]!,
              width: 3,
            ),
          ),
          filled: true,
          hintStyle: TextStyle(
            color: Colors.blueGrey[300],
          ),
          hintText: "Password",
          fillColor: Colors.white,
          errorText: _isEditingPassword
              ? _validatePassword(textControllerPassword.text)
              : null,
          errorStyle: const TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      );

  TextButton get signUpButton => TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueGrey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () async {
          await signOut();
          setState(() {
            _isRegistering = true;
          });
          await registerWithEmailPassword(
                  textControllerEmail.text, textControllerPassword.text)
              .then((result) async {
            if (result != null) {
              loginStatus = 'You have registered successfully';
              loginStringColor = Colors.green;

              if(result.emailVerified){
                gotoClientDashboard(context);
              }
              else{
                Popups.showSuccessPopup(context, "Verfication is sent to your email. Please verify it.");
              }

              print(result);

              await fireStoreService.addUser(user!);
            } else {
              loginStatus = 'Error occurred while registering';
              loginStringColor = Colors.green;
              Popups.showErrorPopup(context, error?? loginStatus);
            }
          }).catchError((error) {
            print('Registration Error: $error');

            loginStatus = 'Error occurred while registering';
            loginStringColor = Colors.red;
            Popups.showErrorPopup(context, loginStatus);
          });

          setState(() {
            _isRegistering = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 30.0,
          ),
          child: _isRegistering
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
        ),
      );

  TextButton get signInButton => TextButton(
        style: TextButton.styleFrom(
          // foregroundColor: Colors.blueGrey.shade800,
          backgroundColor: Colors.blue.shade500,
          textStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isRegistering = true;
          });
          await signInWithEmailPassword(
                  textControllerEmail.text, textControllerPassword.text)
              .then((result) async {
            if (user!.emailVerified) {
              if (result != null) {
                loginStatus = 'You have logged in successfully';
                loginStringColor = Colors.green;
                var isAdmin = (await fireStoreService.getUserById(user!.uid))!
                    .data()!["isAdmin"];
                if (isAdmin) {
                  gotoAdminDashboard(context);
                } else {
                  gotoClientDashboard(context);
                }
                print("isAdmin: ${isAdmin.toString()}");
                print(result);
              } else {
                loginStatus = 'Credentials are not correct';
                loginStringColor = Colors.green;
                Popups.showErrorPopup(context, loginStatus);
              }
            } else {
              Popups.showWarningPopup(context, "Please verify your email.");
            }
          }).catchError((error) {
            print('Signin Error: $error');

            loginStatus = 'Error occurred while signing in';
            loginStringColor = Colors.red;
            Popups.showErrorPopup(context, loginStatus);
          });

          setState(() {
            _isRegistering = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 30.0,
          ),
          child: _isRegistering
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
        ),
      );

  String? _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String? _validatePassword(String value) {
    value = value.trim();

    if (textControllerPassword.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Password should be at least 6 character';
      }
    }

    return null;
  }
}
