import 'dart:io';

import 'package:meta/meta.dart';
import 'package:gatabank/constants/const.dart';
import 'package:gatabank/data/local/storage.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/services/api.dart';

abstract class BaseUserRepository {
  Future<User> authenticate({
    @required String email,
    @required String password,
  });

  Future<User> getUser();

  Future<User> signup(
      {@required String email,
        @required String password,
        @required String confirmPassword,
        String referralCode});

  User currentUser();

  Future<String> sendOTP(
      {@required String recaptchaToken, @required String phone, @required String countryCode});

  Future<bool> checkOTP({@required String code, @required String firebaseSID});

  Future<bool> sendEmaiVerificationCode();

  Future<bool> checkEmailVerificationCode({
    @required code,
  });

  Future<User> updateUser(User user);

  Future<bool> logout();

  Future<bool> addFcmToken({@required fcmToken});

  Future<bool> checkEmailExist({@required email});

  Future<bool> checkPhoneExist({@required countryCode, @required phone});

  Future<bool> sendAuthenticationCodeForEmail({@required email, @required resend});

  Future<bool> checkAuthenticationCodeAndEmail({@required email, @required authenticationCode});

  Future<bool> resetPwd(
      {@required email,
        @required authenticationCode,
        @required newPassword,
        @required confirmNewPassword});
}

class UserRepository extends BaseUserRepository {
  final BaseAPI api;

  UserRepository({
    @required this.api,
  })  : assert(api != null);

  /// Auth [email], [password]
  ///
  /// Response token if success. Otherwise throw error.
  Future<User> authenticate({
    @required String email,
    @required String password,
  }) async {
    var response = await api.auth(email, password);
    if (response.statusCode != 200) {
      return null;
    }

    Map<String, dynamic> map = response.data;
    String token = map['Result']['Token'];
    if (token.isNotEmpty) {
      await utils.saveSecureData(CONST.JWT_TOKEN, token);
      return await getUser();
    }

    return null;
  }

  Future<User> updateUser(User user) async {
    var response = await api.updateUser(user);
    return _handleUserData(response);
  }

  Future<User> getUser() async {
    var response = await api.userInfo();
    return _handleUserData(response);
  }

  Future<User> _handleUserData(var response) async {
    var map = response.data;
    User user = User.fromJson(map['Result']);
    storage.saveUser(user);
    // save to keystore
    await utils.saveSecureData(CONST.CRYPTO_PASSPHASE, map['Result'][User.KEY_CRYPTO_PASS_PHASE]);
    return user;
  }

  /// register a new user with [NotVerified], [Password], and [ConfirmPassword]
  ///
  /// response user info if success. Otherwise throw error.
  Future<User> signup(
      {@required String email,
        @required String password,
        @required String confirmPassword,
        String referralCode}) async {
    var response = await api.signup(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        referralCode: referralCode);

    if (response.statusCode != 200) {
      return null;
    }

    return await authenticate(email: email, password: password);
  }

  User currentUser() {
    return storage.getUser();
  }

  /// clean [user] session
  ///
  /// return true.
  Future<bool> logout() async {
    await utils.deleteSecureData(CONST.JWT_TOKEN);
    await storage.clearUserPref();
    return true;
  }

  @override
  Future<bool> addFcmToken({@required fcmToken}) async {
    var response = await api.addFcmToken(await utils.getToken(), fcmToken);
    return response.statusCode != HttpStatus.ok;
  }

  /// check [email] exist or not.
  ///
  /// return true if exist. Otherwise is false.
  @override
  Future<bool> checkEmailExist({@required email}) async {
    try {
      var response = await api.checkEmailExist(
        email,
      );

      if (response.statusCode != HttpStatus.ok) {
        return false;
      }

      Map<String, dynamic> map = response.data;
      bool result = map['Result'];
      return result;
    } catch (e) {
      return false;
    }
  }

  /// send authentication code to [email]
  ///
  /// return true/false.
  @override
  Future<bool> sendAuthenticationCodeForEmail({email, resend}) async {
    var response = await api.sendAuthenticationCode(
      email,
      resend,
    );

    if (response.statusCode != HttpStatus.ok) {
      return false;
    }

    Map<String, dynamic> map = response.data;
    bool result = map['Result'];
    return result;
  }

  /// check [authentication code] and [email] are valid or not
  ///
  /// return true/false.
  @override
  Future<bool> checkAuthenticationCodeAndEmail({email, authenticationCode}) async {
    try {
      var response = await api.checkAuthenticationCode(
        email,
        authenticationCode,
      );

      if (response.statusCode != HttpStatus.ok) {
        return false;
      }

      Map<String, dynamic> map = response.data;
      bool result = map['Result'];
      return result;
    } catch (e) {
      return false;
    }
  }

  /// reset [email] with [new password]
  ///
  /// return true/false.
  @override
  Future<bool> resetPwd({email, authenticationCode, newPassword, confirmNewPassword}) async {
    var response = await api.resetPwd(email, authenticationCode, newPassword, confirmNewPassword);

    return _handleResult(response);
  }

  Future<bool> _handleResult(var response) async {
    if (response.statusCode != HttpStatus.ok) {
      return false;
    }

    Map<String, dynamic> map = response.data;
    bool result = map['Result'];
    return result;
  }

  @override
  Future<String> sendOTP({String recaptchaToken, String phone, String countryCode}) async {
    var response = await api.sendOTP(recaptchaToken, phone, countryCode);
    Map<String, dynamic> map = response.data;
    return map['Result']['firebase_sid'];
  }

  @override
  Future<bool> checkOTP({String code, String firebaseSID}) async {
    var response = await api.checkOTP(code, firebaseSID);
    Map<String, dynamic> map = response.data;
    return map['Result'] != null;
  }

  @override
  Future<bool> checkEmailVerificationCode({code}) async {
    var response = await api.checkEmailVerificationCode(code);
    Map<String, dynamic> map = response.data;
    return map['Result'] != null;
  }

  @override
  Future<bool> sendEmaiVerificationCode() async {
    var response = await api.sendEmailVerificationCode();
    Map<String, dynamic> map = response.data;
    return map['Result'] != null;
  }

  @override
  Future<bool> checkPhoneExist({countryCode, phone}) async {
    var response = await api.checkPhoneExist(countryCode, phone);
    return _handleResult(response);
  }
}
