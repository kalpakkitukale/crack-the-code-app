import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/presentation/screens/collection/character_detail_screen.dart';

class CardScannerScreen extends ConsumerStatefulWidget {
  const CardScannerScreen({super.key});

  @override
  ConsumerState<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends ConsumerState<CardScannerScreen> {
  final _codeController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _lookupCharacter() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // Try to find character by ID (CHAR-001) or name (BLITZ)
    final charRepo = ref.read(characterRepositoryProvider);
    final character = charRepo.getById(code) ??
        charRepo.getAll().where((c) => c.name.toUpperCase() == code).firstOrNull;

    if (character != null) {
      // Award coins
      ref.read(playerProfileProvider.notifier).addCoins(10);
      ref.read(playerProfileProvider.notifier).addXp(10);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: character)),
      );
    } else {
      setState(() => _error = 'Character not found. Try CHAR-001 or a character name like BLITZ.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: const Text('SCAN CARD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Camera placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 48, color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(height: 8),
                  Text('QR Scanner coming soon',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(height: 4),
                  Text('Use manual entry below',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.3))),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Manual entry
            Text('OR ENTER CHARACTER',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.4), letterSpacing: 2)),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'CHAR-001 or BLITZ',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFFFD700)),
                ),
              ),
              onSubmitted: (_) => _lookupCharacter(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(fontSize: 12, color: Color(0xFFFF5722))),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _lookupCharacter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF0A0618),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('FIND CHARACTER', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),

            const Spacer(),

            // Quick characters to try
            Text('TRY THESE:', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['ASH', 'BLITZ', 'FANG', 'CHIEF', 'SHADE'].map((name) {
                return ActionChip(
                  label: Text(name, style: const TextStyle(fontSize: 12, color: Color(0xFFFFD700))),
                  backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.1),
                  side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.2)),
                  onPressed: () {
                    _codeController.text = name;
                    _lookupCharacter();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
