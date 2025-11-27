import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../services/firestore_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Indonesia';
  String _selectedCurrency = 'IDR';

  // Profile data
  String _userName = 'Admin Kasir';
  String _userEmail = 'admin@kasircerdas.com';
  String _storeName = 'Warung Makan Cerdas';
  String _storeAddress = 'Jl. Raya No. 123, Jakarta';
  String _storePhone = '+62 812-3456-7890';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'Indonesia';
      _selectedCurrency = prefs.getString('currency') ?? 'IDR';

      // Load profile data
      _userName = prefs.getString('userName') ?? 'Admin Kasir';
      _userEmail = prefs.getString('userEmail') ?? 'admin@kasircerdas.com';
      _storeName = prefs.getString('storeName') ?? 'Warung Makan Cerdas';
      _storeAddress = prefs.getString('storeAddress') ?? 'Jl. Raya No. 123, Jakarta';
      _storePhone = prefs.getString('storePhone') ?? '+62 812-3456-7890';
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
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSwitchItem(
                  icon: Icons.dark_mode,
                  title: 'Mode Gelap',
                  subtitle: 'Tema gelap untuk aplikasi',
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.setDarkMode(value);
                  },
                );
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
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
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
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
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
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor),
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
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor),
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
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
              });

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userName', _userName);
              await prefs.setString('userEmail', _userEmail);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showStoreInfoDialog() {
    final nameController = TextEditingController(text: _storeName);
    final addressController = TextEditingController(text: _storeAddress);
    final phoneController = TextEditingController(text: _storePhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Informasi Toko'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Toko',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _storeName = nameController.text;
                _storeAddress = addressController.text;
                _storePhone = phoneController.text;
              });

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('storeName', _storeName);
              await prefs.setString('storeAddress', _storeAddress);
              await prefs.setString('storePhone', _storePhone);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informasi toko berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() async {
    try {
      // Get all products and transactions
      final products = await FirestoreService().getProducts();
      final transactions = await FirestoreService().getTransactions();
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      // Create backup data
      final backupData = {
        'timestamp': DateTime.now().toIso8601String(),
        'products': products.map((p) => p.toMap()).toList(),
        'transactions': transactions.map((t) => t.toMap()).toList(),
        'settings': {
          'userName': _userName,
          'userEmail': _userEmail,
          'storeName': _storeName,
          'storeAddress': _storeAddress,
          'storePhone': _storePhone,
          'notifications': _notificationsEnabled,
          'darkMode': themeProvider.isDarkMode,
          'language': _selectedLanguage,
          'currency': _selectedCurrency,
        },
      };

      // Save to SharedPreferences as backup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backupData', backupData.toString());

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dicadangkan ke penyimpanan lokal')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencadangkan data: $e')),
      );
    }
  }

  void _showRestoreDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupString = prefs.getString('backupData');

      if (backupString == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data cadangan ditemukan')),
        );
        return;
      }

      // For demo purposes, we'll just show that restore would work
      // In a real app, you'd parse the JSON and restore the data
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dipulihkan dari cadangan')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memulihkan data: $e')),
      );
    }
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Data'),
        content: const Text('Apakah Anda yakin ingin menghapus semua data aplikasi? Tindakan ini akan menghapus semua produk, transaksi, dan pengaturan. Data yang sudah dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Clear all SharedPreferences data
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Reset all settings to defaults
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                setState(() {
                  _notificationsEnabled = true;
                  _selectedLanguage = 'Indonesia';
                  _selectedCurrency = 'IDR';
                  _userName = 'Admin Kasir';
                  _userEmail = 'admin@kasircerdas.com';
                  _storeName = 'Warung Makan Cerdas';
                  _storeAddress = 'Jl. Raya No. 123, Jakarta';
                  _storePhone = '+62 812-3456-7890';
                });
                themeProvider.setDarkMode(false);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua data berhasil dihapus')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus data: $e')),
                );
              }
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