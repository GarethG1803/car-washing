import 'dart:async';
import 'dart:math' show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final AnimationController _floatCtrl;
  int _current = 0;
  Timer? _timer;

  static const _pages = [
    _PageData(
      scene: _SceneType.wash,
      title: 'Premium Car Wash',
      subtitle: 'Professional washing brought to your door — whenever and wherever you need it.',
    ),
    _PageData(
      scene: _SceneType.booking,
      title: 'Book in Seconds',
      subtitle: 'Pick a service, set your time and address. We handle the rest.',
    ),
    _PageData(
      scene: _SceneType.washer,
      title: 'Trusted Washers',
      subtitle: 'Every washer is verified, trained, and rated by customers like you.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _pages.length;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _floatCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  // Skip
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 8),
                      child: TextButton(
                        onPressed: () => context.go('/login'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.7),
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ),

                  // Pages
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n is UserScrollNotification) _startTimer();
                        return false;
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pages.length,
                        onPageChanged: (i) => setState(() => _current = i),
                        itemBuilder: (_, i) => _OnboardingPage(
                          data: _pages[i],
                          floatCtrl: _floatCtrl,
                        ),
                      ),
                    ),
                  ),

                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _current;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const Gap(36),

                  // CTA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Get Started',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Gap(18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.7))),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text('Sign In',
                            style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),

                  const Gap(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────

enum _SceneType { wash, booking, washer }

class _PageData {
  final _SceneType scene;
  final String title;
  final String subtitle;
  const _PageData(
      {required this.scene, required this.title, required this.subtitle});
}

// ─────────────────────────────────────────────
// Page widget
// ─────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final _PageData data;
  final AnimationController floatCtrl;

  const _OnboardingPage({required this.data, required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Scene
          SizedBox(
            height: 280,
            child: AnimatedBuilder(
              animation: floatCtrl,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, sin(floatCtrl.value * pi) * 7),
                child: child,
              ),
              child: _buildScene(),
            ),
          ),

          const Gap(40),

          // Title
          Text(
            data.title,
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms),

          const Gap(14),

          Text(
            data.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: 100.ms),
        ],
      ),
    );
  }

  Widget _buildScene() {
    switch (data.scene) {
      case _SceneType.wash:
        return const _WashScene();
      case _SceneType.booking:
        return const _BookingScene();
      case _SceneType.washer:
        return const _WasherScene();
    }
  }
}

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────

BoxDecoration get _cardDecoration => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.18),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ],
    );

Widget _floatingBadge({
  required IconData icon,
  required Color bg,
  required Color fg,
  required double size,
  double iconSize = 14,
}) =>
    Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: fg, size: iconSize),
    );

// ─────────────────────────────────────────────
// Scene 1 — Car Wash
// ─────────────────────────────────────────────

class _WashScene extends StatelessWidget {
  const _WashScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft glow ring behind card
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),

        // Main card
        Container(
          width: 200,
          decoration: _cardDecoration,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with blue background
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.local_car_wash_rounded,
                    size: 40, color: AppColors.primary),
              ),
              const Gap(16),
              Text('Premium Service',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              const Gap(8),
              // Vehicle type chips
              Wrap(
                spacing: 6,
                children: ['Sedan', 'SUV', 'Truck'].map((t) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(t,
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textSecondary)),
                  );
                }).toList(),
              ),
              const Gap(14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Book Now',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.92, 0.92), duration: 500.ms),

        // Floating water drops
        Positioned(
          top: 24,
          right: 28,
          child: _floatingBadge(
            icon: Icons.water_drop,
            bg: Colors.white.withValues(alpha: 0.2),
            fg: Colors.white,
            size: 36,
            iconSize: 18,
          )
              .animate(delay: 200.ms)
              .fadeIn()
              .scale(begin: const Offset(0.5, 0.5)),
        ),
        Positioned(
          top: 72,
          left: 18,
          child: _floatingBadge(
            icon: Icons.water_drop,
            bg: Colors.white.withValues(alpha: 0.12),
            fg: Colors.white.withValues(alpha: 0.7),
            size: 24,
            iconSize: 12,
          ).animate(delay: 350.ms).fadeIn(),
        ),
        Positioned(
          bottom: 40,
          right: 20,
          child: _floatingBadge(
            icon: Icons.auto_awesome,
            bg: const Color(0xFFFDE68A).withValues(alpha: 0.25),
            fg: const Color(0xFFFDE68A),
            size: 30,
            iconSize: 15,
          ).animate(delay: 400.ms).fadeIn(),
        ),
        Positioned(
          bottom: 28,
          left: 24,
          child: _floatingBadge(
            icon: Icons.water_drop,
            bg: Colors.white.withValues(alpha: 0.15),
            fg: Colors.white.withValues(alpha: 0.6),
            size: 20,
            iconSize: 10,
          ).animate(delay: 300.ms).fadeIn(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Scene 2 — Booking
// ─────────────────────────────────────────────

class _BookingScene extends StatelessWidget {
  const _BookingScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),

        // Booking card
        Container(
          width: 210,
          decoration: _cardDecoration,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 16, color: AppColors.primary),
                const Gap(6),
                Text('Your Booking',
                    style: AppTypography.labelLarge
                        .copyWith(color: AppColors.primary)),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.success, shape: BoxShape.circle),
                ),
              ]),
              const Divider(height: 20, color: AppColors.divider),
              _bookingRow(
                  Icons.access_time_rounded, 'Today, 3:00 PM', AppColors.primary),
              const Gap(10),
              _bookingRow(
                  Icons.location_on_rounded, 'Home Address', AppColors.warning),
              const Gap(10),
              _bookingRow(Icons.local_car_wash_rounded, 'Premium Wash',
                  AppColors.success),
              const Gap(16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 15),
                    const Gap(6),
                    Text('Confirmed',
                        style: AppTypography.labelSmall.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.92, 0.92), duration: 500.ms),

        // Floating clock
        Positioned(
          top: 20,
          left: 22,
          child: _floatingBadge(
            icon: Icons.schedule_rounded,
            bg: Colors.white.withValues(alpha: 0.2),
            fg: Colors.white,
            size: 38,
            iconSize: 20,
          ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.5, 0.5)),
        ),
        // Notification dot
        Positioned(
          top: 30,
          right: 20,
          child: _floatingBadge(
            icon: Icons.notifications_rounded,
            bg: const Color(0xFFFDE68A).withValues(alpha: 0.25),
            fg: const Color(0xFFFDE68A),
            size: 32,
            iconSize: 16,
          ).animate(delay: 350.ms).fadeIn(),
        ),
        Positioned(
          bottom: 26,
          left: 18,
          child: _floatingBadge(
            icon: Icons.pin_drop_rounded,
            bg: Colors.white.withValues(alpha: 0.15),
            fg: Colors.white,
            size: 26,
            iconSize: 13,
          ).animate(delay: 400.ms).fadeIn(),
        ),
      ],
    );
  }

  Widget _bookingRow(IconData icon, String text, Color color) => Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const Gap(10),
          Text(text,
              style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      );
}

// ─────────────────────────────────────────────
// Scene 3 — Washer Profile
// ─────────────────────────────────────────────

class _WasherScene extends StatelessWidget {
  const _WasherScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),

        // Profile card
        Container(
          width: 200,
          decoration: _cardDecoration,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person_rounded,
                        size: 38, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Text('Expert Washer',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              const Gap(4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Verified Professional',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.success)),
              ),
              const Gap(12),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (_) => const Icon(Icons.star_rounded,
                      color: Color(0xFFFBBF24), size: 20),
                ),
              ),
              const Gap(10),
              const Divider(color: AppColors.divider, height: 1),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('250+', 'Jobs'),
                  Container(width: 1, height: 28, color: AppColors.divider),
                  _stat('4.9', 'Rating'),
                  Container(width: 1, height: 28, color: AppColors.divider),
                  _stat('3yr', 'Exp.'),
                ],
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.92, 0.92), duration: 500.ms),

        // Floating stars
        Positioned(
          top: 22,
          left: 20,
          child: const Icon(Icons.star_rounded,
                  color: Color(0xFFFBBF24), size: 22)
              .animate(delay: 200.ms)
              .fadeIn()
              .scale(begin: const Offset(0.3, 0.3)),
        ),
        Positioned(
          top: 14,
          right: 30,
          child: const Icon(Icons.star_rounded,
                  color: Color(0xFFFBBF24), size: 16)
              .animate(delay: 300.ms)
              .fadeIn(),
        ),
        Positioned(
          bottom: 30,
          right: 18,
          child: _floatingBadge(
            icon: Icons.thumb_up_rounded,
            bg: Colors.white.withValues(alpha: 0.2),
            fg: Colors.white,
            size: 34,
            iconSize: 17,
          ).animate(delay: 350.ms).fadeIn(),
        ),
        Positioned(
          bottom: 22,
          left: 16,
          child: const Icon(Icons.star_rounded,
                  color: Color(0xFFFBBF24), size: 14)
              .animate(delay: 400.ms)
              .fadeIn(),
        ),
      ],
    );
  }

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value,
              style: AppTypography.titleMedium
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      );
}
