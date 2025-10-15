import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Function(String)? onPhoneNumberChanged; // Callback for complete phone number
  final Function(String)? onCountryChanged; // Callback for country code change
  final String? initialCountryCode; // Optional initial country code (e.g., 'US', 'NG', 'GB')

  const PhoneNumberInputField({
    Key? key,
    this.labelText = 'Phone Number',
    this.hintText = 'Enter your phone number',
    this.icon,
    this.isRequired = false,
    this.validator,
    this.onPhoneNumberChanged,
    this.onCountryChanged,
    this.initialCountryCode = 'NG', // Default to Nigeria
  }) : super(key: key);

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  String completePhoneNumber = '';
  String currentCountryCode = '';
  
  // Define your colors here (replace with your actual color definitions)
  final Color darkText = Colors.black87;
  final Color inputBorder = Colors.grey.shade300;
  final Color lightGray = Colors.grey.shade500;

  @override
  void initState() {
    super.initState();
    currentCountryCode = widget.initialCountryCode ?? 'NG';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional asterisk
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.labelText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: darkText,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Phone input field with country picker
        Container(
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: inputBorder),
          ),
          child: IntlPhoneField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: lightGray,
                fontSize: 14,
              ),
              prefixIcon: widget.icon != null 
                  ? Icon(
                      widget.icon,
                      color: lightGray,
                      size: 20,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: darkText,
            ),
            initialCountryCode: widget.initialCountryCode,
            onChanged: (phone) {
              completePhoneNumber = phone.completeNumber;
              
              // Call the callback with complete phone number
              if (widget.onPhoneNumberChanged != null) {
                widget.onPhoneNumberChanged!(completePhoneNumber);
              }
            },
            onCountryChanged: (country) {
              currentCountryCode = country.code;
              
              // Trigger the callback
              if (widget.onCountryChanged != null) {
                widget.onCountryChanged!(currentCountryCode);
              }
            },
            validator: widget.validator != null 
                ? (phone) => widget.validator!(phone?.completeNumber)
                : null,
            // Customization options
            dropdownTextStyle: TextStyle(
              color: darkText,
              fontSize: 16,
            ),
            flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 12),
            showDropdownIcon: true,
            dropdownIcon: Icon(
              Icons.arrow_drop_down,
              color: lightGray,
            ),
          ),
        ),
      ],
    );
  }

  // Method to get the complete phone number
  String getCompletePhoneNumber() {
    return completePhoneNumber;
  }
  
  // Method to get the current country code
  String getCountryCode() {
    return currentCountryCode;
  }
}