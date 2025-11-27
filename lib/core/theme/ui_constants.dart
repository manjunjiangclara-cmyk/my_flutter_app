/// UI constants for consistent design system
class UIConstants {
  UIConstants._();

  // Feature Toggles
  static const bool enableImageShadows = false;

  // Spacing
  static const double extraSmallPadding = 4.0;
  static const double tinyPadding = 2.0;
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
  static const double extraLargeRadius = 28.0;

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
  // Memory Card Layout
  static const double memoryCardVerticalMargin = 8.0; // replaces Spacing.sm
  static const double memoryCardBorderWidth = 1.0;
  static const double memoryCardSectionSpacingLarge =
      16.0; // replaces Spacing.lg
  static const double memoryCardSectionSpacingSmall =
      4.0; // replaces Spacing.xs
  static const double memoryCardChipHorizontalPadding =
      8.0; // replaces Spacing.sm
  static const double memoryCardChipVerticalPadding =
      4.0; // replaces Spacing.xs
  static const double memoryCardTagSpacing = 8.0; // replaces Spacing.sm
  static const double memoryCardTagRunSpacing = 4.0; // replaces Spacing.xs
  static const double memoryCardHeaderSpacer = 4.0; // replaces Spacing.xs

  // Memory Screen behavior
  static const int memoryDefaultExpandedGroupCount = 1;

  // Memory Card Press Feedback
  static const double memoryCardPressScale = 0.96;
  static const Duration memoryCardPressDuration = Duration(milliseconds: 120);

  // Image Gallery
  static const double defaultImageSize = 100.0;
  static const double imageGallerySpacing = 8.0;
  static const double imageGalleryRunSpacing = 8.0;
  static const double imageGalleryOpacity = 0.8;
  static const double imageGalleryElevation = 6.0;
  static const int imageGalleryTwoColumnCount = 2;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Expressive Loading Indicator
  static const double expressiveIndicatorSizeSm = 16.0;
  static const double expressiveIndicatorSizeMd = 24.0;
  static const double expressiveIndicatorSizeLg = 40.0;
  static const Duration expressiveIndicatorAnimationDuration = Duration(
    milliseconds: 1400,
  );

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

  // Date Picker (Compose)
  static const int datePickerFirstYear = 1970;
  static int get datePickerLastYear => DateTime.now().year;
  static const double cupertinoDatePickerHeight = 216.0;

  // Image Picker
  static const int imageQuality = 85;
  static const int maxPhotos = 9;
  static const int maxImageSizeMB = 10;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;

  static const double locationIconSize = 16.0;
  static const double tagCloseIconSize = 14.0;
  static const double tagCloseIconSpacing = 4.0;

  // Tag Chip Padding - Interactive (with close button)
  static const double tagChipInteractiveHorizontalPadding = 12.0;
  static const double tagChipInteractiveVerticalPadding = 6.0;

  static const double actionButtonIconSize = 24.0;
  static const double actionButtonPadding = 12.0;
  // Circular action button sizing
  static const double actionButtonDiameter = defaultButtonHeight; // 48.0
  static const double actionButtonSplashRadius = actionButtonDiameter / 2;
  static const double actionButtonBorderWidth = 1.0;
  // Action button colors
  static const double actionButtonBackgroundLerp = 0.3;

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
  static const double journalHeaderDefaultAspectRatio = 1.5; // 3:2 default
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

  // Docked Toolbar
  static const double dockedBarHeight = 48.0;
  static const double dockedBarRadius = 32.0;
  static const double dockedBarHorizontalPadding = smallPadding;
  static const double dockedBarVerticalPadding = smallPadding;
  static const double dockedBarMargin = defaultPadding;
  static const double dockedBarIconSize = 26.0;
  static const double dockedBarIconPadding = 12.0;
  static const double dockedBarActiveOverlayOpacity = 0.90;
  static const double dockedBarShadowOpacity = 0.12;
  static const double dockedBarShadowBlur = 8.0;
  static const double dockedBarShadowOffsetY = 6.0;
  static const double dockedBarShadowSpread = -0.5;
  static const double dockedBarShadow2Opacity = 0.06;
  static const double dockedBarShadow2Blur = 32.0;
  static const double dockedBarShadow2OffsetY = 12.0;
  static const double dockedBarShadow2Spread = -2.0;
  static const double dockedBarBottomOffset = 8.0;
  static const double dockedBarMaxWidth = 240.0;
  static const Duration dockedBarSlideDuration = Duration(milliseconds: 300);
  static const double dockedBarSlideOffset = 100.0;
  static const Duration dockedBarFadeDuration = Duration(milliseconds: 260);
  static const Duration dockedBarScaleDuration = Duration(milliseconds: 340);
  static const double dockedBarHiddenScale = 0.98;
  static const Duration toolbarIconColorFadeDuration = Duration(
    milliseconds: 180,
  );
  static const double dockedBarAccentTintOpacity = 0.10;
  static const double dockedBarAccentBorderWidth = 1.0;
  static const double dockedBarAccentBorderOpacity = 0.12;

  // Docked Toolbar Dynamic Elevation (scroll-driven)
  static const double dockedBarElevScrollStart = 0.0;
  static const double dockedBarElevScrollEnd = 120.0;

  // Overlay opacity interpolation
  static const double dockedBarOverlayOpacityMin =
      0.80; // base stronger for readability
  static const double dockedBarOverlayOpacityMax =
      0.92; // deeper scroll = more contrast

  // Shadow 1 interpolation (near shadow)
  static const double dockedBarShadowOpacityMin =
      dockedBarShadowOpacity; // 0.12
  static const double dockedBarShadowOpacityMax = 0.18;
  static const double dockedBarShadowBlurMin = dockedBarShadowBlur; // 8.0
  static const double dockedBarShadowBlurMax = 16.0;
  static const double dockedBarShadowOffsetYMin = dockedBarShadowOffsetY; // 6.0
  static const double dockedBarShadowOffsetYMax = 10.0;
  static const double dockedBarShadowSpreadMin = dockedBarShadowSpread; // -0.5
  static const double dockedBarShadowSpreadMax = -0.5;

  // Shadow 2 interpolation (far/ambient shadow)
  static const double dockedBarShadow2OpacityMin =
      dockedBarShadow2Opacity; // 0.06
  static const double dockedBarShadow2OpacityMax = 0.12;
  static const double dockedBarShadow2BlurMin = dockedBarShadow2Blur; // 32.0
  static const double dockedBarShadow2BlurMax = 48.0;
  static const double dockedBarShadow2OffsetYMin =
      dockedBarShadow2OffsetY; // 12.0
  static const double dockedBarShadow2OffsetYMax = 18.0;
  static const double dockedBarShadow2SpreadMin =
      dockedBarShadow2Spread; // -2.0
  static const double dockedBarShadow2SpreadMax = -2.0;

  // Docked Toolbar Visual Differentiation (Scheme A)
  static const double dockedBarTintOpacityMin = 0.02; // more subtle tint
  static const double dockedBarTintOpacityMax = 0.06; // restrained at elevation
  static const double dockedBarEdgeGradientOpacityMin =
      0.08; // top edge separator
  static const double dockedBarEdgeGradientOpacityMax = 0.12;

  // Option C: inner highlight stroke
  static const double dockedBarInnerHighlightWidth = 1.0;
  static const double dockedBarInnerHighlightOpacityMin = 0.10;
  static const double dockedBarInnerHighlightOpacityMax = 0.18;

  // Cleaned up toolbar constants
  static const double dockedBarButtonScaleMin = 0.96;
  static const double dockedBarButtonRotationMax = 0.05;
  static const double dockedBarSelectedIconSizeIncrease = 4.0;
  static const double dockedBarSelectedOverlayOpacity = 0.15;
  static const double dockedBarSelectedBorderOpacity = 0.2;
  static const double dockedBarSelectedBorderWidth = 0.5;
  static const double dockedBarTopHighlightOpacity = 0.08;
  static const double dockedBarTopHighlightOffset = -0.5;
  static const double dockedBarSelectedTextOpacity = 0.8;
  static const double dockedBarUnselectedTextOpacity = 0.7;

  // Docked Toolbar Sliding Indicator
  static const double dockedBarIndicatorWidth = 24.0;
  static const double dockedBarIndicatorHeight = 3.0;
  static const double dockedBarIndicatorRadius = 2.0;
  static const double dockedBarIndicatorBottomInset = 6.0;
  static const double dockedBarIndicatorOpacity = 0.85;

  // LiquidGlass specific tweaks
  static const double liquidGlassUnselectedIconOpacity = 0.6;

  // Tag Chip Specific
  static const double tagChipWidthPadding = 16.0;
  static const double tagChipBorderWidth = 1.0;
  static const double tagChipMoreButtonIconSpacing = 2.0;
  static const double tagChipMoreButtonIconSize = 16.0;
  static const double tagChipCollapseButtonIconSpacing = 4.0;
  static const double tagChipCollapseButtonIconSize = 16.0;

  // Search Bar
  static const double searchBarDebounceMs = 500.0;
  static const double searchBarMinQueryLength = 2.0;
  static const double searchBarMaxResults = 20.0;
  static const Duration searchBarTimeout = Duration(seconds: 6);
  static const double searchBarCornerRadius = mediumRadius;

  // Bottom Sheet Handle
  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;
  static const double bottomSheetHandleRadius = 2.0;

  // Bottom Sheet Heights
  static const double locationPickerHeight = 0.8;
  static const double tagPickerHeight = 0.85;
  static const double shareOptionsHeight = 0.35;
  static const double themeBottomSheetHeight = 0.35;

  // Location Picker Bottom Sheet
  static const double locationPickerCornerRadius = extraLargeRadius;
  static const double shareOptionsCornerRadius = extraLargeRadius;
  static const double shareOptionItemPadding = 16.0;
  static const double shareOptionIconSize = defaultIconSize;
  static const double locationResultItemPadding = 16.0;
  static const double locationResultIconPadding = 8.0;
  static const double locationResultIconSize = 24.0;
  static const double locationRatingIconSize = 16.0;
  static const double locationTypeChipHeight = 24.0;
  static const double locationTypeChipPadding = 8.0;
  static const double locationErrorIconSize = 48.0;
  static const double locationLoadingIndicatorSize = 24.0;

  // Location Picker Gradient Transition
  static const double locationPickerGradientHeight = 32.0;
  static const double locationPickerGradientOpacity = 0.8;

  // Refresh Indicator
  static const double refreshDisplacement = 40.0;
  static const double refreshEdgeOffset = 0.0;
  static const double refreshStrokeWidth = 2.0;

  // Location Chip
  static const double locationChipHorizontalPadding = 8.0;
  static const double locationChipVerticalPadding = 4.0;
  static const double locationChipRadius = largeRadius;
  static const double locationChipMaxWidthFraction = 0.66;
  static const double locationEmojiScale = 1.25;
  static const double locationChipFontSize = 12.0;

  // Journal Image Gallery
  static const int journalImageGalleryColumns = 3;
  static const double journalImageGallerySpacing = 8.0;
  static const double journalImageGalleryItemHeight = 120.0;

  // Sharing/Capture
  static const double shareCapturePixelRatio = 4.0;
  static const double shareCapturePadding = 20.0;

  // ========== SPLASH SCREEN ==========

  /// Splash screen animation duration
  static const Duration splashFadeInDuration = Duration(milliseconds: 200);

  /// Splash screen fade-out duration
  static const Duration splashFadeOutDuration = Duration(milliseconds: 600);

  /// Splash screen display duration (minimum time to show)
  static const Duration splashMinDisplayDuration = Duration(milliseconds: 2000);

  /// Splash route transition (cross-fade) duration
  static const Duration splashRouteTransitionDuration = Duration(
    milliseconds: 260,
  );

  /// Splash screen logo size
  static const double splashLogoSize = 120.0;

  /// Splash screen title font size
  static const double splashTitleFontSize = 48.0;

  /// Splash screen subtitle font size
  static const double splashSubtitleFontSize = 16.0;

  /// Splash screen loading indicator size
  static const double splashLoadingIndicatorSize = 40.0;

  /// Splash screen vertical spacing between elements
  static const double splashVerticalSpacing = 24.0;

  /// Splash screen horizontal padding
  static const double splashHorizontalPadding = 32.0;

  /// Splash screen quote font size (short, readable)
  static const double splashQuoteFontSize = 20.0;

  /// Splash screen author font size (smaller than quote)
  static const double splashAuthorFontSize = 14.0;

  /// Splash screen quote max text width to keep lines short on wide screens
  static const double splashQuoteMaxWidth = 320.0;

  // ========== SETTINGS TILES ==========

  /// Settings tile horizontal padding (aligned with app bar title)
  static const double settingsTileHorizontalPadding = 0.0;

  /// Settings tile vertical padding
  static const double settingsTileVerticalPadding = 4.0;

  /// Settings tile icon container size
  static const double settingsTileIconContainerSize = 40.0;

  /// Settings tile icon size
  static const double settingsTileIconSize = 24.0;

  /// Settings tile icon background opacity
  static const double settingsTileIconBackgroundOpacity = 0.15;

  /// Settings tile trailing icon size
  static const double settingsTileTrailingIconSize = 16.0;

  /// Settings tile trailing icon padding
  static const double settingsTileTrailingIconPadding = 0.0;

  // Light Dropdown Arrow
  static const double lightDropdownArrowSize = 16.0;
  static const double lightDropdownArrowOpacity = 0.3;
  static const double lightDropdownArrowRotation =
      0.0; // radians, 0 = no rotation

  /// Settings section divider height
  static const double settingsSectionDividerHeight = 1.0;

  /// Settings section divider opacity
  static const double settingsSectionDividerOpacity = 0.12;

  /// Settings section top margin
  static const double settingsSectionTopMargin = defaultPadding;

  /// Settings section bottom margin
  static const double settingsSectionBottomMargin = defaultPadding;

  // Spacing between settings cards
  static const double settingsCardSpacing = defaultPadding;

  // Settings card content left padding (aligns with app bar title)
  static const double settingsCardContentLeftPadding = smallPadding;
}
