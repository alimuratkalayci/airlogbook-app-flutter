import 'package:coin_go/features/add_flight_page/add_flight_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_go/theme/theme.dart';
import '../../features/chat_page/chat_page.dart';
import '../../features/flights_page/my_flights_page.dart';
import '../../features/home_page/home_page.dart';
import '../../features/settings_page/settings_page.dart';
import 'navigation_cubit.dart';
import 'navigation_state.dart';

class RootScreenUI extends StatelessWidget {
  RootScreenUI({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    HomePage(),
    MyFlightsPage(),
    AddFlightPage(),
    ChatPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
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
    );
  }

  Widget _buildBottomNavBar(BuildContext context, NavigationState state) {
    return ConvexAppBar(
      backgroundColor: AppTheme.darkBackgroundColor,
      style: TabStyle.fixedCircle,
      items: [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(
          icon: Image.asset('assets/icons/flights1.png'),
          activeIcon: Image.asset('assets/icons/flights2.png'),
          title: 'Flights',
        ),
        TabItem(icon: Icons.add, title: 'Add Flight'),
        TabItem(icon: Icons.chat_bubble_outline, title: 'Chat'),
        TabItem(icon: Icons.settings, title: 'Settings'),
      ],
      initialActiveIndex: state.selectedItem.index,
      onTap: (int index) {
        context.read<NavigationCubit>().selectItem(NavigationItem.values[index]);
      },
      activeColor: Colors.deepOrange,
      color: Colors.white,
    );
  }


  String _getPageTitle(NavigationItem item) {
    switch (item) {
      case NavigationItem.home:
        return 'Home';
      case NavigationItem.chat:
        return 'My Flights';
      case NavigationItem.wallet:
        return 'Wallet';
      case NavigationItem.settings:
        return 'Settings';
      case NavigationItem.addFlight:
        return 'Add Flight';
      default:
        return 'My App';
    }
  }
}
