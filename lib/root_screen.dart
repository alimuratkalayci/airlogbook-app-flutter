import 'package:coin_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'features/chat_page/chat_page.dart';
import 'features/giveaway_page.dart';
import 'features/home_page.dart';
import 'features/settings_page/settings_page.dart';
import 'features/wallet_page.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> _pages = [
    HomePage(),
    GiveawayPage(),
    ChatPage(),
    WalletPage(),
    SettingPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackgroundColor,
        title: SafeArea(
          child: Center(
            child: Text(
              _getPageTitle(_selectedIndex),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBackgroundColor,
      ),
      child: SafeArea(
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Giveaways
            SalomonBottomBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              title: Text("Giveaways"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Chat
            SalomonBottomBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              title: Text("Chat"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Wallet
            SalomonBottomBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              title: Text("Wallet"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Settings
            SalomonBottomBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Giveaways';
      case 2:
        return 'Chat';
      case 3:
        return 'Wallet';
      case 4:
        return 'Settings';
      default:
        return 'My App';
    }
  }
}
