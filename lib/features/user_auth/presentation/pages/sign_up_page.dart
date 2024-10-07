import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_demo/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:share_demo/features/user_auth/presentation/pages/login_page.dart';
import 'package:share_demo/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:share_demo/global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isCreatingAccount = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Share App - Sign Up'),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: Center(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Account",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "UserId",
                isPasswordField: false,
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _createAccount();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 146, 50, 87),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isCreatingAccount
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 146, 50, 87),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        )));
  }

  void _createAccount() async {
    setState(() {
      _isCreatingAccount = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isCreatingAccount = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happend");
    }
  }
}
