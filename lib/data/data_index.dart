//TODO: REMOVE DEPENDENCY ON THIS CLASS; REPLACED BY "contents" INSIDE JSON FILE
class DataClass {
  ///Name of JSON file.
  String jsonAsset;
  ///Names of entry types.
  List<String> types;

  DataClass({required this.jsonAsset, required this.types});
}

List<DataClass> dataClassIndex = [
  DataClass(
    jsonAsset: "lib/data/psalmboek1773.json",
    types: [
      "psalmen",
      "gezangen",
    ],
  ),
];
