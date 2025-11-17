import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/more_widgets.dart';

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: ModernTheme.shadowSM,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: ModernTheme.primaryBlue,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  imageCached(post.image),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ModernTheme.radiusXL),
                  topRight: Radius.circular(ModernTheme.radiusXL),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      post.title,
                      style: ModernTheme.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ModernTheme.spaceMD),
                    
                    // Date/Time indicator
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ModernTheme.spaceSM,
                        vertical: ModernTheme.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: ModernTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: ModernTheme.primaryBlue,
                          ),
                          SizedBox(width: ModernTheme.spaceXS),
                          Text(
                            'تم النشر مؤخراً',
                            style: ModernTheme.labelMedium.copyWith(
                              color: ModernTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: ModernTheme.spaceLG),
                    
                    // Divider
                    Divider(color: Colors.grey[200]),
                    
                    SizedBox(height: ModernTheme.spaceLG),
                    
                    // Description section header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ModernTheme.spaceXS),
                          decoration: BoxDecoration(
                            color: ModernTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                          ),
                          child: Icon(
                            Icons.description,
                            size: 20,
                            color: ModernTheme.primaryBlue,
                          ),
                        ),
                        SizedBox(width: ModernTheme.spaceSM),
                        Text(
                          'التفاصيل',
                          style: ModernTheme.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ModernTheme.spaceMD),
                    
                    // Description
                    Text(
                      post.description,
                      style: ModernTheme.bodyLarge.copyWith(
                        height: 1.8,
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                    
                    SizedBox(height: ModernTheme.space2XL),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
