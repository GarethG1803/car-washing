import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const AppBadge({
    super.key,
    required this.count,
    required this.child,
  });

  String get _displayText {
    if (count > 99) return '99+';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            alignment: Alignment.center,
            child: Text(
              _displayText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
