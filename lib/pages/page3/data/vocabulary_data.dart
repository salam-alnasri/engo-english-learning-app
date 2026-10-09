/// نموذج بيانات المفردات — مرتبط بمهمة "تعلّم 500 كلمة شائعة".
///
/// يحتوي هذا الملف على 10 كلمات افتتاحية فقط كبداية. يمكنك إضافة
/// الكلمات المتبقية يدوياً عبر توسيع القائمة [vocabularyWords] بنفس
/// البنية — لا حاجة لتعديل أي ملف آخر.
library;

import 'package:flutter/material.dart';

/// فئة الكلمة المفردة في قائمة المفردات.
class VocabularyWord {
  /// معرّف تسلسلي ثابت (يستخدم للترتيب وكمفتاح React-style).
  final int id;

  /// الكلمة بالإنجليزية.
  final String english;

  /// الترجمة العربية.
  final String arabic;

  /// النطق التقريبي بصيغة مبسّطة (اختياري).
  final String? pronunciation;

  /// مثال قصير يوضّح استخدام الكلمة في جملة (اختياري).
  final String? example;

  const VocabularyWord({
    required this.id,
    required this.english,
    required this.arabic,
    this.pronunciation,
    this.example,
  });
}

const Color vocabularyAccent = Color(0xFFD6EBFB);

// ============================================================
//  🟢 EDIT HERE — أضف بقية الكلمات هنا.
//
//  • أبقِ الـ id تسلسلياً (11, 12, 13, ...).
//  • اترك [pronunciation] أو [example] فارغين إن لم يتوفرا.
//  • لا تحذف الكلمات الموجودة إلا إذا أردت استبدالها.
// ============================================================

const List<VocabularyWord> vocabularyWords = [
  VocabularyWord(
    id: 1,
    english: 'Hello',
    arabic: 'مرحباً',
    pronunciation: 'هيلو',
    example: 'Hello, how are you?',
  ),
  VocabularyWord(
    id: 2,
    english: 'Goodbye',
    arabic: 'مع السلامة',
    pronunciation: 'غود باي',
    example: 'Goodbye, see you tomorrow.',
  ),
  VocabularyWord(
    id: 3,
    english: 'Yes',
    arabic: 'نعم',
    pronunciation: 'يس',
    example: 'Yes, I understand.',
  ),
  VocabularyWord(
    id: 4,
    english: 'No',
    arabic: 'لا',
    pronunciation: 'نو',
    example: 'No, thank you.',
  ),
  VocabularyWord(
    id: 5,
    english: 'Please',
    arabic: 'من فضلك',
    pronunciation: 'بليز',
    example: 'Please help me.',
  ),
  VocabularyWord(
    id: 6,
    english: 'Thanks',
    arabic: 'شكراً',
    pronunciation: 'ثانكس',
    example: 'Thanks for your help.',
  ),
  VocabularyWord(
    id: 7,
    english: 'Sorry',
    arabic: 'آسف',
    pronunciation: 'سوري',
    example: 'Sorry, I am late.',
  ),
  VocabularyWord(
    id: 8,
    english: 'Name',
    arabic: 'اسم',
    pronunciation: 'نيم',
    example: 'What is your name?',
  ),
  VocabularyWord(
    id: 9,
    english: 'Friend',
    arabic: 'صديق',
    pronunciation: 'فريند',
    example: 'He is my friend.',
  ),
  VocabularyWord(
    id: 10,
    english: 'Family',
    arabic: 'عائلة',
    pronunciation: 'فاميلي',
    example: 'I love my family.',
  ),
  VocabularyWord(
    id: 11,
    english: 'House',
    arabic: 'منزل',
    pronunciation: 'هاوس',
    example: 'This is my house.',
  ),
  VocabularyWord(
    id: 12,
    english: 'Car',
    arabic: 'سيارة',
    pronunciation: 'كار',
    example: 'My car is new.',
  ),
  VocabularyWord(
    id: 13,
    english: 'School',
    arabic: 'مدرسة',
    pronunciation: 'سكول',
    example: 'I go to school every day.',
  ),
  VocabularyWord(
    id: 14,
    english: 'Teacher',
    arabic: 'معلم',
    pronunciation: 'تيتشر',
    example: 'The teacher is kind.',
  ),
  VocabularyWord(
    id: 15,
    english: 'Student',
    arabic: 'طالب',
    pronunciation: 'ستيودنت',
    example: 'She is a good student.',
  ),
  VocabularyWord(
    id: 16,
    english: 'Book',
    arabic: 'كتاب',
    pronunciation: 'بوك',
    example: 'I read a book.',
  ),
  VocabularyWord(
    id: 17,
    english: 'Pen',
    arabic: 'قلم',
    pronunciation: 'بن',
    example: 'This pen is blue.',
  ),
  VocabularyWord(
    id: 18,
    english: 'Table',
    arabic: 'طاولة',
    pronunciation: 'تيبل',
    example: 'The book is on the table.',
  ),
  VocabularyWord(
    id: 19,
    english: 'Chair',
    arabic: 'كرسي',
    pronunciation: 'تشير',
    example: 'Sit on the chair.',
  ),
  VocabularyWord(
    id: 20,
    english: 'Water',
    arabic: 'ماء',
    pronunciation: 'ووتر',
    example: 'I drink water.',
  ),
  VocabularyWord(
    id: 21,
    english: 'Food',
    arabic: 'طعام',
    pronunciation: 'فود',
    example: 'The food is delicious.',
  ),
  VocabularyWord(
    id: 22,
    english: 'Apple',
    arabic: 'تفاحة',
    pronunciation: 'آبل',
    example: 'I eat an apple.',
  ),
  VocabularyWord(
    id: 23,
    english: 'Bread',
    arabic: 'خبز',
    pronunciation: 'بريد',
    example: 'We need some bread.',
  ),
  VocabularyWord(
    id: 24,
    english: 'Milk',
    arabic: 'حليب',
    pronunciation: 'ميلك',
    example: 'The child drinks milk.',
  ),
  VocabularyWord(
    id: 25,
    english: 'Coffee',
    arabic: 'قهوة',
    pronunciation: 'كوفي',
    example: 'I like coffee.',
  ),
  VocabularyWord(
    id: 26,
    english: 'Day',
    arabic: 'يوم',
    pronunciation: 'داي',
    example: 'Today is a good day.',
  ),
  VocabularyWord(
    id: 27,
    english: 'Night',
    arabic: 'ليل',
    pronunciation: 'نايت',
    example: 'Good night.',
  ),
  VocabularyWord(
    id: 28,
    english: 'Morning',
    arabic: 'صباح',
    pronunciation: 'مورنينغ',
    example: 'Good morning everyone.',
  ),
  VocabularyWord(
    id: 29,
    english: 'Time',
    arabic: 'وقت',
    pronunciation: 'تايم',
    example: 'What time is it?',
  ),
  VocabularyWord(
    id: 30,
    english: 'Work',
    arabic: 'عمل',
    pronunciation: 'وورك',
    example: 'I go to work at 8.',
  ),
  VocabularyWord(
    id: 31,
    english: 'Job',
    arabic: 'وظيفة',
    pronunciation: 'جوب',
    example: 'He has a good job.',
  ),
  VocabularyWord(
    id: 32,
    english: 'Money',
    arabic: 'مال',
    pronunciation: 'ماني',
    example: 'I need some money.',
  ),
  VocabularyWord(
    id: 33,
    english: 'Market',
    arabic: 'سوق',
    pronunciation: 'ماركت',
    example: 'She is at the market.',
  ),
  VocabularyWord(
    id: 34,
    english: 'Shop',
    arabic: 'متجر',
    pronunciation: 'شوب',
    example: 'The shop is open.',
  ),
  VocabularyWord(
    id: 35,
    english: 'City',
    arabic: 'مدينة',
    pronunciation: 'سيتي',
    example: 'Baghdad is a large city.',
  ),
  VocabularyWord(
    id: 36,
    english: 'Country',
    arabic: 'دولة',
    pronunciation: 'كانتري',
    example: 'I love my country.',
  ),
  VocabularyWord(
    id: 37,
    english: 'Road',
    arabic: 'طريق',
    pronunciation: 'رود',
    example: 'The road is busy.',
  ),
  VocabularyWord(
    id: 38,
    english: 'Bus',
    arabic: 'حافلة',
    pronunciation: 'بس',
    example: 'The bus is coming.',
  ),
  VocabularyWord(
    id: 39,
    english: 'Train',
    arabic: 'قطار',
    pronunciation: 'ترين',
    example: 'The train arrived early.',
  ),
  VocabularyWord(
    id: 40,
    english: 'Airplane',
    arabic: 'طائرة',
    pronunciation: 'إيربلين',
    example: 'The airplane is flying.',
  ),
  VocabularyWord(
    id: 41,
    english: 'Man',
    arabic: 'رجل',
    pronunciation: 'مان',
    example: 'The man is tall.',
  ),
  VocabularyWord(
    id: 42,
    english: 'Woman',
    arabic: 'امرأة',
    pronunciation: 'وومن',
    example: 'The woman is smiling.',
  ),
  VocabularyWord(
    id: 43,
    english: 'Child',
    arabic: 'طفل',
    pronunciation: 'تشايلد',
    example: 'The child is happy.',
  ),
  VocabularyWord(
    id: 44,
    english: 'Boy',
    arabic: 'ولد',
    pronunciation: 'بوي',
    example: 'The boy is playing.',
  ),
  VocabularyWord(
    id: 45,
    english: 'Girl',
    arabic: 'بنت',
    pronunciation: 'غيرل',
    example: 'The girl is reading.',
  ),
  VocabularyWord(
    id: 46,
    english: 'Dog',
    arabic: 'كلب',
    pronunciation: 'دوغ',
    example: 'The dog is friendly.',
  ),
  VocabularyWord(
    id: 47,
    english: 'Cat',
    arabic: 'قطة',
    pronunciation: 'كات',
    example: 'The cat is sleeping.',
  ),
  VocabularyWord(
    id: 48,
    english: 'Sun',
    arabic: 'شمس',
    pronunciation: 'سان',
    example: 'The sun is shining.',
  ),
  VocabularyWord(
    id: 49,
    english: 'Moon',
    arabic: 'قمر',
    pronunciation: 'مون',
    example: 'The moon is bright.',
  ),
  VocabularyWord(
    id: 50,
    english: 'Star',
    arabic: 'نجمة',
    pronunciation: 'ستار',
    example: 'The star is beautiful.',
  ),
];
