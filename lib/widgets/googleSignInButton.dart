import 'package:app4hr/utils/firestore.dart';
import 'package:flutter/material.dart';
import '../utils/authentication.dart';
import '../utils/navigation_functions.dart';
import 'popups.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isProcessing = false;
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.blueGrey, width: 1),
        ),
        color: Colors.white,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.blueGrey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.blueGrey, width: 3),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          setState(() {
            _isProcessing = true;
          });
          await signInWithGoogle().then((result) async {
            print(result);
            if (result != null) {
              var data = (await firestoreService.getUserById(user!.uid))!.data();
              if(data == null){
                await firestoreService.addUser(user!);
              }
              else if(data!["isAdmin"]){
                gotoAdminDashboard(context);
              }
              else{
                gotoClientDashboard(context);
              }
              print("Successfully created");
            }
            else{
              var loginStatus = 'Error occurred while signing in';
              Popups.showErrorPopup(context, loginStatus);
            }
          }).catchError((error) {
            print('Registration Error: $error');
            var loginStatus = 'Error occurred while signing in';
            Popups.showErrorPopup(context, loginStatus);
          });
          setState(() {
            _isProcessing = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: _isProcessing
              ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blueGrey,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Image(
                image: AssetImage("assets/images/google-logo.png"),
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
