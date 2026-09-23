import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../providers/game_provider.dart';
import 'game_board_screen.dart';

class SinglePlayerSetupScreen extends StatefulWidget {
  const SinglePlayerSetupScreen({super.key});

  @override
  State<SinglePlayerSetupScreen> createState() => _SinglePlayerSetupScreenState();
}

class _SinglePlayerSetupScreenState extends State<SinglePlayerSetupScreen> {
  double _goalScore = 30;
  final List<int> _presetGoals = [20, 30, 50, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Solo vs AI',
          style: GoogleFonts.righteous(
            fontSize: 22,
            letterSpacing: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SINGLE PLAYER MODE',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 6),

              Text(
                'Challenge the Smart Bot',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 28),

              // Matchup Card (You vs AI)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Player 1 (You)
                    Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'You',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Player 1',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // VS Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'VS',
                        style: GoogleFonts.righteous(
                          fontSize: 16,
                          letterSpacing: 1.5,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),

                    // Player 2 (AI Bot)
                    Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFF9D174D)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'AI Bot',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          'Computer',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 450.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 36),

              // Section: Goal Score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GOAL SCORE TO WIN',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${_goalScore.round()} PTS',
                      style: GoogleFonts.righteous(
                        fontSize: 16,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Preset chips
              Row(
                children: _presetGoals.map((preset) {
                  final isSelected = _goalScore.round() == preset;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            '$preset',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.secondary,
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.secondary
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _goalScore = preset.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

              const SizedBox(height: 20),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.secondary,
                  inactiveTrackColor: AppColors.surfaceLight,
                  thumbColor: Colors.white,
                  overlayColor: AppColors.secondary.withValues(alpha: 0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _goalScore,
                  min: 10,
                  max: 120,
                  divisions: 22,
                  onChanged: (val) {
                    setState(() {
                      _goalScore = val;
                    });
                  },
                ),
              ).animate().fadeIn(delay: 350.ms),

              const Spacer(),

              // Start Match Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // Initialize single player game
                    context.read<GameProvider>().setupSinglePlayer(
                          targetScore: _goalScore.round(),
                        );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameBoardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 8,
                    shadowColor: AppColors.secondary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 26),
                      const SizedBox(width: 10),
                      Text(
                        'START SOLO MATCH',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 450.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
