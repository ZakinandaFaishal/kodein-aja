import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/caesar.dart';
import '../utils/vigenere.dart';
import '../utils/aes.dart';

class SuperPage extends StatefulWidget {
  const SuperPage({super.key});
  @override
  State<SuperPage> createState() => _SuperPageState();
}

class _SuperPageState extends State<SuperPage> {
  final _controller = TextEditingController();
  final _vigenereKeyController = TextEditingController(text: "key");
  final _caesarShiftController = TextEditingController(text: "3");

  String _result = "";
  bool _hasResult = false;
  final AESHelper _aes = AESHelper();

  String superEncrypt(String text) {
    // Caesar -> Vigenère -> AES -> Reverse String (simulasi)
    int shift = int.tryParse(_caesarShiftController.text) ?? 3;
    String vigenereKey = _vigenereKeyController.text.isNotEmpty
        ? _vigenereKeyController.text
        : "key";

    String step1 = Caesar.encrypt(text, shift);
    String step2 = Vigenere.encrypt(step1, vigenereKey);
    String step3 = _aes.encryptText(step2);
    return step3.split('').reversed.join(); // simulasi
  }

  String superDecrypt(String text) {
    // Reverse -> AES -> Vigenère -> Caesar
    int shift = int.tryParse(_caesarShiftController.text) ?? 3;
    String vigenereKey = _vigenereKeyController.text.isNotEmpty
        ? _vigenereKeyController.text
        : "key";

    String step1 = text.split('').reversed.join();
    String step2 = _aes.decryptText(step1);
    String step3 = Vigenere.decrypt(step2, vigenereKey);
    String step4 = Caesar.decrypt(step3, shift);
    return step4;
  }

  void _encrypt() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _result = superEncrypt(_controller.text);
      _hasResult = true;
    });
  }

  void _decrypt() {
    if (_controller.text.isEmpty) return;
    setState(() {
      try {
        _result = superDecrypt(_controller.text);
      } catch (_) {
        _result = "Error: Invalid input for decryption.";
      }
      _hasResult = true;
    });
  }

  void _copyToClipboard() {
    if (_result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _result));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Result copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _vigenereKeyController.dispose();
    _caesarShiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Encryption")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Visualisasi Proses ---
              _buildProcessVisualizer(),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              // --- Input & Konfigurasi ---
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Enter your text",
                  hintText: "Type or paste text here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _vigenereKeyController,
                      decoration: InputDecoration(
                        labelText: "Vigenère Key",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _caesarShiftController,
                      decoration: InputDecoration(
                        labelText: "Caesar Shift",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Tombol Aksi ---
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.security_rounded),
                      onPressed: _encrypt,
                      label: const Text("Encrypt"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.lock_open_rounded),
                      onPressed: _decrypt,
                      label: const Text("Decrypt"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),

              // --- Hasil ---
              if (_hasResult) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Result",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: _copyToClipboard,
                      tooltip: "Copy to Clipboard",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SelectableText(
                    _result,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk memvisualisasikan proses
  Widget _buildProcessVisualizer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Encryption Flow",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildStepTile(
            Icons.looks_3,
            "1. Caesar Cipher",
            "Shifts characters by a set amount.",
          ),
          _buildStepTile(
            Icons.key,
            "2. Vigenère Cipher",
            "Encrypts using a keyword.",
          ),
          _buildStepTile(
            Icons.shield_outlined,
            "3. AES Encryption",
            "Advanced symmetric encryption.",
          ),
          _buildStepTile(
            Icons.swap_horiz,
            "4. Reverse (Simulated RSA)",
            "Reverses the string for final layer.",
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
