import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../providers/game_provider.dart';
import 'game_board_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _selectedPlayers = 2;
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
          'Match Setup',
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
              // Header description
              Text(
                'CUSTOMIZE YOUR GAME',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 6),

              Text(
                'Configure rules and players',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),

              // Section: Number of Players
              Text(
                'NUMBER OF PLAYERS',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [2, 3, 4].map((count) {
                  final isSelected = _selectedPlayers == count;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlayers = count;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.18)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.08),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                count == 2
                                    ? Icons.people_outline_rounded
                                    : count == 3
                                        ? Icons.groups_outlined
                                        : Icons.group_work_outlined,
                                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                size: 28,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$count',
                                style: GoogleFonts.righteous(
                                  fontSize: 22,
                                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Players',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

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

              // Preset goal score chips
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
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.08),
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

              // Custom Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.surfaceLight,
                  thumbColor: Colors.white,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
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

              // Start Game Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // Initialize game provider
                    context.read<GameProvider>().setupGame(
                          players: _selectedPlayers,
                          targetScore: _goalScore.round(),
                        );

                    // Navigate to game board
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameBoardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 8,
                    shadowColor: AppColors.primary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'START BATTLE',
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
