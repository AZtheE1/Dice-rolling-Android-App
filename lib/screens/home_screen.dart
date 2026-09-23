import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import 'setup_screen.dart';
import 'single_player_setup.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Deep dark-blue-to-black atmospheric background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF060919), // Deepest obsidian blue
                    Color(0xFF0F172A), // Slate 900
                    Color(0xFF090D1A), // Deep cosmic black
                  ],
                ),
              ),
            ),
          ),

          // 2. Blurred glowing neon orbs matching splash screen
          // Indigo Orb (Top Left)
          Positioned(
            top: -60,
            left: -50,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.28),
              ),
            ),
          ),
          // Vibrant Fuchsia/Pink Orb (Right Middle)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEC4899).withValues(alpha: 0.22),
              ),
            ),
          ),
          // Deep Purple / Violet Orb (Bottom Left)
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.24),
              ),
            ),
          ),

          // Backdrop Blur Layer over glowing orbs
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 3. Main UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // Top Header with brand badge and profile quick-access
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF10B981),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF10B981),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SEASON 1 ACTIVE',
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  letterSpacing: 2.2,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ROLL MASTER',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppColors.textPrimary,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Glassmorphism Profile Quick Button
                      _buildGlassProfileIcon(context),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 24),

                  // Neon Subtitle / Tagline Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.casino_rounded,
                          size: 16,
                          color: Color(0xFFEC4899),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SELECT YOUR BATTLEGROUND',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 450.ms),

                  const Spacer(),

                  // Glassmorphism Menu Action Cards
                  // 1. Single Player (AI Bot)
                  _buildGlassMenuCard(
                    title: 'Single Player',
                    subtitle: 'Challenge the adaptive AI Bot in solo mode',
                    icon: Icons.smart_toy_rounded,
                    accentColor: const Color(0xFFEC4899),
                    gradientBorder: const [
                      Color(0xFFEC4899),
                      Color(0xFF8B5CF6),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SinglePlayerSetupScreen(),
                        ),
                      );
                    },
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 20),

                  // 2. Multiplayer (Primary Mode with continuous pulse & glow)
                  _buildGlassMenuCard(
                    title: 'Multiplayer Mode',
                    subtitle: 'Pass & play battle for 2 to 4 local players',
                    icon: Icons.groups_rounded,
                    accentColor: const Color(0xFF6366F1),
                    gradientBorder: const [
                      Color(0xFF6366F1),
                      Color(0xFFEC4899),
                      Color(0xFF8B5CF6),
                    ],
                    isPrimary: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupScreen(),
                        ),
                      );
                    },
                  )
                      .animate(delay: 450.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0)
                      // Continuous subtle breathing & floating animation
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .scaleXY(
                        begin: 1.0,
                        end: 1.025,
                        duration: 1800.ms,
                        curve: Curves.easeInOut,
                      ),

                  const SizedBox(height: 20),

                  // 3. Player Profile
                  _buildGlassMenuCard(
                    title: 'Player Profile',
                    subtitle: 'Google Sign-In, avatar customization & stats',
                    icon: Icons.person_rounded,
                    accentColor: const Color(0xFF10B981),
                    gradientBorder: const [
                      Color(0xFF10B981),
                      Color(0xFF06B6D4),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                  const Spacer(),

                  // Bottom subtle footer
                  Text(
                    'PRO DIVISION • ROLL FOR GLORY',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ).animate().fadeIn(delay: 750.ms),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Profile Quick Icon with frosted glass
  Widget _buildGlassProfileIcon(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Frosted Glassmorphism Action Card
  Widget _buildGlassMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<Color> gradientBorder,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? accentColor.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.35),
            blurRadius: isPrimary ? 24 : 16,
            spreadRadius: isPrimary ? 1 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              // Semi-transparent frosted glass gradient
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isPrimary ? 0.12 : 0.08),
                  Colors.white.withValues(alpha: isPrimary ? 0.04 : 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              // Thin vibrant glowing gradient border
              border: Border.all(
                color: isPrimary
                    ? accentColor.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.14),
                width: isPrimary ? 1.8 : 1.2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onTap,
                splashColor: accentColor.withValues(alpha: 0.2),
                highlightColor: accentColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      // Elegant Glowing Icon Container
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradientBorder,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.45),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),

                      const SizedBox(width: 18),

                      // Card Typography
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                if (isPrimary) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6366F1),
                                          Color(0xFFEC4899),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFEC4899)
                                              .withValues(alpha: 0.5),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'HOT',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Forward Chevron with subtle glow
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPrimary
                              ? accentColor.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isPrimary
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
