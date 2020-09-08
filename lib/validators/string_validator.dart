class StringValidator {
  static String notEmpty(String value) {
    return value == null || value.isEmpty ? 'Không được bỏ trống' : null;
  }
}
