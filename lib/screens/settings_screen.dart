import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;
  String _selectedLanguage = 'Indonesia';

  final List<String> _languages = [
    'Indonesia',
    'Inggris',
    'Jepang',
    'Korea',
    'Mandarin',
  ];

  /// ================================
  /// ✅ FUNGSI LOGOUT (DITAMBAHKAN)
  /// ================================
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          buildSectionTitle("Akun"),
          buildListTile(
            icon: Icons.person,
            title: "Profil",
            subtitle: "Kelola informasi akun Anda",
            onTap: () {},
          ),
          buildListTile(
            icon: Icons.lock,
            title: "Keamanan",
            subtitle: "Atur ulang kata sandi",
            onTap: () {},
          ),
          buildListTile(
            icon: Icons.language,
            title: "Bahasa",
            subtitle: _selectedLanguage,
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              items: _languages
                  .map((lang) =>
                      DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            onTap: () {},
          ),
          const Divider(),

          buildSectionTitle("Preferensi"),
          SwitchListTile(
            title: const Text("Notifikasi"),
            subtitle: const Text("Aktifkan atau nonaktifkan notifikasi"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: const Color(0xFF6750A4),
          ),
          SwitchListTile(
            title: const Text("Tema Gelap"),
            subtitle: const Text("Ubah tampilan aplikasi ke mode gelap"),
            value: _darkThemeEnabled,
            onChanged: (value) {
              setState(() {
                _darkThemeEnabled = value;
              });
            },
            activeColor: const Color(0xFF6750A4),
          ),
          const Divider(),

          buildSectionTitle("Tentang"),
          buildListTile(
            icon: Icons.info,
            title: "Tentang Aplikasi",
            subtitle: "Versi 1.0.0",
            onTap: () {},
          ),
          buildListTile(
            icon: Icons.support,
            title: "Bantuan",
            subtitle: "Pusat bantuan dan FAQ",
            onTap: () {},
          ),
          const Divider(),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Keluar", style: TextStyle(color: Colors.red)),
            subtitle: const Text("Keluar dari aplikasi"),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6750A4),
        ),
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6750A4)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// ================================
  /// ⚡ DIALOG LOGOUT (DIPERBAIKI)
  /// ================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),

          /// 🔥 Logout beneran (sudah terhubung ke Firebase + clear Prefs)
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await logout(context);
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
