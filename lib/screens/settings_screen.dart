import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Indonesia';
  String _selectedCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Indonesia';
      _selectedCurrency = prefs.getString('currency') ?? 'IDR';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionHeader('Akun & Profil'),
            _buildSettingItem(
              icon: Icons.person,
              title: 'Profil Pengguna',
              subtitle: 'Kelola informasi akun Anda',
              onTap: () => _showProfileDialog(),
            ),
            _buildSettingItem(
              icon: Icons.business,
              title: 'Informasi Toko',
              subtitle: 'Detail restoran/kedai',
              onTap: () => _showStoreInfoDialog(),
            ),

            const SizedBox(height: 20),

            // Preferences Section
            _buildSectionHeader('Preferensi'),
            _buildSwitchItem(
              icon: Icons.notifications,
              title: 'Notifikasi',
              subtitle: 'Aktifkan pemberitahuan transaksi',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
                _saveSetting('notifications', value);
              },
            ),
            _buildSwitchItem(
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              subtitle: 'Tema gelap untuk aplikasi',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() => _darkModeEnabled = value);
                _saveSetting('darkMode', value);
              },
            ),

            const SizedBox(height: 20),

            // Regional Section
            _buildSectionHeader('Regional'),
            _buildDropdownItem(
              icon: Icons.language,
              title: 'Bahasa',
              subtitle: 'Pilih bahasa aplikasi',
              value: _selectedLanguage,
              items: ['Indonesia', 'English'],
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                _saveSetting('language', value);
              },
            ),
            _buildDropdownItem(
              icon: Icons.attach_money,
              title: 'Mata Uang',
              subtitle: 'Pilih mata uang default',
              value: _selectedCurrency,
              items: ['IDR', 'USD', 'EUR'],
              onChanged: (value) {
                setState(() => _selectedCurrency = value!);
                _saveSetting('currency', value);
              },
            ),

            const SizedBox(height: 20),

            // Data & Storage Section
            _buildSectionHeader('Data & Penyimpanan'),
            _buildSettingItem(
              icon: Icons.backup,
              title: 'Cadangkan Data',
              subtitle: 'Simpan data ke cloud',
              onTap: () => _showBackupDialog(),
            ),
            _buildSettingItem(
              icon: Icons.restore,
              title: 'Pulihkan Data',
              subtitle: 'Kembalikan dari cadangan',
              onTap: () => _showRestoreDialog(),
            ),
            _buildSettingItem(
              icon: Icons.delete_forever,
              title: 'Hapus Semua Data',
              subtitle: 'Hapus semua data aplikasi',
              textColor: Colors.red,
              onTap: () => _showDeleteDataDialog(),
            ),

            const SizedBox(height: 20),

            // Support Section
            _buildSectionHeader('Bantuan & Dukungan'),
            _buildSettingItem(
              icon: Icons.help,
              title: 'Pusat Bantuan',
              subtitle: 'FAQ dan panduan penggunaan',
              onTap: () => _showHelpDialog(),
            ),
            _buildSettingItem(
              icon: Icons.contact_support,
              title: 'Hubungi Kami',
              subtitle: 'Kirim pesan ke tim dukungan',
              onTap: () => _showContactDialog(),
            ),
            _buildSettingItem(
              icon: Icons.info,
              title: 'Tentang Aplikasi',
              subtitle: 'Versi dan informasi aplikasi',
              onTap: () => _showAboutDialog(),
            ),

            const SizedBox(height: 20),

            // Account Section
            _buildSectionHeader('Akun'),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'Keluar',
              subtitle: 'Keluar dari aplikasi',
              textColor: Colors.red,
              onTap: () => _showLogoutDialog(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  // Dialog methods
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil Pengguna'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fitur profil pengguna akan segera hadir!'),
            SizedBox(height: 8),
            Text('Kelola nama, email, dan informasi lainnya.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showStoreInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Toko'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fitur informasi toko akan segera hadir!'),
            SizedBox(height: 8),
            Text('Kelola nama toko, alamat, dan jam operasional.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadangkan Data'),
        content: const Text('Fitur cadangan data akan segera hadir untuk menyimpan semua data produk dan transaksi ke cloud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pulihkan Data'),
        content: const Text('Fitur pemulihan data akan segera hadir untuk mengembalikan data dari cadangan cloud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Data'),
        content: const Text('Apakah Anda yakin ingin menghapus semua data? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete all data logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur hapus data akan segera hadir')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pusat Bantuan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Panduan Penggunaan Kasir Cerdas:'),
            SizedBox(height: 8),
            Text('• Tambah produk di menu Produk'),
            Text('• Kelola keranjang belanja'),
            Text('• Proses pembayaran dengan berbagai metode'),
            Text('• Lihat riwayat transaksi'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Kami'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Email: support@kasircerdas.com'),
            SizedBox(height: 4),
            Text('Telepon: +62 812-3456-7890'),
            SizedBox(height: 8),
            Text('Tim dukungan kami siap membantu Anda 24/7.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Kasir Cerdas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Versi: 1.0.0'),
            SizedBox(height: 8),
            Text('Aplikasi kasir modern untuk restoran dan kedai dengan integrasi Firebase dan dukungan pembayaran digital Indonesia.'),
            SizedBox(height: 8),
            Text('© 2024 Kasir Cerdas Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur logout akan segera hadir')),
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}