import 'package:cgpa_calculator/constants.dart';
import 'package:cgpa_calculator/course.dart';
import 'package:cgpa_calculator/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'script.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  List<Course> get sitemslist =>
      Hive.box<Course>('coursesBox').values
          .where(
            (course) =>
                (course.discipline ==
                        ((selecteddiscipline.substring(0, 2) != "--")
                            ? selecteddiscipline.substring(0, 2)
                            : selecteddiscipline.substring(2, 4)) ||
                    course.discipline ==
                        ((selecteddiscipline.substring(0, 2) != "--")
                            ? selecteddiscipline.substring(2, 4)
                            : "ccccc")),
          )
          .toList();

  @override
  State<Analytics> createState() => _AnalyticsState();
}

double creds(String s, List<Course> si) {
  double sum = 0;
  for (int i = 0; i < si.length; i++) {
    if (si[i].elective == s && (si[i].grade1 > 0 || si[i].grade1 == -3)) {
      sum += si[i].credits;
    }
  }
  return sum;
}

class _AnalyticsState extends State<Analytics> {
  var creditsforcourses = {
    'AD': [15, 48, 4, 12], //cdc course,cdc credits, del course,del credits
    'AA': [14, 48, 4, 12],
    'AB': [15, 48, 4, 12],
    'AC': [14, 48, 4, 12],
    'AJ': [14, 48, 4, 12],
    'A1': [15, 45, 5, 15],
    'A2': [17, 57, 4, 12],
    'A3': [15, 49, 4, 12],
    'A4': [16, 56, 4, 12],
    'A5': [16, 48, 4, 12],
    'A7': [14, 48, 4, 12],
    'A8': [14, 48, 4, 12],
    'A9': [13, 43, 5, 15],
    'B1': [14, 44, 5, 15],
    'B2': [12, 37, 5, 15],
    'B3': [14, 42, 6, 18],
    'B4': [14, 42, 5, 15],
    'B5': [15, 45, 4, 15],
    'B7': [15, 45, 5, 15],
    'B-': [0, 0, 0, 0],
  };

  // Courses counted by a card: the ones that carry a grade.
  List<Course> _taken(String elective) =>
      widget.sitemslist
          .where(
            (course) =>
                course.elective == elective &&
                (course.grade1 > 0 || course.grade1 == -3),
          )
          .toList();

  List<Course> get _allTaken =>
      widget.sitemslist
          .where((course) => course.grade1 > 0 || course.grade1 == -3)
          .toList();

  void _showCourses(Constants thm, String title, List<Course> list) {
    final courses = [...list]..sort((a, b) {
      final s = a.sem.compareTo(b.sem);
      return (s != 0) ? s : a.title.compareTo(b.title);
    });
    double credits = 0;
    for (final c in courses) {
      credits += c.credits;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: thm.backcolor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: thm.sepcolor.withValues(alpha: 0.5)),
      ),
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: thm.sepcolor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 14, 20, 4),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: thm.textcolor,
                    ),
                  ),
                ),
                Text(
                  "${courses.length} course${courses.length == 1 ? '' : 's'}"
                  "  Â·  ${credits.toString().replaceAll('.0', '')} credits",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: thm.unscolor,
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: thm.sepcolor.withValues(alpha: 0.5),
                ),
                if (courses.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "No courses taken yet",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: thm.unscolor,
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 4, bottom: 12),
                      shrinkWrap: true,
                      itemCount: courses.length,
                      separatorBuilder:
                          (_, __) => Divider(
                            height: 1,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                            color: thm.sepcolor.withValues(alpha: 0.25),
                          ),
                      itemBuilder: (context, i) {
                        final c = courses[i];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            c.title,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: thm.textcolor,
                            ),
                          ),
                          subtitle: Text(
                            "${c.id}  Â·  Sem ${c.sem}  Â·  "
                            "${c.credits.toString().replaceAll('.0', '')} cr",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11.5,
                              color: thm.unscolor,
                            ),
                          ),
                          trailing: Text(
                            gradecalc(c.grade1),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: thm.highcolor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(((MediaQuery.of(context).size.height -max((40+min(MediaQuery.of(context).size.width * 0.28,100)),100)) > 3*MediaQuery.of(context).size.width*0.50 )?20:(MediaQuery.of(context).size.height*0.78 -(40+min(MediaQuery.of(context).size.width * 0.28,100)))/3);
    // print(widget.sitemslist.where((Course) => Course.elective == "CDC1" && (Course.grade1 > 0 || Course.grade1==-3),).length.toString());
    // `print`(widget.sitemslist.where((Course) => Course.elective == "CDC2" && (Course.grade1 > 0 || Course.grade1==-3),).length.toString());
    var thm = themes.firstWhere((theme) => theme.theme == selected_theme);
    setnavcolor();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: thm.textcolor),
        title: Text(
          "Analytics",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: thm.textcolor,
          ),
        ),
        backgroundColor: thm.backcolor,
      ),
      backgroundColor: thm.backcolor, //themes[0].backcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: min(MediaQuery.of(context).size.width * 0.28, 100),
            width: MediaQuery.of(context).size.width * 0.90,
            child: InkWell(
              onTap:
                  (selecteddiscipline == "----")
                      ? () async {
                        await Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ),
                            )
                            .then((value) async {
                              selected_theme = selected_theme;
                              await settheme();
                              profile1n = profile1n;
                              profile2n = profile2n;
                              await setprof();
                              currentsem = currentsem;
                              selecteddiscipline = selecteddiscipline;
                              await setdis();
                              await initializeCourses();
                              setState(() {
                                profile1n = profile1n;
                                selecteddiscipline = selecteddiscipline;
                                selected_theme = selected_theme;
                                // items = courselist
                                //     .where((course) => course.sem == currentsem && course.discipline == selecteddiscipline)
                                //     .toList();
                              });
                            });
                      }
                      : () => _showCourses(thm, "All Courses", _allTaken),
              child: Card(
                elevation: 3,
                color: thm.cardcolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (selecteddiscipline != "----")
                                ? "Total $creditLabel "
                                : "Select Discipline to View Analytics",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  (selecteddiscipline != "----")
                                      ? thm.textcolor
                                      : thm.highcolor,
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Spacer(flex: 1),
                        Text(
                          (selecteddiscipline != "----")
                              ? "$ccred1 / 144".replaceAll('.0', '')
                              : "",
                          style: TextStyle(
                            color: thm.textcolor,
                            fontSize: 22,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
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
          SizedBox(height: 20),
          Center(
            child: Row(
              children: [
                Spacer(flex: 1),
                if (selecteddiscipline.substring(2, 4).startsWith("A"))
                  Column(
                    children: [
                      SizedBox(
                        height:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        width:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        child: InkWell(
                          onTap:
                              () => _showCourses(
                                thm,
                                "CDC (" +
                                    selecteddiscipline.substring(2, 4) +
                                    ")",
                                _taken("CDC2"),
                              ),
                          child: Card(
                            elevation: 3,
                            color: thm.cardcolor,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "CDC (" +
                                        selecteddiscipline.substring(2, 4) +
                                        ")",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: thm.textcolor,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 4),
                                Row(
                                  children: [
                                    Text(
                                      "  Courses",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      widget.sitemslist
                                              .where(
                                                (Course) =>
                                                    Course.elective == "CDC2" &&
                                                    (Course.grade1 > 0 ||
                                                        Course.grade1 == -3),
                                              )
                                              .length
                                              .toString() +
                                          "/" +
                                          creditsforcourses[selecteddiscipline
                                                  .substring((2))]![0]
                                              .toString() +
                                          "  ",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "  $creditLabel",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      creds(
                                            "CDC2",
                                            widget.sitemslist,
                                          ).toString().replaceAll('.0', '') +
                                          "/" +
                                          creditsforcourses[selecteddiscipline
                                                  .substring((2))]![1]
                                              .toString() +
                                          "  ",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                if (selecteddiscipline.substring(2, 4).startsWith("A"))
                  Column(
                    children: [
                      SizedBox(
                        height:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        width:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        child: InkWell(
                          onTap:
                              () => _showCourses(
                                thm,
                                "Disciplinary Electives (" +
                                    selecteddiscipline.substring(2, 4) +
                                    ")",
                                _taken("Disciplinary Elective2"),
                              ),
                          child: Card(
                            elevation: 3,
                            color: thm.cardcolor,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Disciplinary Electives (" +
                                        selecteddiscipline.substring(2, 4) +
                                        ")",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: thm.textcolor,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Spacer(flex: 4),
                                Row(
                                  children: [
                                    Text(
                                      "  Courses",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      widget.sitemslist
                                              .where(
                                                (Course) =>
                                                    Course.elective ==
                                                        "Disciplinary Elective2" &&
                                                    (Course.grade1 > 0 ||
                                                        Course.grade1 == -3),
                                              )
                                              .length
                                              .toString() +
                                          "/" +
                                          creditsforcourses[selecteddiscipline
                                                  .substring((2))]![2]
                                              .toString() +
                                          "  ",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "  $creditLabel",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      creds(
                                            "Disciplinary Elective2",
                                            widget.sitemslist,
                                          ).toString().replaceAll('.0', '') +
                                          "/" +
                                          creditsforcourses[selecteddiscipline
                                                  .substring((2))]![3]
                                              .toString() +
                                          "  ",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Spacer(flex: 1),
              ],
            ),
          ),
          if (selecteddiscipline.startsWith("B"))
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
          if (selecteddiscipline.startsWith("B"))
            Center(
              child: Row(
                children: [
                  Spacer(flex: 1),
                  Column(
                    children: [
                      SizedBox(
                        height:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        width:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        child: InkWell(
                          onTap:
                              () => _showCourses(
                                thm,
                                "CDC (" +
                                    selecteddiscipline.substring(0, 2) +
                                    ")",
                                _taken("CDC1"),
                              ),
                          child: Card(
                            elevation: 3,
                            color: thm.cardcolor,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "CDC (" +
                                        selecteddiscipline.substring(0, 2) +
                                        ")",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: thm.textcolor,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 4),
                                Row(
                                  children: [
                                    Text(
                                      "  Courses",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      widget.sitemslist
                                              .where(
                                                (Course) =>
                                                    Course.elective == "CDC1" &&
                                                    (Course.grade1 > 0 ||
                                                        Course.grade1 == -3),
                                              )
                                              .length
                                              .toString() +
                                          ((!selecteddiscipline.startsWith(
                                                "B-",
                                              ))
                                              ? ("/" +
                                                  creditsforcourses[selecteddiscipline
                                                          .substring(0, 2)]![0]
                                                      .toString() +
                                                  "  ")
                                              : "  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "  $creditLabel",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      creds(
                                            "CDC1",
                                            widget.sitemslist,
                                          ).toString().replaceAll('.0', '') +
                                          ((!selecteddiscipline.startsWith(
                                                "B-",
                                              ))
                                              ? ("/" +
                                                  creditsforcourses[selecteddiscipline
                                                          .substring(0, 2)]![1]
                                                      .toString() +
                                                  "  ")
                                              : "  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Column(
                    children: [
                      SizedBox(
                        height:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        width:
                            ((MediaQuery.of(context).size.height -
                                        max(
                                          (40 +
                                              min(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.28,
                                                100,
                                              )),
                                          100,
                                        )) >
                                    3 *
                                        MediaQuery.of(context).size.width *
                                        0.50)
                                ? MediaQuery.of(context).size.width * 0.42
                                : (MediaQuery.of(context).size.height * 0.78 -
                                        (40 +
                                            min(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.28,
                                              100,
                                            ))) /
                                    3,
                        child: InkWell(
                          onTap:
                              () => _showCourses(
                                thm,
                                "Disciplinary Electives (" +
                                    selecteddiscipline.substring(0, 2) +
                                    ")",
                                _taken("Disciplinary Elective1"),
                              ),
                          child: Card(
                            elevation: 3,
                            color: thm.cardcolor,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Disciplinary Electives (" +
                                        selecteddiscipline.substring(0, 2) +
                                        ")",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: thm.textcolor,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Spacer(flex: 4),
                                Row(
                                  children: [
                                    Text(
                                      "  Courses",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      widget.sitemslist
                                              .where(
                                                (Course) =>
                                                    Course.elective ==
                                                        "Disciplinary Elective1" &&
                                                    (Course.grade1 > 0 ||
                                                        Course.grade1 == -3),
                                              )
                                              .length
                                              .toString() +
                                          ((!selecteddiscipline.startsWith(
                                                "B-",
                                              ))
                                              ? ("/" +
                                                  creditsforcourses[selecteddiscipline
                                                          .substring(0, 2)]![2]
                                                      .toString() +
                                                  "  ")
                                              : "  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "  $creditLabel",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      creds(
                                            "Disciplinary Elective1",
                                            widget.sitemslist,
                                          ).toString().replaceAll('.0', '') +
                                          ((!selecteddiscipline.startsWith(
                                                "B-",
                                              ))
                                              ? ("/" +
                                                  creditsforcourses[selecteddiscipline
                                                          .substring(0, 2)]![3]
                                                      .toString() +
                                                  "  ")
                                              : "  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.03),
          Center(
            child: Row(
              children: [
                Spacer(flex: 1),
                Column(
                  children: [
                    if (selecteddiscipline != "----")
                      Column(
                        children: [
                          SizedBox(
                            height:
                                ((MediaQuery.of(context).size.height -
                                            max(
                                              (40 +
                                                  min(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.28,
                                                    100,
                                                  )),
                                              100,
                                            )) >
                                        3 *
                                            MediaQuery.of(context).size.width *
                                            0.50)
                                    ? MediaQuery.of(context).size.width * 0.42
                                    : (MediaQuery.of(context).size.height *
                                                0.78 -
                                            (40 +
                                                min(
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.28,
                                                  100,
                                                ))) /
                                        3,
                            width:
                                ((MediaQuery.of(context).size.height -
                                            max(
                                              (40 +
                                                  min(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.28,
                                                    100,
                                                  )),
                                              100,
                                            )) >
                                        3 *
                                            MediaQuery.of(context).size.width *
                                            0.50)
                                    ? MediaQuery.of(context).size.width * 0.42
                                    : (MediaQuery.of(context).size.height *
                                                0.78 -
                                            (40 +
                                                min(
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.28,
                                                  100,
                                                ))) /
                                        3,
                            child: InkWell(
                              onTap:
                                  () => _showCourses(
                                    thm,
                                    "Humanity Electives",
                                    _taken("Humanity Elective"),
                                  ),
                              child: Card(
                                elevation: 3,
                                color: thm.cardcolor,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        "Humanity Electives",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: thm.textcolor,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 4),
                                    Row(
                                      children: [
                                        Text(
                                          "  Courses",
                                          style: TextStyle(
                                            color: thm.textcolor,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(flex: 1),
                                        Text(
                                          widget.sitemslist
                                                  .where(
                                                    (Course) =>
                                                        Course.elective ==
                                                            "Humanity Elective" &&
                                                        (Course.grade1 > 0 ||
                                                            Course.grade1 ==
                                                                -3),
                                                  )
                                                  .length
                                                  .toString() +
                                              "/3  ",
                                          style: TextStyle(
                                            color: thm.textcolor,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "  $creditLabel",
                                          style: TextStyle(
                                            color: thm.textcolor,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(flex: 1),
                                        Text(
                                          creds(
                                                "Humanity Elective",
                                                widget.sitemslist,
                                              ).toString().replaceAll(
                                                '.0',
                                                '',
                                              ) +
                                              "/8  ",
                                          style: TextStyle(
                                            color: thm.textcolor,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(flex: 1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (selecteddiscipline != "----")
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                if (selecteddiscipline != "----")
                  SizedBox(
                    height:
                        ((MediaQuery.of(context).size.height -
                                    max(
                                      (40 +
                                          min(
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                            100,
                                          )),
                                      100,
                                    )) >
                                3 * MediaQuery.of(context).size.width * 0.50)
                            ? MediaQuery.of(context).size.width * 0.42
                            : (MediaQuery.of(context).size.height * 0.78 -
                                    (40 +
                                        min(
                                          MediaQuery.of(context).size.width *
                                              0.28,
                                          100,
                                        ))) /
                                3,
                    width:
                        ((MediaQuery.of(context).size.height -
                                    max(
                                      (40 +
                                          min(
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                            100,
                                          )),
                                      100,
                                    )) >
                                3 * MediaQuery.of(context).size.width * 0.50)
                            ? MediaQuery.of(context).size.width * 0.42
                            : (MediaQuery.of(context).size.height * 0.78 -
                                    (40 +
                                        min(
                                          MediaQuery.of(context).size.width *
                                              0.28,
                                          100,
                                        ))) /
                                3,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap:
                              () => _showCourses(
                                thm,
                                "Open Electives",
                                _taken("Open Elective"),
                              ),
                          child: Card(
                            elevation: 3,
                            color: thm.cardcolor,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Open Electives",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: thm.textcolor,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 4),
                                Row(
                                  children: [
                                    Text(
                                      "  Courses",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      widget.sitemslist
                                              .where(
                                                (Course) =>
                                                    Course.elective ==
                                                        "Open Elective" &&
                                                    (Course.grade1 > 0 ||
                                                        Course.grade1 == -3),
                                              )
                                              .length
                                              .toString() +
                                          ((selecteddiscipline.startsWith("B"))
                                              ? "  "
                                              : "/5  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "  $creditLabel",
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Text(
                                      creds(
                                            "Open Elective",
                                            widget.sitemslist,
                                          ).toString().replaceAll('.0', '') +
                                          ((selecteddiscipline.startsWith("B"))
                                              ? "  "
                                              : "/15  "),
                                      style: TextStyle(
                                        color: thm.textcolor,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ),
                        if (selecteddiscipline.startsWith("B") &&
                            selecteddiscipline.substring(2).startsWith("A"))
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                color: thm.backcolor.withValues(alpha: 0),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Spacer(flex: 1),
              ],
            ),
          ),

          Spacer(flex: 1),
          Text(
            "Calculation is based on $profile1n grades",
            style: TextStyle(
              color: thm.textcolor,
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
