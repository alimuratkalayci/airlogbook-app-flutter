import 'package:coin_go/features/login_pages/welcome_page/welcome_screen.dart';
import 'package:coin_go/features/settings_page/sub_pages/add_favorite_aircraft_page/add_favorite_aircraft_page.dart';
import 'package:coin_go/features/settings_page/sub_pages/change_password_page/change_password_page.dart';
import 'package:coin_go/features/settings_page/sub_pages/delete_account_page/delete_account_page.dart';
import 'package:coin_go/features/settings_page/sub_pages/feedback_and_support/feedback_and_support_page.dart';
import 'package:coin_go/features/settings_page/sub_pages/set_location_page/set_location_page.dart';
import 'package:coin_go/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/show_logout_modal_bottom_sheet.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print('Sign out successful.');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Change Password',
                              style: TextStyle(color: AppTheme.TextColorWhite),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddFavoriteAircraftPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Add Favorite Aircraft',
                              style: TextStyle(color: AppTheme.TextColorWhite),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SetLocationPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Set Location',
                              style: TextStyle(color: AppTheme.TextColorWhite),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbackAndSupportPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Feedback and Support',
                              style: TextStyle(color: AppTheme.TextColorWhite),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteAccountPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Delete Account',
                              style: TextStyle(color: AppTheme.TextColorWhite),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showLogoutConfirmationBottomSheet(context).then((result) {
                                if (result == 'logged_out') {
                                  _signOut().then((_) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                    );
                                  }).catchError((error) {
                                    print('Sign out failed: $error');
                                  });
                                }
                              }).catchError((error) {
                                print('Modal failed: $error');
                              });
                            },

                            child: Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
