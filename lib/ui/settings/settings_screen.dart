import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Setting States
  String _defaultBase = 'USD';
  String _defaultTarget = 'INR';
  int _decimals = 2;
  bool _offlineMode = false;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'AUD', 'CAD'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved preferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultBase = prefs.getString('defaultBase') ?? 'USD';
      _defaultTarget = prefs.getString('defaultTarget') ?? 'INR';
      _decimals = prefs.getInt('decimals') ?? 2;
      _offlineMode = prefs.getBool('offlineMode') ?? false;
    });
  }

  // Save string preferences (Currencies)
  void _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Save int preferences (Decimals)
  void _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Save boolean preferences (Offline mode)
  void _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [

          // --- PREFERENCES SECTION ---
          _buildSectionHeader('Preferences'),
          _buildCard(
            context,
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.secondary),
                  title: const Text('Default Base Currency', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: DropdownButton<String>(
                    value: _defaultBase,
                    underline: const SizedBox(),
                    items: _currencies.map((String cur) => DropdownMenuItem(value: cur, child: Text(cur))).toList(),
                    onChanged: (val) {
                      setState(() => _defaultBase = val!);
                      _saveString('defaultBase', val!);
                    },
                  ),
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.currency_exchange, color: Theme.of(context).colorScheme.secondary),
                  title: const Text('Default Target Currency', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: DropdownButton<String>(
                    value: _defaultTarget,
                    underline: const SizedBox(),
                    items: _currencies.map((String cur) => DropdownMenuItem(value: cur, child: Text(cur))).toList(),
                    onChanged: (val) {
                      setState(() => _defaultTarget = val!);
                      _saveString('defaultTarget', val!);
                    },
                  ),
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.numbers, color: Theme.of(context).colorScheme.secondary),
                  title: const Text('Decimal Precision', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: DropdownButton<int>(
                    value: _decimals,
                    underline: const SizedBox(),
                    items: [2, 3, 4, 5].map((int dec) => DropdownMenuItem(value: dec, child: Text('$dec places'))).toList(),
                    onChanged: (val) {
                      setState(() => _decimals = val!);
                      _saveInt('decimals', val!);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- APPEARANCE SECTION ---
          _buildSectionHeader('Appearance'),
          _buildCard(
            context,
            SwitchListTile(
              title: const Text('Dark Theme', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Toggle day and night mode'),
              secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Theme.of(context).colorScheme.secondary),
              activeThumbColor: Theme.of(context).colorScheme.secondary,
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                final provider = Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(value);
              },
            ),
          ),
          const SizedBox(height: 24),

          // --- DATA & STORAGE SECTION ---
          _buildSectionHeader('Data & Storage'),
          _buildCard(
            context,
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Offline Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Use last cached conversion rates'),
                  secondary: Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.secondary),
                  activeThumbColor: Theme.of(context).colorScheme.secondary,
                  value: _offlineMode,
                  onChanged: (value) {
                    setState(() => _offlineMode = value);
                    _saveBool('offlineMode', value);
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.secondary),
                  title: const Text('Clear App Cache', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Free up local storage'),
                  onTap: () => _showSnackBar('Cache cleared successfully'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- ABOUT & LEGAL SECTION ---
          _buildSectionHeader('About & Legal'),
          _buildCard(
            context,
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).colorScheme.secondary),
                  title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showSnackBar('Opening Privacy Policy...'),
                ),
                _buildDivider(),
                const ListTile(
                  leading: Icon(Icons.api),
                  title: Text('Data Sources', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('ExchangeRate-API & NewsAPI'),
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Date Created', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text('May 2026', style: TextStyle(color: Colors.grey)),
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: const Text('System Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text('Active / Stable', style: TextStyle(color: Colors.grey)),
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // UI Helper functions for cleaner code
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, color: Colors.grey.withValues(alpha: 0.2));
  }
}