import 'package:flutter/material.dart';
import 'package:gitshiwam/statemanagement/view_model.dart';
import 'package:provider/provider.dart';




/// The view of the MVVM architecture.
abstract class StatelessView<T extends ViewModel> extends StatelessWidget {
  const StatelessView({Key? key, this.reactive = true}) : super(key: key);

  final bool reactive;

  @override
  Widget build(BuildContext context) => render(context, Provider.of<T>(context, listen: reactive));

  Widget render(BuildContext context, T vm);
}
