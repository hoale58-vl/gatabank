import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gatabank/consts.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:meta/meta.dart';

import 'fcm_states.dart';

class FcmCubit extends Cubit<FcmState> {
  final UserRepository userRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FcmCubit({@required this.userRepository}) : super(FcmUninitialized());

  Future<void>  setupFcm() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        receivedFcm();
      },
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );

    _firebaseMessaging.onTokenRefresh
        .listen((token) => _saveToken(token)); // save token when it was refreshed
  }

  Future<void>  receivedFcm() async {
    emit(FcmTransactionConfirmed(transactionId: 1));
  }

  Future<void> addFcm() async {
    await _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) => _saveToken(token)); // save token after login
  }

  Future<void> removeFcm() async {
    _firebaseMessaging.deleteInstanceID();
  }

  _saveToken(String token) async {
    if (await _isTheSameToken(token)) return;
    if (userRepository.currentUser() == null) return;
    bool isAdded = await userRepository.addFcmToken(fcmToken: token);
    storage.saveBoolean(CONST.PREF_IS_FCM_TOKEN_ADDED, isAdded);
  }

  Future<bool> _isTheSameToken(String token) async {
    String lastFcmToken = storage.getString(CONST.PREF_LAST_FCM_TOKEN);
    return token == lastFcmToken;
  }
}
