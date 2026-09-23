import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _avatars = ['🎲', '👑', '🔥', '⚡', '🐉', '🎯', '🚀', '⭐'];
  final List<String> _genders = ['Male', 'Female', 'Non-Binary', 'Other'];

  late int _selectedAge;
  late String _selectedGender;
  late String _selectedAvatar;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final auth = context.read<AppAuthProvider>();
      _selectedAge = auth.age;
      _selectedGender = auth.gender;
      _selectedAvatar = auth.avatar;
      _initialized = true;
    }
  }

  void _saveProfile() {
    context.read<AppAuthProvider>().updateUserProfile(
          age: _selectedAge,
          gender: _selectedGender,
          avatar: _selectedAvatar,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Profile updated successfully!',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Player Profile',
              style: GoogleFonts.righteous(
                fontSize: 22,
                letterSpacing: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              physics: const BouncingScrollPhysics(),
              child: auth.isAuthenticated
                  ? _buildLoggedInView(auth)
                  : _buildLoggedOutView(auth),
            ),
          ),
        );
      },
    );
  }

  // View when user is not logged in
  Widget _buildLoggedOutView(AppAuthProvider auth) {
    return Column(
      children: [
        const SizedBox(height: 36),
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

        const SizedBox(height: 28),

        Text(
          'Connect Your Account',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 8),

        Text(
          'Sign in with Google to save your player avatar, age, and in-game achievements.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 250.ms),

        if (auth.errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
            ),
            child: Text(
              auth.errorMessage!,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.redAccent),
            ),
          ),
        ],

        const SizedBox(height: 44),

        // Google Sign In Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : () => auth.signInWithGoogle(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: auth.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.g_mobiledata_rounded,
                          color: Color(0xFF4285F4),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
          ),
        ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.15, end: 0),
      ],
    );
  }

  // View when user is authenticated with Google
  Widget _buildLoggedInView(AppAuthProvider auth) {
    final user = auth.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Google User Profile Card
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
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Google Avatar / Photo
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundImage:
                    user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? Text(
                        _selectedAvatar,
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Player',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user?.email ?? 'Connected with Google',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

        const SizedBox(height: 28),

        // Customizable In-Game Avatar Selection
        Text(
          'CHOOSE IN-GAME AVATAR',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _avatars.map((emoji) {
            final isSelected = _selectedAvatar == emoji;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatar = emoji;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
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
                            blurRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: isSelected ? 30 : 26,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 28),

        // Age Selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AGE',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                '$_selectedAge YEARS',
                style: GoogleFonts.righteous(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: 10),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceLight,
            thumbColor: Colors.white,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
            trackHeight: 5,
          ),
          child: Slider(
            value: _selectedAge.toDouble(),
            min: 8,
            max: 90,
            divisions: 82,
            onChanged: (val) {
              setState(() {
                _selectedAge = val.round();
              });
            },
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 24),

        // Gender Selection
        Text(
          'GENDER',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 350.ms),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          children: _genders.map((g) {
            final isSelected = _selectedGender == g;
            return ChoiceChip(
              label: Text(
                g,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedGender = g;
                  });
                }
              },
            );
          }).toList(),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 36),

        // Save Profile Action Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'SAVE PROFILE',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 18),

        // Sign Out Action Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: auth.isLoading ? null : () => auth.signOut(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'SIGN OUT',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 24),
      ],
    );
  }
}
