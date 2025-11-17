import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/modern_theme.dart';

class ModernInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isNumber;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final bool readOnly;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  const ModernInputField({
    Key? key,
    required this.label,
    this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.isNumber = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  bool _isFocused = false;
  bool _isObscured = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(
            right: ModernTheme.spaceMD,
            bottom: ModernTheme.spaceXS,
          ),
          child: Text(
            widget.label,
            style: ModernTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: _isFocused
                  ? ModernTheme.primaryBlue
                  : ModernTheme.textPrimary,
            ),
          ),
        ),

        // Input Field
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: ModernTheme.surfaceColor,
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            boxShadow: _isFocused ? ModernTheme.shadowSM : [],
            border: Border.all(
              color: _isFocused ? ModernTheme.primaryBlue : ModernTheme.divider,
              width: _isFocused ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: widget.isPassword ? _isObscured : false,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: ModernTheme.bodyMedium.copyWith(
              color: ModernTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: ModernTheme.bodyMedium.copyWith(
                color: ModernTheme.textTertiaryColor,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ModernTheme.spaceMD,
                        vertical: ModernTheme.spaceSM,
                      ),
                      child: Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? ModernTheme.primaryBlue
                            : ModernTheme.textSecondary,
                        size: 20,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: ModernTheme.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? 0 : ModernTheme.spaceMD,
                vertical: ModernTheme.spaceMD,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModernPhoneInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ModernPhoneInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<ModernPhoneInputField> createState() => _ModernPhoneInputFieldState();
}

class _ModernPhoneInputFieldState extends State<ModernPhoneInputField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(
            right: ModernTheme.spaceMD,
            bottom: ModernTheme.spaceXS,
          ),
          child: Text(
            widget.label,
            style: ModernTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: _isFocused
                  ? ModernTheme.primaryBlue
                  : ModernTheme.textPrimary,
            ),
          ),
        ),

        // Phone Input with Country Code
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: ModernTheme.surfaceColor,
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            boxShadow: _isFocused ? ModernTheme.shadowSM : [],
            border: Border.all(
              color: _isFocused ? ModernTheme.primaryBlue : ModernTheme.divider,
              width: _isFocused ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Country Code Prefix
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ModernTheme.spaceMD,
                  vertical: ModernTheme.spaceMD,
                ),
                decoration: BoxDecoration(
                  color: ModernTheme.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ModernTheme.radiusMD),
                    bottomRight: Radius.circular(ModernTheme.radiusMD),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: ModernTheme.divider,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone,
                      color: _isFocused
                          ? ModernTheme.primaryBlue
                          : ModernTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),

              // Phone Number Input
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  validator: widget.validator,
                  style: ModernTheme.bodyMedium.copyWith(
                    color: ModernTheme.textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: '07XXXXXXXXX',
                    hintStyle: ModernTheme.bodyMedium.copyWith(
                      color: ModernTheme.textTertiary,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: ModernTheme.spaceMD,
                      vertical: ModernTheme.spaceMD,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
