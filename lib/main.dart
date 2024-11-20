import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/firebase_options.dart';
import 'package:scanner/management/provider_folder.dart';
import 'package:scanner/management/provider_image.dart';
import 'package:scanner/scanned_images_folder/scan_folder.dart';

FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyCV-iu7P_SlzI_2PfUVzDf0pF4S6wX-sDY',
  appId: '1:369452662922:android:f86288e408a8b636e42d73',
  messagingSenderId: '',
  projectId: 'scanner-c591c',
  storageBucket: 'scanner-c591c.appspot.com',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: android);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageListProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ScannedImagesScreen(),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final plugin = FacebookLogin(debug: true);

//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHome(plugin: plugin),
//     );
//   }
// }

// class MyHome extends StatefulWidget {
//   final FacebookLogin plugin;

//   const MyHome({Key? key, required this.plugin}) : super(key: key);

//   @override
//   _MyHomeState createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   String? _sdkVersion;
//   FacebookAccessToken? _token;
//   FacebookUserProfile? _profile;
//   String? _email;
//   String? _imageUrl;

//   @override
//   void initState() {
//     super.initState();

//     _getSdkVersion();
//     _updateLoginInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLogin = _token != null && _profile != null;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login via Facebook example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               if (_sdkVersion != null) Text('SDK v$_sdkVersion'),
//               if (isLogin)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: _buildUserInfo(context, _profile!, _token!, _email),
//                 ),
//               isLogin
//                   ? OutlinedButton(
//                       child: const Text('Log Out'),
//                       onPressed: _onPressedLogOutButton,
//                     )
//                   : OutlinedButton(
//                       child: const Text('Log In'),
//                       onPressed: _onPressedLogInButton,
//                     ),
//               if (!isLogin && Platform.isAndroid)
//                 OutlinedButton(
//                   child: const Text('Express Log In'),
//                   onPressed: () => _onPressedExpressLogInButton(context),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
//       FacebookAccessToken accessToken, String? email) {
//     final avatarUrl = _imageUrl;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (avatarUrl != null)
//           Center(
//             child: Image.network(avatarUrl),
//           ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             const Text('User: '),
//             Text(
//               '${profile.firstName} ${profile.lastName}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         const Text('AccessToken: '),
//         Text(
//           accessToken.token,
//           softWrap: true,
//         ),
//         if (email != null) Text('Email: $email'),
//       ],
//     );
//   }

//   Future<void> _onPressedLogInButton() async {
//     await widget.plugin.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);
//     await _updateLoginInfo();
//   }

//   Future<void> _onPressedExpressLogInButton(BuildContext context) async {
//     final res = await widget.plugin.expressLogin();
//     if (res.status == FacebookLoginStatus.success) {
//       await _updateLoginInfo();
//     } else {
//       await showDialog<Object>(
//         context: context,
//         builder: (context) => const AlertDialog(
//           content: Text("Can't make express log in. Try regular log in."),
//         ),
//       );
//     }
//   }

//   Future<void> _onPressedLogOutButton() async {
//     await widget.plugin.logOut();
//     await _updateLoginInfo();
//   }

//   Future<void> _getSdkVersion() async {
//     final sdkVersion = await widget.plugin.sdkVersion;
//     setState(() {
//       _sdkVersion = sdkVersion;
//     });
//   }

//   Future<void> _updateLoginInfo() async {
//     final plugin = widget.plugin;
//     final token = await plugin.accessToken;
//     FacebookUserProfile? profile;
//     String? email;
//     String? imageUrl;

//     if (token != null) {
//       profile = await plugin.getUserProfile();
//       if (token.permissions.contains(FacebookPermission.email.name)) {
//         email = await plugin.getUserEmail();
//       }
//       imageUrl = await plugin.getProfileImageUrl(width: 100);
//     }

//     setState(() {
//       _token = token;
//       _profile = profile;
//       _email = email;
//       _imageUrl = imageUrl;
//     });
//   }
// }

// import 'dart:async';
// import 'dart:convert' show json;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

// /// The scopes required by this application.
// // #docregion Initialize
// const List<String> scopes = <String>[
//   'email',
//   // 'https://www.googleapis.com/oauth2/v1/certs',
// ];

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // serverClientId:
//   //     '21142849779-a7vjhlinh8crbkhcke0pv8vc1dqo6k9q.apps.googleusercontent.com',
//   scopes: scopes,
// );
// // #enddocregion Initialize

// void main() {
//   runApp(
//     const MaterialApp(
//       title: 'Google Sign In',
//       home: SignInDemo(),
//     ),
//   );
// }

// /// The SignInDemo app.
// class SignInDemo extends StatefulWidget {
//   ///
//   const SignInDemo({super.key});

//   @override
//   State createState() => _SignInDemoState();
// }

// class _SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//   String _contactText = '';

//   @override
//   void initState() {
//     super.initState();

//     _googleSignIn.onCurrentUserChanged
//         .listen((GoogleSignInAccount? account) async {
// // #docregion CanAccessScopes
//       // In mobile, being authenticated means being authorized...
//       bool isAuthorized = account != null;
//       // However, on web...
//       if (kIsWeb && account != null) {
//         isAuthorized = await _googleSignIn.canAccessScopes(scopes);
//       }
// // #enddocregion CanAccessScopes

//       setState(() {
//         _currentUser = account;
//         _isAuthorized = isAuthorized;
//       });

//       // Now that we know that the user can access the required scopes, the app
//       // can call the REST API.
//       if (isAuthorized) {
//         unawaited(_handleGetContact(account!));
//       }
//     });

//     // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
//     //
//     // It is recommended by Google Identity Services to render both the One Tap UX
//     // and the Google Sign In button together to "reduce friction and improve
//     // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
//     _googleSignIn.signInSilently();
//   }

//   // Calls the People API REST endpoint for the signed-in user to retrieve information.
//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });
//     final http.Response response = await http.get(
//       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
//           '?requestMask.includeField=person.names'),
//       headers: await user.authHeaders,
//     );
//     if (response.statusCode != 200) {
//       setState(() {
//         _contactText = 'People API gave a ${response.statusCode} '
//             'response. Check logs for details.';
//       });
//       print('People API ${response.statusCode} response: ${response.body}');
//       return;
//     }
//     final Map<String, dynamic> data =
//         json.decode(response.body) as Map<String, dynamic>;
//     final String? namedContact = _pickFirstNamedContact(data);
//     setState(() {
//       if (namedContact != null) {
//         _contactText = 'I see you know $namedContact!';
//       } else {
//         _contactText = 'No contacts to display.';
//       }
//     });
//   }

//   String? _pickFirstNamedContact(Map<String, dynamic> data) {
//     final List<dynamic>? connections = data['connections'] as List<dynamic>?;
//     final Map<String, dynamic>? contact = connections?.firstWhere(
//       (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
//       orElse: () => null,
//     ) as Map<String, dynamic>?;
//     if (contact != null) {
//       final List<dynamic> names = contact['names'] as List<dynamic>;
//       final Map<String, dynamic>? name = names.firstWhere(
//         (dynamic name) =>
//             (name as Map<Object?, dynamic>)['displayName'] != null,
//         orElse: () => null,
//       ) as Map<String, dynamic>?;
//       if (name != null) {
//         return name['displayName'] as String?;
//       }
//     }
//     return null;
//   }

//   // This is the on-click handler for the Sign In button that is rendered by Flutter.
//   //
//   // On the web, the on-click handler of the Sign In button is owned by the JS
//   // SDK, so this method can be considered mobile only.
//   // #docregion SignIn
//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }
//   // #enddocregion SignIn

//   // Prompts the user to authorize `scopes`.
//   //
//   // This action is **required** in platforms that don't perform Authentication
//   // and Authorization at the same time (like the web).
//   //
//   // On the web, this must be called from an user interaction (button click).
//   // #docregion RequestScopes
//   Future<void> _handleAuthorizeScopes() async {
//     final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
//     // #enddocregion RequestScopes
//     setState(() {
//       _isAuthorized = isAuthorized;
//     });
//     // #docregion RequestScopes
//     if (isAuthorized) {
//       unawaited(_handleGetContact(_currentUser!));
//     }
//     // #enddocregion RequestScopes
//   }

//   Future<void> _handleSignOut() => _googleSignIn.disconnect();

//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       // The user is Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           if (_isAuthorized) ...<Widget>[
//             // The user has Authorized all required scopes
//             Text(_contactText),
//             ElevatedButton(
//               child: const Text('REFRESH'),
//               onPressed: () => _handleGetContact(user),
//             ),
//           ],
//           if (!_isAuthorized) ...<Widget>[
//             // The user has NOT Authorized all required scopes.
//             // (Mobile users may never see this button!)
//             const Text('Additional permissions needed to read your contacts.'),
//             ElevatedButton(
//               onPressed: _handleAuthorizeScopes,
//               child: const Text('REQUEST PERMISSIONS'),
//             ),
//           ],
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('SIGN OUT'),
//           ),
//         ],
//       );
//     } else {
//       // The user is NOT Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           // This method is used to separate mobile from web code with conditional exports.
//           // See: src/sign_in_button.dart
//           ElevatedButton(
//             onPressed: _handleSignIn,
//             child: const Text('SIGN IN'),
//           )
//         ],
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign In'),
//         ),
//         body: ConstrainedBox(
//           constraints: const BoxConstraints.expand(),
//           child: _buildBody(),
//         ));
//   }
// }

// class Demo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Buttons aur Circle'),
//         ),
//         body: Center(
//           child: Stack(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 1'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 2'),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 child: Container(
//                   margin: EdgeInsets.only(
//                     left: 150,
//                   ), // Circle ka margin set kiya
//                   width: MediaQuery.of(context).size.width / 4, // Circle width
//                   height:
//                       MediaQuery.of(context).size.width / 2, // Circle height
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 3'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 4'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class LockScreen extends StatefulWidget {
//   @override
//   _LockScreenState createState() => _LockScreenState();
// }

// class _LockScreenState extends State<LockScreen> {
//   TextEditingController _passwordController = TextEditingController();
//   String _savedPassword = ''; // Variable to store saved password
//   bool _locked = true; // Initial locked state
//   late SharedPreferences _prefs;

//   @override
//   void initState() {
//     super.initState();
//     _initPrefs();
//   }

//   void _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//     _savedPassword =
//         _prefs.getString('password') ?? ''; // Load saved password if available
//     bool isLocked = _prefs.getBool('locked') ?? true; // Load lock state
//     setState(() {
//       _locked = isLocked;
//     });
//   }

//   void _savePassword() {
//     _prefs.setString('password', _passwordController.text); // Save password
//     _prefs.setBool('locked', false); // Set lock state to unlocked
//     setState(() {
//       _locked = false;
//     });
//     _passwordController.clear();
//   }

//   void _unlock() {
//     if (_passwordController.text == _savedPassword) {
//       _prefs.setBool('locked', false); // Set lock state to unlocked
//       setState(() {
//         _locked = false;
//       });
//       _passwordController.clear();
//     } else {
//       // Handle incorrect password
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Incorrect Password'),
//             content: Text('Please try again.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _lockScreen() {
//     _prefs.setBool('locked', true); // Set lock state to locked
//     setState(() {
//       _locked = true;
//     });
//   }

//   void _forgotPassword() {
//     _prefs.remove('password'); // Remove saved password
//     _prefs.setBool('locked', true); // Set lock state to locked
//     setState(() {
//       _locked = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lock Screen'),
//       ),
//       body: Center(
//         child: _locked
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'Enter Password',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   SizedBox(height: 20.0),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40.0),
//                     child: TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: _savedPassword.isEmpty ? _savePassword : _unlock,
//                     child: Text(
//                         _savedPassword.isEmpty ? 'Set Password' : 'Unlock'),
//                   ),
//                   SizedBox(height: 10.0),
//                   TextButton(
//                     onPressed: _forgotPassword,
//                     child: Text(
//                       'Forgot Password',
//                       style: TextStyle(fontSize: 16.0, color: Colors.red),
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   ElevatedButton(
//                     onPressed: _lockScreen,
//                     child: Text(
//                       'Lock Screen',
//                       style: TextStyle(fontSize: 20.0),
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   Text(
//                     'Your Password: $_savedPassword',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File? _scannedImage;

//   void _startScan(BuildContext context) async {
//     var image = await DocumentScannerFlutter.launch(context);
//     if (image != null) {
//       final pdf = pw.Document();
// final imageBytes = Uint8List.fromList(image.readAsBytesSync());

// pdf.addPage(pw.Page(
//   build: (pw.Context context) {
//     return pw.Image(
//       pw.MemoryImage(imageBytes),
//       width: 500,
//       height: 500,
//     );
//   },
// ));

// final directory = await getApplicationDocumentsDirectory();
// final pdfFile = File("${directory.path}/scanned_image.pdf");
// await pdfFile.writeAsBytes(await pdf.save());

//       setState(() {
//         _scannedImage = pdfFile;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_scannedImage != null)
//               Image.file(
//                 _scannedImage!,
//                 height: 500,
//                 width: 500,
//               ),
//             if (_scannedImage == null)
//               const Text(
//                 'You have pushed the button this many times:',
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _startScan(context),
//         tooltip: 'Increment',
//         child: const Icon(Icons.scanner_outlined),
//       ),
//     );
//   }
// }

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({super.key});

  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  // PDFDocument? _scannedDocument;
  // File? _scannedDocumentFile;
  // File? _scannedImage;

  // Function to save the scanned PDF to the gallery

  // openPdfScanner(BuildContext context) async {
  //   var doc = await DocumentScannerFlutter.launchForPdf(
  //     context,
  //     labelsConfig: {
  //       ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Steps",
  //       ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
  //       ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
  //           "Only {PAGES_COUNT} Page",
  //     },
  //     // source: ScannerFileSource.GALLERY
  //   );
  //   print(doc);
  //   if (doc != null) {
  //     _scannedDocument = null;
  //     print('gbgbf${doc}');
  //     setState(() {});
  //     await Future.delayed(Duration(milliseconds: 100));
  //     _scannedDocumentFile = doc;
  //     _scannedDocument = await PDFDocument.fromFile(doc);
  //     print('sdcsdc ${_scannedDocument}');
  //     setState(() {});
  //   }
  // }
  // List<String> _pictures = [];
  // void onPressed() async {
  //   List<String> pictures;
  //   try {
  //     pictures = await CunningDocumentScanner.getPictures() ?? [];
  //     if (!mounted) return;
  //     setState(() {
  //       _pictures = pictures;
  //     });
  //   } catch (exception) {
  //     // Handle exception here
  //   }
  // }

  // openImageScanner(BuildContext context) async {
  //   var image = await DocumentScannerFlutter.launch(
  //     context,
  //     labelsConfig: {
  //       ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
  //       ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
  //     },
  //     source: ScannerFileSource.CAMERA,
  //   );

  //   if (image != null) {
  //     _scannedImage = image;

  //     // Prompt the user to choose an item
  //     DataProvider dataProvider =
  //         Provider.of<DataProvider>(context, listen: false);

  //     // Get the list of items from dataProvider
  //     List<String> items = dataProvider.items;

  //     String? chosenItem = await showDialog<String>(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Choose an Item'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: items.map((item) {
  //                 return ListTile(
  //                   title: Text(item),
  //                   onTap: () {
  //                     Navigator.of(context).pop(item);
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     );

  //     if (chosenItem != null && chosenItem.isNotEmpty) {
  //       // Add the scanned image to the ImageListProvider
  //       final imageProvider =
  //           Provider.of<ImageListProvider>(context, listen: false);
  //       imageProvider.addImage(_scannedImage!, chosenItem);

  //       // No need to add the chosen item as it already exists in DataProvider
  //       // You can use the chosenItem to associate the image with this item if needed

  //       setState(() {});
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print(_scannedDocumentFile!.path);
    return Scaffold(
        appBar: AppBar(
          title: Text("Scanner App"),
          actions: [
            IconButton(
              onPressed: () async {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ScannedImagesScreen(),
                //   ),
                // );
              },
              icon: Icon(Icons.camera),
            ),
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //    PhotoViewGestureDetectorScope(
              //     imageProvider: AssetImage("assets/large-image.jpg"),
              // )
              // Center(
              //   child: Builder(builder: (context) {
              //     // return ElevatedButton(
              //     //     onPressed: () => openImageScanner(context),
              //     //     child: Text("Image Scan"));
              //   }),
              // ),
            ]));
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   File? file;
//   ImagePicker image = ImagePicker();
//   getImage() async {
//     var img = await image.pickImage(source: ImageSource.gallery);

//     setState(() {
//       file = File(img!.path);
//     });
//   }

//   getImagecam() async {
//     var img = await image.pickImage(source: ImageSource.camera);

//     setState(() {
//       file = File(img!.path);
//     });
//   }

//   Future<Uint8List> _generatePdf(PdfPageFormat format, file) async {
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//     final font = await PdfGoogleFonts.nunitoExtraLight();

//     final showimage = pw.MemoryImage(file.readAsBytesSync());

//     pdf.addPage(
//       pw.Page(
//         pageFormat: format,
//         build: (context) {
//           return pw.Center(
//             child: pw.Image(showimage, fit: pw.BoxFit.contain),
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(" WEB FUN pdf maker"),
//           actions: [
//             IconButton(
//               onPressed: getImage,
//               icon: Icon(Icons.image),
//             ),
//             IconButton(
//               onPressed: getImagecam,
//               icon: Icon(Icons.camera),
//             ),
//           ],
//         ),
//         body: file == null
//             ? Container()
//             : PdfPreview(
//                 build: (format) => _generatePdf(format, file),
//               ),
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Home Page")),
//       body: SafeArea(
//         child: Center(
//             child: ElevatedButton(
//           onPressed: () async {
//             await availableCameras().then((value) => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
//           },
//           child: const Text("Take a Picture"),
//         )),
//       ),
//     );
//   }
// }
