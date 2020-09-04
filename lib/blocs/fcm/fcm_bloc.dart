import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:gatabank/constants/const.dart';
import 'package:gatabank/data/local/storage.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/repositories/user_repos.dart';

import 'fcm_events.dart';
import 'fcm_states.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final BaseUserRepository userRepository;
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
      utils.log('yield FcmTransactionConfirmed');
      yield FcmTransactionConfirmed(transactionId: 1);
    }
  }

  _setupFcm() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        utils.log("onMessage: $message");
        add(ReceivedFcm());
      },
      onLaunch: (Map<String, dynamic> message) async {
        utils.log("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        utils.log("onResume: $message");
      },
    );

    _firebaseMessaging.onTokenRefresh
        .listen((token) => _saveToken(token)); // save token when it was refreshed
  }

  _saveToken(String token) async {
    utils.log('add fcm token $token');
    if (await _isTheSameToken(token)) return;
    if (userRepository.currentUser() == null) return;
    bool isAdded = await userRepository.addFcmToken(fcmToken: token);
    storage.saveBoolean(CONST.PREF_IS_FCM_TOKEN_ADDED, isAdded);
  }

  // firebase message bug : onTokenRefresh is called even tokens are the same
  // https://github.com/FirebaseExtended/flutterfire/issues/1824
  Future<bool> _isTheSameToken(String token) async {
    String lastFcmToken = storage.getString(CONST.PREF_LAST_FCM_TOKEN);
    return token == lastFcmToken;
  }
}
