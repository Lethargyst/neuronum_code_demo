import 'dart:convert';

import 'package:common/bloc/onlyoffice_bloc/onlyoffice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/widgets/app_bar/app_bar.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

part 'views/error_view.dart';
part 'views/loading_view.dart';
part 'views/success_view.dart';

class OnlyofficeScreenView extends StatefulWidget {
  const OnlyofficeScreenView({super.key});

  @override
  State<OnlyofficeScreenView> createState() => _OnlyofficeScreenViewState();
}

class _OnlyofficeScreenViewState extends State<OnlyofficeScreenView> {
  final ValueNotifier<String> _iframePointerEventsNotifier = ValueNotifier('auto');

  void _onDateRangePicked(DateTime startDate, DateTime endDate) =>
    context.read<OnlyofficeBloc>().add(GetConfigEvent(startDate: startDate, endDate: endDate));

  void _onPreventHtmlGestures(bool value) {
    _iframePointerEventsNotifier.value = value ? 'none' : 'auto';
  }

  @override
  void dispose() {
    _iframePointerEventsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: CustomAppBar.onlyoffice(
        onDateRangePicked: _onDateRangePicked,
        onPreventHtmlGestures: _onPreventHtmlGestures,
      ),
      body: BlocBuilder<OnlyofficeBloc, OnlyofficeState>(
        builder: (_, state) => switch (state) {
          SuccessState() => _SuccessView(iframePointerEventsNotifier: _iframePointerEventsNotifier),
          FailureState() => const _ErrorView(),
          LoadingState() => const _LoadingView(),
        },
      ),
    ),
  );
}
