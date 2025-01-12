import 'package:domain/entity/common/dashboards/dashboard_response/dashboard_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

class BarChartDasboard extends StatelessWidget {
  final DashboardResponse dashboard;
  final VoidCallback? onTap;

  const BarChartDasboard({ 
    required this.dashboard,
    this.onTap,
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    final bottomTitles = dashboard.columns.map((e) => e.valueX).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.theme.colorScheme.tertiary,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (dashboard.name != null)
            AppText.large(context: context, text: dashboard.name!),
          
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final titleWith = constraints.maxWidth / bottomTitles.length - 20;
            
                return BarChart(
                  BarChartData(
                    maxY: (dashboard.maxY * 1.1).floorToDouble(),
                    barGroups: _getGroupsData(dashboard),
                    gridData: const FlGridData(
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        axisNameSize: 50,
                        axisNameWidget: Center(
                          child: AppText.large(
                            context: context, 
                            text: dashboard.nameY,
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          maxIncluded: false,
                          getTitlesWidget: (value, meta) => 
                            _getLeftTitles(
                              context: context,
                              value: value, 
                              meta: meta, 
                            ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameSize: 50,
                        axisNameWidget: Center(
                          child: AppText.large(
                            context: context, 
                            text: dashboard.nameX,
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => 
                            _getBottomTitles(
                              context: context,
                              value: value, 
                              meta: meta, 
                              titles: bottomTitles,
                              width: titleWith,
                            ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getGroupsData(DashboardResponse dashboard) {
    final groups = <BarChartGroupData>[];

    for (var i = 0; i < dashboard.columns.length; ++i) {
      final column = dashboard.columns[i];
      final rodData = <BarChartRodData>[];

      for (final subColumn in column.subColumns) {
        rodData.add(
          BarChartRodData(
            toY: subColumn.valueY,
            width: 10,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.blueLight,
                AppColors.blueLight.withOpacity(0.6),
              ],
            ),
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