import 'package:flutter/material.dart';
import 'package:flutter_mediator_lite/mediator.dart';

final locale = globalWatch(0);

final hello = [
  'Hello',
  'Bonjour',
];

void main() {
  runApp(
    LocaleTestApp(),
  );
}

class LocaleTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return globalHost(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Mediator Locale Test',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globalConsume(
        () => Text(hello[locale.value]),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //* Stet4: Make an update to the watched variable.
            onPressed: () => updateLocale(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}

void updateLocale() {
  locale.value++;
  if (locale.value >= hello.length) {
    locale.value = 0;
  }
}
