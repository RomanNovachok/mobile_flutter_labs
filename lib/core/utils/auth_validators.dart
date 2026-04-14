class AuthValidators {
  static final _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final _nameRegex = RegExp(
    r"^[a-zA-ZА-ЩЬЮЯЄІЇҐа-щьюяєіїґ'\-\s]+$",
  );

  static bool isValidEmail(String value) => _emailRegex.hasMatch(value);

  static bool isValidName(String value) =>
      value.isNotEmpty && _nameRegex.hasMatch(value);

  static bool isValidPassword(String value) => value.length >= 6;
}
