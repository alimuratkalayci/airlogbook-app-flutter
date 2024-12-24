import 'package:coin_go/general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../root_screen.dart';
import '../../../theme/theme.dart';
import '../forgot_password_page/forgot_password_page.dart';
import 'auth_state.dart';
import 'auth_cubit.dart';

class SignInUpPage extends StatefulWidget {
  @override
  _SignInUpPageState createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  final _emailController = TextEditingController();
  final _emailControllerSignUp = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerSignUp = TextEditingController();
  final _confirmPasswordControllerSignUp = TextEditingController();
  final _usernameControllerSignUp = TextEditingController();

  bool isLogin = true;
  bool isValidEmail = true;
  bool passwordsMatch = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: BlocProvider(
        create: (_) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _usernameControllerSignUp.clear();
              _emailControllerSignUp.clear();
              _passwordControllerSignUp.clear();
              _confirmPasswordControllerSignUp.clear();
              _emailController.clear();
              _passwordController.clear();
            }
            if (state is AuthError) {
              showCustomModal(context: context, title: 'Error', message: state.message);
            } else if (state is AuthLoggedIn) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => RootScreen()));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AIR LOGBOOK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.AccentColor,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = true;
                          });
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: isLogin
                                ? AppTheme.AccentColor
                                : Colors.grey,
                            fontWeight: isLogin ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = false;
                          });
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: !isLogin
                                ? AppTheme.AccentColor
                                : Colors.grey,
                            fontWeight: !isLogin ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  if (isLogin) _buildLoginForm(context) else _buildSignUpForm(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _login(context),
                child: _isProcessing
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.AccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
          },
          child: Text(
            "Forgot password?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.AccentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameControllerSignUp,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emailControllerSignUp,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordControllerSignUp,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordControllerSignUp,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: AppTheme.AccentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: AppTheme.AccentColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          obscureText: true,
        ),
        if (!passwordsMatch)
          Text(
            'Passwords do not match!',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _signUp(context),
                child: _isProcessing
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.AccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  void _login(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomModal(context: context, title: 'Error', message: "All fields are required.");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      showCustomModal(context: context, title: 'Error', message: "Please enter a valid e-mail address");
      return;
    }

    context.read<AuthCubit>().signIn(context, email, password);
  }


  void _signUp(BuildContext context) {
    final email = _emailControllerSignUp.text.trim();
    final password = _passwordControllerSignUp.text.trim();
    final confirmedPassword = _confirmPasswordControllerSignUp.text.trim();
    final username = _usernameControllerSignUp.text.trim();

    if (email.isEmpty || password.isEmpty || confirmedPassword.isEmpty || username.isEmpty) {
      showCustomModal(context: context, title: 'Error', message: 'All fields are required.');
      return;
    }

    if (password != confirmedPassword) {
      setState(() {
        passwordsMatch = false;
      });
      return;
    } else {
      setState(() {
        passwordsMatch = true;
      });
    }

    context.read<AuthCubit>().signUp(context, email, password, username);
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameControllerSignUp.dispose();
    _emailControllerSignUp.dispose();
    _passwordControllerSignUp.dispose();
    _confirmPasswordControllerSignUp.dispose();
    super.dispose();
  }
}
