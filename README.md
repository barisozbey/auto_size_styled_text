# AutoSizeStyledText

Text widget with formatted text using tags. Makes it easier to use formatted text in multilingual applications.([styled_text](https://pub.dev/packages/styled_text)) Combined with [auto_size_text](https://pub.dev/packages/auto_size_text) that automatically resizes text to fit perfectly within its bounds.

## Table of Contents

- [Getting Started](#getting-Started)
- [Usage examples](#usage-examples)
- [Migration from version 2.0](#migration-from-version-20)

## Getting Started

In your flutter project add the dependency:

```dart
dependencies:
  ...
  auto_size_styled_text: ^[version]
```

Import package:
```dart
import 'package:auto_size_styled_text/auto_size_styled_text.dart';
```

## Usage Examples

```dart
StyledText(
  text: 'Test: <bold>bold</bold> and <red>red color</red> text.',
  tags: {
    'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
    'red': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
  },
)
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/2-bold-and-color.png)

---

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/.github/art/maxlines_rich.gif)