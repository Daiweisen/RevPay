import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BankingApp extends StatefulWidget {
  final String? username;
  final String ? selectedCountry; 

  
  const BankingApp({
    Key? key,
     this.username,
     this.selectedCountry,
  }) : super(key: key);
  @override
  _BankingAppState createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> {
  String walletAddress = '34528391...65769';
  double usdBalance = 0.0;
  double UMCBalance = 0.0;
  String? _currentUserId;
  bool _isLoadingBonus = true;

  final Map<String, double> exchangeRates = {
    // Existing countries
    'US': 1.0,
    'UK': 0.79,
    'NG': 1550.0,
    'CA': 1.35,
    'GH': 15.47,
    'UG': 3661.0,
    'TZ': 2710.0,
    'CM': 558.6,
    'SN': 558.0,
    
    // Added African countries
    'KE': 150.0,    // Kenya Shilling
    'SA': 18.5,     // South African Rand
    'ET': 55.0,     // Ethiopian Birr
    'MA': 10.2,     // Moroccan Dirham
    'EG': 31.0,     // Egyptian Pound
    'DZ': 135.0,    // Algerian Dinar
    'RW': 1300.0,   // Rwandan Franc
    'BW': 13.5,     // Botswana Pula
    'ZM': 27.0,     // Zambian Kwacha
    'ZW': 322.0,    // Zimbabwean Dollar
    'NA': 18.5,     // Namibian Dollar
    'ML': 558.0,    // West African CFA Franc
    'BF': 558.0,    // West African CFA Franc
    'CI': 558.0,    // West African CFA Franc
    
    // Added Western countries
    'AU': 1.52,     // Australian Dollar
    'DE': 0.92,     // Euro
    'FR': 0.92,     // Euro
    'NL': 0.92,     // Euro
    'SE': 10.8,     // Swedish Krona
    'NO': 10.9,     // Norwegian Krone
    'DK': 6.9,      // Danish Krone
  };

  final Map<String, Map<String, dynamic>> countryConfig = {
    // Existing countries
    'US': {
      'currency': 'USD',
      'currencySymbol': '\$',
      'accountType': 'Checking Account',
      'accountNumber': '****1234',
      'bankName': 'FirstBank',
      'routingNumber': '021000021',
      'flagEmoji': '🇺🇸',
    },
    'UK': {
      'currency': 'GBP',
      'currencySymbol': '£',
      'accountType': 'Current Account',
      'accountNumber': '****5678',
      'bankName': 'Royal Bank',
      'routingNumber': 'SORT: 12-34-56',
      'flagEmoji': '🇬🇧',
    },
    'NG': {
      'currency': 'NGN',
      'currencySymbol': '₦',
      'accountType': 'Savings Account',
      'accountNumber': '****9012',
      'bankName': 'Access Bank',
      'routingNumber': '044150149',
      'flagEmoji': '🇳🇬',
    },
    'CA': {
      'currency': 'CAD',
      'currencySymbol': 'C\$',
      'accountType': 'Chequing Account',
      'accountNumber': '****3456',
      'bankName': 'TD Bank',
      'routingNumber': '004',
      'flagEmoji': '🇨🇦',
    },
    'GH': {
      'currency': 'GHS',
      'currencySymbol': '₵',
      'accountType': 'Savings Account',
      'accountNumber': '****7890',
      'bankName': 'Ghana Commercial Bank',
      'routingNumber': 'GHBANK',
      'flagEmoji': '🇬🇭',
    },
    'UG': {
      'currency': 'UGX',
      'currencySymbol': 'USh',
      'accountType': 'Current Account',
      'accountNumber': '****1357',
      'bankName': 'Stanbic Bank',
      'routingNumber': 'UB123',
      'flagEmoji': '🇺🇬',
    },
    'TZ': {
      'currency': 'TZS',
      'currencySymbol': 'TSh',
      'accountType': 'Savings Account',
      'accountNumber': '****2468',
      'bankName': 'CRDB Bank',
      'routingNumber': 'TZ456',
      'flagEmoji': '🇹🇿',
    },
    'CM': {
      'currency': 'XAF',
      'currencySymbol': 'FCFA',
      'accountType': 'Savings Account',
      'accountNumber': '****8024',
      'bankName': 'Afriland Bank',
      'routingNumber': 'CM404',
      'flagEmoji': '🇨🇲',
    },
    'SN': {
      'currency': 'XOF',
      'currencySymbol': 'CFA',
      'accountType': 'Current Account',
      'accountNumber': '****9135',
      'bankName': 'BNP Paribas Senegal',
      'routingNumber': 'SN505',
      'flagEmoji': '🇸🇳',
    },
    
    // Added African countries
    'KE': {
      'currency': 'KES',
      'currencySymbol': 'KSh',
      'accountType': 'Savings Account',
      'accountNumber': '****4567',
      'bankName': 'Equity Bank',
      'routingNumber': 'KE001',
      'flagEmoji': '🇰🇪',
    },
    'SA': {
      'currency': 'ZAR',
      'currencySymbol': 'R',
      'accountType': 'Savings Account',
      'accountNumber': '****8901',
      'bankName': 'Standard Bank',
      'routingNumber': 'SA051',
      'flagEmoji': '🇿🇦',
    },
    'ET': {
      'currency': 'ETB',
      'currencySymbol': 'Br',
      'accountType': 'Savings Account',
      'accountNumber': '****2345',
      'bankName': 'Commercial Bank of Ethiopia',
      'routingNumber': 'ET080',
      'flagEmoji': '🇪🇹',
    },
    'MA': {
      'currency': 'MAD',
      'currencySymbol': 'DH',
      'accountType': 'Current Account',
      'accountNumber': '****6789',
      'bankName': 'Attijariwafa Bank',
      'routingNumber': 'MA007',
      'flagEmoji': '🇲🇦',
    },
    'EG': {
      'currency': 'EGP',
      'currencySymbol': 'E£',
      'accountType': 'Savings Account',
      'accountNumber': '****0123',
      'bankName': 'National Bank of Egypt',
      'routingNumber': 'EG003',
      'flagEmoji': '🇪🇬',
    },
    'DZ': {
      'currency': 'DZD',
      'currencySymbol': 'DA',
      'accountType': 'Current Account',
      'accountNumber': '****4567',
      'bankName': 'Bank of Algeria',
      'routingNumber': 'DZ001',
      'flagEmoji': '🇩🇿',
    },
    'RW': {
      'currency': 'RWF',
      'currencySymbol': 'RF',
      'accountType': 'Savings Account',
      'accountNumber': '****8901',
      'bankName': 'Bank of Kigali',
      'routingNumber': 'RW101',
      'flagEmoji': '🇷🇼',
    },
    'BW': {
      'currency': 'BWP',
      'currencySymbol': 'P',
      'accountType': 'Savings Account',
      'accountNumber': '****2345',
      'bankName': 'First National Bank',
      'routingNumber': 'BW282',
      'flagEmoji': '🇧🇼',
    },
    'ZM': {
      'currency': 'ZMW',
      'currencySymbol': 'ZK',
      'accountType': 'Current Account',
      'accountNumber': '****6789',
      'bankName': 'Zanaco Bank',
      'routingNumber': 'ZM020',
      'flagEmoji': '🇿🇲',
    },
    'ZW': {
      'currency': 'USD', // Zimbabwe uses USD
      'currencySymbol': '\$',
      'accountType': 'Savings Account',
      'accountNumber': '****0123',
      'bankName': 'CBZ Bank',
      'routingNumber': 'ZW999',
      'flagEmoji': '🇿🇼',
    },
    'NA': {
      'currency': 'NAD',
      'currencySymbol': 'N\$',
      'accountType': 'Savings Account',
      'accountNumber': '****4567',
      'bankName': 'Bank Windhoek',
      'routingNumber': 'NA083',
      'flagEmoji': '🇳🇦',
    },
    'ML': {
      'currency': 'XOF',
      'currencySymbol': 'CFA',
      'accountType': 'Savings Account',
      'accountNumber': '****8901',
      'bankName': 'Bank of Africa Mali',
      'routingNumber': 'ML001',
      'flagEmoji': '🇲🇱',
    },
    'BF': {
      'currency': 'XOF',
      'currencySymbol': 'CFA',
      'accountType': 'Current Account',
      'accountNumber': '****2345',
      'bankName': 'Ecobank Burkina',
      'routingNumber': 'BF001',
      'flagEmoji': '🇧🇫',
    },
    'CI': {
      'currency': 'XOF',
      'currencySymbol': 'CFA',
      'accountType': 'Savings Account',
      'accountNumber': '****6789',
      'bankName': 'Société Générale CI',
      'routingNumber': 'CI001',
      'flagEmoji': '🇨🇮',
    },
    
    // Added Western countries
    'AU': {
      'currency': 'AUD',
      'currencySymbol': 'A\$',
      'accountType': 'Savings Account',
      'accountNumber': '****0123',
      'bankName': 'Commonwealth Bank',
      'routingNumber': '062000',
      'flagEmoji': '🇦🇺',
    },
    'DE': {
      'currency': 'EUR',
      'currencySymbol': '€',
      'accountType': 'Girokonto',
      'accountNumber': '****4567',
      'bankName': 'Deutsche Bank',
      'routingNumber': 'DEUTDEFF',
      'flagEmoji': '🇩🇪',
    },
    'FR': {
      'currency': 'EUR',
      'currencySymbol': '€',
      'accountType': 'Compte Courant',
      'accountNumber': '****8901',
      'bankName': 'BNP Paribas',
      'routingNumber': 'BNPAFRPP',
      'flagEmoji': '🇫🇷',
    },
    'NL': {
      'currency': 'EUR',
      'currencySymbol': '€',
      'accountType': 'Betaalrekening',
      'accountNumber': '****2345',
      'bankName': 'ING Bank',
      'routingNumber': 'INGBNL2A',
      'flagEmoji': '🇳🇱',
    },
    'SE': {
      'currency': 'SEK',
      'currencySymbol': 'kr',
      'accountType': 'Sparkonto',
      'accountNumber': '****6789',
      'bankName': 'Swedbank',
      'routingNumber': 'SWEDSESS',
      'flagEmoji': '🇸🇪',
    },
    'NO': {
      'currency': 'NOK',
      'currencySymbol': 'kr',
      'accountType': 'Sparekonto',
      'accountNumber': '****0123',
      'bankName': 'DNB',
      'routingNumber': 'DNBANOKK',
      'flagEmoji': '🇳🇴',
    },
    'DK': {
      'currency': 'DKK',
      'currencySymbol': 'kr',
      'accountType': 'Opsparingskonto',
      'accountNumber': '****4567',
      'bankName': 'Danske Bank',
      'routingNumber': 'DABADKKK',
      'flagEmoji': '🇩🇰',
    },
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

    // Delay to ensure context is ready
   
  }

  // Add this new method
  void _loadUserBonus() async {
    if (_currentUserId == null) return;
    
    try {
      setState(() {
        _isLoadingBonus = true;
      });
      
      
      
    } catch (e) {
      print('Error loading user bonus: $e');
      setState(() {
        _isLoadingBonus = false;
        // Keep default values (0.0) if loading fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
         final String username = widget.username!;
        final selectedCountry = widget.selectedCountry;
        final config = countryConfig[selectedCountry]!;
        return Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    
                    // Header Section
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.person, size: 24.sp, color: Colors.white),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $username',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Welcome back!',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4.r,
                                spreadRadius: 1.r,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.black54,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // Balance Card
                    Container(
                      width: double.infinity,
                      height: 250.h,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                   color: Color(0xFF3B82F6)
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned(
                            top: -20.h,
                            right: -20.w,
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Balance',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'RevBank',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              
                              // Updated balance display with loading state
                              _isLoadingBonus 
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.w,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    UMCBalance.toStringAsFixed(2) + '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              
                              Row(
                                children: [
                                  Text(
                                    _isLoadingBonus ? 'Loading...' : usdEquivalent,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  _isLoadingBonus 
                                    ? Text('') 
                                    : Text(
                                        NumberFormat.currency(
                                          symbol: '${config['currencySymbol']}',
                                          decimalDigits: 0,
                                        ).format(getLocalBalance(selectedCountry!)),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      border: Border.all(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '● ',
                                          style: TextStyle(color: Colors.orange, fontSize: 12.sp),
                                        ),
                                        Text(
                                          'Custodial',
                                          style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white54),
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'Polygon',
                                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '24hr change',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Text(
                                        '+2.4%',
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Wallet Address Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Account Number',
                                  style: TextStyle(
                                    color: Color(0xFF3B82F6),
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  walletAddress,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
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
                                  content: Text('Accoun Number copied!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(Icons.copy, color: Colors.grey[600], size: 20.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.send,
                          label: 'Send',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.qr_code_scanner,
                          label: 'Scan',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.open_in_full,
                          label: 'Receive',
                          onTap: () {},
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Recent Transactions Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transaction',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // Transaction Items
                    _buildTransactionItem(
                      type: 'Received',
                      fromTo: 'From Sterling bank',
                      amount: '+25',
                      time: '',
                      isPositive: true,
                    ),
                    
                    SizedBox(height: 100.h), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, -5.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.account_balance_wallet, false),
                _buildNavItem(Icons.swap_horiz, false),
                _buildNavItem(Icons.home, true), // Active item
                _buildNavItem(Icons.settings, false),
                _buildNavItem(Icons.person_outline, false),
              ],
            ),
          ),
        );
      
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF3B82F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey[400],
        size: 24.sp,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 95.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(icon, color: Color(0xFF3B82F6), size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: isPositive ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: isPositive ? Colors.green : Colors.red,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  fromTo,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
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
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}