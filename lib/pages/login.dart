import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hentai_reader_love/pages/main_screen.dart';
import 'package:hentai_reader_love/pages/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //from key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();

  final _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {

    //login function
    void singnIN(String email, String password) async
    {
      if(_formKey.currentState!.validate())
      {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          Fluttertoast.showToast(msg: "Login Succsessful"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()))


        }).catchError((e)
        {
          Fluttertoast.showToast(msg: e!.message);

        });
      }
    }

    // email Filed
    final emailFiled = TextFormField(
      autocorrect: false,
      controller: emailControler,
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
        emailControler.text = value!;
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
      controller: passwordControler,
      obscureText: true,

      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.isEmpty) {
          return('Plese Entern your Password');



        }
        if(!regex.hasMatch(value)){
          return("Plese Enter Valid Password(Min. 6 Character)");
        }
        return null;

      },
      onSaved: (value) {
        passwordControler.text = value!;
      },
      textInputAction:  TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          singnIN(emailControler.text, passwordControler.text);
        },
        child: const Text('Login', textAlign: TextAlign.center,
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key:  _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: SizedBox(child: Image.asset("assets/mvideo.png", fit: BoxFit.contain)),
                    ),
                    const SizedBox(height: 40,),
                    emailFiled,
                    const SizedBox(height: 20,),
                    passwordFiled,
                    const SizedBox(height: 20,),
                    loginButton,
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Dont, Have an account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text('Sign Up',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize:  15),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
