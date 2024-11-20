import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class GoogleSignInController {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';

  GoogleSignInController() {
    _googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      _currentUser = account;
      _isAuthorized = isAuthorized;

      if (isAuthorized) {
        unawaited(_handleGetContact(account!));
      }
    });
    _googleSignIn.signInSilently();
  }

  final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      if (_currentUser != null) {
        String userEmail = _currentUser!.email;
        String username = _currentUser!.displayName ?? '';
        String photoUrl = _currentUser!.photoUrl ?? '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('username', username);
        await prefs.setString('photoUrl', photoUrl);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future<String?> getUserEmail() async {
    await _googleSignIn.signInSilently();
    return _currentUser?.email;
  }

  Future<String?> getUserName() async {
    await _googleSignIn.signInSilently();
    return _currentUser?.displayName;
  }

  Future<String?> getUserPhotoUrl() async {
    await _googleSignIn.signInSilently();
    return _currentUser?.photoUrl;
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    _contactText = 'Loading contact info...';
    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      _contactText =
          'People API gave a ${response.statusCode} response. Check logs for details.';
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    if (namedContact != null) {
      _contactText = 'I see you know $namedContact!';
    } else {
      _contactText = 'No contacts to display.';
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }
}

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;
  static Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  static Future<User?> loginWithgoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }
  //  Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   _contactText = 'Loading contact info...';
  //   final http.Response response = await http.get(
  //     Uri.parse(
  //         'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     _contactText =
  //         'People API gave a ${response.statusCode} response. Check logs for details.';
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data =
  //       json.decode(response.body) as Map<String, dynamic>;
  //   final String? namedContact = _pickFirstNamedContact(data);
  //   if (namedContact != null) {
  //     _contactText = 'I see you know $namedContact!';
  //   } else {
  //     _contactText = 'No contacts to display.';
  //   }
  // }
}

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  static Future<GoogleSignInAccount?> login() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      return googleAccount;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
}
