import 'package:coin_go/features/add_flight_page/add_flight_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_go/theme/theme.dart';
import '../../features/analyze_page/analyze_page.dart';
import '../../features/flights_page/flights_page.dart';
import '../../features/home_page/home_page.dart';
import '../../features/settings_page/settings_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.darkBackgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Boş bir widget, başlığı ortalamak için
                SizedBox(width: 48.0), // İsteğe bağlı, butonun yerini ayarlamak için kullanılabilir

                Expanded(
                  child: Center(
                    child: SafeArea(
                      child: Text(
                        _getPageTitle(state.selectedItem),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Bildirim simgesine tıklama işlemi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifications clicked!')),
                    );
                  },
                ),
              ],
            ),
            elevation: 0,
            centerTitle: false, // Başlık merkezde değil
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
        TabItem(icon: Icons.analytics_outlined, title: 'Analyze'),
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
