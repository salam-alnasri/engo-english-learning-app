import 'package:engo/screens/a5.dart';
import 'package:engo/screens/a1.dart';
import 'package:engo/screens/a2.dart';
import 'package:engo/screens/a3.dart';
import 'package:engo/screens/a4.dart';
import 'package:engo/screens/a6.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// نموذج بيانات المرحلة
class LevelData {
  final int id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double height;
  final Widget? screen;

  const LevelData({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.height,
    this.screen,
  });

  /// إنشاء نسخة معدلة من البيانات
  LevelData copyWith({
    int? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    double? height,
    Widget? screen,
  }) {
    return LevelData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      height: height ?? this.height,
      screen: screen ?? this.screen,
    );
  }
}

class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  // قائمة بيانات المراحل مع ربط الصفحات الموجودة
  static final List<LevelData> _levels = [
    LevelData(
      id: 1,
      name: 'المستوى الأول',
      description: 'كلمات انجليزية وخيارات عربية',
      color: const Color(0xFF2196F3),
      icon: Icons.star,
      height: 0,
      screen: A1(),
    ),
    LevelData(
      id: 2,
      name: 'المستوى الثاني',
      description: 'كلمات عربية وخيارات انجليزية',
      color: const Color(0xFF4CAF50),
      icon: Icons.headphones,
      height: 80,
      screen: const A2(),
    ),
    LevelData(
      id: 3,
      name: 'المستوى الثالث',
      description: 'اختر الجملة الإنجليزية الصحيحة',
      color: const Color(0xFFFF9800),
      icon: Icons.video_camera_back,
      height: 160,
      screen: const A3(),
    ),
    LevelData(
      id: 4,
      name: 'المستوى الرابع',
      description: 'أدخل الكلمات التي سمعتها',
      color: const Color(0xFF9C27B0),
      icon: Icons.favorite,
      height: 240,
      screen: A4(),
    ),
    LevelData(
      id: 5,
      name: 'المستوى الخامس',
      description: 'ترجم الكلمات التي سمعتها',
      color: const Color(0xFFE91E63),
      icon: Icons.train,
      height: 350,
      screen: const A5(),
    ),
    LevelData(
      id: 6,
      name: 'المستوى السادس',
      description: 'مراحل التعلم الديناميكية',
      color: const Color(0xFF3F51B5),
      icon: Icons.flight,
      height: 400,
      screen: A6(),
    ),
  ];

  // ثوابت التصميم
  static const double _containerSize = 100.0;
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final itemsPerRow = isSmallScreen ? 3 : 4;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 10.0 : 24.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLevelsGrid(itemsPerRow),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء شبكة المراحل الديناميكية بشكل متعرج
  Widget _buildLevelsGrid(int itemsPerRow) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final spacing = 5.0;
        final itemWidth =
            (availableWidth - ((itemsPerRow - 1) * spacing)) / itemsPerRow;

        return Column(
          children: _buildZigZagRows(itemsPerRow, itemWidth, spacing),
        );
      },
    );
  }

  /// بناء صفوف متعرجة للمراحل
  List<Widget> _buildZigZagRows(
    int itemsPerRow,
    double itemWidth,
    double spacing,
  ) {
    List<Widget> rows = [];

    for (int i = 0; i < _levels.length; i += itemsPerRow) {
      final endIndex = (i + itemsPerRow > _levels.length)
          ? _levels.length
          : i + itemsPerRow;
      final rowItems = _levels.sublist(i, endIndex);
      final isEvenRow = (i ~/ itemsPerRow) % 2 == 0;

      rows.add(
        _buildZigZagRow(
          rowItems,
          i,
          itemWidth,
          spacing,
          isEvenRow,
          itemsPerRow,
        ),
      );

      if (i + itemsPerRow < _levels.length) {
        rows.add(const SizedBox(height: 0));
      }
    }

    return rows;
  }

  /// بناء صف واحد بشكل متعرج
  Widget _buildZigZagRow(
    List<LevelData> rowItems,
    int startIndex,
    double itemWidth,
    double spacing,
    bool isEvenRow,
    int itemsPerRow,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,

      // إزالة هذا السطر أو تثبيته على LTR
      // textDirection: isEvenRow ? TextDirection.ltr : TextDirection.rtl,
      children: rowItems.asMap().entries.map((entry) {
        final localIndex = entry.key;
        final globalIndex = startIndex + localIndex;
        final level = entry.value;
        final delay = globalIndex * 150;

        // حساب الارتفاع المتعرج
        double zigzagHeight = 0;
        if (isEvenRow) {
          // الصفوف الزوجية: تدرج من اليسار لليمين
          zigzagHeight = localIndex * 90.0;
        } else {
          // الصفوف الفردية: نفس الاتجاه لكن بارتفاعات مختلفة للحصول على التعرج
          zigzagHeight = localIndex * 90.0;
        }

        return Flexible(
          child: Container(
            width: itemWidth.clamp(80.0, _containerSize * 1.2),
            margin: EdgeInsets.symmetric(horizontal: spacing / 1),
            child: _buildLevelContainer(
              level: level.copyWith(height: zigzagHeight),
              index: globalIndex,
              animationDelay: delay,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// بناء حاوية المرحلة الواحدة
  Widget _buildLevelContainer({
    required LevelData level,
    required int index,
    required int animationDelay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + animationDelay),
      tween: Tween(begin: 0.0, end: 0.9),
      curve: Curves.elasticOut,
      builder: (context, animation, child) {
        return Transform.scale(
          scale: animation,
          child: Column(
            children: [
              // مساحة علوية متغيرة حسب بيانات المرحلة
              SizedBox(height: level.height * animation),

              // الحاوية الرئيسية
              Hero(
                tag: 'level_${level.id}',
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  shadowColor: level.color,
                  child: InkWell(
                    onTap: () => _showLevelDetails(level),
                    borderRadius: BorderRadius.circular(_borderRadius),
                    child: Container(
                      height: _containerSize,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [level.color, level.color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(_borderRadius),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: const Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // تأثير لمعان
                          Positioned(
                            top: 1,
                            left: 8,
                            child: Text(
                              '${level.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // محتوى المرحلة
                          Center(
                            child: Icon(
                              level.icon,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // معلومات المرحلة أسفل الحاوية
              const SizedBox(height: 8),
              Text(
                level.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                level.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  /// عرض تفاصيل المرحلة عند النقر
  void _showLevelDetails(LevelData level) {
    Get.to(
      () =>
          level.screen ??
          Scaffold(
            appBar: AppBar(
              title: Text(level.name),
              backgroundColor: level.color,
            ),
            body: Center(
              child: Text(
                'تفاصيل ${level.name} ستظهر هنا.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
    );
  }
}
