import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryProvider extends ChangeNotifier {
  DiaryProvider() {
    getSwitchValues();
  }

  bool _showQuestions = false;

  bool get showQuestions => _showQuestions;

  void toggleQuestions() {
    _showQuestions = !_showQuestions;
    notifyListeners();
  }

  bool isQuillEditorFocused = false;

  void updateQuillEditorState(bool hasFocus) {
    isQuillEditorFocused = hasFocus;
    notifyListeners();
  }

  ///// AppLock after splash screen functionality ///////

  bool isSwitchedFT = false;

  getSwitchValues() async {
    isSwitchedFT = await getSwitchState();
    notifyListeners();
  }

  // Constructor

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("switchState") ?? false;
  }

  Future<void> onChangeFunction(bool value) async {
    try {
      isSwitchedFT = await saveSwitchState(value);
      notifyListeners();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  ValueNotifier<bool> switchStateNotifier = ValueNotifier<bool>(false);

  Future<void> resetSwitchState() async {
    await saveSwitchState(false);
    switchStateNotifier.value = false;
    notifyListeners();
  }

  void checkFirstScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    await Future.delayed(const Duration(seconds: 1));

    if (_seen) {
      // if (isSwitchedFT) {
      //   // Navigator.of(context).push(MaterialPageRoute(
      //   //     builder: (context) => VerifyPasswordScreen(
      //             ontap: () {
      //               // Navigator.of(context).push(MaterialPageRoute(
      //               //     builder: (context) => const DashboardScreen()));
      //             // },
      //             onConfirmPressed: (String, bool) {},
      //           )));
      // } else {

      // }
    } else {
      await prefs.setBool('seen', true);
      notifyListeners();
    }
  }

  // late final QuillEditorController controller = QuillEditorController();
  final titleController = TextEditingController();
  final yearController = TextEditingController();

  // set notes(List<DbNote> value) {
  //   _notes = value;
  //   notifyListeners();
  // }

  // List<DbNote> _notes = [];

  // List<DbNote> get notes => _notes;

  // Future<void> deleteNote(int noteId) async {
  //   await DatabaseHelper.instance.deleteDbNote(noteId);
  // }

  bool _isSwitchOn = false;

  bool get isSwitchOn => _isSwitchOn;

  void setSwitchState(bool value) {
    _isSwitchOn = value;
    notifyListeners();
  }
}
