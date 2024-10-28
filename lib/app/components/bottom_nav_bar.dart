import 'package:ecom/app/screens/cart.dart';
import 'package:ecom/app/screens/catalog.dart';
import 'package:ecom/app/screens/favorite.dart';
import 'package:ecom/app/screens/home.dart';
import 'package:ecom/app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    Color activeColor = Theme.of(context).colorScheme.primary;
    return PersistentTabView(
      avoidBottomPadding: true,
      handleAndroidBackButtonPress: true,
      popActionScreens: PopActionScreensType.all,
      resizeToAvoidBottomInset: false,
      stateManagement: true,
      tabs: [
        PersistentTabConfig(
          screen: const HomePage(),
          item: ItemConfig(
            activeColorSecondary: activeColor,
            activeForegroundColor: activeColor,
            inactiveIcon: const Icon(Iconsax.home),
            icon: const Icon(Iconsax.home_15),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const CatalogPage(),
          item: ItemConfig(
            activeColorSecondary: activeColor,
            activeForegroundColor: activeColor,
            inactiveIcon: const Icon(Iconsax.search_status),
            icon: const Icon(Iconsax.search_status),
            title: "Catalog",
          ),
        ),
        PersistentTabConfig(
          screen: const CartPage(),
          item: ItemConfig(
            activeColorSecondary: activeColor,
            activeForegroundColor: activeColor,
            inactiveIcon: const Icon(Iconsax.shopping_cart),
            icon: const Icon(Iconsax.shopping_cart5),
            title: "Cart",
          ),
        ),
        PersistentTabConfig(
          screen: const FavoritePage(),
          item: ItemConfig(
            activeColorSecondary: activeColor,
            activeForegroundColor: activeColor,
            inactiveIcon: const Icon(Iconsax.heart),
            icon: const Icon(Iconsax.heart5),
            title: "Favorite",
          ),
        ),
        PersistentTabConfig(
          screen: const ProfilePage(),
          item: ItemConfig(
            activeColorSecondary: activeColor,
            activeForegroundColor: activeColor,
            inactiveIcon: const Icon(Iconsax.profile_circle),
            icon: const Icon(Iconsax.profile_circle5),
            title: "Profile",
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }
}
