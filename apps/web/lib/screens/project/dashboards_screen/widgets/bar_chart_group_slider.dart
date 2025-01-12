import 'package:carousel_slider/carousel_slider.dart';
import 'package:common/bloc/dashboard_group_bloc/dashboard_group_bloc.dart';
import 'package:common/bloc/filters_bloc/filters_bloc.dart';
import 'package:core/typedefs.dart';
import 'package:domain/entity/common/dashboards/dashboard_group/dashboard_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lvm_telephony_web/dialog/app_dialog.dart';
import 'package:lvm_telephony_web/screens/project/dashboards_screen/widgets/bar_chart_dashboard.dart';
import 'package:lvm_telephony_web/screens/project/dashboards_screen/widgets/bar_chart_dashboard_slim.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/buttons/icon_button.dart';
import 'package:lvm_telephony_web/widgets/common/spacers.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

class BarChartGroupSlider extends StatefulWidget {
  final DashboardGroup group;
  final bool slim;
  final int initialSlide;
  final IntCallback? onSlideChanged;

  const BarChartGroupSlider({ 
    required this.group,
    this.slim = true,
    this.initialSlide = 0,
    this.onSlideChanged,
    super.key, 
  });

  @override
  State<BarChartGroupSlider> createState() => _BarChartGroupSliderState();
}

class _BarChartGroupSliderState extends State<BarChartGroupSlider> {
  final _carouselController = CarouselSliderController();
  late int _currentSlide = widget.initialSlide;

  Future<void> _onDashboardTap(int index) => AppDialog().dashnoardGroup(
    context: context, 
    groupBloc: context.read<DashboardGroupBloc>(),
    filtersBloc: context.read<FiltersBloc>(),
    currentSlide: _currentSlide,
  );

  Future<void> _toPreviuos() async {
    if (_currentSlide == 0) return;
    await _carouselController.previousPage();
    widget.onSlideChanged?.call(_currentSlide);
    _currentSlide -= 1;
  }

  Future<void> _toNext() async {
    if (_currentSlide == widget.group.dashboards.length - 1) return;
    await _carouselController.nextPage();
    widget.onSlideChanged?.call(_currentSlide);
    _currentSlide += 1;
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (widget.group.dashboards.length > 1)
        AppIconButton(
          onTap: _toPreviuos,
          backgroundColor: context.theme.colorScheme.tertiary,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.theme.colorScheme.primary,
          ),
        ),
      Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: !widget.slim 
                  ? context.theme.colorScheme.tertiary
                  : null,
              ),
              child: AppText.large(
                context: context, 
                text: widget.group.name,
                color: context.theme.colorScheme.onPrimary,
              ),
            ),

            const SpacerV(8),

            Flexible(
              child: CarouselSlider.builder(
                itemCount: widget.group.dashboards.length,
                carouselController: _carouselController,
                disableGesture: true,
                itemBuilder: (_, index, __) {
                  if (widget.slim) {
                    return BarChartDasboardSlim(
                      dashboard: widget.group.dashboards[index],
                      onTap: () async => _onDashboardTap(index),
                    ); 
                  }
              
                  return BarChartDasboard(
                    dashboard: widget.group.dashboards[index],
                    onTap: () async => _onDashboardTap(index),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: _currentSlide,
                ),
              ),
            ),
          ],
        ),
      ),
      if (widget.group.dashboards.length > 1)
        AppIconButton(
          onTap: _toNext,
          backgroundColor: context.theme.colorScheme.tertiary,
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: context.theme.colorScheme.primary,
          ),
        ),
    ],
  );
}