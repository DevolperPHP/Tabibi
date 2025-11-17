import 'package:flutter/material.dart';
import '../../utils/constants/images_url.dart';
import '../../utils/design_system/modern_theme.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  final String? heroTag;
  
  const AnimatedLogo({
    super.key,
    this.size = 100,
    this.heroTag,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.15,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              decoration: BoxDecoration(
                color: ModernTheme.primaryBlue.withOpacity(_glowAnimation.value),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ModernTheme.primaryBlue.withOpacity(_glowAnimation.value * 2),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                  BoxShadow(
                    color: ModernTheme.primaryBlue.withOpacity(_glowAnimation.value),
                    blurRadius: 40 * _pulseAnimation.value,
                    spreadRadius: 10 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  ImagesUrl.logoPNG,
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
      },
    );
  }
}
