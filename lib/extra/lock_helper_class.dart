import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockHelper {
  static final _storage = FlutterSecureStorage();
  static const _pinKey = 'userPin';

  /// Store the PIN securely
  static Future<void> storePin(String pin) async {
    if (pin.length == 6) {
      try {
        await _storage.write(key: _pinKey, value: pin);
      } catch (e) {
        print('Error storing PIN: $e');
        // Handle error - Could be a MissingPluginException
      }
    } else {
      print('PIN should have exactly 6 digits.');
    }
  }

  /// Retrieve the PIN securely
  static Future<String?> getPin() async {
    try {
      return await _storage.read(key: _pinKey);
    } catch (e) {
      print('Error retrieving PIN: $e');
      // Handle error - Could be a MissingPluginException
      return null;
    }
  }

  /// Verify if the input PIN matches the stored PIN
  static Future<bool> verifyPin(String inputPin) async {
    String? storedPin = await getPin();
    // If there is no PIN set, return false
    if (storedPin == null) return false;
    // Compare the input PIN with the stored PIN
    return inputPin == storedPin;
  }

  /// Remove the PIN securely
  static Future<void> removePin() async {
    try {
      await _storage.delete(key: _pinKey);
    } catch (e) {
      print('Error removing PIN: $e');
      // Handle error - Could be a MissingPluginException
    }
  }
}
