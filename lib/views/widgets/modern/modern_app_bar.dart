import 'package:flutter/material.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/modern_theme.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onLogoTap;

  const ModernAppBar({
    super.key,
    this.title,
    this.actions,
    this.showLogo = true,
    this.onLogoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ModernTheme.spaceMD,
            vertical: ModernTheme.spaceSM,
          ),
          child: Row(
            children: [
              if (showLogo)
                GestureDetector(
                  onTap: onLogoTap,
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: ModernTheme.shadowSM,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          ImagesUrl.logoPNG,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                ),
              if (showLogo) const SizedBox(width: ModernTheme.spaceMD),
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: ModernTheme.headline3,
                  ),
                )
              else
                const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
