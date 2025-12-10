abstract class Regex {
  static const email =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  static const alpha = r'^[a-zA-Z]+$';
  static const numeric = r'^-?[0-9]+$';
  static const alphanumeric = r'^[a-zA-Z0-9]+$';
  static const base64 =
      r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$';

  /// This regex will enforce these rules:
  ///
  /// - At least one upper case English letter, `(?=.*?[A-Z])`
  /// - At least one lower case English letter, `(?=.*?[a-z])`
  /// - At least one digit, `(?=.*?[0-9])`
  /// - At least one special character, `(?=.*?[#?!@$%^&*-])`
  /// - Minimum eight in length `.{8,}` (with the anchors)
  static const password8 =
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$";

  /// This regex will enforce these rules:
  ///
  /// - At least one upper case English letter, `(?=.*?[A-Z])`
  /// - At least one lower case English letter, `(?=.*?[a-z])`
  /// - At least one digit, `(?=.*?[0-9])`
  /// - At least one special character, `(?=.*?[#?!@$%^&*-])`
  /// - Minimum six in length `.{6,}` (with the anchors)
  static const password6 =
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$";

  /// Regex for name which only accepts alphabets and spaces. Min: 2 & Max: 80.
  static const name = r'^[a-zA-Z ]{2,80}$';
}
