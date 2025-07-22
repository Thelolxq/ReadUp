import 'dart:ui';

import 'package:flutter/material.dart';

Future<List<String>> paginateTextByWordCount(String text, int wordsPerPage) async {
  final words = text.split(RegExp(r'\s+'));
  List<String> pages = [];

  for (int i = 0; i < words.length; i += wordsPerPage) {
    final chunk = words.sublist(
      i,
      i + wordsPerPage > words.length ? words.length : i + wordsPerPage,
    );
    pages.add(chunk.join(' '));
  }

  return pages;
}