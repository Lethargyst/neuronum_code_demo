import 'package:domain/entity/common/dashboards/dashboard_response/dashboard_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/dropdown/description_overlay_wrapper.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

class BarChartDasboardSlim extends StatelessWidget {
  final DashboardResponse dashboard;
  final VoidCallback? onTap;

  const BarChartDasboardSlim({ 
    required this.dashboard,
    this.onTap,
    super.key, 
  });

  @override
  Widget build(BuildContext context) => DescriptionOverlayWrapper(
    description: dashboard.groupName,
    child: Material(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          hoverColor: context.theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: context.theme.colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              child: IgnorePointer(
                child: BarChart(
                  BarChartData(
                    maxY: (dashboard.maxY * 1.1).floorToDouble(),
                    barGroups: _getGroupsData(dashboard),
                    gridData: const FlGridData(
                      drawHorizontalLine: false,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: AxisTitles(
                        axisNameWidget: dashboard.name != null
                          ? AppText.large(
                            context: context, 
                            text: dashboard.name!,
                          )
                          : null,
                      ),
                      leftTitles: const AxisTitles(),
                      bottomTitles: const AxisTitles(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
  );

  List<BarChartGroupData> _getGroupsData(DashboardResponse dashboard) {
    final groups = <BarChartGroupData>[];

    for (var i = 0; i < dashboard.columns.length; ++i) {
      final column = dashboard.columns[i];
      final rodData = <BarChartRodData>[];

      for (final subColumn in column.subColumns) {
        rodData.add(
          BarChartRodData(
            toY: subColumn.valueY,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.blueLight,
                AppColors.blueLight.withOpacity(0.6),
              ],
            ),
            width: 10,
          ),
        );
      }

      groups.add(
        BarChartGroupData(
          barsSpace: 4,
          x: i,
          barRods: rodData,
        ),
      );
    }

    return groups;
  }

  Widget _getBottomTitles({
    required BuildContext context,
    required double value, 
    required TitleMeta meta, 
    required List<String> titles,
    double width = 100,
  }) 
    => SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: SizedBox(
        width: width,
        child: AppText.bold(
          color: context.theme.colorScheme.primary,
          context: context, 
          text: titles[value.toInt()],
          ellispis: false,
        ),
      ),
    );

  Widget _getLeftTitles({
    required BuildContext context,
    required double value, 
    required TitleMeta meta,
  }) 
    => SideTitleWidget(
      axisSide: meta.axisSide,
      child: AppText.bold(
        color: context.theme.colorScheme.primary,
        context: context, 
        text: value.toString(),
        ellispis: false,
      ),
    );
}