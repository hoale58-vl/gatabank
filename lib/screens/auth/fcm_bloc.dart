import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gatabank/consts.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:meta/meta.dart';

import 'fcm_events.dart';
import 'fcm_states.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final UserRepository userRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FcmBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  FcmState get initialState => FcmUninitialized();

  @override
  Stream<FcmState> mapEventToState(FcmEvent event) async* {
    if (event is InitialFcm) {
      _setupFcm();
    } else if (event is AddFcm) {
      await _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.getToken().then((token) => _saveToken(token)); // save token after login
    } else if (event is RemoveFcm) {
      _firebaseMessaging
          .deleteInstanceID(); // make fcm token invalid, so logged out device won't receive notification
    } else if (event is ReceivedFcm) {
      yield FcmTransactionConfirmed(transactionId: 1);
    }
  }

  _setupFcm() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        add(ReceivedFcm());
      },
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );

    _firebaseMessaging.onTokenRefresh
        .listen((token) => _saveToken(token)); // save token when it was refreshed
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
