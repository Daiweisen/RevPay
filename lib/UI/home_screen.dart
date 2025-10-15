import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:revbank/UI/transaction_history.dart';

class BankingApp extends StatefulWidget {
  final String? username;
  final String? selectedCountry; 

  const BankingApp({
    Key? key,
    this.username,
    this.selectedCountry,
  }) : super(key: key);
  
  @override
  _BankingAppState createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> with SingleTickerProviderStateMixin {
  String walletAddress = '34528391...65769';
  double usdBalance = 0.0;
  double UMCBalance = 0.0;
  String? _currentUserId;
  bool _isLoadingBonus = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, double> exchangeRates = {
    'US': 1.0, 'UK': 0.79, 'NG': 1550.0, 'CA': 1.35, 'GH': 15.47,
    'UG': 3661.0, 'TZ': 2710.0, 'CM': 558.6, 'SN': 558.0, 'KE': 150.0,
    'SA': 18.5, 'ET': 55.0, 'MA': 10.2, 'EG': 31.0, 'DZ': 135.0,
    'RW': 1300.0, 'BW': 13.5, 'ZM': 27.0, 'ZW': 322.0, 'NA': 18.5,
    'ML': 558.0, 'BF': 558.0, 'CI': 558.0, 'AU': 1.52, 'DE': 0.92,
    'FR': 0.92, 'NL': 0.92, 'SE': 10.8, 'NO': 10.9, 'DK': 6.9,
  };

  final Map<String, Map<String, dynamic>> countryConfig = {
    'US': {'currency': 'USD', 'currencySymbol': '\$', 'accountType': 'Checking Account',
      'accountNumber': '****1234', 'bankName': 'FirstBank', 'routingNumber': '021000021', 'flagEmoji': '🇺🇸'},
    'UK': {'currency': 'GBP', 'currencySymbol': '£', 'accountType': 'Current Account',
      'accountNumber': '****5678', 'bankName': 'Royal Bank', 'routingNumber': 'SORT: 12-34-56', 'flagEmoji': '🇬🇧'},
    'NG': {'currency': 'NGN', 'currencySymbol': '₦', 'accountType': 'Savings Account',
      'accountNumber': '****9012', 'bankName': 'Access Bank', 'routingNumber': '044150149', 'flagEmoji': '🇳🇬'},
    'CA': {'currency': 'CAD', 'currencySymbol': 'C\$', 'accountType': 'Chequing Account',
      'accountNumber': '****3456', 'bankName': 'TD Bank', 'routingNumber': '004', 'flagEmoji': '🇨🇦'},
    'GH': {'currency': 'GHS', 'currencySymbol': '₵', 'accountType': 'Savings Account',
      'accountNumber': '****7890', 'bankName': 'Ghana Commercial Bank', 'routingNumber': 'GHBANK', 'flagEmoji': '🇬🇭'},
    'UG': {'currency': 'UGX', 'currencySymbol': 'USh', 'accountType': 'Current Account',
      'accountNumber': '****1357', 'bankName': 'Stanbic Bank', 'routingNumber': 'UB123', 'flagEmoji': '🇺🇬'},
    'TZ': {'currency': 'TZS', 'currencySymbol': 'TSh', 'accountType': 'Savings Account',
      'accountNumber': '****2468', 'bankName': 'CRDB Bank', 'routingNumber': 'TZ456', 'flagEmoji': '🇹🇿'},
    'CM': {'currency': 'XAF', 'currencySymbol': 'FCFA', 'accountType': 'Savings Account',
      'accountNumber': '****8024', 'bankName': 'Afriland Bank', 'routingNumber': 'CM404', 'flagEmoji': '🇨🇲'},
    'SN': {'currency': 'XOF', 'currencySymbol': 'CFA', 'accountType': 'Current Account',
      'accountNumber': '****9135', 'bankName': 'BNP Paribas Senegal', 'routingNumber': 'SN505', 'flagEmoji': '🇸🇳'},
    'KE': {'currency': 'KES', 'currencySymbol': 'KSh', 'accountType': 'Savings Account',
      'accountNumber': '****4567', 'bankName': 'Equity Bank', 'routingNumber': 'KE001', 'flagEmoji': '🇰🇪'},
    'SA': {'currency': 'ZAR', 'currencySymbol': 'R', 'accountType': 'Savings Account',
      'accountNumber': '****8901', 'bankName': 'Standard Bank', 'routingNumber': 'SA051', 'flagEmoji': '🇿🇦'},
    'ET': {'currency': 'ETB', 'currencySymbol': 'Br', 'accountType': 'Savings Account',
      'accountNumber': '****2345', 'bankName': 'Commercial Bank of Ethiopia', 'routingNumber': 'ET080', 'flagEmoji': '🇪🇹'},
    'MA': {'currency': 'MAD', 'currencySymbol': 'DH', 'accountType': 'Current Account',
      'accountNumber': '****6789', 'bankName': 'Attijariwafa Bank', 'routingNumber': 'MA007', 'flagEmoji': '🇲🇦'},
    'EG': {'currency': 'EGP', 'currencySymbol': 'E£', 'accountType': 'Savings Account',
      'accountNumber': '****0123', 'bankName': 'National Bank of Egypt', 'routingNumber': 'EG003', 'flagEmoji': '🇪🇬'},
    'DZ': {'currency': 'DZD', 'currencySymbol': 'DA', 'accountType': 'Current Account',
      'accountNumber': '****4567', 'bankName': 'Bank of Algeria', 'routingNumber': 'DZ001', 'flagEmoji': '🇩🇿'},
    'RW': {'currency': 'RWF', 'currencySymbol': 'RF', 'accountType': 'Savings Account',
      'accountNumber': '****8901', 'bankName': 'Bank of Kigali', 'routingNumber': 'RW101', 'flagEmoji': '🇷🇼'},
    'BW': {'currency': 'BWP', 'currencySymbol': 'P', 'accountType': 'Savings Account',
      'accountNumber': '****2345', 'bankName': 'First National Bank', 'routingNumber': 'BW282', 'flagEmoji': '🇧🇼'},
    'ZM': {'currency': 'ZMW', 'currencySymbol': 'ZK', 'accountType': 'Current Account',
      'accountNumber': '****6789', 'bankName': 'Zanaco Bank', 'routingNumber': 'ZM020', 'flagEmoji': '🇿🇲'},
    'ZW': {'currency': 'USD', 'currencySymbol': '\$', 'accountType': 'Savings Account',
      'accountNumber': '****0123', 'bankName': 'CBZ Bank', 'routingNumber': 'ZW999', 'flagEmoji': '🇿🇼'},
    'NA': {'currency': 'NAD', 'currencySymbol': 'N\$', 'accountType': 'Savings Account',
      'accountNumber': '****4567', 'bankName': 'Bank Windhoek', 'routingNumber': 'NA083', 'flagEmoji': '🇳🇦'},
    'ML': {'currency': 'XOF', 'currencySymbol': 'CFA', 'accountType': 'Savings Account',
      'accountNumber': '****8901', 'bankName': 'Bank of Africa Mali', 'routingNumber': 'ML001', 'flagEmoji': '🇲🇱'},
    'BF': {'currency': 'XOF', 'currencySymbol': 'CFA', 'accountType': 'Current Account',
      'accountNumber': '****2345', 'bankName': 'Ecobank Burkina', 'routingNumber': 'BF001', 'flagEmoji': '🇧🇫'},
    'CI': {'currency': 'XOF', 'currencySymbol': 'CFA', 'accountType': 'Savings Account',
      'accountNumber': '****6789', 'bankName': 'Société Générale CI', 'routingNumber': 'CI001', 'flagEmoji': '🇨🇮'},
    'AU': {'currency': 'AUD', 'currencySymbol': 'A\$', 'accountType': 'Savings Account',
      'accountNumber': '****0123', 'bankName': 'Commonwealth Bank', 'routingNumber': '062000', 'flagEmoji': '🇦🇺'},
    'DE': {'currency': 'EUR', 'currencySymbol': '€', 'accountType': 'Girokonto',
      'accountNumber': '****4567', 'bankName': 'Deutsche Bank', 'routingNumber': 'DEUTDEFF', 'flagEmoji': '🇩🇪'},
    'FR': {'currency': 'EUR', 'currencySymbol': '€', 'accountType': 'Compte Courant',
      'accountNumber': '****8901', 'bankName': 'BNP Paribas', 'routingNumber': 'BNPAFRPP', 'flagEmoji': '🇫🇷'},
    'NL': {'currency': 'EUR', 'currencySymbol': '€', 'accountType': 'Betaalrekening',
      'accountNumber': '****2345', 'bankName': 'ING Bank', 'routingNumber': 'INGBNL2A', 'flagEmoji': '🇳🇱'},
    'SE': {'currency': 'SEK', 'currencySymbol': 'kr', 'accountType': 'Sparkonto',
      'accountNumber': '****6789', 'bankName': 'Swedbank', 'routingNumber': 'SWEDSESS', 'flagEmoji': '🇸🇪'},
    'NO': {'currency': 'NOK', 'currencySymbol': 'kr', 'accountType': 'Sparekonto',
      'accountNumber': '****0123', 'bankName': 'DNB', 'routingNumber': 'DNBANOKK', 'flagEmoji': '🇳🇴'},
    'DK': {'currency': 'DKK', 'currencySymbol': 'kr', 'accountType': 'Opsparingskonto',
      'accountNumber': '****4567', 'bankName': 'Danske Bank', 'routingNumber': 'DABADKKK', 'flagEmoji': '🇩🇰'},
  };

  double getLocalBalance(String selectedCountry) {
    return usdBalance * exchangeRates[selectedCountry]!;
  }

  String getFormattedBalance(String selectedCountry) {
    final config = countryConfig[selectedCountry]!;
    return '${config['currencySymbol']}${getLocalBalance(selectedCountry).toStringAsFixed(2)}';
  }

  String get usdEquivalent {
    return '= \$${usdBalance.toStringAsFixed(2)} USD';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadUserBonus() async {
    if (_currentUserId == null) return;
    
    try {
      setState(() {
        _isLoadingBonus = true;
      });
    } catch (e) {
      setState(() {
        _isLoadingBonus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String username = widget.username!;
    final selectedCountry = widget.selectedCountry;
    final config = countryConfig[selectedCountry]!;
    
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(username),
                      SizedBox(height: 28.h),
                      _buildBalanceCard(config, selectedCountry!),
                      SizedBox(height: 20.h),
                      _buildAccountInfo(),
                      SizedBox(height: 32.h),
                      _buildQuickActions(),
                      SizedBox(height: 36.h),
                      _buildTransactionSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(String username) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Icon(Icons.person, size: 24.sp, color: Colors.white),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                username,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF374151),
                  size: 24.sp,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard({
  required bool isPositive,
  required String type,
  required String fromTo,
  required String amount,
  required String time,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16.r,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPositive 
                ? [Color(0xFF10B981).withOpacity(0.15), Color(0xFF059669).withOpacity(0.15)]
                : [Color(0xFFEF4444).withOpacity(0.15), Color(0xFFDC2626).withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
            color: isPositive ? Color(0xFF10B981) : Color(0xFFEF4444),
            size: 24.sp,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                fromTo,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: isPositive ? Color(0xFF10B981) : Color(0xFFEF4444),
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildBottomNav() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28.r),
        topRight: Radius.circular(28.r),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24.r,
          offset: Offset(0, -4.h),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.account_balance_wallet_rounded, false),
        _buildNavItem(Icons.swap_horiz_rounded, false),
        _buildNavItem(Icons.home_rounded, true),
        _buildNavItem(Icons.pie_chart_rounded, false),
        _buildNavItem(Icons.person_rounded, false),
      ],
    ),
  );
}

  Widget _buildNavItem(IconData icon, bool isActive) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      width: 52.w,
      height: 52.h,
      decoration: BoxDecoration(
        gradient: isActive 
          ? LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
        color: isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isActive ? [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ] : null,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Color(0xFF9CA3AF),
        size: 26.sp,
      ),
    ),
  );
}

Widget _buildBalanceCard(Map<String, dynamic> config, String selectedCountry) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(28.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28.r),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF667EEA).withOpacity(0.4),
          blurRadius: 24.r,
          offset: Offset(0, 12.h),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          top: -40.h,
          right: -40.w,
          child: Container(
            width: 160.w,
            height: 160.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -20.h,
          left: -30.w,
          child: Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      UMCBalance.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    'RevBank',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            _isLoadingBonus 
              ? SizedBox.shrink() 
              : Text(
                  NumberFormat.currency(
                    symbol: '${config['currencySymbol']}',
                    decimalDigits: 0,
                  ).format(getLocalBalance(selectedCountry)),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildBadge('Custodial', Color(0xFFFBBF24)),
                    SizedBox(width: 10.w),
                    _buildBadge('Polygon', Colors.transparent),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Color(0xFF10B981).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Color(0xFF10B981), size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '+2.4%',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildBadge(String label, Color indicatorColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          if (indicatorColor != Colors.transparent) ...[
            Container(
              width: 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA).withOpacity(0.15), Color(0xFF764BA2).withOpacity(0.15)],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF667EEA), size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Number',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  walletAddress,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: walletAddress));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account number copied!'),
                  backgroundColor: Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.content_copy_rounded, color: Color(0xFF667EEA), size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          icon: Icons.arrow_upward_rounded,
          label: 'Send',
          gradient: [Colors.grey, Colors.grey],
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Scan',
          gradient: [Colors.grey, Colors.grey],
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.arrow_downward_rounded,
          label: 'Receive',
          gradient: [Colors.grey, Colors.grey],
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.more_horiz_rounded,
          label: 'More',
          gradient: [Colors.grey, Colors.grey],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68.w,
            height: 68.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.3),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF374151),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
                );
              },
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF667EEA), size: 14.sp),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildTransactionItem(
          type: 'Received',
          fromTo: 'From Sterling Bank',
          amount: '+25',
          time: 'Today, 2:30 PM',
          isPositive: true,
        ),
        _buildTransactionItem(
          type: 'Sent',
          fromTo: 'To John Doe',
          amount: '-150',
          time: 'Yesterday, 4:15 PM',
          isPositive: false,
        ),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String type,
    required String fromTo,
    required String amount,
    required String time,
    required bool isPositive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(0.04),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPositive 
                  ? [Color(0xFF10B981).withOpacity(0.15), Color(0xFF059669).withOpacity(0.15)]
                  : [Color(0xFFEF4444).withOpacity(0.15), Color(0xFFDC2626).withOpacity(0.15)],
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isPositive ? Color(0xFF10B981) : Color(0xFFEF4444),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  fromTo,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isPositive ? Color(0xFF10B981) : Color(0xFFEF4444),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//   Widget _buildBottomNav() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(28.r),
//           topRight: Radius.circular(28.r),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 24.r,
//             offset: Offset(0, -4.h),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.account_balance_wallet_rounded, false),
//           _buildNavItem(Icons.swap_horiz_rounded, false),
//           _buildNavItem(Icons.home_rounded, true),
//           _buildNavItem(Icons.pie_chart_rounded, false),
//           _buildNavItem(Icons.person_rounded, false),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, bool isActive) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 52.w,
//         height: 52.h,
//         decoration: BoxDecoration(
//           gradient: isActive 
//             ? LinearGradient(
//                 colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : null,
//           color: isActive ? null : Colors.transparent,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: isActive ? [
//             BoxShadow(
//               color: Color(0xFF667EEA).withOpacity(0.3),
//               blurRadius: 12.r,
//               offset: Offset(0, 4.h),
//             ),
//           ] : null,
//         ),
//         child: Icon(
//           icon,
//           color: isActive ? Colors.white : Color(0xFF9CA3AF),
//           size: 26.sp,
//         ),
//       ),
//     );
//   }
}