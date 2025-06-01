import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_plus/mvvm_plus.dart';

class HomeScreenMobile extends ViewWidget<HomeScreenMobileViewModel> {
  final Map<String, dynamic> bsonData;
  HomeScreenMobile({super.key, required this.bsonData}) : super(
    builder: () => HomeScreenMobileViewModel(),
  );

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel homeScreenViewModel = get<HomeScreenViewModel>();

    final colorScheme = Theme.of(context).colorScheme;
    if (viewModel.count == null) viewModel.count = homeScreenViewModel.count;
    int value = (viewModel.count! > homeScreenViewModel.maxVerse) ? homeScreenViewModel.maxVerse : viewModel.count!;
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
                viewModel.setCounter(value.round());
              },
              onChangeStart: (i) {
                viewModel.setAnimatingText(true);
              },
              onChangeEnd: (i) {
                viewModel.setAnimatingText(false);
                homeScreenViewModel.setCounter(viewModel.count!.toInt());
              },
              min: 1,
              max: homeScreenViewModel.maxVerse.toDouble(),
              initialValue: value.toDouble(),
              innerWidget: (i) {
                return viewModel.isAnimatingText ?
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
                          if (valueInt <= homeScreenViewModel.maxVerse && valueInt > 0) {
                            viewModel.setCounter(valueInt);
                            homeScreenViewModel.setCounter(viewModel.count!);
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
                        controller: TextEditingController(text: homeScreenViewModel.count.toString()),
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
                    if (value > 1) {
                      viewModel.setCounter(value - 1);
                      homeScreenViewModel.setCounter(viewModel.count!);
                    }
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
                    if (value < homeScreenViewModel.maxVerse) {
                      viewModel.setCounter(value + 1);
                      homeScreenViewModel.setCounter(viewModel.count!);
                    }
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

class HomeScreenMobileViewModel extends ViewModel {
  int? count; // local counter (for circular slider)
  void setCounter(int value) {
    count = value;
    buildView();
  }

  bool isAnimatingText = false;
  void setAnimatingText(bool value) {
    isAnimatingText = value;
    buildView();
  }
}
