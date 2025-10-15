import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:revbank/UI/SignUpScreen.dart';
import 'package:revbank/UI/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  
  // Updated color palette to match the screenshot
  static const Color primaryBlue = Colors.deepPurple; // #3D72FC
  static const Color darkText = Color(0xFF2C2C2C);
  static const Color lightGray = Color(0xFF999999);
  static const Color inputGray = Color(0xFFF5F5F5);
  static const Color redRequired = Color(0xFFFF4444);
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

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
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _handleLogin() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  setState(() {
    isLoading = true;
  });
  
  // Simulate login delay
  await Future.delayed(const Duration(seconds: 1));
  
  if (mounted) {
    setState(() {
      isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Text('Welcome back! Login successful.'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BankingApp(),
      ),
    );
  }
}
  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegistrationScreen(),
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

  void _navigateToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegistrationScreen(),
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
      backgroundColor: const Color(0xFF3D72FC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Top Blue Section
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: primaryBlue,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      // Logo
                      // Center(
                      //   child: Image.asset(
                      //     'assets/logo.png',
                      //     height: 130.h,
                      //   ),
                      // ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              
              // Bottom White Section with Scrollable Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.75 - 60,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30.h),
                                
                                // Welcome back text
                                Center(
                                  child: Text(
                                    'Welcome back',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 40.h),
                                
                                // Email Address Label
                                Row(
                                  children: [
                                    Text(
                                      'Email Address',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: darkText,
                                      ),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: redRequired,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 8.h),
                                
                                // Email Input
                                Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: inputGray,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
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
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: darkText,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email address',
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: lightGray,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: lightGray,
                                        size: 20.w,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                        horizontal: 16.w,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 20.h),
                                
                                // Password Label
                                Row(
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: darkText,
                                      ),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: redRequired,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 8.h),
                                
                                // Password Input
                                Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: inputGray,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: darkText,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your Password',
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: lightGray,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: lightGray,
                                        size: 20.w,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          color: lightGray,
                                          size: 20.w,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                        horizontal: 16.w,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 16.h),
                                
                                // Remember Me & Forgot Password Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                            activeColor: primaryBlue,
                                            side: BorderSide(color: lightGray),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Remember me',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: lightGray,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: _navigateToForgotPassword,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlue,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 30.h),
                                
                                     SizedBox(
                                      width: double.infinity,
                                      height: 50.h,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryBlue,
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
                                                child: const CircularProgressIndicator(
                                                  strokeWidth: 2,
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
                                
                                // Social Login Icons (if needed in future)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [],
                                ),
                                
                                // Use Expanded to push the Sign Up text to bottom but keep it visible
                                Expanded(
                                  child: Container(),
                                ),
                                
                                // Sign Up Prompt - Always visible
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'New to Umoja Pay? ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: lightGray,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _navigateToRegister,
                                        child: Text(
                                          'Sign Up',
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
                                
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}