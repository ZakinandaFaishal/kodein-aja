// pages/ecc_page.dart (Versi Diperbaiki)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/ecc_helper.dart';

class ECCPage extends StatefulWidget {
  const ECCPage({super.key});

  @override
  State<ECCPage> createState() => _ECCPageState();
}

class _ECCPageState extends State<ECCPage> {
  final _textController = TextEditingController();
  final _eccHelper = ECCHelper();

  bool _isLoading = true;
  String _signature = "";
  String? _error; // State untuk menyimpan pesan error

  @override
  void initState() {
    super.initState();
    _initializeECC();
  }

  Future<void> _initializeECC() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _eccHelper.init();
    } catch (e) {
      _error = "Failed to initialize ECC keys.\nDetails: $e";
      print(_error); // Untuk debugging di konsol
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ... fungsi _signMessage dan _verifySignature tetap sama ...
  void _signMessage() {
    if (_textController.text.isEmpty) return;
    final signature = _eccHelper.sign(_textController.text);
    setState(() {
      _signature = signature;
    });
    Clipboard.setData(ClipboardData(text: signature));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Signature generated and copied to clipboard!'),
      ),
    );
  }

  void _verifySignature() {
    if (_textController.text.isEmpty || _signature.isEmpty) return;

    final isValid = _eccHelper.verify(_textController.text, _signature);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isValid
              ? '✅ Signature Verified: The message is authentic.'
              : '❌ Verification Failed: The message or signature is invalid.',
        ),
        backgroundColor: isValid ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ECC Digital Signature")),
      body: _buildBody(), // Gunakan fungsi terpisah untuk body
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                onPressed: _initializeECC,
              ),
            ],
          ),
        ),
      );
    }
    // Jika tidak loading dan tidak ada error, tampilkan konten utama
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Message", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Enter the message to sign...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            minLines: 4,
            maxLines: 6,
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            icon: const Icon(Icons.draw_rounded),
            label: const Text("Sign Message with Private Key"),
            onPressed: _signMessage,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          if (_signature.isNotEmpty) ...[
            Text(
              "Generated Signature (Hex)",
              style: Theme.of(context).textTheme.titleMedium,
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
              child: SelectableText(_signature),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text("Verify with Public Key"),
              onPressed: _verifySignature,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
