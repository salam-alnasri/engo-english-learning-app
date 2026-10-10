// lib/data/privacy_repository.dart
//
// 🟢 نموذج بيانات سياسة الخصوصية + قارئ من ملف JSON.
// يدعم لغتين (عربي / إنجليزي) عبر بنية `LocalizedText`.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyRepository {
  // مسار الـ JSON — موضَع في assets/data و مُسجَّل في pubspec.yaml.
  static const String assetPath = 'assets/data/engo_privacy_policy.json';

  Future<PrivacyPolicyData> load() async {
    final String raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return PrivacyPolicyData.fromJson(json);
  }
}

class PrivacyPolicyData {
  final String app;
  final LocalizedText title;
  final LocalizedText effectiveDate;
  final LocalizedText lastUpdated;
  final List<PolicyBlock> intro;
  final List<PolicySection> sections;

  PrivacyPolicyData({
    required this.app,
    required this.title,
    required this.effectiveDate,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      app: (json['app'] as String?) ?? '',
      title: LocalizedText.fromJson(
        (json['title'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      effectiveDate: LocalizedText.fromJson(
        (json['effective_date'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      lastUpdated: LocalizedText.fromJson(
        (json['last_updated'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      intro: ((json['intro'] as List?) ?? const [])
          .map((e) => PolicyBlock.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      sections: ((json['sections'] as List?) ?? const [])
          .map(
            (e) => PolicySection.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList(),
    );
  }
}

/// نصّ ثنائي اللغة.
class LocalizedText {
  final String en;
  final String ar;

  const LocalizedText({required this.en, required this.ar});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      en: (json['en'] as String?) ?? '',
      ar: (json['ar'] as String?) ?? '',
    );
  }

  String get(String lang) => lang == 'ar' ? ar : en;
}

/// فقرة أو قائمة (تدعم كلا النوعين: paragraph / list).
class PolicyBlock {
  final String type; // "paragraph" أو "list"
  final Map<String, dynamic> _raw;

  PolicyBlock._(this.type, this._raw);

  factory PolicyBlock.fromJson(Map<String, dynamic> json) {
    final String type = (json['type'] as String?) ?? 'paragraph';
    return PolicyBlock._(type, json);
  }

  /// نصّ الفقرة للغة المعطاة.
  String text(String lang) => (_raw[lang] as String?) ?? '';

  /// قائمة بنود للغة المعطاة.
  List<String> list(String lang) {
    final dynamic v = _raw[lang];
    if (v is List) return v.cast<String>();
    return const <String>[];
  }
}

/// قسم في السياسة (رقم + عنوان + محتوى).
class PolicySection {
  final int id;
  final LocalizedText title;
  final List<PolicyBlock> content;

  PolicySection({
    required this.id,
    required this.title,
    required this.content,
  });

  factory PolicySection.fromJson(Map<String, dynamic> json) {
    return PolicySection(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: LocalizedText.fromJson(
        (json['title'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      content: ((json['content'] as List?) ?? const [])
          .map((e) => PolicyBlock.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }
}
