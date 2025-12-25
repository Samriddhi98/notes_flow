import 'package:flutter/material.dart';
import 'package:notes_flow/l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  void showSnackbar(Widget content) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);
    scaffoldMessenger.showSnackBar(SnackBar(content: content));
  }
}
