import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _phoneNumber = '';
  String _verificationId = '';
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) => _phoneNumber = value,
            ),
            ElevatedButton(
              onPressed: () => _verifyPhoneNumber(),
              child: const Text('Verify'),
            ),
            if (_verificationId.isNotEmpty)
              TextField(
                decoration: const InputDecoration(labelText: 'OTP'),
                onChanged: (value) => _otp = value,
              ),
            if (_verificationId.isNotEmpty)
              ElevatedButton(
                onPressed: () => _signInWithOTP(),
                child: const Text('Submit OTP'),
              ),
          ],
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Error: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithOTP() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otp,
    );
    await _auth.signInWithCredential(credential);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => ItemEntryScreen()),
    // );
  }
}
