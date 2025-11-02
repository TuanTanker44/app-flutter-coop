import 'package:flutter/material.dart';

class PremiumPlansPage extends StatelessWidget {
  const PremiumPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        "title": "Cá nhân",
        "desc": "1 tài khoản • Không quảng cáo • Nghe offline",
        "price": "59.000đ / tháng",
        "color": [Colors.deepPurple, Colors.purpleAccent],
        "icon": Icons.person,
      },
      {
        "title": "Dành cho 2 người",
        "desc": "2 tài khoản • Phát nhạc riêng biệt • Nghe offline",
        "price": "79.000đ / tháng",
        "color": [Colors.blue, Colors.cyanAccent],
        "icon": Icons.people,
      },
      {
        "title": "Gia đình",
        "desc": "Tối đa 6 tài khoản • Chế độ trẻ em • Nghe không quảng cáo",
        "price": "99.000đ / tháng",
        "color": [Colors.green, Colors.tealAccent],
        "icon": Icons.family_restroom,
      },
      {
        "title": "Sinh viên",
        "desc": "1 tài khoản • Ưu đãi đặc biệt cho sinh viên",
        "price": "29.000đ / tháng",
        "color": [Colors.orange, Colors.deepOrangeAccent],
        "icon": Icons.school,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Các gói Premium',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return _buildPlanCard(
            context,
            title: plan['title'] as String,
            desc: plan['desc'] as String,
            price: plan['price'] as String,
            gradientColors: plan['color'] as List<Color>,
            icon: plan['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String desc,
    required String price,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        // Hiệu ứng click
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã chọn gói $title'),
            backgroundColor: Colors.black.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bạn đã chọn gói $title!'),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Chọn gói này',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
