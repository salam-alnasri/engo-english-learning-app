import 'package:engo/data/privacy_policy_data.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define known headings for easy future editing
    const headings = [
      'Privacy Policy for Engo',
      'Privacy Policy',
      'Effective Date: September 30, 2025',
      '1. Information We Do Not Collect',
      '2. Data Storage and Security',
      '3. Children’s Privacy',
      '4. Third-Party Services',
      '5. Changes to This Privacy Policy',
      '6. Contact Us',
      'Consent',
    ];

    final headingStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF222B45), // dark blue/black
    );
    final bodyStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.6,
    );

    final lines = privacyPolicyText.split('\n');
    final children = <Widget>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 14));
        continue;
      }
      final isHeading = headings.contains(trimmed);
      children.add(Text(trimmed, style: isHeading ? headingStyle : bodyStyle));
      if (isHeading) children.add(const SizedBox(height: 6));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.teal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
