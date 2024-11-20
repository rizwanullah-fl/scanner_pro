import 'package:flutter/material.dart';
import 'package:scanner/management/in_app_purchase/purchasing.dart';
import 'package:scanner/scanned_images_folder/ExtractText.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';
import 'package:scanner/scanned_images_folder/setting/fax_screen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FourthColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.print_rounded,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    'Fax',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Fax()));

                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.history_edu,
                    color: AppColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  title: Text(
                    'Fax History',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.document_scanner_sharp,
                    color: AppColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  title: Text(
                    'OCR',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.ios_share_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    'Share App',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.rate_review_outlined,
                    color: AppColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  title: Text(
                    'Rate Us',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.subscriptions,
                    color: AppColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  title: Text(
                    'Subscription',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAppPurchase()));
                    // Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.phonelink_lock,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    'Pin Lock Code',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Switch(
                    value: isSwitched2,
                    onChanged: (value) async {
                      setState(() {
                        isSwitched2 = value;
                        // Save switch state
                      });
                    },
                    activeTrackColor: Color(0xff009B79),
                    activeColor: Colors.white,
                    inactiveThumbColor:
                        Colors.white, // Set inactive thumb color to white
                    inactiveTrackColor: Color(0xffA4ADBF).withOpacity(
                        0.5), // Set inactive track color with opacity
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return null;
                        }

                        return Colors.white;
                      },
                    ),
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.ac_unit_rounded,
                    color: AppColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 30,
                  ),
                  title: Text(
                    'Show Tutorial',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
