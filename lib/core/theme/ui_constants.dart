/// UI constants for consistent design system
class UIConstants {
  UIConstants._();

  // Feature Toggles
  static const bool enableImageShadows = false;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 24.0;
  static const double largePadding = 32.0;
  static const double extraLargePadding = 48.0;

  // Border Radius
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Elevation
  static const double defaultElevation = 2.0;
  static const double smallElevation = 1.0;
  static const double mediumElevation = 4.0;
  static const double largeElevation = 8.0;
  static const double extraLargeElevation = 16.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double mediumIconSize = 32.0;
  static const double largeIconSize = 48.0;
  static const double iconButtonSize = 30.0;

  // Button Heights
  static const double smallButtonHeight = 36.0;
  static const double defaultButtonHeight = 48.0;
  static const double largeButtonHeight = 56.0;

  // Input Field Heights
  static const double defaultInputHeight = 48.0;
  static const double largeInputHeight = 56.0;

  // Card Dimensions
  static const double defaultCardPadding = 16.0;
  static const double defaultCardRadius = 16.0;
  static const double memoryImageElevation = imageGalleryElevation;
  static const double imageCardRadius = extraLargeRadius;
  static const double imageInnerRadius = largeRadius;

  // Memory Card Color Tuning
  static const double memoryCardDarkLightenAmount = 0.06;

  // Memory Card Press Feedback
  static const double memoryCardPressScale = 0.96;
  static const Duration memoryCardPressDuration = Duration(milliseconds: 120);

  // Image Gallery
  static const double defaultImageSize = 100.0;
  static const double imageGallerySpacing = 8.0;
  static const double imageGalleryRunSpacing = 8.0;
  static const double imageGalleryOpacity = 0.8;
  static const double imageGalleryElevation = 6.0;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Screen Breakpoints (for responsive design)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Compose Screen Specific
  static const double photoAttachmentHeight = 120.0;
  static const double photoAttachmentSize = 100.0;
  static const double photoAttachmentIconSize = 40.0;
  static const double photoAttachmentCloseIconSize = 16.0;
  static const double photoAttachmentCloseButtonPadding = 4.0;
  static const double photoAttachmentCloseButtonSize = 24.0;
  static const double photoAttachmentMargin = 8.0;

  // Photo Grid Layout
  static const double photoGridSpacing = 8.0;
  static const int photosPerRow = 3;
  static const double photoMinSize = 80.0;
  static const double photoMaxSize = 120.0;
  static const double photoBorderWidth = 1.0;
  static const double photoBorderOpacity = 0.2;
  static const double photoErrorBackgroundOpacity = 0.1;

  // Photo Viewer
  static const double photoViewerMinScale = 0.5;
  static const double photoViewerMaxScale = 3.0;
  static const double photoViewerErrorIconSize = 64.0;
  static const double photoViewerGradientOpacity = 0.7;
  static const double photoViewerCounterFontSize = 16.0;
  static const double photoViewerDotSize = 8.0;
  static const double photoViewerDotSpacing = 4.0;
  static const double photoViewerDotOpacity = 0.5;

  // Image Picker
  static const int imageQuality = 85;
  static const int maxPhotos = 9;
  static const int maxImageSizeMB = 10;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;

  static const double locationIconSize = 16.0;
  static const double tagCloseIconSize = 14.0;
  static const double tagCloseIconSpacing = 4.0;

  static const double actionButtonIconSize = 24.0;
  static const double actionButtonPadding = 12.0;

  static const double dialogBorderWidth = 1.0;
  static const double dialogOpacity = 0.3;
  static const double dialogCloseOpacity = 0.54;
  static const double dialogPadding = 16.0;
  static const double dialogFontSize = 13.0;

  // Blur Dialog
  static const double dialogBackdropBlurSigma = barBlurSigma;
  static const double dialogBarrierOpacity = 0.4;
  static const Duration dialogAnimationDuration = defaultAnimation;

  static const double postingIndicatorSize = 16.0;
  static const double postingIndicatorStrokeWidth = 2.0;

  // Timeline Indicator
  static const double timelineDotSize = 16.0;
  static const double timelineLineWidth = 1.0;
  static const double timelineLineBorderWidth = 1.5;
  static const double timelineLineOpacityLight = 0.65;
  static const double timelineDotFillBlendLight = 0.08;
  static const double timelineShadowOpacity = 0.08;
  static const double timelineShadowBlur = 8.0;
  static const double timelineShadowOffsetY = 2.0;
  static const double timelineLineOpacityDark = 0.5;
  static const double timelineDotFillBlendDark = 0.04;
  static const double timelineShadowOpacityDark = 0.24;
  static const double timelineShadowBlurDark = 8.0;
  static const double timelineShadowOffsetYDark = 2.0;

  // Journal View Screen
  static const double journalHeaderImageHeight = 180.0;
  static const double journalHeaderImageElevation = imageGalleryElevation;
  static const double journalAppBarIconSize = 24.0;
  static const double journalAppBarIconSizeSmall = 20.0;
  static const double journalAppBarIconPadding = 12.0;
  static const double journalContentPadding = 16.0;
  static const double journalAppBarOverlayOpacity = 0.8;
  static const double journalAppBarGradientStartOpacity = 0.5;
  static const double journalAppBarGradientEndOpacity = 0.0;
  static const double journalAppBarActionShadowOpacity = 0.25;
  static const double journalAppBarActionShadowBlur = 8.0;
  static const double journalAppBarActionShadowOffsetY = 2.0;
  static const double journalAppBarSlideHiddenOffsetY = -1.0;

  // Blurred Bars
  static const double barBlurSigma = 34.0;
  static const double barOverlayOpacity = 0.75;
  static const double barEdgeFadeHeight = 16.0;
  static const double barEdgeFadeStartOpacity = 0.75;

  // Tag Chip Specific
  static const double tagChipWidthPadding = 16.0;
  static const double tagChipBorderWidth = 1.0;
  static const double tagChipMoreButtonIconSpacing = 2.0;
  static const double tagChipMoreButtonIconSize = 16.0;
  static const double tagChipCollapseButtonIconSpacing = 4.0;
  static const double tagChipCollapseButtonIconSize = 16.0;

  // Location Picker Bottom Sheet
  static const double locationPickerHeight = 0.8;
  static const double locationPickerHandleWidth = 40.0;
  static const double locationPickerHandleHeight = 4.0;
  static const double locationResultItemPadding = 16.0;
  static const double locationResultIconPadding = 8.0;
  static const double locationResultIconSize = 24.0;
  static const double locationSearchDebounceMs = 500.0;
  static const double locationSearchMinQueryLength = 2.0;
  static const double locationSearchMaxResults = 20.0;
  static const double locationRatingIconSize = 16.0;
  static const double locationTypeChipHeight = 24.0;
  static const double locationTypeChipPadding = 8.0;
  static const double locationErrorIconSize = 48.0;
  static const double locationLoadingIndicatorSize = 24.0;

  // Journal Image Gallery
  static const int journalImageGalleryColumns = 3;
  static const double journalImageGallerySpacing = 8.0;
  static const double journalImageGalleryItemHeight = 120.0;

  // ========== SPLASH SCREEN ==========

  /// Splash screen animation duration
  static const Duration splashFadeInDuration = Duration(milliseconds: 800);

  /// Splash screen display duration (minimum time to show)
  static const Duration splashMinDisplayDuration = Duration(seconds: 1);

  /// Splash screen logo size
  static const double splashLogoSize = 120.0;

  /// Splash screen title font size
  static const double splashTitleFontSize = 48.0;

  /// Splash screen subtitle font size
  static const double splashSubtitleFontSize = 16.0;

  /// Splash screen loading indicator size
  static const double splashLoadingIndicatorSize = 24.0;

  /// Splash screen vertical spacing between elements
  static const double splashVerticalSpacing = 24.0;

  /// Splash screen horizontal padding
  static const double splashHorizontalPadding = 32.0;
}
