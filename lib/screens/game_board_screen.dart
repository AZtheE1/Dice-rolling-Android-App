import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../core/theme/app_colors.dart';
import '../providers/game_provider.dart';
import '../widgets/dice/procedural_dice.dart';

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  late ConfettiController _confettiController;
  bool _winnerDialogShown = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkWinner(GameProvider game) {
    if (game.hasWinner && !_winnerDialogShown) {
      _winnerDialogShown = true;
      _confettiController.play();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinnerDialog(context, game);
      });
    }
  }

  void _showWinnerDialog(BuildContext context, GameProvider game) {
    final winnerIndex = game.winnerIndex ?? 0;
    final isAiWinner = game.isSinglePlayer && winnerIndex == 1;
    final winnerColor = isAiWinner
        ? AppColors.secondary
        : AppColors.playerColors[winnerIndex % AppColors.playerColors.length];

    final winnerTitle = isAiWinner
        ? 'AI BOT WON!'
        : (game.isSinglePlayer ? 'YOU WON!' : 'VICTORY!');

    final winnerSubtitle = isAiWinner
        ? 'The Computer reached the goal first!'
        : (game.isSinglePlayer
            ? 'Congratulations! You defeated the AI!'
            : 'Player ${winnerIndex + 1} Champion');

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (dialogContext, anim1, anim2) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: winnerColor.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: winnerColor.withValues(alpha: 0.3),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isAiWinner ? AppColors.secondary : AppColors.amber)
                          .withValues(alpha: 0.18),
                      border: Border.all(
                        color: isAiWinner ? AppColors.secondary : AppColors.amber,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isAiWinner ? Icons.smart_toy_rounded : Icons.emoji_events_rounded,
                      color: isAiWinner ? AppColors.secondary : AppColors.amber,
                      size: 42,
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 18),

                  Text(
                    winnerTitle,
                    style: GoogleFonts.righteous(
                      fontSize: 30,
                      letterSpacing: 2,
                      color: isAiWinner ? AppColors.secondary : AppColors.amber,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    winnerSubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Final Score: ${game.playerScores[winnerIndex]} points',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Exit',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            setState(() {
                              _winnerDialogShown = false;
                            });
                            game.resetGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: winnerColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            'Play Again',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        _checkWinner(game);

        final isAiCurrent = game.isSinglePlayer && game.currentPlayerIndex == 1;
        final activeColor = isAiCurrent
            ? AppColors.secondary
            : AppColors.playerColors[
                game.currentPlayerIndex % AppColors.playerColors.length];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Top ambient glow of active player's color
              Positioned(
                top: -100,
                left: MediaQuery.of(context).size.width / 2 - 120,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor.withValues(alpha: 0.15),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Header with back navigation & Goal Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag_rounded,
                                  color: AppColors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'GOAL: ${game.goalScore} PTS',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => game.resetGame(),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: AppColors.textSecondary,
                            ),
                            tooltip: 'Restart Match',
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // TOP SECTION: Scoreboard Cards
                      _buildScoreboard(game),

                      const Spacer(),

                      // MIDDLE SECTION: Procedural Dice & Turn indicator
                      Column(
                        children: [
                          // Turn Announcement
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              key: ValueKey('${game.currentPlayerIndex}_${game.isAiRolling}'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: activeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: activeColor.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isAiCurrent) ...[
                                    const Icon(
                                      Icons.smart_toy_rounded,
                                      size: 16,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    isAiCurrent
                                        ? (game.isRolling
                                            ? 'AI IS ROLLING...'
                                            : 'AI BOT IS THINKING...')
                                        : (game.isSinglePlayer
                                            ? 'YOUR TURN TO ROLL'
                                            : "PLAYER ${game.currentPlayerIndex + 1}'S TURN"),
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: activeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          // The Procedural Animated Dice
                          ProceduralDice(
                            value: game.currentDiceValue,
                            isRolling: game.isRolling,
                            size: 140,
                            onTap: (game.isRolling || game.isAiRolling || isAiCurrent)
                                ? null
                                : () => game.rollDice(),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            game.isRolling
                                ? (isAiCurrent ? 'Bot rolling...' : 'Rolling...')
                                : 'Rolled a ${game.currentDiceValue}!',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // BOTTOM SECTION: Roll Dice Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: (game.isRolling ||
                                  game.isAiRolling ||
                                  isAiCurrent ||
                                  game.hasWinner)
                              ? null
                              : () => game.rollDice(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeColor,
                            disabledBackgroundColor:
                                activeColor.withValues(alpha: 0.35),
                            elevation: 8,
                            shadowColor: activeColor.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isAiCurrent
                                    ? Icons.smart_toy_rounded
                                    : Icons.casino,
                                color: Colors.white.withValues(
                                  alpha: (game.isRolling || isAiCurrent) ? 0.6 : 1.0,
                                ),
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isAiCurrent
                                    ? (game.isRolling ? 'AI IS ROLLING...' : 'AI IS THINKING...')
                                    : (game.isRolling ? 'ROLLING...' : 'ROLL DICE'),
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Colors.white.withValues(
                                    alpha: (game.isRolling || isAiCurrent) ? 0.6 : 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Confetti Overlay for winner celebration
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.amber,
                    Colors.pink,
                    Colors.blue,
                    Colors.green,
                    Colors.purple,
                  ],
                  numberOfParticles: 35,
                  gravity: 0.15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreboard(GameProvider game) {
    return Row(
      children: List.generate(game.numberOfPlayers, (index) {
        final isCurrent = index == game.currentPlayerIndex;
        final isAiCard = game.isSinglePlayer && index == 1;

        final playerColor = isAiCard
            ? AppColors.secondary
            : AppColors.playerColors[index % AppColors.playerColors.length];

        final score = game.playerScores[index];
        final progress = (score / game.goalScore).clamp(0.0, 1.0);

        final label = game.isSinglePlayer
            ? (index == 0 ? 'YOU' : 'AI BOT')
            : 'P${index + 1}';

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: isCurrent
                    ? playerColor.withValues(alpha: 0.18)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCurrent
                      ? playerColor
                      : Colors.white.withValues(alpha: 0.06),
                  width: isCurrent ? 2 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: playerColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isAiCard ? Icons.smart_toy_rounded : Icons.person_rounded,
                        size: 14,
                        color: playerColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isCurrent ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$score',
                    style: GoogleFonts.righteous(
                      fontSize: 22,
                      color: isCurrent ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(playerColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
