
abstract class FcmEvent {}

class InitialFcm extends FcmEvent {
  @override
  String toString() => 'InitialFcm';
}

class AddFcm extends FcmEvent {
  @override
  String toString() => 'AddFcm';
}

class RemoveFcm extends FcmEvent {
  @override
  String toString() => 'RemoveFcm';
}

class ReceivedFcm extends FcmEvent {
  @override
  String toString() => 'ReceivedFcm';
}