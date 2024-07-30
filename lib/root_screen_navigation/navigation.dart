import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:coin_go/theme/theme.dart';
import '../features/chat_page/chat_page.dart';
import '../features/giveaway_page.dart';
import '../features/home_page.dart';
import '../features/settings_page/settings_page.dart';
import '../features/wallet_page.dart';
import 'navigation_cubit.dart';
import 'navigation_state.dart';


class RootScreenUI extends StatelessWidget {
  RootScreenUI({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    HomePage(),
    GiveawayPage(),
    ChatPage(),
    WalletPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<NavigationCubit>();
        if (cubit.state.selectedItem == NavigationItem.home) {
          return true; // Uygulamadan çık
        }
        cubit.selectItem(NavigationItem.home); // Ana sayfaya dön
        return false; // Uygulamayı kapatma
      },
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.darkBackgroundColor,
              title: SafeArea(
                child: Center(
                  child: Text(
                    _getPageTitle(state.selectedItem),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              elevation: 0,
            ),
            body: _pages[state.selectedItem.index],
            bottomNavigationBar: _buildBottomNavBar(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, NavigationState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBackgroundColor,
      ),
      child: SafeArea(
        child: SalomonBottomBar(
          currentIndex: state.selectedItem.index,
          onTap: (index) {
            context.read<NavigationCubit>().selectItem(NavigationItem.values[index]);
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Giveaways
            SalomonBottomBarItem(
              icon: const Icon(Icons.card_giftcard_outlined),
              title: const Text("Giveaways"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Chat
            SalomonBottomBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              title: const Text("Chat"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Wallet
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text("Wallet"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),

            /// Settings
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text("Settings"),
              selectedColor: AppTheme.darkAccentColor,
              unselectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  String _getPageTitle(NavigationItem item) {
    switch (item) {
      case NavigationItem.home:
        return 'Home';
      case NavigationItem.giveaways:
        return 'Giveaways';
      case NavigationItem.chat:
        return 'Chat';
      case NavigationItem.wallet:
        return 'Wallet';
      case NavigationItem.settings:
        return 'Settings';
      default:
        return 'My App';
    }
  }
}
