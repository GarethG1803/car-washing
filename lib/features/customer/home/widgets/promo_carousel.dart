import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;

  final _promos = const [
    {'title': '20% Off Summer Special', 'subtitle': 'Use code SUMMER20 on any wash package', 'gradient': [Color(0xFF0066FF), Color(0xFF0047B3)], 'image': 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800&fit=crop'},
    {'title': 'First Wash Free', 'subtitle': 'New users get their first Quick Wash on us', 'gradient': [Color(0xFF10B981), Color(0xFF059669)], 'image': 'https://images.unsplash.com/photo-1605164599901-db40af1af037?w=800&fit=crop'},
    {'title': 'Premium Detail Rp 350.000', 'subtitle': 'Save Rp 150.000 on our full detail service this week', 'gradient': [Color(0xFF8B5CF6), Color(0xFF6D28D9)], 'image': 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&fit=crop'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients) {
        final next = ((_controller.page?.round() ?? 0) + 1) % _promos.length;
        _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: promo['gradient'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    image: promo['image'] != null
                        ? DecorationImage(
                            image: NetworkImage(promo['image'] as String),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.45),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo['title'] as String,
                        style: AppTypography.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        promo['subtitle'] as String,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const Gap(16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Book Now',
                          style: AppTypography.labelSmall.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(12),
        SmoothPageIndicator(
          controller: _controller,
          count: _promos.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.divider,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}
