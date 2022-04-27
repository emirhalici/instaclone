import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/home_page/home_page.dart';
import 'package:instaclone/screens/profile_page/profile_page.dart';
import 'package:instaclone/screens/reels_page/reels_page.dart';
import 'package:instaclone/screens/search_page/search_page.dart';
import 'package:instaclone/screens/shop_page/shop_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _homeScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _reelsScreen = GlobalKey<NavigatorState>();
  final _shopScreen = GlobalKey<NavigatorState>();
  final _profileScreen = GlobalKey<NavigatorState>();

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      switch (index) {
        case 0:
          if (_homeScreen.currentState?.canPop() ?? false) {
            _homeScreen.currentState?.popUntil((route) => route.isFirst);
          } else {
            if (context.read<HomePageProvider>().mainPostsController.hasClients) {
              context
                  .read<HomePageProvider>()
                  .mainPostsController
                  .animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          }
          break;
        case 1:
          _searchScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 2:
          _reelsScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 3:
          _shopScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 4:
          if (_profileScreen.currentState?.canPop() ?? false) {
            _profileScreen.currentState?.popUntil((route) => route.isFirst);
          } else {
            if (context.read<ProfilePageProvider>().pageScrollController.hasClients) {
              context
                  .read<ProfilePageProvider>()
                  .pageScrollController
                  .animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          }
          break;

        default:
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await context.read<AuthenticationService>().signOut();
      //     if (mounted) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const LoginPage(),
      //         ),
      //       );
      //     }
      //   },
      //   backgroundColor: Colors.green,
      //   foregroundColor: Colors.white,
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          Navigator(
            key: _homeScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const HomePage(),
            ),
          ),
          Navigator(
            key: _searchScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const SearchPage(),
            ),
          ),
          Navigator(
            key: _reelsScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const ReelsPage(),
            ),
          ),
          Navigator(
            key: _shopScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const ShopPage(),
            ),
          ),
          Navigator(
            key: _profileScreen,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const ProfilePage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColorReversed,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: primaryColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/home_filled.svg',
              color: primaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: primaryColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/search_filled.svg',
              color: primaryColor,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/reels.svg',
              color: primaryColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/reels_filled.svg',
              color: primaryColor,
            ),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              color: primaryColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/shop_filled.svg',
              color: primaryColor,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile_small.png'),
            activeIcon: Image.asset('assets/images/profile_small_filled.png'),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
