class User {
  String id, name, gender;
  int age;
  Map<String, double> genderPreferences;

  User(
      {required this.id,
      required this.name,
      required this.gender,
      required this.age,
      required this.genderPreferences});
}
