import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:revbank/Core/notification_service.dart';
import 'package:revbank/UI/home_screen.dart';
import 'package:revbank/UI/loginScreen.dart';
import 'package:revbank/UI/widget/phoneInput.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  
  // Updated color palette to match the screenshot
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFF999999);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // NEW VARIABLES FOR PHONE NUMBER
  String completePhoneNumber = '';
  String selectedCountryCode = 'NG';
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _agreeToTerms = true;
  String? _selectedCountryCode = 'NG';
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Country list with display name and code
  final Map<String, String> _countries = {
    'Nigeria (NG)': 'NG',
    'South Africa (SA)': 'SA',
    'Kenya (KE)': 'KE',
    'Ghana (GH)': 'GH',
    'Tanzania (TZ)': 'TZ',
    'Uganda (UG)': 'UG',
    'Ethiopia (ET)': 'ET',
    'Morocco (MA)': 'MA',
    'Egypt (EG)': 'EG',
    'Algeria (DZ)': 'DZ',
    'Cameroon (CM)': 'CM',
    'Senegal (SN)': 'SN',
    'Rwanda (RW)': 'RW',
    'Botswana (BW)': 'BW',
    'Zambia (ZM)': 'ZM',
    'Zimbabwe (ZW)': 'ZW',
    'Namibia (NA)': 'NA',
    'Mali (ML)': 'ML',
    'Burkina Faso (BF)': 'BF',
    'Ivory Coast (CI)': 'CI',
    'United States (US)': 'US',
    'United Kingdom (UK)': 'UK',
    'Canada (CA)': 'CA',
    'Australia (AU)': 'AU',
    'Germany (DE)': 'DE',
    'France (FR)': 'FR',
    'Netherlands (NL)': 'NL',
    'Sweden (SE)': 'SE',
    'Norway (NO)': 'NO',
    'Denmark (DK)': 'DK',
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _handleSignUp() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (!_agreeToTerms) {
    _showErrorSnackBar('Please agree to the terms and conditions');
    return;
  }

  if (completePhoneNumber.isEmpty) {
    _showErrorSnackBar('Please enter a valid phone number');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Show signup bonus notification sequence
    await NotificationService.showSignupBonusSequence(_nameController.text.trim());
    
    if (!mounted) return;

    // Navigate to Banking App
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BankingApp(),
      ),
    );
  } catch (e) {
    // Print the full error to see what's happening
    print('Full error details: $e');
    print('Error type: ${e.runtimeType}');
    
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      
      // Navigate anyway (comment this out if you want to stop on error)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BankingApp(username: _nameController.text.trim(), selectedCountry: _selectedCountryCode ,),
        ),
      );
      
      // Or show error and don't navigate (uncomment if needed)
      // _showErrorSnackBar('An error occurred: ${e.toString()}');
    }
  }
}

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3D72FC),
      body: Container(
        
      
          child:  FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header with gradient background
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF3D72FC),
                            Color(0xFF3D72FC),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 24.h),
                            // Image.asset(
                            //   'assets/logo.png',
                            //   height: 120.h,
                            //   width: 120.w,
                            // ),
                            SizedBox(height: 26.h),
                          ],
                        ),
                      ),
                    ),
                    
                    // Form Section with rounded top corners
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 24.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h),
                              
                              // Get Started title
                              Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              // Profile Picture Placeholder
                              Center(
                                child: Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFE0E0E0),
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.person_outline,
                                          size: 32.sp,
                                          color: lightGray,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 24.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            color: primaryBlue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.w,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            size: 12.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 32.h),
                              
                              // Name Field
                              _buildInputField(
                                controller: _nameController,
                                labelText: 'Name',
                                hintText: 'Enter your first name',
                                icon: Icons.person_outline,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // Email Field
                              _buildInputField(
                                controller: _emailController,
                                labelText: 'Email Address',
                                hintText: 'Enter your email address',
                                icon: Icons.email_outlined,
                                isRequired: true,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // Phone Number Field
                              PhoneNumberInputField(
                                labelText: 'Phone number',
                                hintText: 'Enter your phone number',
                                icon: Icons.phone_outlined,
                                isRequired: true,
                                initialCountryCode: 'NG',
                                validator: (value) {
                                  if (completePhoneNumber.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (completePhoneNumber.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                                onPhoneNumberChanged: (phoneNumber) {
                                  setState(() {
                                    completePhoneNumber = phoneNumber;
                                  });
                                  print('Complete phone number: $phoneNumber');
                                },
                                onCountryChanged: (countryCode) {
                                  setState(() {
                                    selectedCountryCode = countryCode;
                                  });
                                  print('Selected country: $countryCode');
                                },
                              ),

                              SizedBox(height: 20.h),
                              
                              // Password Field
                              _buildInputField(
                                controller: _passwordController,
                                labelText: 'Password',
                                hintText: 'Enter your Password',
                                icon: Icons.lock_outlined,
                                isRequired: true,
                                obscureText: !_isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: lightGray,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              SizedBox(height: 20.h),

                              // Continue Button
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleSignUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3D72FC),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    disabledBackgroundColor: lightGray,
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.w,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Continue',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: 20.h),
                              
                              // Terms and Conditions Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: 0.9.sp,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreeToTerms = value ?? false;
                                        });
                                      },
                                      activeColor: primaryBlue,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: lightGray,
                                            height: 1.4,
                                          ),
                                          children: [
                                            TextSpan(text: 'By creating an account, I agree to Umoja\'s '),
                                            TextSpan(
                                              text: 'Terms of service',
                                              style: TextStyle(
                                                color: primaryBlue,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                            TextSpan(text: ' and '),
                                            TextSpan(
                                              text: 'Privacy Notice',
                                              style: TextStyle(
                                                color: primaryBlue,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 20.h),
                             
                             // Login Link
                             Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: lightGray,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _navigateToLogin,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Additional padding at bottom for better scrolling experience
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      )
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: labelText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: darkText,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: inputBorder),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: 16.sp,
              color: darkText,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: lightGray,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: lightGray,
                size: 20.sp,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Country',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: darkText,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: inputBorder),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCountryCode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your country';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Select your country',
              hintStyle: TextStyle(
                color: lightGray,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.public_outlined,
                color: lightGray,
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16.w,
              ),
            ),
            items: _countries.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.value,
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: darkText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountryCode = newValue;
              });
            },
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: lightGray,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}