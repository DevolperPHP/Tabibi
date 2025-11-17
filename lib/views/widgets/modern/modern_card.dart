import 'package:flutter/material.dart';
import '../../../utils/design_system/modern_theme.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool withShadow;
  final bool isInteractive;
  final Gradient? gradient;
  final Color? backgroundColor;

  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.withShadow = true,
    this.isInteractive = true,
    this.gradient,
    this.backgroundColor,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isInteractive && widget.onTap != null
          ? (_) => _controller.forward()
          : null,
      onTapUp: widget.isInteractive && widget.onTap != null
          ? (_) {
              _controller.reverse();
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.isInteractive && widget.onTap != null
          ? () => _controller.reverse()
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin ?? const EdgeInsets.all(ModernTheme.spaceSM),
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.backgroundColor ?? const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
                boxShadow: widget.withShadow
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.05 + (0.03 * _elevationAnimation.value),
                          ),
                          blurRadius: 8 + (4 * _elevationAnimation.value),
                          offset: Offset(0, 4 + (2 * _elevationAnimation.value)),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: widget.padding ??
                        const EdgeInsets.all(ModernTheme.spaceMD),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

// Info Card with Icon
class ModernInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ModernInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: (iconColor ?? const Color(0xFF2196F3)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor ?? const Color(0xFF2196F3),
              size: 28,
            ),
          ),
          const SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ModernTheme.headlineMedium,
                ),
                const SizedBox(height: ModernTheme.spaceXS),
                Text(
                  subtitle,
                  style: ModernTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: const Color(0xFF9E9E9E),
            ),
        ],
      ),
    );
  }
}
