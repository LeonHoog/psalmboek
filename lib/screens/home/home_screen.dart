import 'package:hive/hive.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class HomeScreen extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const HomeScreen({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxVerse = snapshot.data[snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length;
    int value = (context.watch<CounterStates>().count > maxVerse) ? maxVerse : context.watch<CounterStates>().count;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children:
        [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 350,
              minHeight: 0,
            ),
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                size: (MediaQuery.of(context).size.height>MediaQuery.of(context).size.width)
                    ? MediaQuery.of(context).size.height*.4
                    : MediaQuery.of(context).size.width*.4,
                customColors:  CustomSliderColors(
                  trackColor: context.watch<LocalStates>().colorScheme!.secondary,
                  progressBarColors: [
                    context.watch<LocalStates>().colorScheme!.tertiary,
                    context.watch<LocalStates>().colorScheme!.secondary,
                    context.watch<LocalStates>().colorScheme!.primary,
                    context.watch<LocalStates>().colorScheme!.onSurface
                  ],
                  shadowColor: context.watch<LocalStates>().colorScheme!.outline,
                ),
              ),
              onChange: (double value) {
                context.read<CounterStates>().setCounter(value.round().toInt());
              },
              min: 1,
              max: maxVerse.toDouble(),
              initialValue: value.toDouble(),
              innerWidget: (i) {
                return AnimatedFlipCounter(
                  value: value,
                  fractionDigits: 0,
                  textStyle: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (value > 1) context.read<CounterStates>().setCounter(value - 1);
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: context.watch<LocalStates>().colorScheme!.primary),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, size: 25, color: context.watch<LocalStates>().colorScheme!.onPrimary,),
                  ),
                ),
                const SizedBox(width: 20,),
                ElevatedButton(
                  onPressed: () {
                    if (value < maxVerse) context.read<CounterStates>().setCounter(value + 1);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: context.watch<LocalStates>().colorScheme!.primary),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward, size: 25, color: context.watch<LocalStates>().colorScheme!.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
