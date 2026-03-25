import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.local_car_wash,
      title: 'Premium Car Wash',
      subtitle:
          'Professional car wash service delivered to your doorstep',
      color: AppColors.primary,
      imageUrl: 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=600&fit=crop',
    ),
    _OnboardingPage(
      icon: Icons.schedule,
      title: 'Book in Seconds',
      subtitle:
          'Schedule a wash in just a few taps. Choose your time and service',
      color: AppColors.primary,
      imageUrl: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&fit=crop',
    ),
    _OnboardingPage(
      icon: Icons.star,
      title: 'Top-Rated Washers',
      subtitle:
          'Our verified professionals deliver exceptional results every time',
      color: AppColors.primary,
      imageUrl: 'https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=600&fit=crop',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingPageView(page: page);
                  },
                ),
              ),

              // Page indicator dots
              SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.divider,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: AppSpacing.sm,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Get Started button
              AppButton(
                label: 'Get Started',
                onPressed: () => context.go('/login'),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Sign In',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class for onboarding pages
// ---------------------------------------------------------------------------

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String? imageUrl;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.imageUrl,
  });
}

// ---------------------------------------------------------------------------
// Single onboarding page widget
// ---------------------------------------------------------------------------

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or icon circle
          if (page.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                page.imageUrl!,
                width: 240,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                page.icon,
                size: 56,
                color: page.color,
              ),
            ),

          const SizedBox(height: AppSpacing.xxxl),

          // Title
          Text(
            page.title,
            style: AppTypography.headlineLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Subtitle
          Text(
            page.subtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
