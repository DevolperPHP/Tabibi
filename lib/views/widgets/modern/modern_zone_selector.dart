import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/design_system/modern_theme.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
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
                    Icons.location_on_outlined,
                    color: ModernTheme.primaryBlue,
                    size: 16,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Text(
                    'المنطقة',
                    style: ModernTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ModernTheme.spaceSM),

          // Zone Selection
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ModernTheme.spaceMD,
                vertical: ModernTheme.spaceSM,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: ModernTheme.divider),
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedZone.isEmpty ? null : selectedZone,
                  hint: Text(
                    'اختر منطقتك',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: ModernTheme.textTertiary,
                    ),
                  ),
                  isExpanded: true,
                  items: zones.map((String zone) {
                    return DropdownMenuItem<String>(
                      value: zone,
                      child: Text(
                        zone,
                        style: ModernTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onZoneSelected(newValue);
                    }
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: ModernTheme.spaceMD),
        ],
      ),
    );
  }
}