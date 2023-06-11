import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? userEmail;

String? name;
String? imageUrl;

User? user;

FirebaseOptions firebaseOptions =  const FirebaseOptions(
    apiKey: "AIzaSyAHr1LoM2HwpV6KWgj4Nc_OrpY4ERfjIlw",
    authDomain: "app4hr-a0867.firebaseapp.com",
    projectId: "app4hr-a0867",
    storageBucket: "app4hr-a0867.appspot.com",
    messagingSenderId: "214736634664",
    appId: "1:214736634664:web:5c2cf70c78c5703b31c61d"
);

Future<User?> registerWithEmailPassword(String email, String password) async {
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: firebaseOptions,
  // );

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = userCredential.user;

    if (user != null) {
      uid = user!.uid;
      userEmail = user!.email;
    }
  }on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print(e.message.toString());
      print('An account already exists for that email.');
    }
  }
  catch (e) {
    print(e);
  }

  return user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  // await Firebase.initializeApp(options: firebaseOptions);

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user!.uid;
      userEmail = user!.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
    }
  }

    // Initialize Firebase

  return user;
}

Future<User?> signInWithGoogle() async {
  await Firebase.initializeApp(options: firebaseOptions);

  // The `GoogleAuthProvider` can only be used while running on the web
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);

    user = userCredential.user;

  } catch (e) {
    print(e);
  }

  if (user != null) {
    uid = user!.uid;
    name = user!.displayName;
    userEmail = user!.email;
    imageUrl = user!.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
  }

  return user;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;

  return 'User signed out';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print("User signed out of Google account");
}



