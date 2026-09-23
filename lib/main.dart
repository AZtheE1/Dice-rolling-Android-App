import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'widgets/dice/procedural_dice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  const DiceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Rolling Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
      ),
      home: const ArchitecturePreviewScreen(),
    );
  }
}

/// Initial preview screen demonstrating the setup & procedural dice animation
class ArchitecturePreviewScreen extends StatefulWidget {
  const ArchitecturePreviewScreen({super.key});

  @override
  State<ArchitecturePreviewScreen> createState() => _ArchitecturePreviewScreenState();
}

class _ArchitecturePreviewScreenState extends State<ArchitecturePreviewScreen> {
  int _diceVal = 6;
  bool _rolling = false;

  void _rollDice() async {
    if (_rolling) return;
    setState(() => _rolling = true);

    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      _diceVal = (DateTime.now().microsecond % 6) + 1;
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) {
      setState(() => _rolling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DICE ROLLER',
                style: GoogleFonts.righteous(
                  fontSize: 34,
                  letterSpacing: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  'Phase 1: Architecture Initialized',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              ProceduralDice(
                value: _diceVal,
                isRolling: _rolling,
                size: 130,
                onTap: _rollDice,
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: _rollDice,
                icon: const Icon(Icons.casino, color: Colors.white),
                label: Text(_rolling ? 'Rolling...' : 'Tap to Test Roll'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
