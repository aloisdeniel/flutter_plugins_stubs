// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'dart:html';

import 'package:meta/meta.dart';

/// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
/// a persistent store for simple data.
///
/// Data is persisted to disk asynchronously.
class SharedPreferences {
  SharedPreferences._(this._preferenceCache);

  static const String _prefix = 'flutter.';
  static SharedPreferences _instance;
  static Future<SharedPreferences> getInstance() async {
    if (_instance == null) {
      final Map<String, String> preferencesMap =
          await _getSharedPreferencesMap();
      _instance = SharedPreferences._(preferencesMap);
    }
    return _instance;
  }

  /// The cache that holds all preferences.
  ///
  /// It is instantiated to the current state of the SharedPreferences or
  /// NSUserDefaults object and then kept in sync via setter methods in this
  /// class.
  ///
  /// It is NOT guaranteed that this cache and the device prefs will remain
  /// in sync since the setter method might fail for any reason.
  final Map<String, String> _preferenceCache;

  /// Returns all keys in the persistent storage.
  Set<String> getKeys() => Set<String>.from(_preferenceCache.keys);

  /// Reads a value of any type from persistent storage.
  dynamic get(String key) => _preferenceCache[key];

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// bool.
  bool getBool(String key) {
    final v = _preferenceCache[key];
    if (v == null) return null;
    return v == "true";
  }

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  int getInt(String key) {
    final v = _preferenceCache[key];
    if (v == null) return null;
    return int.parse(v);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// double.
  double getDouble(String key) {
    final v = _preferenceCache[key];
    if (v == null) return null;
    return double.parse(v);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  String getString(String key) => _preferenceCache[key];

  /// Returns true if persistent storage the contains the given [key].
  bool containsKey(String key) => _preferenceCache.containsKey(key);

  /// Reads a set of string values from persistent storage, throwing an
  /// exception if it's not a string set.
  List<String> getStringList(String key) {
    final v = _preferenceCache[key];
    if (v == null) return null;
    return v.split("%,%");
  }

  /// Saves a boolean [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) =>
      _setValue(key, value?.toString());

  /// Saves an integer [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setInt(String key, int value) =>
      _setValue(key, value?.toString());

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value) =>
      _setValue(key, value?.toString());

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value) => _setValue(key, value);

  /// Saves a list of strings [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setStringList(String key, List<String> value) =>
      _setValue(key, value?.join("%,%"));

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key) => _setValue(key, null);

  Future<bool> _setValue(String key, String value) {
    if (value == null) {
      _preferenceCache.remove(key);
      return Future.value(window.localStorage?.remove("$_prefix$key") != null);
    } else {
      _preferenceCache[key] = value;
      window.localStorage?.addAll({"$_prefix$key": value});
      return Future.value(window.localStorage != null);
    }
  }

  /// Always returns true.
  /// On iOS, synchronize is marked deprecated. On Android, we commit every set.
  @deprecated
  Future<bool> commit() => Future.value(true);

  /// Completes with true once the user preferences for the app has been cleared.
  Future<bool> clear() async {
    _preferenceCache.clear();
    window.localStorage?.clear();
    return Future.value(window.localStorage != null);
  }

  /// Fetches the latest values from the host platform.
  ///
  /// Use this method to observe modifications that were made in native code
  /// (without using the plugin) while the app is running.
  Future<void> reload() async {
    final Map<String, Object> preferences =
        await SharedPreferences._getSharedPreferencesMap();
    _preferenceCache.clear();
    _preferenceCache.addAll(preferences);
  }

  static Future<Map<String, Object>> _getSharedPreferencesMap() async {
    final Map<String, String> fromSystem = window.localStorage;
    assert(fromSystem != null);
    // Strip the flutter. prefix from the returned preferences.
    final Map<String, Object> preferencesMap = <String, Object>{};
    for (String key in fromSystem.keys) {
      assert(key.startsWith(_prefix));
      preferencesMap[key.substring(_prefix.length)] = fromSystem[key];
    }
    return preferencesMap;
  }

  /// Initializes the shared preferences with mock values for testing.
  @visibleForTesting
  static void setMockInitialValues(Map<String, dynamic> values) {}
}
