import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/rsa_helper.dart';
import 'package:encrypt/encrypt.dart';

class RSAPage extends StatefulWidget {
  const RSAPage({super.key});
  @override
  State<RSAPage> createState() => _RSAPageState();
}

class _RSAPageState extends State<RSAPage> {
  final _controller = TextEditingController();
  String _result = "";
  Encrypter? _encrypter;

  bool _isLoading = true;
  bool _hasResult = false;
  String? _error; // State baru untuk menyimpan pesan error

  @override
  void initState() {
    super.initState();
    _initializeEncrypter();
  }

  // Fungsi yang diperbarui dengan try-catch
  Future<void> _initializeEncrypter() async {
    setState(() {
      _isLoading = true;
      _error = null; // Reset error state saat mencoba lagi
    });

    try {
      // Memberi sedikit delay agar UI terasa responsif
      await Future.delayed(const Duration(milliseconds: 500));
      _encrypter = await RSAHelper.getEncrypter();
    } catch (e) {
      // Jika terjadi error, tangkap dan simpan pesannya
      _error = "Failed to initialize RSA keys. Please try again.\nDetails: $e";
      print(_error); // Print error ke console untuk debugging
    } finally {
      // Pastikan _isLoading selalu di-set ke false, baik berhasil maupun gagal
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Fungsi lainnya (encrypt, decrypt, copy) tetap sama ---
  void _encrypt() {
    if (_controller.text.isEmpty || _encrypter == null) return;
    setState(() {
      _result = _encrypter!.encrypt(_controller.text).base64;
      _hasResult = true;
    });
  }

  void _decrypt() {
    if (_controller.text.isEmpty || _encrypter == null) return;
    setState(() {
      try {
        _result = _encrypter!.decrypt64(_controller.text);
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
      appBar: AppBar(title: const Text("RSA Encryption")),
      body: _buildBody(), // Memindahkan logika body ke fungsi terpisah
    );
  }

  // Fungsi build body yang sekarang menangani 3 state: loading, error, dan success
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Initializing RSA Keys..."),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                "Initialization Failed",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                onPressed: _initializeEncrypter, // Tombol untuk mencoba lagi
              ),
            ],
          ),
        ),
      );
    }

    // Jika tidak loading dan tidak ada error, tampilkan konten utama
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ... (Isi konten utama: TextField, Buttons, Result Display) ...
            // Kode ini sama persis seperti di refactor sebelumnya
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter your text",
                hintText: "Type or paste text here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.key_rounded),
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
                    icon: const Icon(Icons.key_off_rounded),
                    onPressed: _decrypt,
                    label: const Text("Decrypt"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
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
                child: SelectableText(_result),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
