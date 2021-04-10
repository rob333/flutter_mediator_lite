import 'package:flutter/widgets.dart';
import 'package:flutter_mediator_lite/mediator.dart';

import '../assert.dart';
import '../global.dart';

/// A proxy object class, for variables to turn into a watched one.
class RxImpl<T> {
  /// Constructor: add self to the static rx container
  /// and sholud use [setPub] to set the [Pub] when the model initialized.
  RxImpl(this._value) {
    // RxImpl(T initial) : _value = initial {
    ///
    /// variables and constructor calling sequence:
    /// 1. Model inline variables ->
    /// 2. Pub inline variables ->
    /// 3. Pub constructor ->
    /// 4. Model constructor

    _initRxTag();
  }

  T _value; // the underlying value with template type T

  //* region member variables
  final rxAspects = <Object>{}; // aspects attached to this rx variable
  bool _isNullBroadcast = false; // if this rx variable is broadcasting

  /// static aspects and the flag of if enabled
  static Iterable<Object>? stateWidgetAspects;
  static bool stateWidgetAspectsFlag = false;

  /// enable auto add static aspects to aspects of rx - by getter
  static void enableCollectAspect(Iterable<Object>? widgetAspects) {
    stateWidgetAspects = widgetAspects;
    stateWidgetAspectsFlag = true;
  }

  /// disable auto add static aspects to aspects of rx - by getter
  static void disableCollectAspect() {
    stateWidgetAspects = null;
    stateWidgetAspectsFlag = false;
  }
  //! endregion

  //* region static rx auto aspect section
  static int rxTagCounter = 0;
  static int _nextRxTag() {
    assert(ifTagMaximum(rxTagCounter));
    // return numToString128(rxTagCounter++); // As of v2.1.2+3 changes to `int` tag.
    return rxTagCounter++;
  }

  static bool stateRxAutoAspectFlag = false;
  static List<Object> stateRxAutoAspects = [];

  static void enableRxAutoAspect() => stateRxAutoAspectFlag = true;
  static void disableRxAutoAspect() => stateRxAutoAspectFlag = false;
  static List<Object> getRxAutoAspects() => stateRxAutoAspects;
  static void clearRxAutoAspects() => stateRxAutoAspects.clear();
  // get RxAutoAspects and disable RxAutoAspectFlag
  static List<Object> getAndDisableRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    return stateRxAutoAspects;
  }

  /// disable RxAutoAspectFlag And clear RxAutoAspects
  static void disableAndClearRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    stateRxAutoAspects.clear();
  }
  //! endregion

  /// getter: Return the value of the underlying object.
  T get value {
    // if rx automatic aspect is enabled. (precede over state rx aspect)
    if (stateRxAutoAspectFlag == true) {
      touch(); // Touch to activate rx automatic aspect management.
      //
    } else if (stateWidgetAspectsFlag == true) {
      if (stateWidgetAspects != null) {
        rxAspects.addAll(stateWidgetAspects!);
      } else {
        _isNullBroadcast = true;
      }
    }

    return _value;
  }

  /// setter: Set the value of the underlying object.
  set value(T value) {
    if (_value != value) {
      _value = value;
      publishRxAspects();
    }
  }

  /// Notify the host to rebuild and then return the underlying object.
  /// Suitable for class type _value, like List, Map, Set, classes
  /// To inform the value to update.
  /// Like if the value type is a List, you can do `var.ob.add(1)` to notify the host to rebuild.
  /// Or, you can manually notify the host to rebuild by `var.value.add(1); var.notify();`.
  T get ob {
    publishRxAspects();
    return _value;
  }

  /// Touch to activate rx automatic aspect management.
  void touch() {
    // add the _tag to the rx automatic aspect list,
    // for later getRxAutoAspects() to register to host
    stateRxAutoAspects.addAll(rxAspects);
  }

  /// Add an unique system `tag` to the Rx object.
  void _initRxTag() {
    final tag = _nextRxTag();
    // Add the tag to the Rx Aspects list.
    rxAspects.add(tag);
    // Add the tag to the registered aspects of the `Host`.
    globalAllAspects.add(tag);
  }

  /// A helper function to `touch()` itself first and then `globalConsume`.
  Widget consume(Widget Function() create, {Key? key}) {
    final wrapFn = () {
      touch();
      return create();
    };
    return globalConsume(wrapFn, key: key);
  }

  /// Add [aspects] to the Rx aspects.
  /// param aspects:
  ///   Iterable: add [aspects] to the rx aspects
  ///   null: broadcast to the model
  /// RxImpl: add [(aspects as RxImpl).rxAspects] to the rx aspects
  ///       : add `aspects` to the rx aspects
  void addRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.addAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = true;
    } else if (aspects is RxImpl) {
      rxAspects.addAll(aspects.rxAspects);
    } else {
      rxAspects.add(aspects);
    }
  }

  /// Remove [aspects] from the Rx aspects.
  /// param aspects:
  ///   Iterable: remove [aspects] from the rx aspects
  ///   null: don't broadcast to the model
  /// RxImpl: remove [(aspects as RxImpl).rxAspects] from the rx aspects
  ///       : remove `aspects` from the rx aspects
  void removeRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.removeAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = false;
    } else if (aspects is RxImpl) {
      rxAspects.removeAll(aspects.rxAspects);
    } else {
      rxAspects.remove(aspects);
    }
  }

  /// Retain [aspects] in the Rx aspects.
  /// param aspects:
  ///   Iterable: retain rx aspects in the [aspects]
  ///     RxImpl: retain rx aspects in the [(aspects as RxImpl).rxAspects]
  ///           : retain rx aspects in the `aspects`
  void retainRxAspects(Object aspects) {
    if (aspects is Iterable) {
      rxAspects.retainAll(aspects);
    } else if (aspects is RxImpl) {
      rxAspects.retainAll(aspects.rxAspects);
    } else {
      rxAspects.retainWhere((element) => element == aspects);
    }
  }

  /// Clear all the Rx aspects.
  void clearRxAspects() => rxAspects.clear();

  // /// Copy info from another Rx variable.
  // void copyInfo(RxImpl<T> other) {
  //   _tag.addAll(other._tag);
  //   rxAspects.addAll(other.rxAspects);
  // }

  /// Publish Rx aspects to the host.
  void publishRxAspects() {
    if (_isNullBroadcast) {
      return globalPublish();
    } else if (rxAspects.isNotEmpty) {
      return globalPublish(rxAspects);
    }
  }

  /// Synonym of `publishRxAspects()`.
  void notify() => publishRxAspects();

  //* override method
  @override
  String toString() => _value.toString();
}

/// Rx<T> class
class Rx<T> extends RxImpl<T> {
  /// Constructor: With `initial` as the initial value.
  Rx(T initial) : super(initial);
}

/// Helper for all others type to Rx object.
extension RxExtension<T> on T {
  /// Returns a `Rx` instace with [this] `T` as the initial value.
  Rx<T> get rx => Rx<T>(this);
}

// /// Encode a number into a string
// String numToString128(int value) {
//   /// ascii code:
//   /// 32: space /// 33: !  (first character except space)
//   /// 48: 0
//   /// 65: A  /// 90: Z
//   /// 97: a  /// 122
//   // const int charBase = 33;
//   //'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[\\]^_`{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
//   const charBase =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[]^_`{|}~€‚ƒ„…†‡•–™¢£¤¥©®±µ¶º»¼½¾ÀÆÇÈÌÐÑÒ×ØÙÝÞßæç';
//   assert(charBase.length >= 128, 'numToString128 const charBase length < 128');

//   if (value == 0) {
//     return '#0';
//   }

//   var res = '#';

//   assert(value >= 0, 'numToString should provide positive value.');
//   // if (value < 0) {
//   //   value = -value;
//   //   res += '-';
//   // }

//   final list = <String>[];
//   while (value > 0) {
//     /// 64 group
//     // final remainder = value & 63;
//     // value = value >> 6; // == divide by 64

//     /// 128 group
//     final remainder = value & 127;
//     value = value >> 7; // == divide by 128
//     /// num to char, base on charBase
//     //final char = String.fromCharCode(remainder + charBase);
//     final char = charBase[remainder];
//     list.add(char);
//   }

//   for (var i = list.length - 1; i >= 0; i--) {
//     res += list[i];
//   }

//   return res;
// }
