import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'rx/rx_impl.dart';

/// Global area
typedef PublishFn = void Function([Object aspects]);

PublishFn? _globalPublish;
PublishFn get globalPublish => _globalPublish!;

HashSet<Object>? _globalAllAspects;
HashSet<Object>? _globalFrameAspects;

/// Return the updated aspects.
HashSet<Object> get globalFrameAspects => _globalFrameAspects!;

/// Return all the aspects that has been registered.
HashSet<Object> get globalAllAspects => _globalAllAspects!;

///

/// Class `Host` handles the registration of widget aspects.
/// And rebuild widgets with aspects when updating.
@immutable
class Host extends StatefulWidget {
  const Host({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  /// Register widget to the Host, and add aspects to the [regAspects]
  /// return the [TModel]
  static void register(
    BuildContext context, {
    Iterable<Object>? aspects,
  }) {
    if (aspects == null || aspects.isEmpty) {
      InheritedMediator.inheritFrom<InheritedMediator>(context);
      // aspects is null, no need to `addRegAspects`
    }

    InheritedMediator.inheritFrom<InheritedMediator>(context, aspect: aspects);
    final inheritedModel = InheritedMediator.inheritFrom<InheritedMediator>(
      context,
      aspect: aspects,
    );
    assert(inheritedModel != null);
    final state = inheritedModel!._state;
    state.addRegAspects(aspects);
  }

  @override
  _HostState createState() => _HostState(child);
}

class _HostState extends State<Host> {
  _HostState(this.child);

  final Widget child;

  // All aspects that has been registered.
  final _regAspects = HashSet<Object>();
  // Aspects to be updated in this frame time.
  final _frameAspects = HashSet<Object>();

  /// Add [aspects] to the registered aspects of the model
  void addRegAspects(Iterable<Object>? aspects) {
    if (aspects != null) {
      _regAspects.addAll(aspects);
    }
  }

  /// To `setState()` of the [Host] when any aspect publishs,
  /// to rebuild the descendant widgets by aspects.
  void _frameAspectListener([Object? aspects]) {
    setState(() {
      /// Add aspects into [_frameAspects]
      final element = context as StatefulElement;
      if (!element.dirty) {
        /// The widget is in a new frame time,
        /// clear previous processed frame aspects.
        _frameAspects.clear();
      }

      if (aspects == null) {
        /// If aspect == null, then update all aspects.
        _frameAspects.addAll(_regAspects);
      } else if (aspects is Iterable<Object>) {
        _frameAspects.addAll(aspects);
      } else if (aspects is RxImpl) {
        _frameAspects.addAll(aspects.rxAspects);
      } else {
        _frameAspects.add(aspects);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _globalPublish = _frameAspectListener;
    _globalFrameAspects = _frameAspects;
    _globalAllAspects = _regAspects;
  }

  @override
  void dispose() {
    _globalPublish = null;
    _globalFrameAspects = null;
    _globalAllAspects = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedMediator(
      state: this,
      frameAspect: _frameAspects,
      child: child,
    );
  }
}

/// The [InheritedModel] subclass that is rebuilt by [_HostState].
/// The aspect type is always  `Object`.
class InheritedMediator extends InheritedWidget {
  /// Creates an inherited model that supports dependencies qualified by
  /// "aspects", i.e. a descendant widget can indicate that it should
  /// only be rebuilt if a specific aspect of the model changes.
  const InheritedMediator({
    Key? key,
    required _HostState state,
    required HashSet<Object> frameAspect,
    required Widget child,
  })   : _state = state,
        _frameAspects = frameAspect,
        super(key: key, child: child);

  final _HostState _state;
  final HashSet<Object> _frameAspects;

  // _HostState get state => _state;

  @override
  InheritedMediatorElement createElement() => InheritedMediatorElement(this);

  @override
  bool updateShouldNotify(InheritedMediator oldWidget) => true;

  /// Return true if the changes between this model and [oldWidget] match any
  /// of the [dependencies].
  @protected
  bool updateShouldNotifyDependent(
      InheritedMediator oldWidget, HashSet<Object> dependencies) {
    return dependencies.intersection(_frameAspects).isNotEmpty;
  }

  /*
   *
   * clone from the `inherited_model.dart`
   * 
  */

  // The [result] will be a list of all of context's type T ancestors concluding
  // with the one that supports the specified model [aspect].
  static void _findModels<T extends InheritedMediator>(
      BuildContext context, Object aspect, List<InheritedElement> results) {
    final InheritedElement? model =
        context.getElementForInheritedWidgetOfExactType<T>();
    if (model == null) return;

    results.add(model);

    assert(model.widget is T);
    // final T modelWidget = model.widget as T;
    // if (modelWidget.isSupportedAspect(aspect)) return; // always true
    return;

    /* never got here
    Element modelParent;
    model.visitAncestorElements((Element ancestor) {
      modelParent = ancestor;
      return false;
    });
    if (modelParent == null) return;

    _findModels<T>(modelParent, aspect, results);
    */
  }

  /// Makes [context] dependent on the specified [aspect] of an [InheritedModel]
  /// of type T.
  ///
  /// When the given [aspect] of the model changes, the [context] will be
  /// rebuilt. The [updateShouldNotifyDependent] method must determine if a
  /// change in the model widget corresponds to an [aspect] value.
  ///
  /// The dependencies created by this method target all [InheritedModel] ancestors
  /// of type T up to and including the first one.
  ///
  /// If [aspect] is null this method is the same as
  /// `context.dependOnInheritedWidgetOfExactType<T>()`.
  ///
  /// If no ancestor of type T exists, null is returned.
  static T? inheritFrom<T extends InheritedMediator>(BuildContext context,
      {Iterable<Object>? aspect}) {
    if (aspect == null) return context.dependOnInheritedWidgetOfExactType<T>();

    // Create a dependency on all of the type T ancestor models up until
    // a model is found.
    final models = <InheritedElement>[];
    _findModels<T>(context, aspect, models);
    if (models.isEmpty) {
      return null;
    }

    final InheritedElement lastModel = models.last;
    for (final InheritedElement model in models) {
      final value =
          context.dependOnInheritedElement(model, aspect: aspect) as T;
      if (model == lastModel) return value;
    }

    assert(false);
    return null;
  }
}

/// An [Element] that uses a [InheritedMediator] as its configuration.
/// Aspect type is always `Object`.
class InheritedMediatorElement extends InheritedElement {
  /// Creates an element that uses the given widget as its configuration.
  InheritedMediatorElement(InheritedMediator widget) : super(widget);

  @override
  InheritedMediator get widget => super.widget as InheritedMediator;

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final HashSet<Object>? dependencies =
        getDependencies(dependent) as HashSet<Object>?;
    if (dependencies != null && dependencies.isEmpty) return;

    if (aspect == null) {
      setDependencies(dependent, HashSet<Object>());
    } else {
      /// Modified: `add` to `addAll`
      // assert(aspect is Object);
      // setDependencies(dependent,
      //     (dependencies ?? HashSet<Object>())..add(aspect as Object));

      assert(
          aspect is Iterable<Object>, 'Aspect to inherit should be Iterable.');
      setDependencies(
          dependent,
          (dependencies ?? HashSet<Object>())
            ..addAll(aspect as Iterable<Object>));
    }
  }

  @override
  void notifyDependent(InheritedMediator oldWidget, Element dependent) {
    final HashSet<Object>? dependencies =
        getDependencies(dependent) as HashSet<Object>?;
    if (dependencies == null) return;
    if (dependencies.isEmpty ||
        widget.updateShouldNotifyDependent(oldWidget, dependencies))
      dependent.didChangeDependencies();
  }
}
