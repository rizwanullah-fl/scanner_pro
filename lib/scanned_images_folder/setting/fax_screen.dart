import 'package:flutter/material.dart';
import 'package:scanner/management/auth/login.dart';
import 'package:scanner/management/auth/social_login.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';

class Fax extends StatefulWidget {
  const Fax({super.key});

  @override
  State<Fax> createState() => _FaxState();
}

class _FaxState extends State<Fax> {
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  bool checkBox = false;
  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString();
    final minutes = time.minute.toString();
    print(time);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.ThirdColor,
        title: Text(
          'Fax',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Fax Account Settings',
              style: TextStyle(color: AppColors.ThirdColor, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SocialScreen()));
              },
              child: Text(
                'Login or Register',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 20),
            child: Text(
              'Fax Settings',
              style: TextStyle(color: AppColors.ThirdColor, fontSize: 20),
            ),
          ),
          Divider(),
          ListTile(
            visualDensity: VisualDensity.comfortable,
            title: Text('Remind Me to Check in'),
            trailing: Checkbox(
              value: checkBox,
              onChanged: (value) {},
            ),
            onTap: () {
              setState(() {
                checkBox = !checkBox;
              });
            },
          ),
          Divider(),
          ListTile(
            visualDensity: VisualDensity.compact,
            title: Text('Remind Time'),
            subtitle: Text('$hours:$minutes'),
            onTap: () async {
              TimeOfDay? newTime =
                  await showTimePicker(context: context, initialTime: time);
              if (newTime == null) return;
              setState(() => time = newTime);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
