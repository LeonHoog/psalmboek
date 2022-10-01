import 'dart:convert';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:psalmboek/screens/settingspage.dart';
import 'package:psalmboek/screens/songpage.dart';
import '../providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psalmboek'),
        actions:
        [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int value = context.watch<Counter>().count;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Stack(
            alignment: Alignment.center,
            children:
            [
              SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: (MediaQuery.of(context).size.height>MediaQuery.of(context).size.width)
                      ? MediaQuery.of(context).size.height*.4
                      : MediaQuery.of(context).size.width*.4,
                ),
                onChange: (double value) {
                  context.read<Counter>().setCounter(value.round().toInt());
                },
                min: 1,
                max: 150,
                initialValue: value.toDouble(),
                innerWidget: (i){
                  return AnimatedFlipCounter(
                    value: value,
                    fractionDigits: 0,
                    textStyle: Theme.of(context).textTheme.headline1,
                  );
                },
              ),
              Positioned(
                bottom: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if(value > 1)
                        {
                          context.read<Counter>().setCounter(value - 1);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back, size: 25,),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        if(value < 150)
                        {
                          context.read<Counter>().setCounter(value + 1);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_forward, size: 25,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final Map<String, dynamic> data = await rootBundle.loadString("lib/data/psalmboek1773.json").then((jsonStr) => jsonDecode(jsonStr));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPageText(data: data["psalmen"][value - 1]),),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.menu_book, size: 30,),
            ),
          ),
        ],
      ),
    );
  }
}
