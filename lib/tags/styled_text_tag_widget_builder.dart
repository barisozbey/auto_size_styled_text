import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_styled_text/tags/styled_text_tag_base.dart';

/// Signature for the widget builder function for AutoSizeStyledTextWidgetBuilderTag
typedef AutoSizeStyledTextWidgetBuilderTagCallback = Widget Function(
    BuildContext context, Map<String?, String?> attributes);

/// A class in which you can specify the widget builder to
/// insert in place of the tag.
///
/// In the example below, an input field is inserted in place of the tag:
/// ```dart
/// AutoSizeStyledText(
///   text: 'Text with <input/> inside.',
///   tags: {
///     'input': AutoSizeStyledTextWidgetBuilderTag(
///       (context, attributes) => TextField(
///         decoration: InputDecoration(
///           hintText: 'Input',
///         ),
///       ),
///       size: Size.fromWidth(200),
///       constraints: BoxConstraints.tight(Size(100, 50)),
///     ),
///   },
/// )
/// ```
class AutoSizeStyledTextWidgetBuilderTag extends AutoSizeStyledTextTagBase {
  /// Widget builder to insert in place of the tag.
  final AutoSizeStyledTextWidgetBuilderTagCallback builder;

  /// The size of the available space for the widget,
  /// if not specified, the widget will take up
  /// all the available space.
  final Size? size;

  /// Additional constraints to apply to the widget.
  final BoxConstraints? constraints;

  /// Aligning the widget relative to the text.
  final PlaceholderAlignment alignment;

  /// The [TextBaseline] to align against when using [ui.PlaceholderAlignment.baseline],
  /// [ui.PlaceholderAlignment.aboveBaseline], and [ui.PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  final TextBaseline? baseline;

  AutoSizeStyledTextWidgetBuilderTag(
    this.builder, {
    this.size,
    this.constraints,
    this.alignment = PlaceholderAlignment.middle,
    this.baseline = TextBaseline.alphabetic,
  });

  @override
  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  }) {
    Widget widget = builder(context, attributes);

    if (size != null) {
      widget = SizedBox(
        width: (size!.width == double.infinity) ? null : size!.width,
        height: (size!.height == double.infinity) ? null : size!.height,
        child: widget,
      );
    }

    if (constraints != null) {
      widget = ConstrainedBox(
        constraints: constraints!,
        child: widget,
      );
    }

    final InlineSpan span = TextSpan(
      children: [
        WidgetSpan(
          child: widget,
          alignment: alignment,
          baseline: baseline,
          // style: TextStyle(backgroundColor: backgroundColor),
        ),
      ],
    );

    return span;
  }
}
