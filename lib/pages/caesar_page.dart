import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/caesar.dart'; // Pastikan path ini benar

class CaesarPage extends StatefulWidget {
  const CaesarPage({super.key});

  @override
  State<CaesarPage> createState() => _CaesarPageState();
}

class _CaesarPageState extends State<CaesarPage> {
  final _controller = TextEditingController();
  String _result = "";
  double _shift = 3.0;

  // State baru untuk mode selector
  bool _isEncryptMode = true;

  @override
  void initState() {
    super.initState();
    // Menambahkan listener ke controller agar bisa update saat user mengetik
    _controller.addListener(_updateText);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateText);
    _controller.dispose();
    super.dispose();
  }

  // Fungsi ini sekarang menjadi pusat logika
  void _updateText() {
    if (_controller.text.isEmpty) {
      setState(() {
        _result = "";
      });
      return;
    }

    setState(() {
      if (_isEncryptMode) {
        _result = Caesar.encrypt(_controller.text, _shift.toInt());
      } else {
        _result = Caesar.decrypt(_controller.text, _shift.toInt());
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caesar Cipher (Real-time)"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Input Field ---
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Enter your text",
                  hintText: "Result will update as you type...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // Menambahkan tombol clear di input field
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 24),

              // --- Mode Selector ---
              Center(
                child: ToggleButtons(
                  isSelected: [_isEncryptMode, !_isEncryptMode],
                  onPressed: (int index) {
                    setState(() {
                      _isEncryptMode = index == 0;
                      _updateText(); // Langsung update hasil saat mode diubah
                    });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Encrypt'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Decrypt'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Shift Slider Control ---
              Text(
                "Shift Amount: ${_shift.toInt()}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _shift,
                min: 1,
                max: 25,
                divisions: 24,
                label: _shift.toInt().toString(),
                onChanged: (double value) {
                  setState(() {
                    _shift = value;
                    _updateText(); // Update hasil saat slider digeser
                  });
                },
              ),
              const SizedBox(height: 16),

              // --- Result Display ---
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
          ),
        ),
      ),
    );
  }
}
