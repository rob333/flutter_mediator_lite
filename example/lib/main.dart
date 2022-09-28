import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mediator_lite/mediator.dart';

import 'pages/list_page.dart';
import 'pages/locale_page.dart';
import 'pages/scroll_page.dart';
//* Step1: import the var.dart
import 'var.dart';
import 'widgets/bottom_navigation_controller.dart';
import 'widgets/widget_extension.dart';

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

final bottomNavItems = [
  const BottomNavigationBarItem(
    label: 'Int',
    icon: Icon(Icons.lightbulb_outline),
    activeIcon: Icon(Icons.library_books),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'List',
    icon: Icon(Icons.new_releases),
    activeIcon: Icon(Icons.payment),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'Locale',
    icon: Icon(Icons.local_cafe),
    activeIcon: Icon(Icons.local_cafe_outlined),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'Scroll',
    icon: Icon(Icons.info_outline),
    activeIcon: Icon(Icons.inbox),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
];
final navPages = [
  const IntPage(),
  const ListPage(),
  const LocalePage(),
  const ScrollPage(),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Mediator Lite Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNavigationWidget(
        pages: navPages,
        bottomNavItems: bottomNavItems,
        selectedColor: Colors.amber[800]!,
        backgroundColor: Colors.black54.withOpacity(0.5),
        selectedIndex: 0,
      ),
      // add flutter_i18n support
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            forcedLocale: Locale(locale.value),
            // useCountryCode: true,
            fallbackFile: DefaultLocale,
            basePath: 'assets/flutter_i18n',
            decodeStrategies: [JsonDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {
            print(
                '--- Missing Key: $key, languageCode: ${locale!.languageCode}');
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class IntPage extends StatelessWidget {
  const IntPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Int Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          //* Step3: Create a consume widget with
          //* `globalConsume` or `watchedVar.consume` to register the
          //* watched variable to the host to rebuild it when updating.
          globalConsume(
            () => Text(
              '${touchCount.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ).center(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //* Stet4A: Make an update to the watched variable.
            onPressed: () => touchCount.value++,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            //* Stet4B: Make an update to the watched variable.
            onPressed: () => touchCount.value--,
            tooltip: 'decrement',
            child: const Icon(
              Icons.remove,
              color: Colors.deepOrange,
            ),
            heroTag: null,
          )
        ],
      ),
    );
  }
}
