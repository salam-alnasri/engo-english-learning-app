import 'package:engo/pages/page3/months_data.dart';
import 'package:engo/pages/page3/month_section.dart';

import 'package:flutter/material.dart';

/// "رحلتك التعليمية" — vertical scrollable list of monthly learning
/// blocks. Each block is a [MonthSection] built from the data in
/// `lib/data/months_data.dart`.
///
/// To add a new month, append a new [MonthData] entry to the `months`
/// list inside `months_data.dart`.
class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 70,
          bottom: 30,
          right: 10,
          left: 10,
        ),
        itemCount: months.length,
        itemBuilder: (context, i) => Padding(
          padding: EdgeInsets.only(bottom: i == months.length - 1 ? 0 : 24),
          child: MonthSection(month: months[i]),
        ),
      ),
    );
  }
}
