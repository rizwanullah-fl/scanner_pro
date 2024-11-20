// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class FacebookController {
//   static Future<User?> loginWithFacebook() async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login();
//       if (result.status == LoginStatus.success) {
//         // Firebase authentication Proof
//         final AccessToken accessToken = result.accessToken!;
//         print('Access token: ${accessToken.token}');

//         // Get user's data using the access token
//         final profile = await FacebookAuth.i.getUserData();
//         print(
//             'Hello, ${profile['name']}! You have successfully logged in with Facebook.');
//       } else {
//         print('Login failed.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
