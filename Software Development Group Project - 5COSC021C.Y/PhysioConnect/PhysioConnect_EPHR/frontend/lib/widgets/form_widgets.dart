import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';

/// Collection of reusable form elements for consistent UI

/// Text input field with consistent styling
class EPHRTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  
  const EPHRTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        
        // Text field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : AppTheme.aliceBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.midnightTeal, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

/// Date picker field with formatted display
class EPHRDateField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  
  const EPHRDateField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        
        // Date field
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.aliceBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Date display
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'Select a date',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
                
                // Calendar icon
                const Icon(
                  Icons.calendar_today,
                  color: AppTheme.midnightTeal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate ?? now;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(now.year + 5, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.midnightTeal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }
}

/// Dropdown field with consistent styling
class EPHRDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? hint;
  
  const EPHRDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        
        // Dropdown field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.aliceBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: hint != null ? Text(hint!) : null,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.midnightTeal),
              items: items,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Checkbox field with label
class EPHRCheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;
  
  const EPHRCheckboxField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.midnightTeal,
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

/// Radio button group
class EPHRRadioGroup<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<Map<String, dynamic>> options;
  final Function(T?) onChanged;
  
  const EPHRRadioGroup({
    Key? key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        
        // Radio options
        ...options.map((option) {
          return RadioListTile<T>(
            title: Text(option['label']),
            value: option['value'],
            groupValue: value,
            onChanged: onChanged,
            activeColor: AppTheme.midnightTeal,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList(),
      ],
    );
  }
}