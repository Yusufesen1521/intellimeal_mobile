import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:intellimeal/utils/app_colors.dart';

class SelectableExpansionWrap extends StatefulWidget {
  const SelectableExpansionWrap({
    super.key,
    required this.title,
    required this.options,
    this.initialSelectedValues = const [],
    this.onSelectionChanged,
    this.wrapSpacing,
    this.wrapRunSpacing,
    this.multiSelect = true,
  });

  final String title;
  final List<String> options;
  final List<String> initialSelectedValues;
  final ValueChanged<List<String>>? onSelectionChanged;
  final double? wrapSpacing;
  final double? wrapRunSpacing;
  final bool multiSelect;

  @override
  State<SelectableExpansionWrap> createState() =>
      _SelectableExpansionWrapState();
}

class _SelectableExpansionWrapState extends State<SelectableExpansionWrap>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 220);

  late final Set<String> _selectedValues;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialSelectedValues
        .where(widget.options.contains)
        .toSet();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleSelection(String value) {
    setState(() {
      if (widget.multiSelect) {
        if (_selectedValues.contains(value)) {
          _selectedValues.remove(value);
        } else {
          _selectedValues.add(value);
        }
      } else {
        if (_selectedValues.contains(value) && _selectedValues.length == 1) {
          _selectedValues.clear();
        } else {
          _selectedValues
            ..clear()
            ..add(value);
        }
      }
    });
    widget.onSelectionChanged?.call(_selectedValues.toList(growable: false));
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.appBlack),
            color: AppColors.appWhite,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: _toggleExpansion,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBlack,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: _animationDuration,
                      child: const Icon(
                        LucideIcons.chevronDown,
                        color: AppColors.appBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 8.h,
                  ),
                  child: Wrap(
                    spacing: widget.wrapSpacing ?? 10.w,
                    runSpacing: widget.wrapRunSpacing ?? 10.h,
                    children: widget.options.map(_buildSelectableChip).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSelectableChip(String value) {
    final isSelected = _selectedValues.contains(value);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => _handleSelection(value),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.appBlack : AppColors.appWhite,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.appBlack),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isSelected ? AppColors.appWhite : AppColors.appBlack,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
