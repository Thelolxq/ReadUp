// lib/utils/paginator.dart

import 'package:flutter/material.dart';

// LA FUNCIÓN AHORA ES ASÍNCRONA Y DEVUELVE UN FUTURE
Future<List<String>> paginateText(String text, Size pageSize, TextStyle style) async {
  final List<String> pages = [];
  
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  int start = 0;
  int pageCount = 0; // Para controlar cuándo hacemos la pausa

  while (start < text.length) {
    final remainingTextSpan = TextSpan(text: text.substring(start), style: style);
    textPainter.text = remainingTextSpan;
    textPainter.layout(maxWidth: pageSize.width);

    int endOffset = textPainter.getPositionForOffset(Offset(pageSize.width, pageSize.height)).offset;
    
    if (endOffset == 0) {
      break; 
    }
    
    int end = start + endOffset;

    if (end > text.length) {
      end = text.length;
    } else {
      while (end > start && text[end - 1] != ' ' && text[end - 1] != '\n') {
        end--;
      }
    }

    if (end == start) {
      end = start + endOffset;
      if (end > text.length) {
        end = text.length;
      }
    }

    pages.add(text.substring(start, end));
    start = end;
    pageCount++;

    // ================ LA MAGIA ESTÁ AQUÍ ================
    // Cada 5 páginas calculadas, hacemos una pausa.
    // Esto permite que el hilo de la UI procese otros eventos (como la animación del spinner).
    if (pageCount % 5 == 0) {
      await Future.delayed(Duration.zero);
    }
    // ====================================================
  }

  return pages;
}