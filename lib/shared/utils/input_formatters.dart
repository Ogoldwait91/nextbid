import "package:flutter/services.dart";

/// Force uppercase for inputs like JSS rows or crew code.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

/// Allowed characters for JSS rows (keeps typing valid).
final RegExp jssAllowedChars = RegExp(r"[A-Z0-9 _+\-.,/:()#=\\]");
final FilteringTextInputFormatter jssRowFilter =
    FilteringTextInputFormatter.allow(jssAllowedChars);

/// Letters/digits only for crew code.
final FilteringTextInputFormatter crewCodeFilter =
    FilteringTextInputFormatter.allow(RegExp(r"[A-Z0-9]"));
