/// Journal-specific string constants
class JournalStrings {
  JournalStrings._();

  // ---------- Journal View Screen ----------
  static const String journal = 'Journal';
  static const String retry = 'Retry';
  static const String showLess = 'Show less';
  static const String editJournal = 'Edit Journal';
  static const String deleteJournal = 'Delete Journal';
  static const String shareJournal = 'Share Journal';
  static const String closeJournal = 'Close Journal';

  // ---------- Delete Confirmation Dialog ----------
  static const String deleteJournalTitle = 'Delete Journal';
  static const String deleteJournalMessage =
      'Are you sure you want to delete this journal? This action cannot be undone.';
  static const String deleteJournalSuccess = 'Journal deleted successfully';
  static const String cancel = 'Cancel';

  // ---------- Error Messages ----------
  static const String loadJournalError = 'Failed to load journal';
  static const String deleteJournalError = 'Failed to delete journal';

  // ---------- UI Constants ----------
  static const String locationEmoji = '📍';

  // ---------- Accessibility Labels ----------
  static const String journalImageLabel = 'Journal image';
  static const String journalLocationLabel = 'Journal location';
  static const String journalDateLabel = 'Journal date';
  static const String journalContentLabel = 'Journal content';
  static const String journalTagsLabel = 'Journal tags';
  static const String expandTagsLabel = 'Expand tags';
  static const String collapseTagsLabel = 'Collapse tags';
}
