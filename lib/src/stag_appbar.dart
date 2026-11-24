import 'package:flutter/material.dart';

/// The position of the app bar relative to the sidebar.
enum StagAppBarLayoutMode { aboveSidebar, besideSidebar }

/// Arranges an app bar, sidebar and page content within a bounded area.
class StagAppBarLayout extends StatelessWidget {
  const StagAppBarLayout({
    super.key,
    required this.appBar,
    required this.sidebar,
    required this.body,
    this.mode = StagAppBarLayoutMode.aboveSidebar,
    this.spacing = 16,
  }) : assert(spacing >= 0);

  final Widget appBar;
  final Widget sidebar;
  final Widget body;
  final StagAppBarLayoutMode mode;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final beside = mode == StagAppBarLayoutMode.besideSidebar;
    return Column(
      children: [
        if (!beside) ...[appBar, SizedBox(height: spacing)],
        Expanded(
        key: const ValueKey('stag_appbar_layout_content'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sidebar,
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  children: [
                    if (beside) ...[appBar, SizedBox(height: spacing)],
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A toolbar designed to complement the stag_sidebar package.
class StagAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StagAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
    this.style = const StagAppBarStyle(),
    this.height = 64,
  }) : assert(height > 0);

  final Widget title;
  final Widget? leading;
  final List<Widget> actions;
  final StagAppBarStyle style;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: Border.all(color: style.borderColor),
        borderRadius: BorderRadius.circular(style.borderRadius),
        boxShadow: style.shadows,
      ),
      padding: style.padding,
      child: IconTheme.merge(
        data: IconThemeData(color: style.iconColor),
        child: DefaultTextStyle.merge(
          style: style.titleStyle,
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(child: title),
              if (actions.isNotEmpty)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Colors and dimensions matching the default stag_sidebar palettes.
class StagAppBarStyle {
  const StagAppBarStyle({
    this.backgroundColor = const Color(0xFF111322),
    this.borderColor = const Color(0x442B4654),
    this.iconColor = const Color(0xFF52C9D7),
    this.titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    this.borderRadius = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.shadows = const [
      BoxShadow(
        color: Color(0x440C2531),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  });

  const StagAppBarStyle.light({
    this.backgroundColor = const Color(0xFFF8FCFD),
    this.borderColor = const Color(0xFFD0E2E6),
    this.iconColor = const Color(0xFF087487),
    this.titleStyle = const TextStyle(
      color: Color(0xFF193743),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    this.borderRadius = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.shadows = const [
      BoxShadow(
        color: Color(0x33245462),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final TextStyle titleStyle;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow> shadows;
}
