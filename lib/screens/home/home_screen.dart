import 'dart:convert';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/songpage.dart';

class HomeScreen extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const HomeScreen({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxVerse = snapshot.data[snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length;
    int value = (context.watch<LocalStates>().count > maxVerse) ? maxVerse : context.watch<LocalStates>().count;


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
                  context.read<LocalStates>().setCounter(value.round().toInt());
                },
                min: 1,
                max: maxVerse.toDouble(),
                initialValue: value.toDouble(),
                innerWidget: (i) {
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
                        if (value > 1) context.read<LocalStates>().setCounter(value - 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back, size: 25,),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        if (value < maxVerse) context.read<LocalStates>().setCounter(value + 1);
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
              final Map<String, dynamic> data = await rootBundle.loadString(context.read<DatabaseContentProvider>().jsonAsset).then((jsonStr) => jsonDecode(jsonStr));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPageText(data: data[data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]][value - 1]),),);
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
