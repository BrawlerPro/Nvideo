import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hentai_reader_love/model/user_model.dart';
import 'package:hentai_reader_love/pages/main_screen.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _auth = FirebaseAuth.instance;

  // our from key
  final _fromKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingContoller = TextEditingController();
  final emailEditingContoller = TextEditingController();
  final passwordEditingContoller = TextEditingController();
  final confirmpasswordEditingContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final firstNameFiled = TextFormField(
      autocorrect: false,
      controller: firstNameEditingContoller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if(value!.isEmpty) {
          return('Name is required for login');
        }
        if(!regex.hasMatch(value)){
          return("Plese Enter Valid name(Min. 3 Character");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingContoller.text = value!;
      },
      textInputAction:  TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Name",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),

    );

    final emailFiled = TextFormField(
      autocorrect: false,
      controller: emailEditingContoller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if(value!.isEmpty)
        {
          return ("Please enter Your Email");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
        {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingContoller.text = value!;
      },
      textInputAction:  TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Email",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),

    );

    final passwordFiled = TextFormField(
      autocorrect: false,
      obscureText: true,
      controller: passwordEditingContoller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.isEmpty) {
          return('Plese Entern your Password');



        }
        if(!regex.hasMatch(value)){
          return("Plese Enter Valid Password(Min. 6 Character");
        }
        return null;

      },
      onSaved: (value) {
        passwordEditingContoller.text = value!;
      },
      textInputAction:  TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),

    );

    final confirmPasswordFiled = TextFormField(
      autocorrect: false,
      obscureText: true,
      controller: confirmpasswordEditingContoller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if(confirmpasswordEditingContoller.text != passwordEditingContoller.text)
        {
          return"Password dont math";
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordEditingContoller.text = value!;
      },
      textInputAction:  TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),

    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingContoller.text, passwordEditingContoller.text);
        },
        child: const Text('Sing UP', textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green, size: 20.0,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key:  _fromKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: SizedBox(child: Image.asset("assets/mvideo.png", fit: BoxFit.contain)),
                    ),
                    firstNameFiled,
                    const SizedBox(height: 10,),
                    emailFiled,
                    const SizedBox(height: 10,),
                    passwordFiled,
                    const SizedBox(height: 10,),
                    confirmPasswordFiled,
                    const SizedBox(height: 10,),
                    signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void signUp(String email, String password) async
  {
    if(_fromKey.currentState!.validate())
    {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
        postDetailsToFirestore(),

      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async
  {
    //calling our firestore
    // calling our user model
    //sending rhese values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = firstNameEditingContoller.text;


    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created succdsesfully :)");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => const MainScreen()),
            (route) => false);

  }
}
