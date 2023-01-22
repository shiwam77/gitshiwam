
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model.dart';

/// The MVVM builder widget.
class MVVM<T extends ViewModel> extends StatefulWidget {

  final Widget Function(BuildContext, T) view;
  final T viewModel;
  final bool disposeVM;
  final bool initOnce;
  final bool implicitView;

  const MVVM({
    Key? key,
    required this.view,
    required this.viewModel,
    this.disposeVM = true,
    this.implicitView = true,
    this.initOnce = false,
  }) : super(key: key);

  @override
  _MVVMState<T> createState() => _MVVMState<T>();
}

class _MVVMState<T extends ViewModel> extends State<MVVM<T>> with WidgetsBindingObserver {
  late T _vm;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _vm = widget.viewModel;
    _vm.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _vm.onResume();
    } else if (state == AppLifecycleState.inactive) {
      _vm.onInactive();
    } else if (state == AppLifecycleState.paused) {
      _vm.onPause();
    } else if (state == AppLifecycleState.detached) {
      _vm.onDetach();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (identical(_vm, widget.viewModel)) {
      _vm = widget.viewModel;
    }

    _vm.context = context;

    if (widget.initOnce && !_initialised) {
      _vm.init();
      _initialised = true;
    } else if (!widget.initOnce) {
      _vm.init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _vm.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vm.onBuild();

    // if (widget.implicitView) {
    //   if (!widget.disposeVM) {
    //     print("#### In 1  ####");
    //     return ChangeNotifierProvider<T>.value(value: _vm, child: widget.view(context, _vm));
    //   }
    //   print("#### In 2  ####");
    //   return ChangeNotifierProvider<T>(create: (_) => _vm, child: widget.view(context, _vm));
    // }
    //
    // if (!widget.disposeVM) {
    //   print("#### In Disposevm  ####");
    //   return ChangeNotifierProvider<T>.value(
    //     value: _vm,
    //     child: Consumer<T>(
    //       builder: (context, vm, _) => widget.view(context, vm),
    //     ),
    //   );
    // }
    //
    // print("#### In ChangeNotifierProvider  ####");
    // return ChangeNotifierProvider<T>(
    //   create: (_) => _vm,
    //   child: Consumer<T>(
    //     builder: (context, vm, _) => widget.view(context, vm),
    //   ),
    // );
    return ChangeNotifierProvider<T>.value(value: _vm, child: widget.view(context, _vm));
  }
}
