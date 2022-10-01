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
          const SizedBox(height: 15,), //extra padding
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('app weergave', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text('forceer dark-mode'),
            value: context.watch<LocalSettings>().forceDarkMode,
            onChanged: (value){
              context.read<LocalSettings>().setForceDarkMode(value);
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
