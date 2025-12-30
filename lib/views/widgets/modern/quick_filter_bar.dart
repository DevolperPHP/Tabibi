import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabibi/data/models/category.dart';
import 'package:tabibi/utils/design_system/modern_theme.dart';

class QuickFilterBar extends StatelessWidget {
  final List<String> availableZones;
  final List<Category> availableCategories;
  final String selectedZone;
  final Category? selectedCategory;
  final String selectedGender;
  final Function(String) onZoneChanged;
  final Function(Category?) onCategoryChanged;
  final Function(String) onGenderChanged;
  final VoidCallback onShowAdvancedFilters;
  final VoidCallback? onClearFilters;
  final bool hasActiveFilters;

  const QuickFilterBar({
    Key? key,
    required this.availableZones,
    required this.availableCategories,
    required this.selectedZone,
    required this.selectedCategory,
    required this.selectedGender,
    required this.onZoneChanged,
    required this.onCategoryChanged,
    required this.onGenderChanged,
    required this.onShowAdvancedFilters,
    this.onClearFilters,
    this.hasActiveFilters = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: ModernTheme.primaryBlue,
                size: 20,
              ),
              SizedBox(width: ModernTheme.spaceSM),
              Text(
                'الفلاتر السريعة',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ModernTheme.textPrimary,
                  decoration: TextDecoration.none,
                  decorationColor: Colors.transparent,
                ),
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasActiveFilters && onClearFilters != null)
                    Padding(
                      padding: EdgeInsets.only(left: ModernTheme.spaceXS),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onClearFilters,
                          borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.clear_all, size: 16, color: Colors.red[600]),
                                SizedBox(width: 4),
                                Text(
                                  'مسح',
                                  style: ModernTheme.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      onShowAdvancedFilters();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ModernTheme.primaryBlue.withOpacity(0.1),
                      foregroundColor: ModernTheme.primaryBlue,
                      padding: EdgeInsets.symmetric(
                        horizontal: ModernTheme.spaceSM,
                        vertical: ModernTheme.spaceXS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                        side: BorderSide(
                          color: ModernTheme.primaryBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, size: 16, color: ModernTheme.primaryBlue),
                        SizedBox(width: 4),
                        Text(
                          'متقدم',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ModernTheme.primaryBlue,
                            decoration: TextDecoration.none,
                            decorationColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          
          // Quick filter chips in a horizontal scrollable list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Zone quick filter (show first 3 zones + "المزيد")
                _buildQuickSection('المنطقة:'),
                if (availableZones.isNotEmpty) ...[
                  ..._buildZoneQuickFilters(),
                ],
                if (availableZones.length > 3)
                  _buildMoreChip('مناطق', () => onShowAdvancedFilters()),
                
                SizedBox(width: ModernTheme.spaceMD),
                
                // Category quick filter (show first 2 categories + "المزيد")
                _buildQuickSection('الفئة:'),
                if (availableCategories.isNotEmpty) ...[
                  ..._buildCategoryQuickFilters(),
                ],
                if (availableCategories.length > 2)
                  _buildMoreChip('فئات', () => onShowAdvancedFilters()),
                
                SizedBox(width: ModernTheme.spaceMD),
                
                // Gender quick filter
                _buildQuickSection('الجنس:'),
                ..._buildGenderQuickFilters(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSection(String title) {
    return Container(
      margin: EdgeInsets.only(left: ModernTheme.spaceSM, right: ModernTheme.spaceXS),
      child: Text(
        title,
        style: ModernTheme.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  List<Widget> _buildZoneQuickFilters() {
    final zonesToShow = availableZones.take(3).toList();
    return [
      ...zonesToShow.map((zone) => _buildQuickChip(
        zone,
        selectedZone == zone,
        () => onZoneChanged(zone),
      )),
    ];
  }

  List<Widget> _buildCategoryQuickFilters() {
    final categoriesToShow = availableCategories.take(2).toList();
    return [
      ...categoriesToShow.map((category) => _buildQuickChip(
        category.name,
        selectedCategory?.id == category.id,
        () => onCategoryChanged(category),
      )),
    ];
  }

  List<Widget> _buildGenderQuickFilters() {
    return [
      _buildQuickChip(
        'الكل',
        selectedGender == 'all',
        () => onGenderChanged('all'),
      ),
      _buildQuickChip(
        'ذكر',
        selectedGender == 'male',
        () => onGenderChanged('male'),
      ),
      _buildQuickChip(
        'أنثى',
        selectedGender == 'female',
        () => onGenderChanged('female'),
      ),
    ];
  }

  Widget _buildQuickChip(String label, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(left: ModernTheme.spaceXS),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: ModernTheme.spaceSM,
            vertical: ModernTheme.spaceXS,
          ),
          decoration: BoxDecoration(
            color: isSelected ? ModernTheme.primaryBlue : Colors.grey[100],
            borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            border: Border.all(
              color: isSelected ? ModernTheme.primaryBlue : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: ModernTheme.bodySmall.copyWith(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreChip(String label, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(left: ModernTheme.spaceXS),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ModernTheme.spaceSM,
            vertical: ModernTheme.spaceXS,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المزيد',
                style: ModernTheme.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.keyboard_arrow_right,
                size: 14,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}