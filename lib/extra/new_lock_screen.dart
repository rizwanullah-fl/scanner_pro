// import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:my_diary_starter/core/widgets/custom/custom_app_bar.dart';
// // import 'package:my_diary_starter/features/provider/diary_provider.dart';
// // import 'package:my_diary_starter/features/screens/dashboard/pages/dashboard_page.dart';
// // import 'package:my_diary_starter/features/screens/splash_screens/walk_away_screen/lock_helper_class.dart';
// // import 'package:my_diary_starter/features/screens/splash_screens/walk_away_screen/verify_password_screen.dart';
// import 'dart:math' as math;
// // import 'package:my_diary_starter/themes/manager/ThemeManager.dart';
// import 'package:provider/provider.dart';
// import 'package:scanner/bottomNavigation.dart';
// import 'package:scanner/extra/diary_provider.dart';
// import 'package:scanner/extra/lock_helper_class.dart';
// // import 'package:scanner/lock_helper_class.dart';
// import 'package:scanner/scanned_images_folder/batchImages.dart';
// import 'package:sizer/sizer.dart';
// // import '../../Template/widgets/custom_lock_screen_content.dart';
//
// class NewLockScreen extends StatefulWidget {
//   final bool backButton;
//   final VoidCallback? ontap;
//   const NewLockScreen({super.key, this.ontap, this.backButton = false});
//
//   @override
//   State createState() => _NewLockScreenState();
// }
//
// class _NewLockScreenState extends State<NewLockScreen>
//     with SingleTickerProviderStateMixin {
//   bool showTitle = false;
//   bool showDescription = false;
//   bool showRecoveryEmail = false;
//   bool isPinConfirmed = false;
//   final ValueNotifier<String> pinNotifier = ValueNotifier('');
//   late AnimationController _controller;
//   late Animation<double> _shakeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     _shakeAnimation = Tween<double>(begin: 0, end: 16 * math.pi).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _controller.reset();
//         }
//       });
//     pinNotifier.addListener(() {
//       if (pinNotifier.value.length == 6 && !isPinConfirmed) {
//         Future.delayed(const Duration(milliseconds: 100), () async {
//           if (pinNotifier.value.isNotEmpty) {
//             await LockHelper.storePin(pinNotifier.value);
//             setState(() {
//               showTitle = true;
//               showDescription = true;
//               showRecoveryEmail = true;
//               // pinNotifier.value = "";
//             });
//           } else {
//             _verifyPin();
//           }
//           // LockHelper.verifyPin(pinNotifier.value);
//           print("Stored PIN: ${await LockHelper.getPin()}");
//         });
//       }
//     });
//   }
//
//   void _navigateToNextScreen() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => const BottomNavigation(),
//       ),
//     );
//   }
//
//   void _showWrongPinAnimation() {
//     _controller.forward();
//   }
//
//   void _verifyPin() async {
//     try {
//       if (await LockHelper.verifyPin(pinNotifier.value)) {
//         _navigateToNextScreen();
//       } else {
//         // Incorrect PIN
//         _showWrongPinAnimation();
//         setState(() {
//           pinNotifier.value = ''; // Clear the PIN
//         });
//       }
//     } catch (e) {
//       print("Error verifying PIN: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     pinNotifier.dispose();
//     final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
//     // if (pinNotifier.value.isEmpty) {
//     //   LockHelper.removePin();
//     // }
//
//     diaryProvider.onChangeFunction(pinNotifier.value.length == 6);
//     super.dispose();
//   }
//
//   void _onNumberTap(String number) {
//     setState(() {
//       if (pinNotifier.value.length < 6) {
//         pinNotifier.value += number;
//       }
//     });
//   }
//
//   void _onDeleteTap() {
//     LockHelper.removePin();
//     setState(() {
//       if (pinNotifier.value.isNotEmpty) {
//         pinNotifier.value =
//             pinNotifier.value.substring(0, pinNotifier.value.length - 1);
//       }
//     });
//   }
//
//   void _onClearTap() {
//     setState(() {
//       pinNotifier.value = '';
//     });
//   }
//
//   Widget _buildNumberButton(String number, {VoidCallback? onPressed}) {
//     return ClipOval(
//       child: Material(
//         child: InkWell(
//           onTap: onPressed ??
//               () {
//                 _onNumberTap(number);
//               },
//           child: Container(
//             height: 20,
//             width: 20,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(60),
//                 border: Border.all(color: Colors.blue)),
//             child: Padding(
//               padding: EdgeInsets.all(2),
//               child: Center(
//                 child: Text(
//                   number,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String title = showTitle ? "Verification" : "Pin";
//     String description = showDescription ? " verification" : " pin";
//     String recoveryEmail = showRecoveryEmail ? " verification" : "pin";
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             // CustomLockScreenContent(
//             //   title: title,
//             //   description: description,
//             //   recoveryEmail: recoveryEmail,
//             // ),
//             CustomLockCircles(
//                 shakeAnimation: _shakeAnimation, pinNotifier: pinNotifier),
//             // const CustomLockButtons(),
//             Expanded(
//               child: GridView.builder(
//                 padding: EdgeInsets.all(50),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1,
//                   mainAxisSpacing: 20, // Adjust the main axis spacing
//                   crossAxisSpacing: 20, // Adjust the cross axis spacing
//                 ),
//                 itemCount: 12, // for the number buttons and the delete button
//                 itemBuilder: (BuildContext context, int index) {
//                   switch (index) {
//                     case 9:
//                       return _buildNumberButton('X', onPressed: _onClearTap);
//                     case 10:
//                       return _buildNumberButton('0');
//                     case 11:
//                       return _buildNumberButton('⌫', onPressed: _onDeleteTap);
//                     default:
//                       return _buildNumberButton('${index + 1}');
//                   }
//                 },
//               ),
//             ),
//             Visibility(
//               visible: pinNotifier.value.length == 6,
//               child: verifyPinButton(context),
//             ),
//             Visibility(
//               visible: isPinConfirmed,
//               child: confirmPinButton(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   InkWell verifyPinButton(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         if (await LockHelper.verifyPin(pinNotifier.value)) {
//           setState(() {
//             isPinConfirmed = true; // Set flag for PIN confirmation
//             pinNotifier.value = '';
//           });
//         } else {
//           // Handle incorrect PIN entry
//           _showWrongPinAnimation();
//           setState(() {
//             pinNotifier.value = ''; // Clear the PIN
//           });
//         }
//       },
//       child: Container(
//         color: Colors.green,
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: const Text("Verify PIN"),
//         ),
//       ),
//     );
//   }
//
//   InkWell confirmPinButton(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Perform actions after PIN verification
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => batchImages(value: pinNotifier.value),
//         ));
//       },
//       child: Container(
//         color: Colors.blue,
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: const Text("Confirm PIN and Proceed"),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomLockCircles extends StatelessWidget {
//   const CustomLockCircles({
//     super.key,
//     required Animation<double> shakeAnimation,
//     required this.pinNotifier,
//   }) : _shakeAnimation = shakeAnimation;
//
//   final Animation<double> _shakeAnimation;
//   final ValueNotifier<String> pinNotifier;
//   Widget _buildPinCircle(int index) {
//     return AnimatedBuilder(
//       animation: _shakeAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(
//             math.sin(_shakeAnimation.value) *
//                 9, // This creates the shake effect
//             0,
//           ),
//           child: child,
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4),
//         width: 13,
//         height: 13,
//         decoration: BoxDecoration(
//           color: index < pinNotifier.value.length ? Colors.black : Colors.white,
//           border: Border.all(color: Colors.black),
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(pinNotifier.value);
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(6, (index) => _buildPinCircle(index)),
//       ),
//     );
//   }
// }
//
// // class CustomLockButtons extends StatefulWidget {
// //   const CustomLockButtons({super.key});
// //
// //   @override
// //   State<CustomLockButtons> createState() => _CustomLockButtonsState();
// // }
// //
// // class _CustomLockButtonsState extends State<CustomLockButtons> {
// //   void _onNumberTap(String number) {
// //     setState(() {
// //       if (pinNotifier.value.length < 6) {
// //         pinNotifier.value += number;
// //       }
// //       print("this is on tap ${pinNotifier.value}");
// //     });
// //   }
// //
// //   void _onDeleteTap() {
// //     setState(() {
// //       if (pinNotifier.value.isNotEmpty) {
// //         pinNotifier.value =
// //             pinNotifier.value.substring(0, pinNotifier.value.length - 1);
// //       }
// //     });
// //   }
// //
// //   void _onClearTap() {
// //     setState(() {
// //       pinNotifier.value = '';
// //     });
// //   }
// //
// //   final ValueNotifier<String> pinNotifier = ValueNotifier('');
// //
// //   Widget _buildNumberButton(String number, {VoidCallback? onPressed}) {
// //     return ClipOval(
// //       child: Material(
// //         child: InkWell(
// //           onTap: onPressed ??
// //               () {
// //                 _onNumberTap(number);
// //               },
// //           child: Container(
// //             height: 20.h,
// //             width: 20.w,
// //             decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(60.r),
// //                 border: Border.all(
// //                     color:
// //                         ThemeManager.instance.currentTheme.primaryColorDark)),
// //             child: Padding(
// //               padding: EdgeInsets.all(2.h),
// //               child: Center(
// //                 child: Text(
// //                   number,
// //                   style:
// //                       TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: GridView.builder(
// //         padding: EdgeInsets.all(50.h),
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 3,
// //           childAspectRatio: 1,
// //           mainAxisSpacing: 20.h, // Adjust the main axis spacing
// //           crossAxisSpacing: 20.w, // Adjust the cross axis spacing
// //         ),
// //         itemCount: 12, // for the number buttons and the delete button
// //         itemBuilder: (BuildContext context, int index) {
// //           switch (index) {
// //             case 9:
// //               return _buildNumberButton('X', onPressed: _onClearTap);
// //             case 10:
// //               return _buildNumberButton('0');
// //             case 11:
// //               return _buildNumberButton('⌫', onPressed: _onDeleteTap);
// //             default:
// //               return _buildNumberButton('${index + 1}');
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
