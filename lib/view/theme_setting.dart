import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanta/commons/space.dart';
import 'package:yanta/commons/utils.dart';
import 'package:yanta/view_model/theme_change.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Styles.boldTextStyle('Theme Settings'),
      ),
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 50.0),
          //   child: AnimatedCrossFade(
          //     crossFadeState: Theme.of(context).brightness == Brightness.light
          //         ? CrossFadeState.showFirst
          //         : CrossFadeState.showSecond,
          //     firstChild: Image.asset(
          //       'assets/sun.png',
          //       width: 200,
          //     ),
          //     secondChild: Image.asset(
          //       'assets/moon.png',
          //       width: 200,
          //     ),
          //     duration: Duration(milliseconds: 200),
          //   ),
          // ),
          const HSpace(24),
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            groupValue: themeChanger.themeMode,
            value: ThemeMode.light,
            onChanged: themeChanger.setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            groupValue: themeChanger.themeMode,
            value: ThemeMode.dark,
            onChanged: themeChanger.setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System Mode'),
            groupValue: themeChanger.themeMode,
            value: ThemeMode.system,
            onChanged: themeChanger.setTheme,
          ),
        ],
      ),
    );
  }
}
