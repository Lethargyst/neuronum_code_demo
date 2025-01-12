import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lvm_telephony_web/widgets/cards/floating_card.dart';

Future<void> showFlushbar(BuildContext context, {required String message}) => Flushbar<void>(
    backgroundColor: Colors.black.withOpacity(0),
    messageText: FloatingCard(title: message),
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);