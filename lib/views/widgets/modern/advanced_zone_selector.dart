import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_doctor/utils/design_system/modern_theme.dart';

class AdvancedZoneSelector extends StatefulWidget {
  final List<String> availableZones;
  final String selectedZone;
  final Function(String) onZoneSelected;
  final VoidCallback onClose;

  const AdvancedZoneSelector({
    Key? key,
    required this.availableZones,
    required this.selectedZone,
    required this.onZoneSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AdvancedZoneSelector> createState() => _AdvancedZoneSelectorState();
}

class _AdvancedZoneSelectorState extends State<AdvancedZoneSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ZoneViewMode _viewMode = ZoneViewMode.grid;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }


  List<String> get _filteredZones {
    List<String> zones = widget.availableZones.where((zone) =>
        zone.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
    
    if (_viewMode == ZoneViewMode.alphabetical) {
      zones.sort((a, b) => a.compareTo(b));
    }
    
    return zones;
  }

  Map<String, List<String>> get _groupedZones {
    Map<String, List<String>> groups = {};
    
    for (String zone in _filteredZones) {
      String firstLetter = zone.isNotEmpty ? zone[0] : '#';
      if (!groups.containsKey(firstLetter)) {
        groups[firstLetter] = [];
      }
      groups[firstLetter]!.add(zone);
    }
    
    // Sort groups alphabetically
    groups.forEach((key, value) {
      value.sort((a, b) => a.compareTo(b));
    });
    
    return groups;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: EdgeInsets.all(ModernTheme.spaceLG),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.98,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildViewModeToggle(),
                    _buildContent(),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ModernTheme.radiusXL),
          topRight: Radius.circular(ModernTheme.radiusXL),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: ModernTheme.primaryBlue,
            size: 24,
          ),
          SizedBox(width: ModernTheme.spaceSM),
          Expanded(
            child: Text(
              'اختر المنطقة',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ModernTheme.textPrimary,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(Icons.close),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(ModernTheme.spaceMD),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن منطقة...',
            hintStyle: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
            prefixIcon: Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: ModernTheme.primaryBlue),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
      child: Row(
        children: [
          Expanded(
            child: _buildViewModeButton(
              'شبكة',
              Icons.grid_view,
              ZoneViewMode.grid,
            ),
          ),
          SizedBox(width: ModernTheme.spaceSM),
          Expanded(
            child: _buildViewModeButton(
              'أبجدي',
              Icons.sort_by_alpha,
              ZoneViewMode.alphabetical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(String label, IconData icon, ZoneViewMode mode) {
    final isSelected = _viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? ModernTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            border: Border.all(
              color: isSelected ? ModernTheme.primaryBlue : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.transparent,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: _viewMode == ZoneViewMode.alphabetical
            ? _buildAlphabeticalView()
            : _buildGridView(),
      ),
    );
  }

  Widget _buildAlphabeticalView() {
    final groups = _groupedZones;
    final sortedKeys = groups.keys.toList()..sort();
    
    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final letter = sortedKeys[index];
        final zones = groups[letter]!;
        
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(ModernTheme.spaceMD),
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    child: Text(
                      letter,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ModernTheme.primaryBlue,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                  ),
                  ...zones.map((zone) => _buildZoneTile(zone)).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildGridView() {
    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.all(ModernTheme.spaceMD),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: ModernTheme.spaceSM,
          mainAxisSpacing: ModernTheme.spaceSM,
          childAspectRatio: 2.5,
          mainAxisExtent: 90,
        ),
        itemCount: _filteredZones.length,
        itemBuilder: (context, index) {
          final zone = _filteredZones[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildZoneCard(zone),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildZoneTile(String zone) {
    final isSelected = zone == widget.selectedZone;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ModernTheme.spaceMD,
        vertical: ModernTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: isSelected ? ModernTheme.primaryBlue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
        border: Border.all(
          color: isSelected ? ModernTheme.primaryBlue : Colors.grey[200]!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () => widget.onZoneSelected(zone),
          leading: Icon(Icons.location_city_outlined),
          title: Text(
            zone,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? ModernTheme.primaryBlue : Colors.black87,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: ModernTheme.primaryBlue)
              : null,
        ),
      ),
    );
  }

  Widget _buildZoneCard(String zone) {
    final isSelected = zone == widget.selectedZone;
    
    return GestureDetector(
      onTap: () => widget.onZoneSelected(zone),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? ModernTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
          border: Border.all(
            color: isSelected ? ModernTheme.primaryBlue : Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_city,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 18,
            ),
            SizedBox(height: 4),
            Text(
              zone,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.1,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ModernTheme.radiusXL),
          bottomRight: Radius.circular(ModernTheme.radiusXL),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onClose,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceMD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                side: BorderSide(color: ModernTheme.primaryBlue),
              ),
              child: Text(
                'إلغاء',
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
              onPressed: widget.selectedZone.isNotEmpty ? widget.onClose : null,
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
      ),
    );
  }

}

enum ZoneViewMode {
  grid,
  alphabetical,
}