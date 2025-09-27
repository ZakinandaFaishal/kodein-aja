import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/vigenere.dart'; // Make sure this path is correct

class VigenerePage extends StatefulWidget {
  const VigenerePage({super.key});

  @override
  State<VigenerePage> createState() => _VigenerePageState();
}

class _VigenerePageState extends State<VigenerePage> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = "";
  bool _hasResult = false;

  void _validateAndProcess(Function(String, String) processFunction) {
    final text = _textController.text;
    final key = _keyController.text;

    if (text.isEmpty) {
      // Optional: Show a message if the main text is empty
      return;
    }

    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: The key cannot be empty.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      try {
        _result = processFunction(text, key);
        _hasResult = true;
      } catch (_) {
        _result = "An error occurred during the process.";
      }
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
    _textController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vigenère Cipher")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Input Fields ---
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "Text to Encrypt/Decrypt",
                  hintText: "Enter your text here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: "Encryption Key",
                  hintText: "Enter the secret key...",
                  prefixIcon: const Icon(Icons.key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Action Buttons ---
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.lock_outline),
                      onPressed: () => _validateAndProcess(Vigenere.encrypt),
                      label: const Text("Encrypt"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.lock_open_outlined),
                      onPressed: () => _validateAndProcess(Vigenere.decrypt),
                      label: const Text("Decrypt"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),

              // --- Result Display ---
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
}
