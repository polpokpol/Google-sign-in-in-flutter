// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  String _imageUrl;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Board"), centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Google sign-in"),
                onPressed: () => _gSignin(),
                color: Colors.red,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Signin with Email"),
                color: Colors.amberAccent,
                onPressed: () => _signInWithEmail(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Create Account"),
                color: Colors.lightBlueAccent,
                onPressed: () => _createUser(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: FlatButton(
                child: Text("Sign Out"),
                color: Colors.blueGrey,
                onPressed: () => _logout(),
              ),
            ),

            Image.network(_imageUrl == null || _imageUrl.isEmpty ?
            "https://picsum.photos/200/300"
            : _imageUrl),

          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignin() async{
    // print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
   final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn(); 
   final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
   final AuthCredential credential = GoogleAuthProvider.getCredential(
     
     accessToken: googleSignInAuthentication.accessToken,
     idToken: googleSignInAuthentication.idToken,
   );

   FirebaseUser user = await _auth.signInWithCredential(credential);


  print("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWUser is: ${user.photoUrl}");

  setState(() {
    _imageUrl = user.photoUrl;
  });

   return user;

  }



  Future _createUser() async{
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: "the.owl434@gmail.com", password: "test12345" // dummy email and cannot be repeated 
    ).then((user){
      print("User created ${user.displayName}");
      print("Email: ${user.email}");
      });
  }


  void _logout(){
    setState(() {
      // _googleSignIn.signOut();
      _auth.signOut();
      _imageUrl = null;
    }); 
  }



  void _signInWithEmail(){
    _auth.signInWithEmailAndPassword(
      email: "the.owl434@gmail.com", // dummy. Not finished yet
      password: "test12345",
    ).catchError((onError){
      print("Something went wrong! ${onError.toString()}");
    }).then((newUser){
      print("User signed in: ${newUser.email}");
    });
  }


  
}

