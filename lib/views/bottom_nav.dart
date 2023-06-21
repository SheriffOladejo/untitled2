import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:untitled2/models/wallet.dart';
import 'package:untitled2/utils/db_helper.dart';
import 'package:untitled2/utils/hex_color.dart';
import 'package:untitled2/views/explore_screen.dart';
import 'package:untitled2/views/wallets_screen.dart';
import 'package:untitled2/views/market_screen.dart';
import 'package:untitled2/views/settings_screen.dart';

class BottomNav extends StatefulWidget {

  const BottomNav({Key key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();

}

class _BottomNavState extends State<BottomNav> {

  PersistentTabController _controller;

  List<Wallet> wallet_list = [];


  List<Widget> _buildScreens() {
    return [
      const WalletScreen(),
      const MarketScreen(),
      const ExploreScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  Future<void> callback() async {
    DbHelper db = DbHelper();
    wallet_list = await db.getWallets();
    setState(() {

    });
  }

  Future<void> init () async {
    _controller = PersistentTabController(initialIndex: 0);
    DbHelper db = DbHelper();
    wallet_list = await db.getWallets();
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/wallet.png"),
        ),
        title: ("Wallets"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/market.png"),
        ),
        title: ("Market"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/explore.png"),
        ),
        title: ("Explore"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'inter-medium',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        icon: ImageIcon(
          AssetImage("assets/images/settings.png"),
        ),
        title: ("Settings"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: HexColor("#AAAAAA"),
      ),
    ];
  }

}
