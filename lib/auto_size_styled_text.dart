library auto_size_styled_text;

import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xmlstream/xmlstream.dart';
import 'package:auto_size_styled_text/tags/styled_text_tag_base.dart';

export 'icon_style.dart';
export 'custom_text_style.dart';
export 'action_text_style.dart';

export 'tags/styled_text_tag_base.dart';
export 'tags/styled_text_tag.dart';
export 'tags/styled_text_tag_icon.dart';
export 'tags/styled_text_tag_action.dart';
export 'tags/styled_text_tag_widget.dart';
export 'tags/styled_text_tag_widget_builder.dart';
export 'tags/styled_text_tag_custom.dart';

///
/// Text widget with formatting via tags.
///
/// Formatting is specified as xml tags. For each tag, you can specify a style, icon, etc. in the [tags] parameter.
///
/// Example:
/// ```dart
/// AutoSizeStyledText(
///   text: '<red>Red</red> text.',
///   tags: [
///     'red': AutoSizeStyledTextTag(style: TextStyle(color: Colors.red)),
///   ],
/// )
/// ```
/// See also:
///
/// * [TextStyle], which discusses how to style text.
///
class AutoSizeStyledText extends StatefulWidget {
  /// The text to display in this widget. The text must be valid xml.
  ///
  /// Tag attributes must be enclosed in double quotes.
  /// You need to escape specific XML characters in text:
  ///
  /// ```
  /// Original character  Escaped character
  /// ------------------  -----------------
  /// "                   &quot;
  /// '                   &apos;
  /// &                   &amp;
  /// <                   &lt;
  /// >                   &gt;
  /// <space>             &space;
  /// ```
  ///
  final String text;

  /// Sets the key for the resulting [Text] widget.
  ///
  /// This allows you to find the actual `Text` widget built by `AutoSizeText`.
  final Key? textKey;

  /// Treat newlines as line breaks.
  final bool newLineAsBreaks;

  /// Default text style.
  final TextStyle? style;

  /// Map of tag assignments to text style classes and tag handlers.
  ///
  /// Example:
  /// ```dart
  /// AutoSizeStyledText(
  ///   text: '<red>Red</red> text.',
  ///   tags: [
  ///     'red': AutoSizeStyledTextTag(style: TextStyle(color: Colors.red)),
  ///   ],
  /// )
  /// ```
  final Map<String, AutoSizeStyledTextTagBase> tags;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// The minimum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double minFontSize;

  /// The maximum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double maxFontSize;

  /// The step size in which the font size is being adapted to constraints.
  ///
  /// The Text scales uniformly in a range between [minFontSize] and
  /// [maxFontSize].
  /// Each increment occurs as per the step size set in stepGranularity.
  ///
  /// Most of the time you don't want a stepGranularity below 1.0.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double stepGranularity;

  /// Predefines all the possible font sizes.
  ///
  /// **Important:** PresetFontSizes have to be in descending order.
  final List<double>? presetFontSizes;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  ///
  /// If you want multiple [AutoSizeText]s to have the same text size, give all
  /// of them the same [AutoSizeGroup] instance. All of them will have the
  /// size of the smallest [AutoSizeText]
  final AutoSizeGroup? group;

  /// Whether words which don't fit in one line should be wrapped.
  ///
  /// If false, the fontSize is lowered as far as possible until all words fit
  /// into a single line.
  final bool wrapWords;

  /// If the text is overflowing and does not fit its bounds, this widget is
  /// displayed instead.
  final Widget? overflowReplacement;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// AutoSizeText(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String? semanticsLabel;

  /// Create a text widget with formatting via tags.
  ///
  AutoSizeStyledText({
    Key? key,
    required this.text,
    this.newLineAsBreaks = true,
    this.style,
    Map<String, AutoSizeStyledTextTagBase>? tags,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.wrapWords = true,
    this.overflowReplacement,
    this.textKey,
    this.semanticsLabel,
  })  : this.tags = tags ?? const {},
        super(key: key);

  @override
  _AutoSizeStyledTextState createState() => _AutoSizeStyledTextState();
}

class _AutoSizeStyledTextState extends State<AutoSizeStyledText> {
  String? _text;
  TextSpan? _textSpans;
  _Node? _rootNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextSpans();
  }

  @override
  void didUpdateWidget(AutoSizeStyledText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.text != oldWidget.text) ||
        (widget.tags != oldWidget.tags) ||
        (widget.style != oldWidget.style) ||
        (widget.newLineAsBreaks != oldWidget.newLineAsBreaks)) {
      _updateTextSpans(force: true);
    }
  }

  AutoSizeStyledTextTagBase? _tag(String? tagName) {
    if (tagName == null) return null;

    if (widget.tags.containsKey(tagName)) {
      return widget.tags[tagName];
    }

    return null;
  }

  // Parse text
  void _updateTextSpans({bool force = false}) {
    if (_text != widget.text || force) {
      _text = widget.text;

      String? textValue = _text;
      if (textValue == null) return;

      if (widget.newLineAsBreaks) {
        textValue = textValue.replaceAll("\n", '<br/>');
      }

      _rootNode?.dispose();

      TextStyle defaultStyle = (widget.style != null)
          ? DefaultTextStyle.of(context).style.merge(widget.style)
          : DefaultTextStyle.of(context).style;
      _Node node = _TextNode();
      ListQueue<_Node> textQueue = ListQueue();
      Map<String?, String?>? attributes;

      var xmlStreamer = new XmlStreamer(
          '<?xml version="1.0" encoding="UTF-8"?><root>' +
              textValue +
              '</root>',
          trimSpaces: false);
      xmlStreamer.read().listen((e) {
        switch (e.state) {
          case XmlState.Text:
          case XmlState.CDATA:
            node.children.add(
              _TextNode(text: e.value),
            );
            break;

          case XmlState.Open:
            textQueue.addLast(node);

            if (e.value == 'br') {
              node = _TextNode(text: "\n");
            } else {
              AutoSizeStyledTextTagBase? tag = _tag(e.value);
              node = _TagNode(tag: tag);
              attributes = {};
            }

            break;

          case XmlState.Closed:
            node.configure(attributes);

            if (textQueue.isNotEmpty) {
              final _Node child = node;
              node = textQueue.removeLast();
              node.children.add(child);
            }

            break;

          case XmlState.Attribute:
            if (e.key != null && attributes != null) {
              attributes![e.key] = e.value;
            }
            break;

          case XmlState.Comment:
          case XmlState.StartDocument:
          case XmlState.EndDocument:
          case XmlState.Namespace:
          case XmlState.Top:
            break;
        }
      }).onDone(() {
        _rootNode = node;
        _buildTextSpans(_rootNode, defaultStyle);
      });
    } else {
      if (_rootNode != null && _textSpans == null) {
        _buildTextSpans(_rootNode);
      }
    }
  }

  void _buildTextSpans(_Node? node, [TextStyle? defaultStyle]) {
    if (mounted && node != null) {
      TextStyle? style = defaultStyle;
      if (style == null) {
        style = (widget.style != null)
            ? DefaultTextStyle.of(context).style.merge(widget.style)
            : DefaultTextStyle.of(context).style;
      }

      final span = node.createSpan(context: context);
      _textSpans = TextSpan(style: style, children: [span]);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_textSpans == null) return const SizedBox();
    return AutoSizeText.rich(
      _textSpans!,
      key: widget.key,
      textKey: widget.textKey,
      style: widget.style,
      strutStyle: widget.strutStyle,
      minFontSize: widget.minFontSize,
      maxFontSize: widget.maxFontSize,
      stepGranularity: widget.stepGranularity,
      presetFontSizes: widget.presetFontSizes,
      group: widget.group,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      wrapWords: widget.wrapWords,
      overflow: widget.overflow,
      overflowReplacement: widget.overflowReplacement,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
    );
  }
}

abstract class _Node {
  String? text;
  final List<_Node> children = [];

  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  });

  void configure(Map<String?, String?>? attributes) {}

  List<InlineSpan> createChildren({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return children
        .map((c) => c.createSpan(context: context, recognizer: recognizer))
        .toList();
  }

  void dispose() {
    for (var node in children) {
      node.dispose();
    }
  }
}

class _TagNode extends _Node {
  AutoSizeStyledTextTagBase? tag;
  Map<String?, String?> attributes = {};
  GestureRecognizer? _recognizer;

  _TagNode({
    this.tag,
  });

  @override
  void dispose() {
    _recognizer?.dispose();
    super.dispose();
  }

  @override
  void configure(Map<String?, String?>? attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      this.attributes.addAll(attributes);
    }
  }

  @override
  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    _recognizer = tag?.createRecognizer(text, attributes) ?? recognizer;
    InlineSpan? result = (tag != null)
        ? tag!.createSpan(
            context: context,
            text: text,
            children: createChildren(context: context, recognizer: _recognizer),
            attributes: attributes,
            recognizer: _recognizer,
          )
        : null;
    if (result == null) {
      result = TextSpan(
        text: text,
        children: createChildren(context: context, recognizer: _recognizer),
      );
    }
    return result;
  }
}

class _TextNode extends _Node {
  final String? _text;

  _TextNode({
    String? text,
  }) : _text = text;

  @override
  String? get text => _text
      ?.replaceAll('&space;', ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', "<")
      .replaceAll('&gt;', ">");

  @override
  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return TextSpan(
      text: text,
      children: createChildren(context: context, recognizer: recognizer),
      recognizer: recognizer,
    );
  }
}
