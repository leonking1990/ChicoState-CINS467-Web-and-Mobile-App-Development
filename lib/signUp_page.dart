import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerController = TextEditingController();
  final FirebaseAuthService _authService =
      FirebaseAuthService(); // Your authentication service

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: _isLoading
          ? const CircularProgressIndicator()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(labelText: 'User ID'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: _passwordVerController,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () => _signUp(),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
    );
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    if (_passwordController == _passwordController) {
      final String desiredUsername = _userIdController.text.trim();
      // Query Firestore to check if username is already in use
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: desiredUsername)
          .limit(1)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        // Username is taken
        setState(() {
          _isLoading = false;
        });
        // Show an error message to the user
      } else {
        try {
          // Use your AuthService to create a new user with email and password
          User? user = await _authService.signUpWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          if (user != null) {
            // Construct user data map
            final userData = {
              'firstName': _firstNameController.text.trim(),
              'lastName': _lastNameController.text.trim(),
              'userId': desiredUsername,
              'email': _emailController.text.trim(),
              'downloadURL': "https://firebasestorage.googleapis.com/v0/b/cinecritique-b9117.appspot.com/o/DefaultProfile.jpg?alt=media&token=8e652483-452e-443d-a721-81cf5d5597f3",
              'title': "",
              'timestamp': "",
            };

            // Send the additional user data to Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userData);

            // Navigate to the next page (home, profile, etc.) after sign up
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            _isLoading = false;
          });
          if (e.code == 'email-already-in-use') {
            // The email is already in use.
            // Show an error message or handle the situation appropriately.
          } else {
            // Handle other FirebaseAuth issues
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', // The named route you want to navigate to.
            (Route<dynamic> route) =>
                false, // Conditions for removing all other routes.
          );
        }
      }
    } else {
      // display message password dose not match
      if (kDebugMode) {
        print('password dose not match');
      }
    }
  }

  // Remember to dispose of your controllers
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
