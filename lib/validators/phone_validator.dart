class PhoneValidator {
  static String validate(String value) {
    String pattern = r'(^\d{4,12}$)';
    RegExp regExp = new RegExp(pattern);
    return value.length == 0 || !regExp.hasMatch(value) ? 'Số điện thoại không hợp lệ' : null;
  }
}
