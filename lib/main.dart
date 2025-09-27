import 'package:flutter/material.dart';
import 'pages/caesar_page.dart';
import 'pages/vigenere_page.dart';
import 'pages/aes_page.dart';
import 'pages/rsa_page.dart';
import 'pages/super_page.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      // Mengaktifkan Material 3 dan menggunakan ColorScheme modern
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // Otomatis mengikuti tema sistem
      home: const MainMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data class sederhana untuk item menu
class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Memisahkan data dari UI
    final List<_MenuItem> menuItems = [
      _MenuItem(
        title: "Caesar Cipher",
        subtitle: "Simple substitution cipher.",
        icon: Icons.looks_one,
        page: const CaesarPage(),
      ),
      _MenuItem(
        title: "Vigenère Cipher",
        subtitle: "Polyalphabetic substitution.",
        icon: Icons.looks_two,
        page: const VigenerePage(),
      ),
      _MenuItem(
        title: "AES Encryption",
        subtitle: "Advanced symmetric encryption.",
        icon: Icons.looks_3,
        page: const AESPage(),
      ),
      _MenuItem(
        title: "RSA Encryption",
        subtitle: "Asymmetric public-key encryption.",
        icon: Icons.looks_4,
        page: const RSAPage(),
      ),
      _MenuItem(
        title: "Super Encryption",
        subtitle: "A multi-layer encryption chain.",
        icon: Icons.looks_5,
        page: const SuperPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cryptography Toolkit"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: Icon(
                item.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
