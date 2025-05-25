import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class HomeScreenMobile extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const HomeScreenMobile({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    int maxVerse = snapshot.data[snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length;
    int value = (context.watch<CounterStates>().count > maxVerse) ? maxVerse : context.watch<CounterStates>().count;
    const int spinnerDuration = 1300;

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
                spinnerDuration: spinnerDuration,
                size: (MediaQuery.of(context).size.height>MediaQuery.of(context).size.width)
                    ? MediaQuery.of(context).size.height*.4
                    : MediaQuery.of(context).size.width*.4,
                customColors:  CustomSliderColors(
                  trackColor: colorScheme.secondary,
                  progressBarColors: [
                    colorScheme.tertiary,
                    colorScheme.secondary,
                    colorScheme.primary,
                    colorScheme.onSurface
                  ],
                  shadowColor: colorScheme.outline,
                ),
              ),
              onChange: (double value) {
                context.read<CounterStates>().setCounter(value.round().toInt());
              },
              onChangeStart: (i) {
                context.read<CounterStates>().setIsAnimatingText(true);
              },
              onChangeEnd: (i) {
                context.read<CounterStates>().setIsAnimatingText(false);
              },
              min: 1,
              max: maxVerse.toDouble(),
              initialValue: value.toDouble(),
              innerWidget: (i) {
                return context.watch<CounterStates>().isAnimatingText ?
                  AnimatedFlipCounter(
                    value: value,
                    fractionDigits: 0,
                    textStyle: Theme.of(context).textTheme.displayLarge,
                  ) :
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onSubmitted: (String value) {
                          int valueInt = int.parse(value);
                          if (valueInt <= maxVerse && valueInt > 0) {
                            context.read<CounterStates>().setCounter(valueInt);
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          helperStyle: TextStyle(fontSize: 0),
                          suffixStyle: TextStyle(fontSize: 0),
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        maxLength: 4,
                        maxLines: 1,
                        controller: TextEditingController(text: context.watch<CounterStates>().count.toString()),
                        style: TextStyle(
                          fontFamily: Theme.of(context).textTheme.displayLarge!.fontFamily,
                          fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                          fontWeight: Theme.of(context).textTheme.displayLarge!.fontWeight,
                          fontStyle: Theme.of(context).textTheme.displayLarge!.fontStyle,
                          color: Theme.of(context).textTheme.displayLarge!.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                  style: OutlinedButton.styleFrom(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, size: 25,),
                  ),
                ),
                const SizedBox(width: 20,),
                ElevatedButton(
                  onPressed: () {
                    if (value < maxVerse) context.read<CounterStates>().setCounter(value + 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward, size: 25),
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
