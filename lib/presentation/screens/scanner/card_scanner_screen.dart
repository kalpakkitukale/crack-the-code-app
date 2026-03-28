import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/presentation/screens/collection/character_detail_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CardScannerScreen extends ConsumerStatefulWidget {
  const CardScannerScreen({super.key});

  @override
  ConsumerState<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends ConsumerState<CardScannerScreen> {
  final _codeController = TextEditingController();
  String? _error;
  bool _useCamera = true;
  bool _found = false;

  bool get _canUseCamera {
    if (kIsWeb) return false;
    try { return Platform.isIOS || Platform.isAndroid; } catch (_) { return false; }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _processCode(String code) {
    if (_found) return;
    String lookup = code.trim().toUpperCase();
    if (lookup.startsWith('CTC:')) lookup = lookup.substring(4);
    if (lookup.isEmpty) return;

    final charRepo = ref.read(characterRepositoryProvider);
    final character = charRepo.getById(lookup) ??
        charRepo.getAll().where((c) => c.name.toUpperCase() == lookup).firstOrNull ??
        charRepo.getAll().where((c) => c.id.toUpperCase() == lookup).firstOrNull;

    if (character != null) {
      setState(() => _found = true);
      ref.read(playerProfileProvider.notifier).addCoins(10);
      ref.read(playerProfileProvider.notifier).addXp(10);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: character)));
    } else {
      setState(() => _error = '"$lookup" not found. Try CHAR-001 or a name like BLITZ.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: const Text('SCAN CARD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1)),
        actions: [
          if (_canUseCamera)
            IconButton(
              icon: Icon(_useCamera ? Icons.keyboard : Icons.qr_code_scanner, color: Colors.white70),
              onPressed: () => setState(() => _useCamera = !_useCamera),
            ),
        ],
      ),
      body: Column(
        children: [
          // Camera or text input
          if (_canUseCamera && _useCamera)
            Expanded(child: _buildCamera())
          else
            Expanded(child: _buildManualEntry()),

          // Quick-try chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Wrap(
              spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
              children: ['ASH','BLITZ','FANG','CHIEF','SHADE','OAK','GHOST','RHYME'].map((name) {
                return ActionChip(
                  label: Text(name, style: const TextStyle(fontSize: 12, color: Color(0xFFFFD700))),
                  backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.1),
                  side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.2)),
                  onPressed: () => _processCode(name),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCamera() {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            for (final barcode in capture.barcodes) {
              if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                _processCode(barcode.rawValue!);
                break;
              }
            }
          },
        ),
        Center(
          child: Container(
            width: 250, height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          bottom: 20, left: 0, right: 0,
          child: Text('Point at QR code on your card',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7),
                  backgroundColor: Colors.black54)),
        ),
      ],
    );
  }

  Widget _buildManualEntry() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2, size: 56, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 12),
          Text(_canUseCamera ? 'Manual Entry' : 'Enter Character Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 20),
          TextField(
            controller: _codeController,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 2),
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'BLITZ',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.15)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2)),
            ),
            onSubmitted: (_) => _processCode(_codeController.text),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(fontSize: 12, color: Color(0xFFFF5722)),
                textAlign: TextAlign.center),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _processCode(_codeController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF0A0618),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('FIND CHARACTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
