import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scanner/management/auth/login.dart';
import 'package:scanner/management/auth/register.dart';
import 'package:scanner/management/controller/facebook_signin.dart';
import 'package:scanner/management/controller/google_signin.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _updateLoginInfo();
  }

  Future<void> _onPressedLogInButton() async {
    await plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    final res = await plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  final plugin = FacebookLogin(debug: true);

  Future<void> _onPressedLogOutButton() async {
    await plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVersion = await plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }

  late GoogleSignInController _signInManager = GoogleSignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      //   backgroundColor: AppColors.ThirdColor,
      //   title: Text(
      //     'Login',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // color: const Color(0xff7c94b6),
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: ExactAssetImage(
              'assets/images/OIG3.jpeg',
            ),
            fit: BoxFit.fitHeight,
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black, // Adjust the opacity as needed
              Colors.transparent,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                // margin: EdgeInsets.all(20),
                width: double.infinity,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    child: Text(
                      'Sign Up with Email',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2, // Adjust the height as needed
                    width: 80, // Adjust the width as needed
                    color: Colors.white,
                  ),
                  SizedBox(width: 5), // Adjust the width as needed

                  Text(
                    'or use sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(width: 5), // Adjust the width as needed
                  Container(
                    height: 2, // Adjust the height as needed
                    width: 80, // Adjust the width as needed
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SignInWithAppleButton(
                onPressed: () async {
                  try {
                    final credential =
                        await SignInWithApple.getAppleIDCredential(
                      scopes: [
                        AppleIDAuthorizationScopes.email,
                        AppleIDAuthorizationScopes.fullName,
                      ],
                      webAuthenticationOptions: WebAuthenticationOptions(
                        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                        clientId:
                            'de.lunaone.flutter.signinwithappleexample.service',
                        redirectUri:
                            // For web your redirect URI needs to be the host of the "current page",
                            // while for Android you will be using the API server that redirects back into your app via a deep link
                            // NOTE(tp): For package local development use (as described in `Development.md`)
                            // Uri.parse('https://siwa-flutter-plugin.dev/')
                            // kIsWeb
                            //     ? Uri.parse('https://${window.location.host}/')
                            //     :
                            Uri.parse(
                          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                        ),
                      ),
                      // TODO: Remove these if you have no need for them
                      nonce: 'example-nonce',
                      state: 'example-state',
                    );

                    // Print the obtained credential
                    print(credential);

                    // This is the endpoint that will convert an authorization code obtained
                    // via Sign in with Apple into a session in your system
                    final signInWithAppleEndpoint = Uri(
                      scheme: 'https',
                      host: 'flutter-sign-in-with-apple-example.glitch.me',
                      path: '/sign_in_with_apple',
                      queryParameters: <String, String>{
                        'code': credential.authorizationCode,
                        if (credential.givenName != null)
                          'firstName': credential.givenName!,
                        if (credential.familyName != null)
                          'lastName': credential.familyName!,
                        'useBundleId':
                            !kIsWeb && (Platform.isIOS || Platform.isMacOS)
                                ? 'true'
                                : 'false',
                        if (credential.state != null)
                          'state': credential.state!,
                      },
                    );

                    final session = await http.Client().post(
                      signInWithAppleEndpoint,
                    );

                    // If we got this far, a session based on the Apple ID credential has been created in your system,
                    // and you can now set this as the app's session
                    // Print the obtained session
                    print(session);
                  } catch (e) {
                    // Handle any exceptions that occur during the sign-in process
                    print('An error occurred during sign-in with Apple: $e');
                  }
                },
              ),
              const SizedBox(height: 18),
              SocialLoginButton(
                  borderRadius: 10,
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () async {
                    _signInManager.signIn().then((_) {
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScannedImagesScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      });
                    });

                    // _googleSignInProcess(context);
                    // try {
                    //   final user = await GoogleSignInApi.login();
                    //   print(user?.email);
                    //   if (user != null && mounted) {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ScannedImagesScreen()),
                    //       (Route<dynamic> route) =>
                    //           false, // Replace this with your route predicate
                    //     );
                    //   }
                    // } catch (e) {
                    //   print(e);
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(SnackBar(content: Text(e.toString())));
                    // } catch (e) {
                    //   print(e);
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(SnackBar(content: Text(e.toString())));
                    // }
                  }),
              const SizedBox(height: 18),
              SocialLoginButton(
                borderRadius: 10,
                buttonType: SocialLoginButtonType.facebook,
                onPressed: _onPressedLogInButton,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an Account?',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(width: 5), // Adjust the width as needed
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'lOGIN',
                      // _currentUser!.email.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ResGoogleSignInModel {
  String? displayName;
  String? email;
  String? id;
  String? photoUrl;
  String? token;

  ResGoogleSignInModel(
      {this.displayName, this.email, this.id, this.photoUrl, this.token});

  ResGoogleSignInModel.fromJson(Map<String, dynamic> json) {
    displayName = json[KeyConstants.googleDisplayName];
    email = json[KeyConstants.googleEmail];
    id = json[KeyConstants.googleId];
    photoUrl = json[KeyConstants.googlePhotoUrl];
    token = json[KeyConstants.googleToken];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[KeyConstants.googleDisplayName] = this.displayName;
    data[KeyConstants.googleEmail] = this.email;
    data[KeyConstants.googleId] = this.id;
    data[KeyConstants.googlePhotoUrl] = this.photoUrl;
    data[KeyConstants.googleToken] = this.token;
    return data;
  }
}

class KeyConstants {
  static const String googleDisplayName = "displayName";
  static const String googleEmail = "email";
  static const String googleId = "id";
  static const String googlePhotoUrl = "photoUrl";
  static const String googleToken = "token";
  static const String facebookUserDataFields =
      "name,email,picture.width(200),birthday,friends,gender,link";
  static const String emailKey = 'email';
}

class LogUtils {
  static void showLog(String message) {
    debugPrint(message);
  }
}
