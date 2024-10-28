import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Box cartBox = Hive.box('CART');
  Box favoritesBox = Hive.box('FAVORITES');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  favoritesBox.clear();
                },
                child: const Text("Clear Favorites"),
              ),
              ElevatedButton(
                onPressed: () {
                  cartBox.clear();
                },
                child: const Text("Clear Cart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
