class MockAnalytics {
  static final List<Map<String, dynamic>> monthlyRevenue = [
    {'month': 'Jan', 'revenue': 187500000.0},
    {'month': 'Feb', 'revenue': 213000000.0},
    {'month': 'Mar', 'revenue': 207000000.0},
    {'month': 'Apr', 'revenue': 247500000.0},
    {'month': 'May', 'revenue': 273000000.0},
    {'month': 'Jun', 'revenue': 315000000.0},
    {'month': 'Jul', 'revenue': 297000000.0},
    {'month': 'Aug', 'revenue': 337500000.0},
    {'month': 'Sep', 'revenue': 361500000.0},
    {'month': 'Oct', 'revenue': 351000000.0},
    {'month': 'Nov', 'revenue': 402000000.0},
    {'month': 'Dec', 'revenue': 427500000.0},
  ];

  static final List<Map<String, dynamic>> weeklyBookings = [
    {'day': 'Mon', 'count': 15},
    {'day': 'Tue', 'count': 22},
    {'day': 'Wed', 'count': 18},
    {'day': 'Thu', 'count': 25},
    {'day': 'Fri', 'count': 30},
    {'day': 'Sat', 'count': 35},
    {'day': 'Sun', 'count': 28},
  ];

  static final List<Map<String, dynamic>> serviceBreakdown = [
    {'service': 'Quick Wash', 'percentage': 35.0, 'color': 0xFF0066FF},
    {'service': 'Standard Wash', 'percentage': 28.0, 'color': 0xFF10B981},
    {'service': 'Premium Detail', 'percentage': 20.0, 'color': 0xFFF59E0B},
    {'service': 'Express Interior', 'percentage': 12.0, 'color': 0xFFEF4444},
    {'service': 'Ceramic Coating', 'percentage': 5.0, 'color': 0xFF8B5CF6},
  ];

  static final List<Map<String, dynamic>> customerGrowth = [
    {'month': 'Jul', 'customers': 95},
    {'month': 'Aug', 'customers': 120},
    {'month': 'Sep', 'customers': 155},
    {'month': 'Oct', 'customers': 198},
    {'month': 'Nov', 'customers': 260},
    {'month': 'Dec', 'customers': 342},
  ];

  static const Map<String, dynamic> kpiData = {
    'totalRevenue': 785100000.0,
    'totalBookings': 1247,
    'activeCustomers': 342,
    'averageRating': 4.7,
    'monthlyGrowth': 12.5,
    'completionRate': 96.8,
  };

  static final List<Map<String, dynamic>> recentActivity = [
    {
      'type': 'booking',
      'message': 'New booking #1247 from Alex Johnson',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'type': 'payment',
      'message': 'Payment of Rp 500.000 received for #1246',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'type': 'review',
      'message': 'New 5-star review from Emily Davis',
      'time': DateTime.now().subtract(const Duration(minutes: 32)),
    },
    {
      'type': 'booking',
      'message': 'Booking #1245 completed by Marcus Rivera',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'type': 'washer',
      'message': 'James Wilson went online',
      'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
    },
    {
      'type': 'payment',
      'message': 'Refund of Rp 75.000 processed for #1240',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'type': 'booking',
      'message': 'New booking #1244 from Sarah Miller',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'type': 'inventory',
      'message': 'Low stock alert: Microfiber Towels',
      'time': DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      'type': 'washer',
      'message': 'New washer application from David Kim',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'type': 'promotion',
      'message': 'SUMMER20 promo used 15 times today',
      'time': DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];
}
