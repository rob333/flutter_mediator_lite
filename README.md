# Flutter Mediator Lite

Lite:
[![Pub](https://img.shields.io/pub/v/flutter_mediator_lite.svg)](https://pub.dev/packages/flutter_mediator_lite)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg)](https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator_lite/actions)
&nbsp; &nbsp;
Flutter Mediator:
[![Pub](https://img.shields.io/pub/v/flutter_mediator.svg)](https://pub.dev/packages/flutter_mediator)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator.svg)](https://github.com/rob333/flutter_mediator/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator/actions)

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

## Setting up

Add the following dependency to pubspec.yaml of your flutter project:

```yaml
dependencies:
  flutter_mediator_lite: "^1.0.0"
```

Import flutter_mediator_lite in files that will be used:

```dart
import 'package:flutter_mediator_lite/mediator.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).

<br />

## Steps:

1. Declare the watched variable with `globalWatch`.
   <br>**Suggest to put the watched variables into a file [var.dart][example/lib/var.dart] and then import it.**

2. Create the host with `globalHost` at the top of the widget tree.

3. Create a widget with `globalConsume` or `watchedVar.consume` to register the watched variable to the host to rebuild it when updating.

4. Make an update to the watched variable, by `watchedVar.value` or `watchedVar.ob.updateMethod(...)`.

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
void main() {
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

<br>

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

<br>

### Case 3: Locale setting

[example/lib/pages/locale_page.dart][]

Step 1: [var.dart][example/lib/var.dart]

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final locale = globalWatch('en');
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

      // ...
    ],
  ),
);
```

Step 4:

```dart
Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
  locale.value = countryCode;
}
```

<br>

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

<br>

## Recap

- At step 1, `globalWatch(variable)` creates a watched variable from the variable.

- At step 3, create a widget and register it to the host to rebuild it when updating,
  <br> use `globalConsume(() => widget)` if the value of the watched variable is used inside the widget;
  <br>or use `watchedVar.consume(() => widget)` to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.

- At step 4, update to the `watchedVar.value` will notify the host to rebuild; or the underlying object would be a class, then use `watchedVar.ob.updateMethod(...)` to notify the host to rebuild. <br>**`watchedVar.ob = watchedVar.notify() and then return the underlying object`.**

<br>

## Global Get

`globalGet<T>({Object? tag})` to retrieve the watched variable from another file.

- With `globalWatch(variable)`, the watched variable will be retrieved by the `Type` of the variable, i.e. retrieve by `globalGet<Type>()`.

- With `globalWatch(variable, tag: object)`, the watched variable will be retrieved by the tag, i.e. retrieve by `globalGet(tag: object)`.

<br>

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

<br>

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

<br>

## Global Broadcast

- `globalBroadcast()`, to broadcast to all the globalConsume widgets.
- `globalConsumeAll(Widget Function() create, {Key? key})`, to create a widget which will be rebuilt whenever any watched variables changes are made.
- `globalFrameAspects`, a getter, to return the updated aspects.
- `globalAllAspects`, a getter, to return all the aspects that has been registered.

<br>
<br>

[flutter_mediator]: https://github.com/rob333/flutter_mediator/
[inheritedmodel]: https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
[example/lib/main.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/main.dart
[example/lib/var.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/var.dart
[example/lib/pages/list_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/list_page.dart
[example/lib/pages/locale_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/locale_page.dart
[example/lib/pages/scroll_page.dart]: https://github.com/rob333/flutter_mediator_lite/blob/main/example/lib/pages/scroll_page.dart

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

<br />

## License

Flutter Mediator Lite is distributed under the MIT License. See [LICENSE](https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE) for more information.
