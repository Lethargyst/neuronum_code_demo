import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  StackRouter get router => AutoRouter.of(this);

  TabsRouter get tabsRouter => AutoTabsRouter.of(this);
}