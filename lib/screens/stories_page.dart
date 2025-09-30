import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/stories.dart';

class StoriesController extends GetxController {
  RxnInt expandedIndex = RxnInt();
  RxBool showSearch = false.obs;
  RxString searchText = ''.obs;

  void toggleSearch() {
    showSearch.value = !showSearch.value;
    if (!showSearch.value) searchText.value = '';
  }
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  InlineSpan highlightText(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black),
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int index;
    while ((index = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
          ),
        ),
      );
      start = index + query.length;
    }
    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }
    return TextSpan(children: spans);
  }

  // إضافة دالتين مساعدة لبناء الصورة المصغرة والصورة الكبيرة
  Widget _buildThumbnail(Map<String, dynamic> story, double size) {
    final img = (story['thumb'] ?? story['image']) as String?;
    if (img == null || img.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, color: Colors.white70),
      );
    }

    Widget imageWidget;
    if (img.startsWith('http')) {
      imageWidget = Image.network(
        img,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade300,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.white70),
        ),
      );
    } else {
      // treat as asset path
      imageWidget = Image.asset(
        img,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.white70),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }

  Widget _buildLargeImage(Map<String, dynamic> story) {
    final img = (story['image'] ?? story['thumb']) as String?;
    if (img == null || img.isEmpty) return const SizedBox.shrink();

    Widget imageWidget;
    if (img.startsWith('http')) {
      imageWidget = Image.network(
        img,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey.shade300,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey.shade300,
          child: const Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.white70,
          ),
        ),
      );
    } else {
      imageWidget = Image.asset(
        img,
        height: 350,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey.shade300,
          child: const Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.white70,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StoriesController c = Get.put(StoriesController(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(
          () => c.showSearch.value
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'بحث في القصص...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.white,
                  onChanged: (val) => c.searchText.value = val,
                )
              : const Text(' قصص قصيرة '),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                c.showSearch.value ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: c.toggleSearch,
            ),
          ),
        ],
      ),
      body: Obx(() {
        final query = c.searchText.value.trim();
        final filteredStories = query.isEmpty
            ? stories
            : stories.where((story) {
                final title = (story["title"] ?? '').toString().toLowerCase();
                final paragraphs = (story["paragraphs"] as List)
                    .join(' ')
                    .toLowerCase();
                final vocab = (story["vocab"] as List)
                    .expand((v) => v)
                    .join(' ')
                    .toLowerCase();
                return title.contains(query.toLowerCase()) ||
                    paragraphs.contains(query.toLowerCase()) ||
                    vocab.contains(query.toLowerCase());
              }).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          itemCount: filteredStories.length,
          itemBuilder: (context, index) {
            final story = filteredStories[index];
            final originalIndex = stories.indexOf(story);
            return GetBuilder<StoriesController>(
              id: 'story_$originalIndex',
              builder: (_) {
                final isExpanded = c.expandedIndex.value == originalIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isExpanded ? Colors.teal.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isExpanded ? Colors.teal : Colors.grey.shade300,
                      width: isExpanded ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 18,
                          ),
                          leading: Column(
                            children: [
                              Text(
                                // رقم القصة بجانب العنوان
                                story["number"] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isExpanded ? Colors.red : Colors.grey,
                                  letterSpacing: 1,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.teal,
                              ),
                            ],
                          ),

                          // صورة مصغرة على يسار العنوان
                          trailing: _buildThumbnail(story, 55),

                          // عنوان يحتوي رقم القصة والعنوان والنص العربي
                          title: query.isEmpty
                              ? Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            story["title"] ?? '',
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: isExpanded
                                                  ? Colors.teal
                                                  : Colors.black87,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            story["title_ar"] ??
                                                "ترجمة العنوان",
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: isExpanded
                                                  ? Colors.teal
                                                  : Colors.black54,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      story["number"] ?? '',
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: isExpanded
                                            ? Colors.red
                                            : Colors.black54,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: highlightText(
                                              story["title"] ?? '',
                                              query,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.teal,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            story["title_ar"] ??
                                                "ترجمة العنوان",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                          onTap: () {
                            if (c.expandedIndex.value == originalIndex) {
                              c.expandedIndex.value = null;
                            } else {
                              c.expandedIndex.value = originalIndex;
                            }
                            c.update(['story_$originalIndex']);
                            if (c.expandedIndex.value != null) {
                              c.update(['story_${c.expandedIndex.value}']);
                            }
                          },
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          clipBehavior: Clip.antiAlias,
                          child: isExpanded
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // عرض الصورة الكبيرة أولًا عند فتح القصة (إن وُجدت)
                                      _buildLargeImage(story),

                                      // فقرات القصة
                                      ...List.generate(
                                        (story["paragraphs"] as List).length,
                                        (i) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: query.isEmpty
                                              ? Text(
                                                  (story["paragraphs"]
                                                          as List)[i]
                                                      as String,
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 15,
                                                    color: Colors.teal[700],
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                )
                                              : RichText(
                                                  text: highlightText(
                                                    (story["paragraphs"]
                                                        as List)[i],
                                                    query,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                        ),
                                      ),
                                      const Divider(height: 30, thickness: 1.2),
                                      Text(
                                        "Vocab / Phrases",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      ...(story["vocab"] as List).map<Widget>(
                                        (item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),

                                          child: query.isEmpty
                                              ? Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  color: Colors.white70,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "• ${(item as List)[0]}: ",
                                                        style:
                                                            GoogleFonts.cairo(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal[700],
                                                            ),
                                                      ),

                                                      Expanded(
                                                        child: Text(
                                                          (item)[1],
                                                          style:
                                                              GoogleFonts.cairo(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: highlightText(
                                                        "• ${(item as List)[0]}: ",
                                                        query,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                        text: highlightText(
                                                          (item)[1],
                                                          query,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
