import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  
  const AppIconButton({ 
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    super.key, 
  });

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    icon: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: icon,
    ),
  );
}