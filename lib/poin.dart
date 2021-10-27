class Poinku {
  // Creating a field
  late String geekName;

  // Using the getter
  // method to take input
  // ignore: non_constant_identifier_names
  String get geek_name {
    return geekName;
  }

  // Using the setter method
  // to set the input
  // ignore: non_constant_identifier_names
  set geek_name(String name) {
    this.geekName = name;
  }
}
