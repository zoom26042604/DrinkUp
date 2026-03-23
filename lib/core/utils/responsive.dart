import 'package:flutter/material.dart';

/// Returns true if the screen width is >= 600 (tablet).
bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= 600;

/// Returns [tabletValue] on tablet, [phoneValue] on phone.
T rv<T>(BuildContext context, {required T phone, required T tablet}) =>
    isTablet(context) ? tablet : phone;
