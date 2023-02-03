import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<LocalStates>().colorScheme!.background,
      appBar: AppBar(
        backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
        title: const Text('instellingen'),
      ),
      body: ListView(
        children:
        [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('tekst weergave', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('tekst grootte'),
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('Selecteer grootte'),
                  children: <Widget>[
                    const Divider(),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setTextSize(15);
                      },
                      child: const Text('klein', style: TextStyle(fontSize: 15),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setTextSize(15);
                      },
                      child: const Text('normaal', style: TextStyle(fontSize: 18),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setTextSize(20);
                      },
                      child: const Text('groot', style: TextStyle(fontSize: 22),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setTextSize(25);
                      },
                      child: const Text('extra groot', style: TextStyle(fontSize: 27),),
                    ),
                   //TODO: AANGEPASTE GROOTTE 
                    /* const Divider(),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(18);
                      },
                      child: const Text('aangepast'),
                    ),*/
                  ],
                );
              }
              );
            },
          ),
          SwitchListTile(
            title: const Text('dynamische tekstgrootte'),
            activeColor: context.watch<LocalStates>().colorScheme!.primary,
            inactiveTrackColor: context.watch<LocalStates>().colorScheme!.shadow,
            inactiveThumbColor: context.watch<LocalStates>().colorScheme!.inversePrimary,
            value: context.watch<SettingsData>().autoTextSize,
            onChanged: (value) {
              context.read<SettingsData>().setAutoTextSize(value);
            },
          ),
          const SizedBox(height: 15,), //extra padding
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('app weergave', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('app thema'),
            trailing: Text(["donker", "licht", "systeem"][context.read<SettingsData>().appThemeMode], style: const TextStyle(fontStyle: FontStyle.italic),),
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('Selecteer thema'),
                  children: <Widget>[
                    const Divider(),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setAppThemeMode(0);
                        context.read<LocalStates>().notifyLocalStatesListeners();
                        },
                      child: const Text('donker'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setAppThemeMode(1);
                        context.read<LocalStates>().notifyLocalStatesListeners();
                      },
                      child: const Text('licht'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsData>().setAppThemeMode(2);
                        context.read<LocalStates>().notifyLocalStatesListeners();
                      },
                      child: const Text('systeem'),
                    ),
                  ],
                );
              }
                  );
              },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('gegevens', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('wis bladwijzers'),
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Bladwijzers wissen'),
                  actions: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        context.read<SettingsData>().clearBookmarks();
                        Navigator.pop(context);
                      },
                      child: const Text('ja'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('nee'),
                    ),
                  ],
                );
              }
              );
            },
          ),
          const SizedBox(height: 15,), //extra padding
          const Divider(),
          ListTile(
            title: const Text("over Psalmboek"),
            onTap: () {
              showAboutDialog(
                context: context,
               applicationIcon: SizedBox(
                 height: 50,
                 width: 50,
                 child: SvgPicture.asset(
                   "assets/icon/logo.svg",
                 ),
               ),
               // applicationVersion: '0.5.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
