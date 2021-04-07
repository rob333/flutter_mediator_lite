import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator_lite/mediator.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount'); // main.dart

final data = globalWatch(<ListItem>[]); // list_page.dart

const DefaultLocale = 'en';
late Rx<String> locale; // local_page.dart

final opacityValue = globalWatch(0.0); // scroll_page.dart

class ListItem {
  const ListItem(
    this.item,
    this.units,
    this.color,
  );

  final String item;
  final int units;
  final Color color;
}

/// Initialize the watched variables
/// whose value is stored by SharedPreferences.
Future<void>? initVars() async {
  // To make sure SharedPreferences works.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  locale = globalWatch(prefs.getString('locale') ?? DefaultLocale);
}

/// Change the locale, by `String`[countryCode]
/// and store the setting with SharedPreferences.
Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
  locale.value = countryCode;

  await prefs.setString('locale', countryCode);
}

/// String extension for i18n.
extension StringI18n on String {
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }
}
