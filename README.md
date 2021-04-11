# Flutter Mediator Lite

<table cellpadding="0" border="0">
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator">Flutter Mediator</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator"><img src="https://img.shields.io/pub/v/flutter_mediator.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/actions"><img src="https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode + Model Mode
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_lite">Lite</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_lite"><img src="https://img.shields.io/pub/v/flutter_mediator_lite.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/actions"><img src="https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode only
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_persistence">Persistence</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_persistence"><img src="https://img.shields.io/pub/v/flutter_mediator_persistence.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_persistence.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/actions"><img src="https://github.com/rob333/flutter_mediator_persistence/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Lite + Persistence
    </td>
  </tr>
  <tr>
    <td align="right">
    Example
    </td>
    <td colspan="4">
    <a href="https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management">Logins to a REST server with i18n, theming, persistence and state management.</a>
    </td>
  </tr>
</table>

<br>

<!--
Lite:
[![Pub](https://img.shields.io/pub/v/flutter_mediator_lite.svg)](https://pub.dev/packages/flutter_mediator_lite)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg)](https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator_lite/actions)
&nbsp; &nbsp;
Flutter Mediator:
[![Pub](https://img.shields.io/pub/v/flutter_mediator.svg)](https://pub.dev/packages/flutter_mediator)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator.svg)](https://github.com/rob333/flutter_mediator/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator/actions)
-->

Flutter Mediator Lite is a super easy state management package, base on the [InheritedModel][] with automatic aspect management to make it simpler and easier to use and rebuild widgets only when necessary.

Flutter Mediator Lite is derived from [Flutter Mediator][flutter_mediator] v2.1.3, and consists only of the Global Mode.

<table border="0" align="center">
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/rob333/flutter_mediator_lite/main/doc/images/global_mode.gif">
    </td>
  </tr>
</table>

<br>
<hr>

## Table of Contents

- [Setting up](#setting-up)
- [Steps](#steps)
  - [Case 1: Int](#case-1-int)
  - [Case 2: List](#case-2-list)
  - [Case 3: Locale setting with Persistence by SharedPreferences](#case-3-locale-setting-with-persistence-by-sharedpreferences)
  - [Case 4: Scrolling effect](#case-4-scrolling-effect)
- [Recap](#recap)
- [Global Get](#global-get)
  - [Case 1: By `Type`](#case-1-by-type)
  - [Case 2: By `tag`](#case-2-by-tag)
- [Global Broadcast](#global-broadcast)
- [Versions](#versions)
- [Example: Logins to a REST server](#example-logins-to-a-rest-server)
- [Flow chart](#flow-chart)
- [Flutter Widget of the Week: InheritedModel explained](#flutter-widget-of-the-week-inheritedmodel-explained)
- [Changelog](#changelog)
- [License](#license)

<hr>

## Setting up

Add the following dependency to pubspec.yaml of your flutter project:

```yaml
dependencies:
  flutter_mediator_lite: "^1.0.2"
```

Import flutter_mediator_lite in files that will be used:

```dart
import 'package:flutter_mediator_lite/mediator.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).

&emsp; [Table of Contents]

## Steps

1. Declare the watched variable with `globalWatch`.
   <br>**Suggest to put the watched variables into a file [var.dart][example/lib/var.dart] and then import it.**

2. Create the host with `globalHost` at the top of the widget tree.

3. Create a widget with `globalConsume` or `watchedVar.consume` to register the watched variable to the host to rebuild it when updating.

4. Make an update to the watched variable, by `watchedVar.value` or `watchedVar.ob.updateMethod(...)`.

&emsp; [Table of Contents]

### Case 1: Int

[example/lib/main.dart][]

Step 1: [var.dart][example/lib/var.dart]

```dart
//* Step1: Declare the watched variable with `globalWatch`
//* in the var.dart and then import it.
final touchCount = globalWatch(0);
```

Step 2:

```dart
Future<void> main() async {
  //* Initialize the persistent watched variables
  //* whose value is stored by the SharedPreferences.
  await initVars();

  runApp(
    //* Step2: Create the host with `globalHost`
    //* at the top of the widget tree.
    globalHost(
      child: MyApp(),
    ),
  );
}
```

Step 3:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Int Demo')),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('You have pushed the button this many times:'),
      //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
      //* to register the watched variable to the host to rebuild it when updating.
      globalConsume(
        () => Text(
          '${touchCount.value}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
   // ...
```

Step 4:

```dart
FloatingActionButton(
  //* Stet4: Make an update to the watched variable.
  onPressed: () => touchCount.value++,
  tooltip: 'Increment',
  child: const Icon(Icons.add),
  heroTag: null,
),
```

&emsp; [Table of Contents]

### Case 2: List

[example/lib/pages/list_page.dart][]

Step 1: [var.dart][example/lib/var.dart]

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final data = globalWatch(<ListItem>[]);
```

Step 3:

```dart
return Scaffold(
  appBar: AppBar(title: const Text('List Demo')),
  //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
  //* to register the watched variable to the host to rebuild it when updating.
  body: globalConsume(
    () => GridView.builder(
      itemCount: data.value.length,

    // ...
```

Step 4:

```dart
void updateListItem() {
  // ...

  //* Step4: Make an update to the watched variable.
  //* watchedVar.ob = watchedVar.notify() and then return the underlying object
  data.ob.add(ListItem(itemName, units, color));
}
```

&emsp; [Table of Contents]

### Case 3: Locale setting with Persistence by SharedPreferences

> Or use [Flutter Mediator Persistence][persistence] for built in persistence support.
> <br>
> Please see [Flutter Mediator Persistence: use case 3][persistence_use_case3] for details.

[example/lib/pages/locale_page.dart][]

Step 1-1: [var.dart][example/lib/var.dart]

```dart
//* Declare a global scope SharedPreferences.
late SharedPreferences prefs;

//* Step1B: Declare the persistent watched variable with `late Rx<Type>`
//* And then import it in the file.
const DefaultLocale = 'en';
late Rx<String> locale; // local_page.dart

/// Initialize the persistent watched variables
/// whose value is stored by the SharedPreferences.
Future<void> initVars() async {
  // To make sure SharedPreferences works.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  locale = globalWatch(prefs.getString('locale') ?? DefaultLocale);
}
```

Step 1-2: [main.dart][example/lib/main.dart]

```dart
Future<void> main() async {
  //* Step1-2: Initialize the persistent watched variables
  //* whose value is stored by the SharedPreferences.
  await initVars();

  runApp(
    // ...
  );
}
```

Step 1-3: [main.dart][example/lib/main.dart]

```dart
//* Initialize the locale with the persistent value.
localizationsDelegates: [
  FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      forcedLocale: Locale(locale.value),
      fallbackFile: DefaultLocale,
      // ...
    ),
    // ...
  ),
],
```

Step 1-4: add assets in [pubspec.yaml][] and prepare locale files in the [folder][flutter_i18n]

```yaml
flutter:
  # ...
  assets:
    - assets/images/
    - assets/flutter_i18n/
```

Step 3:

```dart
return SizedBox(
  child: Row(
    children: [
      //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
      //* to register the watched variable to the host to rebuild it when updating.
      //* `watchedVar.consume()` is a helper function to
      //* `touch()` itself first and then `globalConsume`.
      locale.consume(() => Text('${'app.hello'.i18n(context)} ')),
      Text('$name, '),
      //* Or use the ci18n extension
      'app.thanks'.ci18n(context),
      // ...
    ],
  ),
);
```

Step 4: [var.dart][example/lib/var.dart]

```dart
Future<void> changeLocale(BuildContext context, String countryCode) async {
  if (countryCode != locale.value) {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);
    //* Step4: Make an update to the watched variable.
    locale.value = countryCode; // will rebuild the registered widget

    await prefs.setString('locale', countryCode);
  }
}
```

&emsp; [Table of Contents]

### Case 4: Scrolling effect

[example/lib/pages/scroll_page.dart][]

Step 1: [var.dart][example/lib/var.dart]

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final opacityValue = globalWatch(0.0);
```

Step 3:

```dart
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
    //* to register the watched variable to the host to rebuild it when updating.
    return globalConsume(
      () => Container(
        color: Colors.black.withOpacity(opacityValue.value),
        // ...
      ),
    );
  }
}
```

Step 4:

```dart
class _ScrollPageState extends State<ScrollPage> {
  // ...

  @override
  void initState() {
    _scrollController.addListener(() {
      //* Step4: Make an update to the watched variable.
      opacityValue.value =
          (_scrollController.offset / 350).clamp(0, 1).toDouble();
    });
    super.initState();
  }
```

&emsp; [Table of Contents]

## Recap

- At step 1, `globalWatch(variable)` creates a watched variable from the variable.

- At step 3, create a widget and register it to the host to rebuild it when updating,
  <br> use `globalConsume(() => widget)` if the value of the watched variable is used inside the widget;
  <br>or use `watchedVar.consume(() => widget)` to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.

- At step 4, update to the `watchedVar.value` will notify the host to rebuild; or the underlying object would be a class, then use `watchedVar.ob.updateMethod(...)` to notify the host to rebuild. <br>**`watchedVar.ob = watchedVar.notify() and then return the underlying object`.**

&emsp; [Table of Contents]

## Global Get

`globalGet<T>({Object? tag})` to retrieve the watched variable from another file.

- With `globalWatch(variable)`, the watched variable will be retrieved by the `Type` of the variable, i.e. retrieve by `globalGet<Type>()`.

- With `globalWatch(variable, tag: object)`, the watched variable will be retrieved by the tag, i.e. retrieve by `globalGet(tag: object)`.

&emsp; [Table of Contents]

### Case 1: By `Type`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0);
```

`lib/pages/locale_page.dart`
[example/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by it's [Type] from `../main.dart`
    final mainInt = globalGet<int>();

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

&emsp; [Table of Contents]

### Case 2: By `tag`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount');
```

`lib/pages/locale_page.dart`
[example/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by [tag] from `../main.dart`
    final mainInt = globalGet('tagCount');

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

<br>

### **Note**

- **Make sure the watched variable is initialized, only after the page is loaded.**

- **When using `Type` to retrieve the watched variable, only the first one of the `Type` is returned.**

> Or put the watched variables into a file and then import it.

&emsp; [Table of Contents]

## Global Broadcast

- `globalBroadcast()`, to broadcast to all the globalConsume widgets.
- `globalConsumeAll(Widget Function() create, {Key? key})`, to create a widget which will be rebuilt whenever any watched variables changes are made.
- `globalFrameAspects`, a getter, to return the updated aspects.
- `globalAllAspects`, a getter, to return all the aspects that has been registered.

&emsp; [Table of Contents]

## Versions

- [Flutter Mediator][flutter_mediator]: Global Mode + Model Mode.
- [Lite][]: Global Mode only.
- [Persistence][]: Lite + built in persistence.

&emsp; [Table of Contents]

## Example: Logins to a REST server

A boilerplate example that logins to a REST server with i18n, theming, persistence and state management.

Please see the [login to a REST server example][loginrestexample] for details.

&emsp; [Table of Contents]

<br>

[table of contents]: #table-of-contents
[flutter_mediator]: https://github.com/rob333/flutter_mediator/
[lite]: https://github.com/rob333/flutter_mediator_lite/
[persistence]: https://github.com/rob333/flutter_mediator_persistence/
[persistence_use_case3]: https://github.com/rob333/flutter_mediator_persistence#case-3-locale-setting-with-built-in-persistence
[inheritedmodel]: https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
[example/lib/main.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/main.dart
[example/lib/var.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/var.dart
[example/lib/pages/list_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/list_page.dart
[example/lib/pages/locale_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/locale_page.dart
[example/lib/pages/scroll_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/scroll_page.dart
[loginrestexample]: https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management
[pubspec.yaml]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/pubspec.yaml
[flutter_i18n]: https://github.com/rob333/flutter_mediator_lite/tree/main/example/assets/flutter_i18n

## Flow chart

<p align="center">
<div align="left">Updating:</div>
  <img src="https://raw.githubusercontent.com/rob333/flutter_mediator_lite/main/doc/images/Updating.png">
</p>
<br>

## Flutter Widget of the Week: InheritedModel explained

InheritedModel provides an aspect parameter to its descendants to indicate which fields they care about to determine whether that widget needs to rebuild. InheritedModel can help you rebuild its descendants only when necessary.

<p align="center">
<a href="https://www.youtube.com/watch?feature=player_embedded&v=ml5uefGgkaA
" target="_blank"><img src="https://img.youtube.com/vi/ml5uefGgkaA/0.jpg" 
alt="Flutter Widget of the Week: InheritedModel Explained" /></a></p>

## Changelog

Please see the [Changelog](https://github.com/rob333/flutter_mediator_lite/blob/main/CHANGELOG.md) page.

<br>

## License

Flutter Mediator Lite is distributed under the MIT License. See [LICENSE](https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE) for more information.

&emsp; [Table of Contents]
