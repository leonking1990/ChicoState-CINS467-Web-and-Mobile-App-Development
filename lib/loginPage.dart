import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false,
      verEmail = false,
      verPassword = false,
      _showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //title: const Text('Welcome'),
            ),
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 00),
                        _buildDiscoverCard(),
                        const SizedBox(height: 20),
                        _showErrorMessage
                            ? const Text(
                                'Incorrect E-mail and/or password',
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        const Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 30),
                        _buildSignInButton(context),
                        const SizedBox(height: 20),
                        _buildSocialButtons(),
                        const SizedBox(height: 20),
                        _buildSignUpSuggestion(context),
                      ],
                    ),
                  ),
                ),
        ));
  }

//****************************************************************************** */

  Widget _buildDiscoverCard() {
    // Replace with your network image
    String imageUrl = 'assets/images/Login-page.jpg';

    return Center(
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Replace with your color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(imageUrl),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (_showErrorMessage) {
          return 'Incorrect username and/or password';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: verPassword ? Colors.blueGrey : Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (_showErrorMessage) {
          //return 'Incorrect username and/or password';
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make the button stretch to full width
      child: ElevatedButton(
        onPressed: () {
          _login();
        },
        child: const Text('Sign in'),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle Google sign-in
          },
          child: const Text('Google'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle Facebook sign-in
          },
          child: const Text('Facebook'),
        ),
      ],
    );
  }

  Widget _buildSignUpSuggestion(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: Text('New user? Join now'),
      ),
    );
  }

//****************************************************************************** */

  void _login() async {
    setState(() {
      _isLoading = true;
      _showErrorMessage = false; // Ensure to reset this with each login attempt
    });

    try {
      // Attempt to sign in.
      final User? user = await _authService.sigIinWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Assuming _authService.sigIinWithEmailAndPassword returns null if the user sign-in fails.
      if (user == null) {
        if (kDebugMode) {
          print('User not found!');
        }
        setState(() {
          _showErrorMessage =
              true; // Show error message if sign-in is unsuccessful
        });
      } else {
        // User sign-in is successful
        if (kDebugMode) {
          print('Sign-in successful!');
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
        '/home', // The named route you want to navigate to.
        (Route<dynamic> route) =>
            false, // Conditions for removing all other routes.
      );
      }
    } on FirebaseAuthException catch (authException) {
      // Handle specific Firebase Auth exceptions.
      if (authException.code == 'user-not-found' ||
          authException.code == 'wrong-password') {
        setState(() {
          _showErrorMessage =
              true; // Show an error message specifically for incorrect credentials
        });
        if (kDebugMode) {
          print('Incorrect username or password.');
          _passwordController.clear();
        }
      } else {
        // Handle other types of FirebaseAuthExceptions if needed.
      }
    } catch (e) {
      // Handle any other exceptions that might occur.
      if (kDebugMode) {
        print('Sign-in failed: $e');
      }
    } finally {
      // Stop showing the loading indicator.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
