import 'package:flutter/material.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/design_system/modern_theme.dart';

class GenderProfileIcon extends StatelessWidget {
  final CaseModel caseModel;
  final double size;
  final int? index; // Optional index to show as fallback

  const GenderProfileIcon({
    super.key,
    required this.caseModel,
    this.size = 28.0,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Determine gender and color
    Color profileColor = _getGenderColor(caseModel.gender);
    IconData profileIcon = _getGenderIcon(caseModel.gender);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: profileColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          profileIcon,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  Color _getGenderColor(String? gender) {
    if (gender == null || gender.isEmpty) {
      return Colors.grey; // Default color for unknown gender
    }
    
    switch (gender.toLowerCase()) {
      case 'male':
        return ModernTheme.primaryBlue; // Blue for male
      case 'female':
        return Color(0xFFE91E63); // Pink for female
      default:
        return Colors.grey; // Default color for unknown
    }
  }

  IconData _getGenderIcon(String? gender) {
    // Use a modern profile icon for all genders
    return Icons.person; // Modern person icon for all
  }
}