import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_go/features/add_flight_page/add_flight_page.dart';
import 'package:coin_go/features/analyze_page/analyze_page.dart';
import 'package:coin_go/features/flights_page/flights_page.dart';
import 'package:coin_go/features/home_page/home_page.dart';
import 'package:coin_go/features/settings_page/settings_page.dart';
import 'package:coin_go/theme/theme.dart';
import 'navigation_cubit.dart';
import 'navigation_state.dart';

class RootScreenUI extends StatelessWidget {
  RootScreenUI({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    HomePage(),
    FlightsPage(),
    AddFlightPage(),
    AnalyzePage(),
    SettingPage(),
  ];

  final List<TabItem> _bottomNavItems = [
    TabItem(icon: Icons.home, title: 'Home'),
    TabItem(icon: Icons.flight_takeoff, title: 'My Flights'),
    TabItem(icon: Icons.add, title: 'Add Flight'),
    TabItem(icon: Icons.analytics_outlined, title: 'Analyze'),
    TabItem(icon: Icons.settings, title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.AccentColor,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                AbsorbPointer(
                  absorbing: true,
                  child: IconButton(
                    icon: Icon(Icons.notifications, color: Colors.transparent),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notifications clicked!')),
                      );
                    },
                  ),
                ),


                Expanded(
                  child: Center(
                    child: SafeArea(
                      child: Text(
                        _getPageTitle(state.selectedItem),
                        style: const TextStyle(
                          color: AppTheme.TextColorWhite,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.notifications, color: AppTheme.TextColorWhite,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifications clicked!')),
                    );
                  },
                ),
              ],
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: _pages[state.selectedItem.index],
          bottomNavigationBar: Container(
            color: AppTheme.BackgroundColor,
            padding: EdgeInsets.only(right: 16,left: 16,bottom: 16,top: 8),
            child: BottomBarFloating(
              borderRadius: BorderRadius.circular(24),
              items: _bottomNavItems,
              backgroundColor: AppTheme.AccentColor,
              color: AppTheme.TextColorWhite,
              colorSelected: AppTheme.DeepOrange,
              indexSelected: state.selectedItem.index,
              onTap: (int index) {
                context.read<NavigationCubit>().selectItem(NavigationItem.values[index]);
              },
            ),
          ),
        );
      },
    );
  }

  String _getPageTitle(NavigationItem item) {
    switch (item) {
      case NavigationItem.home:
        return 'Home';
      case NavigationItem.analyze:
        return 'Analyze';
      case NavigationItem.flights:
        return 'Flights';
      case NavigationItem.addFlight:
        return 'Add Flight';
      case NavigationItem.settings:
        return 'Settings';
      default:
        return 'My App';
    }
  }
}
