import 'package:connectivity_stub/connectivity.dart';
import 'package:change_notifier_stub/change_notifier.dart';
import 'package:url_launcher_stub/url_launcher.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isConnected;

  bool get isConnected => _isConnected;

  Future<void> update() async {
    final state = await Connectivity().checkConnectivity();
    _isConnected = state != ConnectivityResult.none;

    this.notifyListeners();
  }

  Future<void> openGoogle() async {
    await launch("https://www.google.com");
  }
}
