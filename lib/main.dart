import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  Locale _locale = Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: themeMode == ThemeMode.light
          ? MyAppThemeConfig.light().getTheme(_locale)
          : MyAppThemeConfig.dark().getTheme(_locale),
      home: MyHomePage(
        toggleThemeMode: () {
          setState(() {
            if (themeMode == ThemeMode.light) {
              themeMode = ThemeMode.dark;
            } else {
              themeMode = ThemeMode.light;
            }
          });
        },
        selectedLanguageChange: (_Language newSelectedLanguageByUser) {
          setState(() {
            if (newSelectedLanguageByUser == _Language.en) {
              _locale = Locale('en');
            } else if (newSelectedLanguageByUser == _Language.fa) {
              _locale = Locale('fa');
            } else {
              _locale = Locale('ar');
            }
          });
        },
      ),
    );
  }
}

class MyAppThemeConfig {
  static const String faPrimaryFontFamily = 'dana';
  static const String arPrimaryFontFamily = 'arabic';
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final Color backgroundColor;
  final Color appBarColor;
  final Brightness brightness;
  final Color dividerColor;

  MyAppThemeConfig.dark()
      : primaryTextColor = Colors.white70,
        secondaryTextColor = const Color.fromARGB(179, 232, 4, 4),
        surfaceColor = Colors.black,
        backgroundColor = const Color.fromARGB(255, 30, 30, 30),
        appBarColor = Colors.black,
        brightness = Brightness.dark,
        dividerColor = Colors.yellow;

  MyAppThemeConfig.light()
      : primaryTextColor = Colors.black87,
        secondaryTextColor = Colors.black,
        surfaceColor = const Color(0x0d000000),
        backgroundColor = Colors.white,
        appBarColor = const Color.fromARGB(255, 235, 235, 235),
        brightness = Brightness.light,
        dividerColor = Colors.red;

  ThemeData getTheme(Locale locale) {
    return ThemeData(
      textTheme: getLocalizedTextTheme(locale),
      brightness: brightness,
      appBarTheme: AppBarTheme(backgroundColor: appBarColor),
      scaffoldBackgroundColor: backgroundColor,
      dividerTheme: DividerThemeData(color: dividerColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontWeight: FontWeight.bold,color: primaryTextColor),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: surfaceColor,
        filled: true,
    
      ),
    );
  }

  TextTheme get enPrimaryTextTheme => GoogleFonts.latoTextTheme().apply(
        bodyColor: primaryTextColor,
      );

  TextTheme get faPrimaryTextTheme => GoogleFonts.latoTextTheme()
      .apply(bodyColor: primaryTextColor, fontFamily: faPrimaryFontFamily);

  TextTheme get arPrimaryTextTheme => GoogleFonts.latoTextTheme()
      .apply(bodyColor: primaryTextColor, fontFamily: arPrimaryFontFamily);

  TextTheme getLocalizedTextTheme(Locale locale) {
    if (locale.languageCode == 'fa') {
      return faPrimaryTextTheme;
    } else if (locale.languageCode == 'ar') {
      return arPrimaryTextTheme;
    } else {
      return enPrimaryTextTheme;
    }
  }
}

class MyHomePage extends StatefulWidget {
  final Function() toggleThemeMode;
  final Function(_Language _language) selectedLanguageChange;

  const MyHomePage(
      {super.key,
      required this.toggleThemeMode,
      required this.selectedLanguageChange});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum _SkillType { flutter, dart }

enum _Language { en, fa, ar }

class _MyHomePageState extends State<MyHomePage> {
  double _rotationAngle = 0;
  bool _showSkills = true; //متغیر برای کنترل نمایش مهارت ها

  void _toggleRotation() {
    setState(() {
      _rotationAngle = _rotationAngle == 0 ? 0.5 : 0; // 0.5 دور 180 درجه است
      _showSkills = !_showSkills; //تغییر حالت نمایش مهارت ها
    });
  }

  _SkillType skill = _SkillType.flutter;
  void updateSelectedSkill(_SkillType skillType) {
    setState(() {
      skill = skillType;
    });
  }

  _Language _language = _Language.en;
  void updateSelectedLanguage(_Language language) {
    widget.selectedLanguageChange(language);
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.profile),
        actions: [
          const Icon(CupertinoIcons.heart),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: widget.toggleThemeMode,
            child: Container(
              child: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? CupertinoIcons.moon
                    : CupertinoIcons.sun_max,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Icon(CupertinoIcons.ellipsis_vertical),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(32),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 85,
                        height: 85,
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.name),
                        Text(localization.job),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 15,
                            ),
                            Text(localization.location)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/flutter-icon.png',
                    width: 30,
                    height: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 8),
              child: Text(localization.summary),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(localization.selectedLanguage),
                  CupertinoSlidingSegmentedControl<_Language>(
                      groupValue: _language,
                      thumbColor: Colors.pink,
                      children: {
                        _Language.en: Text(localization.enLanguage),
                        _Language.fa: Text(localization.faLanguage),
                        _Language.ar: Text(localization.arLanguage),
                      },
                      onValueChanged: (value) {
                        if (value != null) updateSelectedLanguage(value);
                      }),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: GestureDetector(
                onTap: _toggleRotation,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localization.skills,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    AnimatedRotation(
                      turns: _rotationAngle,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showSkills) //نمایش یا پنهان کردن مهارت ها
              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 50,
                  runSpacing: 12,
                  children: [
                    Skill(
                      type: _SkillType.flutter,
                      title: localization.flutter,
                      imagePath: 'assets/images/flutter-icon.png',
                      shadowColor: Colors.blueAccent,
                      isActive: skill == _SkillType.flutter,
                      textColor: Colors.purple,
                      borderActive: Border.all(color: Colors.black, width: 3),
                      onTap: () {
                        updateSelectedSkill(_SkillType.flutter);
                      },
                    ),
                    Skill(
                      type: _SkillType.dart,
                      title: localization.dart,
                      imagePath: 'assets/images/dart-icon.png',
                      shadowColor: Colors.blueAccent,
                      isActive: skill == _SkillType.dart,
                      textColor: Colors.red,
                      borderActive: Border.all(color: Colors.black, width: 3),
                      onTap: () {
                        updateSelectedSkill(_SkillType.dart);
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.information,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: localization.email,
                      prefixIcon: Icon(CupertinoIcons.at),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: localization.phone,
                        prefixIcon: Icon(CupertinoIcons.phone)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: localization.password,
                        prefixIcon: Icon(CupertinoIcons.lock_fill)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: localization.confirm_password,
                        prefixIcon: Icon(CupertinoIcons.lock_fill)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.pink.shade900),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Colors.blue, width: 5)))),
                      child: Text(
                        localization.save,
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: null,
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.pink.shade900),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: Colors.blue, width: 3)))),
                          child: Text(
                            localization.return_home,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19),
                          )))
                ],
              ),
            ),
            const Divider(),
            Center(
              child: Text(localization.thanks,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class Skill extends StatelessWidget {
  final _SkillType type;
  final String title;
  final String imagePath;
  final Color shadowColor;
  final bool isActive;
  final Color textColor;
  final Border borderActive;
  final Function() onTap;

  const Skill({
    super.key,
    required this.title,
    required this.imagePath,
    required this.shadowColor,
    required this.isActive,
    required this.textColor,
    required this.borderActive,
    required this.onTap,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: isActive
            ? BoxDecoration(
                border: isActive ? borderActive : null,
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: isActive
                  ? BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ])
                  : null,
              child: Image.asset(
                imagePath,
                width: 45,
                height: 45,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: TextStyle(
                  color: isActive ? textColor : null,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
