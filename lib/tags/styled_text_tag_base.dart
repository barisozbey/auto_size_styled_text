import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

abstract class AutoSizeStyledTextTagBase {
  GestureRecognizer? createRecognizer(
          String? text, Map<String?, String?> attributes) =>
      null;

  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  });
}

typedef AutoSizeStyledTextTagActionCallback = void Function(
    String? text, Map<String?, String?> attributes);
