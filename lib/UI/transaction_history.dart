import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selectedFilter = 'All';
  
  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'Payment Received',
      'fromTo': 'From John Doe',
      'amount': '+\$1,250.00',
      'time': '10:30 AM',
      'date': 'Today',
      'isPositive': true,
      'category': 'income',
    },
    {
      'type': 'Restaurant',
      'fromTo': 'Sunset Diner',
      'amount': '-\$45.20',
      'time': '08:15 AM',
      'date': 'Today',
      'isPositive': false,
      'category': 'food',
    },
    {
      'type': 'Transfer',
      'fromTo': 'To Savings Account',
      'amount': '-\$500.00',
      'time': '09:45 PM',
      'date': 'Yesterday',
      'isPositive': false,
      'category': 'transfer',
    },
    {
      'type': 'Salary',
      'fromTo': 'Tech Corp Inc.',
      'amount': '+\$3,500.00',
      'time': '12:00 PM',
      'date': 'Yesterday',
      'isPositive': true,
      'category': 'income',
    },
    {
      'type': 'Shopping',
      'fromTo': 'Amazon Purchase',
      'amount': '-\$89.99',
      'time': '03:20 PM',
      'date': 'Oct 13',
      'isPositive': false,
      'category': 'shopping',
    },
    {
      'type': 'Refund',
      'fromTo': 'Nike Store',
      'amount': '+\$120.00',
      'time': '11:30 AM',
      'date': 'Oct 13',
      'isPositive': true,
      'category': 'income',
    },
    {
      'type': 'Utilities',
      'fromTo': 'Electric Company',
      'amount': '-\$150.50',
      'time': '07:00 AM',
      'date': 'Oct 12',
      'isPositive': false,
      'category': 'bills',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF374151),
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${transactions.length} transactions',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Color(0xFF7C3AED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF7C3AED),
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Income', 'Expenses', 'Transfer'];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF7C3AED) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? Color(0xFF7C3AED) : Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF6B7280),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    
    for (var transaction in transactions) {
      final date = transaction['date'];
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
              child: Text(
                date,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...dayTransactions.map((transaction) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildTransactionCard(
                isPositive: transaction['isPositive'],
                type: transaction['type'],
                fromTo: transaction['fromTo'],
                amount: transaction['amount'],
                time: transaction['time'],
              ),
            )),
          ],
        );
      },
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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isPositive 
                ? Color(0xFF7C3AED).withOpacity(0.1)
                : Color(0xFF6B7280).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isPositive ? Color(0xFF7C3AED) : Color(0xFF6B7280),
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
                  color: isPositive ? Color(0xFF7C3AED) : Color(0xFF374151),
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
}