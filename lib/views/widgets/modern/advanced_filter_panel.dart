import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_doctor/data/models/category.dart';
import 'package:my_doctor/utils/design_system/modern_theme.dart';
import 'advanced_zone_selector.dart';

class AdvancedFilterPanel extends StatefulWidget {
  final List<String> availableZones;
  final List<Category> availableCategories;
  final String selectedZone;
  final Category? selectedCategory;
  final String selectedGender;
  final Function(String) onZoneChanged;
  final Function(Category?) onCategoryChanged;
  final Function(String) onGenderChanged;
  final VoidCallback onClearFilters;
  final bool hasActiveFilters;

  const AdvancedFilterPanel({
    Key? key,
    required this.availableZones,
    required this.availableCategories,
    required this.selectedZone,
    required this.selectedCategory,
    required this.selectedGender,
    required this.onZoneChanged,
    required this.onCategoryChanged,
    required this.onGenderChanged,
    required this.onClearFilters,
    required this.hasActiveFilters,
  }) : super(key: key);

  @override
  State<AdvancedFilterPanel> createState() => _AdvancedFilterPanelState();
}

class _AdvancedFilterPanelState extends State<AdvancedFilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  final GlobalKey _panelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ModernTheme.spaceSM),
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
        children: [
          // Filter Header
          GestureDetector(
            onTap: _toggleExpanded,
            child: Container(
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ModernTheme.spaceXS),
                    decoration: BoxDecoration(
                      color: ModernTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: ModernTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Text(
                      'الفلاتر المتقدمة',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ModernTheme.textPrimary,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                  ),
                  if (widget.hasActiveFilters)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ModernTheme.spaceSM,
                        vertical: ModernTheme.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: ModernTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                      ),
                      child: Text(
                        'مفعل',
                        style: ModernTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: ModernTheme.spaceSM),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: ModernTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Filter Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                ModernTheme.spaceMD,
                0,
                ModernTheme.spaceMD,
                ModernTheme.spaceMD,
              ),
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        _buildSectionTitle('المنطقة'),
                        _buildZoneFilter(),
                        SizedBox(height: ModernTheme.spaceMD),
                        _buildSectionTitle('الفئة'),
                        _buildCategoryFilter(),
                        SizedBox(height: ModernTheme.spaceMD),
                        _buildSectionTitle('الجنس'),
                        _buildGenderFilter(),
                        SizedBox(height: ModernTheme.spaceLG),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      child: Text(
        title,
        style: ModernTheme.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildZoneFilter() {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _showAdvancedZoneSelector(),
        child: Container(
          padding: EdgeInsets.all(ModernTheme.spaceMD),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: widget.selectedZone.isNotEmpty
                    ? ModernTheme.primaryBlue
                    : Colors.grey[600],
              ),
              SizedBox(width: ModernTheme.spaceSM),
              Expanded(
                child: Text(
                  widget.selectedZone.isNotEmpty
                      ? widget.selectedZone
                      : 'اختر المنطقة',
                  style: ModernTheme.bodyMedium.copyWith(
                    color: widget.selectedZone.isNotEmpty
                        ? ModernTheme.primaryBlue
                        : Colors.grey[600],
                    fontWeight: widget.selectedZone.isNotEmpty
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAdvancedZoneSelector() {
    Get.dialog(
      AdvancedZoneSelector(
        availableZones: widget.availableZones,
        selectedZone: widget.selectedZone,
        onZoneSelected: (zone) {
          Get.back();
          widget.onZoneChanged(zone);
        },
        onClose: () => Get.back(),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildCategoryFilter() {
    return Wrap(
      spacing: ModernTheme.spaceXS,
      runSpacing: ModernTheme.spaceXS,
      children: [
        _buildFilterChip(
          'الكل',
          widget.selectedCategory == null,
          () => widget.onCategoryChanged(null),
        ),
        ...widget.availableCategories.map((category) => _buildFilterChip(
          category.name,
          widget.selectedCategory?.id == category.id,
          () => widget.onCategoryChanged(category),
        )),
      ],
    );
  }

  Widget _buildGenderFilter() {
    return Wrap(
      spacing: ModernTheme.spaceXS,
      runSpacing: ModernTheme.spaceXS,
      children: [
        _buildFilterChip(
          'الكل',
          widget.selectedGender == 'all',
          () => widget.onGenderChanged('all'),
        ),
        _buildFilterChip(
          'ذكر',
          widget.selectedGender == 'male',
          () => widget.onGenderChanged('male'),
        ),
        _buildFilterChip(
          'أنثى',
          widget.selectedGender == 'female',
          () => widget.onGenderChanged('female'),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ModernTheme.spaceMD,
          vertical: ModernTheme.spaceSM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? ModernTheme.primaryBlue : Colors.grey[100],
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              widget.onClearFilters();
              _closePanel();
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceMD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              side: BorderSide(color: ModernTheme.primaryBlue),
            ),
            child: Text(
              'مسح الفلاتر',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: ModernTheme.primaryBlue,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
            ),
          ),
        ),
        SizedBox(width: ModernTheme.spaceMD),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _closePanel();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ModernTheme.primaryBlue,
              padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceMD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
            ),
            child: Text(
              'تطبيق',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _closePanel() {
    // Use the panel's context to close the panel
    final context = _panelKey.currentContext;
    if (context != null) {
      Navigator.of(context!).pop();
    } else {
      // Fallback: try to close any active dialog/bottom sheet
      Get.back();
    }
  }
}