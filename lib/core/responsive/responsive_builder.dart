import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < ResponsiveBreakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < ResponsiveBreakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  @override
  Widget build(BuildContext context) {
    return builder(context, getDeviceType(context));
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(BuildContext context) {
    final deviceType = ResponsiveBuilder.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final value = ResponsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return Padding(
      padding: value.getValue(context),
      child: child,
    );
  }
}

class ResponsiveConstraints extends StatelessWidget {
  final Widget child;
  final BoxConstraints mobile;
  final BoxConstraints? tablet;
  final BoxConstraints? desktop;

  const ResponsiveConstraints({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final value = ResponsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return ConstrainedBox(
      constraints: value.getValue(context),
      child: child,
    );
  }
}

/// Extension for responsive values based on context
extension ResponsiveExtension on BuildContext {
  /// Get device type for current context
  DeviceType get deviceType => ResponsiveBuilder.getDeviceType(this);

  /// Check if current device is mobile
  bool get isMobile => ResponsiveBuilder.isMobile(this);

  /// Check if current device is tablet
  bool get isTablet => ResponsiveBuilder.isTablet(this);

  /// Check if current device is desktop
  bool get isDesktop => ResponsiveBuilder.isDesktop(this);

  /// Get responsive value based on device type
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    return ResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop)
        .getValue(this);
  }

  /// Get responsive spacing value
  double responsiveSpacing({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Get number of grid columns for current device
  int get gridColumns {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }
}

/// Responsive text that scales appropriately
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    required this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveValue(
      mobile: mobileFontSize,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    ).getValue(context);

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.child,
  });

  /// Vertical space with responsive height
  const ResponsiveSizedBox.vertical({
    super.key,
    required double mobile,
    double? tablet,
    double? desktop,
  })  : mobileHeight = mobile,
        tabletHeight = tablet,
        desktopHeight = desktop,
        mobileWidth = null,
        tabletWidth = null,
        desktopWidth = null,
        child = null;

  /// Horizontal space with responsive width
  const ResponsiveSizedBox.horizontal({
    super.key,
    required double mobile,
    double? tablet,
    double? desktop,
  })  : mobileWidth = mobile,
        tabletWidth = tablet,
        desktopWidth = desktop,
        mobileHeight = null,
        tabletHeight = null,
        desktopHeight = null,
        child = null;

  @override
  Widget build(BuildContext context) {
    final width = mobileWidth != null
        ? ResponsiveValue(
            mobile: mobileWidth!,
            tablet: tabletWidth,
            desktop: desktopWidth,
          ).getValue(context)
        : null;

    final height = mobileHeight != null
        ? ResponsiveValue(
            mobile: mobileHeight!,
            tablet: tabletHeight,
            desktop: desktopHeight,
          ).getValue(context)
        : null;

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

/// Max width container for centering content on large screens
class ResponsiveMaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;

  const ResponsiveMaxWidth({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Align(alignment: alignment, child: content);
  }
}

class ResponsiveGridView extends StatelessWidget {
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsets? padding;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        int columns;
        switch (deviceType) {
          case DeviceType.mobile:
            columns = mobileColumns;
            break;
          case DeviceType.tablet:
            columns = tabletColumns;
            break;
          case DeviceType.desktop:
            columns = desktopColumns;
            break;
        }

        return GridView.builder(
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: 1,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}