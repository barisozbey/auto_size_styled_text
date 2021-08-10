import 'package:flutter/widgets.dart';
import 'package:auto_size_styled_text/tags/styled_text_tag_widget_builder.dart';

/// The class with which you can specify the widget to insert in place of the tag.
///
/// In the example below, an input field is inserted in place of the tag:
/// ```dart
/// AutoSizeStyledText(
///   text: 'Text with <input/> inside.',
///   tags: {
///     'input': AutoSizeStyledTextWidgetTag(
///       TextField(
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
class AutoSizeStyledTextWidgetTag extends AutoSizeStyledTextWidgetBuilderTag {
  AutoSizeStyledTextWidgetTag(
    Widget child, {
    Size? size,
    BoxConstraints? constraints,
    PlaceholderAlignment alignment = PlaceholderAlignment.middle,
    TextBaseline baseline = TextBaseline.alphabetic,
  }) : super(
          (context, attributes) => child,
          size: size,
          constraints: constraints,
          alignment: alignment,
          baseline: baseline,
        );
}
