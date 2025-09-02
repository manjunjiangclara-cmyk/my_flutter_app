List<String> parseCommaSeparatedString(String? value) {
  if (value == null || value.isEmpty) return [];
  return value
      .split(',')
      .where((item) => item.trim().isNotEmpty)
      .map((item) => item.trim())
      .toList();
}
