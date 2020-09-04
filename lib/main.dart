import 'package:gatabank/config/config.dart';
import 'package:gatabank/main_configured.dart';

void main() {
  Config.setEnvironment(Environment.Prod);
  mainDelegate();
}
