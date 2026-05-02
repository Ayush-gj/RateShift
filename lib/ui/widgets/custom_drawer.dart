import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- NEW LAYERED LOGO STACK ---
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.hexagon_outlined, size: 80, color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)),
                      Icon(Icons.currency_exchange, size: 45, color: Theme.of(context).colorScheme.secondary),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Icon(Icons.trending_up, size: 25, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // --- BRAND TEXT ---
                  Text(
                    'RATESHIFT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0, // Added letter spacing for a premium look
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Converter', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Live News', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}