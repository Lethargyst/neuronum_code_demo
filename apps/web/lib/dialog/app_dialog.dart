import 'dart:ui';

import 'package:common/bloc/dashboard_group_bloc/dashboard_group_bloc.dart';
import 'package:common/bloc/filters_bloc/filters_bloc.dart';
import 'package:domain/entity/common/filter.dart';
import 'package:domain/entity/time_range/time_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/screens/project/dashboards_screen/widgets/bar_chart_group_slider.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/icon_button.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/errors/somethig_went_wrong.dart';
import 'package:lvm_telephony_web/widgets/filters/filters_list.dart';

part 'views/dashboard_group.dart';

class AppDialog {
  static final _instance = AppDialog._();

  factory AppDialog() => _instance;

  AppDialog._();

  Future<dynamic> _show({
    required BuildContext context,
    required Widget child,
    bool dismissable = true,
    bool useRootNavigator = false,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: dismissable,
        useRootNavigator: useRootNavigator,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: child,
        ),
      );

  Future<dynamic> dashnoardGroup({
    required BuildContext context,
    required DashboardGroupBloc groupBloc,
    required FiltersBloc filtersBloc,
    int currentSlide = 0,
  })
    => _show(
      context: context,
      child: _DashboardGroup(
        groupBloc: groupBloc,
        filtersBloc: filtersBloc,
        currentSlide: currentSlide,
      ),
    );
}
