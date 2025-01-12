import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/theme/app_colors.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color borderColor;
  final double borderRadius;
  final bool enableBorder;
  final EdgeInsets padding;
  final TextStyle? titleStyle;
  final bool disabled;
  final bool isLoading;
  final bool isOutline;
  final String? title;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final Widget? child;
  final Widget? icon;

  const AppButton({
    required this.onTap,
    super.key,
    this.title,
    this.child,
    this.icon,
    this.buttonColor,
    this.textColor = AppColors.white,
    this.borderColor = AppColors.blue,
    this.width,
    this.borderRadius = 50,
    this.enableBorder = true,
    this.padding = const EdgeInsets.all(16),
    this.titleStyle,
    this.disabled = false,
    this.isLoading = false,
    this.isOutline = false,
  })  : assert(
          !(child == null && title == null),
          'title или child должны быть не null',
        ),
        assert(
          !(child != null && title != null),
          'title и child не могут быть не null одновременно',
        );

  factory AppButton.disabledColor({
    required VoidCallback onTap,
    String? title,
    Widget? child,
    Widget? icon,
    double? width,
    double? borderRadius,
    EdgeInsets? padding,
    bool isLoading = false,
  }) =>
      AppButton(
        onTap: onTap,
        title: title,
        borderRadius: borderRadius ?? 50,
        width: width,
        padding: padding ?? const EdgeInsets.all(16),
        textColor: AppColors.greyDark,
        buttonColor: AppColors.white,
        borderColor: AppColors.grey,
        isLoading: isLoading,
        child: child,
        icon: icon,
      );

  factory AppButton.activeColor({
    required VoidCallback onTap,
    Color? textColor,
    String? title,
    Widget? child,
    double borderRadius = 50,
    double? width = double.maxFinite,
    EdgeInsets? padding,
    bool? disabled,
    bool? isLoading,
    bool? isOutline,
    Key? key,
  }) =>
      AppButton(
        title: title,
        onTap: onTap,
        borderRadius: borderRadius,
        padding: padding ?? const EdgeInsets.all(16),
        disabled: disabled ?? false,
        isLoading: isLoading ?? false,
        width: width,
        isOutline: isOutline ?? false,
        textColor: textColor ?? ((isOutline ?? false) ? AppColors.blue : AppColors.white),
        key: key,
        child: child,
      );

  factory AppButton.icon({
    required VoidCallback onTap,
    required Widget icon,
    Color? backgroundColor,
    EdgeInsets? padding,
    bool? disabled,
    Key? key,
  }) =>
      AppButton(
        onTap: onTap,
        padding: padding ?? const EdgeInsets.all(16),
        disabled: disabled ?? false,
        key: key,
        child: icon,
        buttonColor: backgroundColor,
        borderColor: backgroundColor ?? AppColors.blue,
      );

  Color _getTextColor(BuildContext context) {
    if (disabled) return Colors.black.withOpacity(0.4);
    if (buttonColor != null) return buttonColor!;
    return context.theme.colorScheme.primary;
  }

  Color _getBodyColor(BuildContext context) => _getTextColor(context).withOpacity(0.3);

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: disabled,
    child: Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: isLoading ? null : onTap,
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            color: _getBodyColor(context),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SizedBox(
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: isLoading ? 0 : 1,
                  child: Padding(
                    padding: padding,
                    child: Builder(
                      builder: (context) {
                        if (child != null) return child!;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) 
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: icon,
                              ),
                            Flexible(
                              child: Text(
                                title!,
                                textAlign: TextAlign.center,
                                style: titleStyle ??
                                  context.theme.textTheme.labelLarge?.copyWith(
                                    color: _getTextColor(context),
                                  ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (!isLoading) return const SizedBox.shrink();
                    return SizedBox(
                      height: 24,
                      child: AppLoader(
                        color: _getTextColor(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
