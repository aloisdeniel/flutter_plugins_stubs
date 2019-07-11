import 'package:connectivity_stub/connectivity.dart';
import 'package:change_notifier_stub/change_notifier.dart';
import 'package:url_launcher_stub/url_launcher.dart';

class HomeViewModel extends ChangeNotifier {
  String _status;

  String get status => _status;

  Future<void> update() async {
    final state = await Connectivity().checkConnectivity();
    _status = state?.toString();
    this.notifyListeners();

    Connectivity().onConnectivityChanged.listen((state) {
      _status = state?.toString();
      this.notifyListeners();
    });
  }

  Future<void> openGoogle() async {
    await launch("https://www.google.com");
  }
}
