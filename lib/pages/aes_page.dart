import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Diperlukan untuk Clipboard
import '../utils/aes.dart';

class AESPage extends StatefulWidget {
  const AESPage({super.key});

  @override
  State<AESPage> createState() => _AESPageState();
}

class _AESPageState extends State<AESPage> {
  final _controller = TextEditingController();
  final aes = AESHelper();
  String _result = "";
  bool _hasResult = false; // State untuk mengontrol visibilitas hasil

  void _encrypt() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _result = aes.encryptText(_controller.text);
      _hasResult = true;
    });
  }

  void _decrypt() {
    if (_controller.text.isEmpty) return;
    setState(() {
      try {
        _result = aes.decryptText(_controller.text);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AES Encryption"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        // Agar tidak overflow saat keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Input Field ---
              Text(
                "Enter your text",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type or paste text here...",
                  prefixIcon: const Icon(Icons.abc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 24),

              // --- Action Buttons ---
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.lock_outline),
                      onPressed: _encrypt,
                      label: const Text("Encrypt"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.lock_open_outlined),
                      onPressed: _decrypt,
                      label: const Text("Decrypt"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- Result Display ---
              if (_hasResult) ...[
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily:
                          'monospace', // Font yg baik untuk teks terenkripsi
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
