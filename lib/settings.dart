import 'package:cgpa_calculator/constants.dart';
import 'package:cgpa_calculator/script.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:in_app_review/in_app_review.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

String selectdual = selecteddiscipline.substring(0, 2);
String selecengg = selecteddiscipline.substring(2, 4);

class _SettingsState extends State<Settings> {
  final TextEditingController myController1 = TextEditingController(
    text: profile1n,
  );
  final TextEditingController myController2 = TextEditingController(
    text: profile2n,
  );
  bool _isProfileCardOpen = false;
  TextEditingController _batchController = TextEditingController(
    text: batch.toString(),
  );

  static const double _dropWidth = 118;

  // ---------------------------------------------------------------- styling

  Widget _groupHeader(Constants thm, String text) => Padding(
    padding: EdgeInsets.fromLTRB(20, 20, 20, 6),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: thm.highcolor,
      ),
    ),
  );

  Widget _groupDivider(Constants thm) => Divider(
    height: 1,
    thickness: 0.5,
    indent: 20,
    endIndent: 20,
    color: thm.sepcolor.withValues(alpha: 0.4),
  );

  Widget _tile(
    Constants thm, {
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) => ListTile(
    key: key,
    onTap: onTap,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    horizontalTitleGap: 14,
    minLeadingWidth: 0,
    leading: Icon(icon, size: 22, color: thm.iconcolor),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: thm.textcolor,
      ),
    ),
    subtitle:
        subtitle == null
            ? null
            : Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11.5,
                  color: thm.unscolor,
                ),
              ),
            ),
    trailing: trailing,
  );

  InputDecorationTheme _fieldDeco(Constants thm) => InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: thm.cardcolor,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: thm.sepcolor, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: thm.highcolor, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: thm.sepcolor, width: 1.2),
    ),
  );

  MenuStyle _menuStyle(Constants thm) => MenuStyle(
    backgroundColor: WidgetStateProperty.all(thm.backcolor),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: thm.sepcolor.withValues(alpha: 0.5)),
      ),
    ),
  );

  ButtonStyle _entryStyle(Constants thm) => MenuItemButton.styleFrom(
    textStyle: TextStyle(fontFamily: 'Montserrat'),
    foregroundColor: thm.highcolor,
  );

  TextStyle _fieldText(Constants thm) => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: thm.highcolor,
  );

  // --------------------------------------------------------------- controls

  Widget _dualDisciplineField(Constants thm) => SizedBox(
    width: _dropWidth,
    child: DropdownMenu<String>(
      width: _dropWidth,
      textAlign: TextAlign.center,
      textStyle: _fieldText(thm),
      inputDecorationTheme: _fieldDeco(thm),
      menuStyle: _menuStyle(thm),
      initialSelection:
          (selecteddiscipline.length == 4)
              ? selecteddiscipline.substring(0, 2)
              : (selecteddiscipline.length == 2 &&
                  selecteddiscipline.substring(0, 1) == 'B')
              ? selecteddiscipline.substring(0, 2)
              : "None",
      onSelected: (String? value) {
        setState(() {
          selectdual = value!;
          if (selecteddiscipline.substring(0, 2) != selectdual) {
            erase = 1;
          }
          selecteddiscipline = value + selecengg;
        });
      },
      dropdownMenuEntries:
          degreelist
              .where((id) => id.startsWith("B"))
              .map(
                (id) => DropdownMenuEntry(
                  value: id,
                  label: id,
                  style: _entryStyle(thm),
                ),
              )
              .toList() +
          [
            DropdownMenuEntry(
              value: "B-",
              label: "Other",
              style: _entryStyle(thm),
            ),
            DropdownMenuEntry(
              value: "--",
              label: "None",
              style: _entryStyle(thm),
            ),
          ],
    ),
  );

  Widget _disciplineField(Constants thm) => SizedBox(
    width: _dropWidth,
    child: DropdownMenu<String>(
      width: _dropWidth,
      textAlign: TextAlign.center,
      textStyle: _fieldText(thm),
      inputDecorationTheme: _fieldDeco(thm),
      menuStyle: _menuStyle(thm),
      initialSelection:
          (selecteddiscipline.length == 4)
              ? selecteddiscipline.substring(2, 4)
              : (selecteddiscipline.length == 2 &&
                  selecteddiscipline.substring(0, 1) == 'A')
              ? selecteddiscipline.substring(0, 2)
              : "Other",
      onSelected: (String? value) {
        setState(() {
          selecengg = value!;
          if (selecteddiscipline.substring(2, 4) != selecengg) {
            if (erase != 1 && selecteddiscipline.startsWith("B")) {
              erase = 2;
            } else {
              erase = 1;
            }
          }
          selecteddiscipline = selectdual + value;
        });
      },
      dropdownMenuEntries:
          degreelist
              .where((id) => id.startsWith("A"))
              .map(
                (id) => DropdownMenuEntry(
                  value: id,
                  label: id,
                  style: _entryStyle(thm),
                ),
              )
              .toList() +
          [
            DropdownMenuEntry(
              value: "--",
              label: "Other",
              style: _entryStyle(thm),
            ),
          ],
    ),
  );

  Widget _batchField(Constants thm) => SizedBox(
    width: _dropWidth,
    child: DropdownMenu<int>(
      width: _dropWidth,
      textAlign: TextAlign.center,
      textStyle: _fieldText(thm),
      inputDecorationTheme: _fieldDeco(thm),
      menuStyle: _menuStyle(thm),
      initialSelection:
          batchOptions.contains(batch) ? batch : batchOptions.last,
      dropdownMenuEntries:
          batchOptions
              .map(
                (b) => DropdownMenuEntry(
                  value: b,
                  label: "20$b",
                  style: _entryStyle(thm),
                ),
              )
              .toList(),
      onSelected: (value) async {
        if (value == null) return;
        final listChanged =
            (value >= emptyCurriculumBatch) != (batch >= emptyCurriculumBatch);
        if (curriculumEra(batch) != curriculumEra(value)) {
          erase = 1;
        }
        setState(() {
          batch = value;
          _batchController.text = batch.toString();
        });
        await setdis();
        await initializeCourses();
        if (listChanged) {
          await refreshMasterCourseList();
          if (mounted) setState(() {});
        }
      },
    ),
  );

  Widget _themeField(Constants thm) => SizedBox(
    width: _dropWidth,
    child: DropdownMenu<String>(
      width: _dropWidth,
      textAlign: TextAlign.center,
      textStyle: _fieldText(thm),
      inputDecorationTheme: _fieldDeco(thm),
      menuStyle: _menuStyle(thm),
      initialSelection: selected_theme,
      onSelected: (String? value) async {
        selected_theme = value!;
        thm = themes.firstWhere((theme) => theme.theme == selected_theme);
        await settheme();
        setState(() {
          selected_theme = value;
          setnavcolor();
          thm = themes.firstWhere((theme) => theme.theme == selected_theme);
        });
      },
      dropdownMenuEntries:
          themes
              .map(
                (id) => DropdownMenuEntry(
                  value: id.theme,
                  label: id.theme,
                  style: _entryStyle(thm),
                ),
              )
              .toList(),
    ),
  );

  // ---------------------------------------------------------------- dialogs

  void _showUpdates(Constants thm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: thm.backcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: thm.sepcolor.withValues(alpha: 0.5)),
          ),
          title: Text(
            'Updates',
            style: TextStyle(fontFamily: 'Montserrat', color: thm.highcolor),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1) Click on Reset to update courses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '2) Play Store Updates will show up as Prompts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '3) Bugs / New course requests can be sent from the app itself',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '4) Updated BITS K101 and BITS F101 to 0.5 credits. Delete and add these courses or use reset to update.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '5) Minor Offshoot calculator is added to semester dropdown.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '6) Hold on grade to change quickly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
              Text(
                '7) Reload and hold the page to clear grades.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmReset(Constants thm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: thm.backcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: thm.sepcolor.withValues(alpha: 0.5)),
          ),
          title: Text(
            'Reset?',
            style: TextStyle(fontFamily: 'Montserrat', color: thm.highcolor),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Resetting Courses will Delete grade data',
            style: TextStyle(fontFamily: 'Montserrat', color: thm.textcolor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                erase = 1;
                await initializeCourses();
                Navigator.pop(context);
              },
              child: Text(
                'Reset',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: thm.textcolor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    var thm = themes.firstWhere((theme) => theme.theme == selected_theme);
    setnavcolor();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: thm.textcolor),
        title: Text(
          "Settings",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: thm.textcolor,
          ),
        ),
        backgroundColor: thm.backcolor,
        actions: [
          IconButton(
            tooltip: "Updates",
            icon: Icon(Icons.info_outline_rounded, color: thm.iconcolor),
            onPressed: () => _showUpdates(thm),
          ),
          SizedBox(width: 6),
        ],
      ),
      backgroundColor: thm.backcolor,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            children: [
              _groupHeader(thm, "Degree"),
              _tile(
                thm,
                icon: Icons.school_outlined,
                title: "Dual Discipline",
                subtitle: "Changing this will delete your grades",
                trailing: _dualDisciplineField(thm),
              ),
              _tile(
                thm,
                icon: Icons.menu_book_outlined,
                title: "Discipline",
                trailing: _disciplineField(thm),
              ),
              _tile(
                thm,
                icon: Icons.groups_outlined,
                title: "Batch",
                subtitle:
                    batch >= emptyCurriculumBatch
                        ? "Courses are not pre-loaded for this batch"
                        : null,
                trailing: _batchField(thm),
              ),
              _tile(
                thm,
                key: ValueKey("Reset"),
                icon: Icons.refresh_rounded,
                title: "Reset Courses",
                subtitle: "Reloads the course list and deletes grades",
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: thm.unscolor,
                ),
                onTap: () => _confirmReset(thm),
              ),
              SizedBox(height: 6),
              _groupDivider(thm),
              _groupHeader(thm, "Appearance"),
              _tile(
                thm,
                icon: Icons.palette_outlined,
                title: "Theme",
                trailing: _themeField(thm),
              ),
              _tile(
                thm,
                key: ValueKey("profile"),
                icon: Icons.person_outline_rounded,
                title: "Profile Names",
                subtitle: "$profile1n  /  $profile2n",
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: thm.unscolor,
                ),
                onTap: () {
                  setState(() {
                    _isProfileCardOpen = true;
                  });
                },
              ),
              SizedBox(height: 6),
              _groupDivider(thm),
              _groupHeader(thm, "Help & Feedback"),
              _tile(
                thm,
                key: ValueKey("report"),
                icon: Icons.bug_report_outlined,
                title: "Report a Bug or Add Courses",
                subtitle: "Opens a Google Form",
                trailing: Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: thm.unscolor,
                ),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://forms.gle/t852T4DwNzoDN8tH6'),
                  );
                },
              ),
              if (!kIsWeb && Platform.isAndroid)
                _tile(
                  thm,
                  key: ValueKey("review"),
                  icon: Icons.star_outline_rounded,
                  title: "Write a Review",
                  subtitle: "Rate the app on the Play Store",
                  trailing: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: thm.unscolor,
                  ),
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      await inAppReview.requestReview();
                    } else {
                      await launchUrl(
                        Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.srijen.cgpa_calculator',
                        ),
                      );
                    }
                  },
                ),
              _tile(
                thm,
                icon: Icons.mail_outline_rounded,
                title: "Contact",
                subtitle: "srijenapps@gmail.com",
                trailing: Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: thm.unscolor,
                ),
                onTap: () async {
                  await launchUrl(Uri.parse('mailto:srijenapps@gmail.com'));
                },
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child:
                _isProfileCardOpen
                    ? Stack(
                      children: [
                        AnimatedOpacity(
                          opacity: _isProfileCardOpen ? 0.6 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isProfileCardOpen = false;
                              });
                            },
                            child: Container(
                              color: thm.backcolor,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Center(
                          child: AnimatedScale(
                            scale: _isProfileCardOpen ? 1.0 : 0.8,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutBack,
                            child: Card(
                              color: thm.backcolor,
                              elevation: 40,
                              margin: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: thm.textcolor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.44,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Enter name for Profile 1",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.normal,
                                              color: thm.textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.50,
                                            child: TextField(
                                              controller: myController1,
                                              decoration: InputDecoration(
                                                helperText:
                                                    'Enter less than 9 letters',
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: thm.textcolor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 3),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Enter name for Profile 2",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.normal,
                                              color: thm.textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.50,
                                            child: TextField(
                                              controller: myController2,
                                              decoration: InputDecoration(
                                                helperText:
                                                    'Enter less than 9 letters',
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: thm.textcolor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 2),
                                      Row(
                                        children: [
                                          Spacer(flex: 1),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.08,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.8,
                                            child: FloatingActionButton(
                                              heroTag:
                                                  'settings_update_profile_btn',
                                              backgroundColor: thm.butcolor,
                                              child: Text(
                                                "Update Profile",
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 22,
                                                  color: thm.highcolor,
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  profile1n =
                                                      (myController1
                                                                      .text
                                                                      .length >
                                                                  0 &&
                                                              myController1
                                                                      .text
                                                                      .length <=
                                                                  9)
                                                          ? myController1.text
                                                          : (myController1
                                                                  .text
                                                                  .length ==
                                                              0)
                                                          ? "Profile 1"
                                                          : (myController1
                                                                  .text
                                                                  .length >
                                                              9)
                                                          ? myController1.text
                                                              .substring(0, 9)
                                                          : "-";
                                                  profile2n =
                                                      (myController2
                                                                      .text
                                                                      .length >
                                                                  0 &&
                                                              myController2
                                                                      .text
                                                                      .length <=
                                                                  9)
                                                          ? myController2.text
                                                          : (myController2
                                                                  .text
                                                                  .length ==
                                                              0)
                                                          ? "Profile 2"
                                                          : (myController2
                                                                  .text
                                                                  .length >
                                                              9)
                                                          ? myController2.text
                                                              .substring(0, 9)
                                                          : "-";
                                                  _isProfileCardOpen = false;
                                                });
                                                await setprof();
                                              },
                                            ),
                                          ),
                                          Spacer(flex: 1),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
