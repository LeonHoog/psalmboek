import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(12);
                      },
                      child: const Text('extra klein', style: TextStyle(fontSize: 12),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(15);
                      },
                      child: const Text('klein', style: TextStyle(fontSize: 15),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(15);
                      },
                      child: const Text('normaal', style: TextStyle(fontSize: 18),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(20);
                      },
                      child: const Text('groot', style: TextStyle(fontSize: 22),),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setTextSize(25);
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
            value: context.watch<LocalSettings>().autoTextSize,
            onChanged: (value){
              context.read<LocalSettings>().setAutoTextSize(value);
            },
          ),
          const SizedBox(height: 15,), //extra padding
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('app weergave', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('app thema'),
            trailing: Text(["donker", "licht", "systeem"][context.read<LocalSettings>().appThemeMode], style: const TextStyle(fontStyle: FontStyle.italic),),
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('Selecteer thema'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setAppThemeMode(0);
                        },
                      child: const Text('donker'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setAppThemeMode(1);
                      },
                      child: const Text('licht'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<LocalSettings>().setAppThemeMode(2);
                      },
                      child: const Text('systeem'),
                    ),
                  ],
                );
              }
                  );
              },
          ),
          SwitchListTile(
            title: const Text('lijstweergave'),
            value: context.watch<LocalSettings>().listView,
            onChanged: (value){
              context.read<LocalSettings>().setListView(value);
            },
          ),
          const SizedBox(height: 15,), //extra padding
          const Divider(),
          ListTile(
            title: const Text("over Psalmboek"),
            onTap: () {
              showAboutDialog(
                context: context,
               // applicationVersion: '0.5.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
