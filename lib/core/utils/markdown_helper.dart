class MarkdownHelper {
  /// Converts plain text to markdown format
  static String textToMarkdown(String text) {
    // Basic text to markdown conversion
    String markdown = text;
    
    // Convert line breaks to markdown line breaks
    markdown = markdown.replaceAll('\n', '\n\n');
    
    return markdown;
  }
  
  /// Converts markdown to plain text
  static String markdownToText(String markdown) {
    String text = markdown;
    
    // Remove markdown headers
    text = text.replaceAll(RegExp(r'^#{1,6}\s+'), '');
    
    // Remove markdown bold and italic
    text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    text = text.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
    text = text.replaceAll(RegExp(r'__(.*?)__'), r'$1');
    text = text.replaceAll(RegExp(r'_(.*?)_'), r'$1');
    
    // Remove markdown links
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1');
    
    // Remove markdown code blocks
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '');
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'$1');
    
    // Remove markdown lists
    text = text.replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '');
    
    // Clean up extra whitespace
    text = text.replaceAll(RegExp(r'\n\s*\n'), '\n');
    text = text.trim();
    
    return text;
  }
  
  /// Formats text with basic markdown styling
  static String formatHeading(String text, {int level = 1}) {
    final hashes = '#' * level;
    return '$hashes $text';
  }
  
  /// Formats text as bold
  static String formatBold(String text) {
    return '**$text**';
  }
  
  /// Formats text as italic
  static String formatItalic(String text) {
    return '*$text*';
  }
  
  /// Formats text as code
  static String formatCode(String text) {
    return '`$text`';
  }
  
  /// Formats text as a link
  static String formatLink(String text, String url) {
    return '[$text]($url)';
  }
  
  /// Formats text as a list item
  static String formatListItem(String text, {bool ordered = false, int? number}) {
    if (ordered) {
      final num = number ?? 1;
      return '$num. $text';
    } else {
      return '- $text';
    }
  }
  
  /// Formats text as a quote
  static String formatQuote(String text) {
    return '> $text';
  }
  
  /// Extracts the first few words as a preview
  static String getPreview(String markdown, {int wordLimit = 50}) {
    final plainText = markdownToText(markdown);
    final words = plainText.split(RegExp(r'\s+'));
    
    if (words.length <= wordLimit) {
      return plainText;
    }
    
    return '${words.take(wordLimit).join(' ')}...';
  }
  
  /// Counts words in markdown text
  static int countWords(String markdown) {
    final plainText = markdownToText(markdown);
    return plainText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
  
  /// Estimates reading time in minutes
  static int estimateReadingTime(String markdown, {int wordsPerMinute = 200}) {
    final wordCount = countWords(markdown);
    final minutes = (wordCount / wordsPerMinute).ceil();
    return minutes > 0 ? minutes : 1;
  }
}



