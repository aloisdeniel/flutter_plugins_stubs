import 'package:connectivity_stub/connectivity.dart';
import 'package:change_notifier_stub/change_notifier.dart';
import 'package:url_launcher_stub/url_launcher.dart';
import 'package:shared_preferences_stub/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  String _status;

  String get status => _status;

  String _preferences;

  String get preferences => _preferences;
  set preferences(String value) {
    _preferences = value;
    SharedPreferences.getInstance().then((preferences) => preferences.setString("TEST", value));
  }

  Future<void> update() async {
    final state = await Connectivity().checkConnectivity();
    _status = state?.toString();
    this.notifyListeners();

    _preferences = (await SharedPreferences.getInstance()).getString("TEST");

    Connectivity().onConnectivityChanged.listen((state) {
      _status = state?.toString();
      this.notifyListeners();
    });
  }

  Future<void> openGoogle() async {
    await launch("https://www.google.com");
  }
}
