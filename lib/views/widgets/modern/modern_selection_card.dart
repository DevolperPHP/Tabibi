import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/modern_theme.dart';

class ModernSelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final String selectedValue;
  final Function(String) onSelected;
  final bool isRequired;

  const ModernSelectionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Padding(
        padding: EdgeInsets.all(ModernTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                  ),
                  child: Icon(
                    icon,
                    color: ModernTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Text(
                    title,
                    style: ModernTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isRequired)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ModernTheme.spaceSM,
                      vertical: ModernTheme.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: ModernTheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                    ),
                    child: Text(
                      '*',
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: ModernTheme.spacingM),
            
            // Options
            Row(
              children: options.map((option) {
                final isSelected = selectedValue == option;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: options.indexOf(option) < options.length - 1 
                          ? ModernTheme.spaceSM
                          : 0,
                    ),
                    child: _buildOptionButton(option, isSelected),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, bool isSelected) {
    return GestureDetector(
      onTap: () => onSelected(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceMD),
        decoration: BoxDecoration(
          color: isSelected
                ? ModernTheme.primaryBlue
                : ModernTheme.background,
      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
      border: Border.all(
        color: isSelected
              ? ModernTheme.primaryBlue
              : ModernTheme.divider,
            width: 1.5,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: ModernTheme.primaryBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            option,
            style: ModernTheme.bodyMedium.copyWith(
              color: isSelected
                    ? ModernTheme.surface
                    : ModernTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ModernMedicalInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String selectedValue;
  final Function(String) onSelected;
  final String? description;

  const ModernMedicalInfoCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.selectedValue,
    required this.onSelected,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Padding(
        padding: EdgeInsets.all(ModernTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                  ),
                  child: Icon(
                    icon,
                    color: ModernTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Text(
                    title,
                    style: ModernTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            if (description != null) ...[
              SizedBox(height: ModernTheme.spacingS),
              Text(
                description!,
                style: ModernTheme.bodySmall.copyWith(
                  color: ModernTheme.textSecondaryColor,
                ),
              ),
            ],
            
            SizedBox(height: ModernTheme.spacingM),
            
            // Yes/No Options
            Row(
              children: ['نعم', 'لا'].map((option) {
                final isSelected = selectedValue == (option == 'نعم' ? 'yes' : 'no');
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: option == 'نعم' ? ModernTheme.spaceSM : 0,
                    ),
                    child: _buildMedicalOptionButton(option, isSelected, option == 'نعم' ? 'yes' : 'no'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalOptionButton(String option, bool isSelected, String value) {
    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceMD),
        decoration: BoxDecoration(
          color: isSelected
                ? (option == 'نعم' ? ModernTheme.success : ModernTheme.error)
                : ModernTheme.background,
borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
border: Border.all(
  color: isSelected
        ? (option == 'نعم' ? ModernTheme.success : ModernTheme.error)
        : ModernTheme.divider,
            width: 1.5,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: (option == 'نعم' ? ModernTheme.success : ModernTheme.error).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                option == 'نعم' ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: isSelected ? ModernTheme.surfaceColor : ModernTheme.textSecondaryColor,
              ),
              SizedBox(width: ModernTheme.spacingXS),
              Text(
                option,
                style: ModernTheme.bodyMedium.copyWith(
                  color: isSelected
                        ? ModernTheme.surface
                        : ModernTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModernZoneSelector extends StatelessWidget {
  final String selectedZone;
  final Function(String) onZoneSelected;
  final List<String> zones;

  const ModernZoneSelector({
    Key? key,
    required this.selectedZone,
    required this.onZoneSelected,
    required this.zones,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showZoneSelectionDialog(context),
          borderRadius: BorderRadius.circular(ModernTheme.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: ModernTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المنطقة في بغداد',
                        style: ModernTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ModernTheme.spacingXS),
                      Text(
                        selectedZone.isEmpty ? 'اختر منطقتك' : selectedZone,
                        style: ModernTheme.bodyMedium.copyWith(
                          color: selectedZone.isEmpty
                                ? ModernTheme.textTertiary
                                : ModernTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: ModernTheme.textSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showZoneSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModernZoneSelectionDialog(
        zones: zones,
        onZoneSelected: (zone) {
          onZoneSelected(zone);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ModernZoneSelectionDialog extends StatefulWidget {
  final List<String> zones;
  final Function(String) onZoneSelected;

  const ModernZoneSelectionDialog({
    Key? key,
    required this.zones,
    required this.onZoneSelected,
  }) : super(key: key);

  @override
  State<ModernZoneSelectionDialog> createState() => _ModernZoneSelectionDialogState();
}

class _ModernZoneSelectionDialogState extends State<ModernZoneSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredZones = [];

  @override
  void initState() {
    super.initState();
    _filteredZones = List.from(widget.zones);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterZones(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredZones = List.from(widget.zones);
      } else {
        // Filter zones that match the query
        var filtered = widget.zones
            .where((zone) => zone.toLowerCase().contains(query.toLowerCase()))
            .toList();

        // Always include the first zone (not found option) at the top if it exists and query doesn't match it
        if (widget.zones.isNotEmpty) {
          String firstZone = widget.zones.first;
          // Check if the first zone is the "not found" option
          if (firstZone.contains('في حال عدم وجود') && !filtered.contains(firstZone)) {
            // Add it at the beginning
            filtered.insert(0, firstZone);
          }
        }

        _filteredZones = filtered;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: ModernTheme.surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ModernTheme.radiusXL),
          topRight: Radius.circular(ModernTheme.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSmall),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: ModernTheme.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Text(
                    'اختر منطقتك في بغداد',
                    style: ModernTheme.headline4,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: ModernTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Search Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
            child: Container(
              decoration: BoxDecoration(
                color: ModernTheme.background,
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                border: Border.all(color: ModernTheme.divider),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterZones,
                style: ModernTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منطقتك...',
                  hintStyle: ModernTheme.bodyMedium.copyWith(
                    color: ModernTheme.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ModernTheme.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(ModernTheme.spaceMD),
                ),
              ),
            ),
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Zones List
          Expanded(
            child: _filteredZones.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: ModernTheme.textTertiary,
                        ),
                        SizedBox(height: ModernTheme.spacingM),
                        Text(
                          'لم يتم العثور على نتائج',
                          style: ModernTheme.bodyLarge.copyWith(
                            color: ModernTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: ModernTheme.spacingXS),
                        Text(
                          'حاول تغيير كلمة البحث',
                          style: ModernTheme.bodySmall.copyWith(
                            color: ModernTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
                    itemCount: _filteredZones.length,
                    itemBuilder: (context, index) {
                      final zone = _filteredZones[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: ModernTheme.spaceSM),
                        decoration: BoxDecoration(
                          color: ModernTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(ModernTheme.radiusMedium),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => widget.onZoneSelected(zone),
                            borderRadius: BorderRadius.circular(ModernTheme.radiusMedium),
                            child: Padding(
                              padding: EdgeInsets.all(ModernTheme.spaceMD),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: ModernTheme.textSecondary,
                                    size: 20,
                                  ),
                                  SizedBox(width: ModernTheme.spaceMD),
                                  Expanded(
                                    child: Text(
                                      zone,
                                      style: ModernTheme.bodyMedium,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: ModernTheme.textTertiary,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}