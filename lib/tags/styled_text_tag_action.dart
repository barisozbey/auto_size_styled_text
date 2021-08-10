import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_styled_text/tags/styled_text_tag_base.dart';
import 'package:auto_size_styled_text/tags/styled_text_tag.dart';

/// A class that you can use to specify a callback
/// that will be called when the tag is tapped.
///
class AutoSizeStyledTextActionTag extends AutoSizeStyledTextTag {
  /// A callback to be called when the tag is tapped.
  final AutoSizeStyledTextTagActionCallback onTap;

  AutoSizeStyledTextActionTag(
    this.onTap, {
    TextStyle? style,
  }) : super(style: style);

  GestureRecognizer? createRecognizer(
      String? text, Map<String?, String?> attributes) {
    return TapGestureRecognizer()..onTap = () => onTap(text, attributes);
  }
}
